import 'dart:async';
import 'dart:ffi';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Voip.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/im_header.dart';

import 'core/business/im_client.dart';
import 'package:fixnum/fixnum.dart';

/// 音视频通话
/// SDK接口参考网易云设计：https://dev.yunxin.163.com/docs/interface/%E5%8D%B3%E6%97%B6%E9%80%9A%E8%AE%AFAndroid%E7%AB%AF/IM_Android/com/netease/nimlib/sdk/avchat/AVChatManagerLite.html
/// 双人视频通话流程示例：
/// 1.注册本地各种监听器 observeAVChatState(AVChatStateObserverLite, boolean) 等等。
/// 2.开启音视频引擎， enableRtc()。
/// 3.设置通话场景, 如没有特殊需求不用设置 setChannelProfile(int) 。
/// 4.打开视频模块 enableVideo()。
/// 5.设置视频采集模块 setupVideoCapturer(AVChatVideoCapturer)。
/// 6.设置本地预览画布 setupLocalVideoRender(IVideoRender, boolean, int)。
/// 7.设置视频通话可选参数[可以不设置] setParameter(AVChatParameters.Key, Object), setParameters(AVChatParameters)。
/// 8.打开本地视频预览 startVideoPreview()。
/// 9.呼叫或者接听通话 call2(String, AVChatType, AVChatNotifyOption, AVChatCallback), accept2(long, AVChatCallback)。
/// 10.等待对方进入开始通话, 各种音视频控制。
/// 11.关闭本地预览 stopVideoPreview()。
/// 12.关闭视频模块 disableVideo() ()} 。
/// 13.离开挂断会话 hangUp2(long, AVChatCallback)。
/// 14.关闭音视频引擎, disableRtc()。
class IMAVChat extends IAVChat {
  static final agoraAppId = "2af76c4e0d9746bfb080b485752e7296"; // Agora APP Id
  final _callTimeOut = 10; // s

  var _incomingCallHandleList = new List<AVChatIncomingCallObserver>(); // observeIncomingCall, invite
  var _avChatStateHandleList = new List<AVChatStateObserverLite>(); // AVChatState, 通话过程中的状态变化监听
  //var _calleeAckHandleList = new List<Observer<AVChatCalleeAckEvent>>(); // calleeAck, 音视频通话对方操作通知
  var _hangUpHandleList = new List<AVChatHangUpObserver>(); // hangUp, 音视频通话对方挂断事件
  //var _controlHandleList = new List<Observer<AVChatControlEvent>>(); // control, 音视频通话中接收到控制指令

  var _isInit = false;
  var _callTimer; // 呼叫超时计时器

  AVChatData chatData; // 通话信息
  AVState avState; // 通话状态
  CallSuccess callSuccessCallback; // call success
  CallError callErrorCallback; // call error
  CallAccept acceptCallback; // accept
  CallHangup hangupCallback; // hangup

  /// 单实例
  static final IMAVChat singleton = IMAVChat._internal();

  factory IMAVChat() {
    return singleton;
  }

  IMAVChat._internal();

  _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      print('_addAgoraEventHandlers onError: $code');
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      print('_addAgoraEventHandlers onJoinChannel: $channel, uid: $uid');
      this._avChatStateHandleList.forEach((v) {
        v.onJoinChannel(channel, uid, elapsed);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      print('_addAgoraEventHandlers onLeaveChannel');
      this._avChatStateHandleList.forEach((v) {
        v.onLeaveChannel();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      print('userJoined: $uid');
      this._avChatStateHandleList.forEach((v) {
        v.onUserJoined(uid, elapsed);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      print('userOffline: $uid');
      this._avChatStateHandleList.forEach((v) {
        v.onUserOffline(uid, reason);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      print('firstRemoteVideo: $uid ${width}x $height');
    };
  }

  /// 初始化
  init() async {
    if (_isInit) {
      return false;
    }
    _isInit = true;

    /// Create agora sdk instance and initialize
    await AgoraRtcEngine.create(agoraAppId);
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    //await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);

    IMClient.singleton.observerVOIPService("IMAVChat", this, true);

    return true;
  }

  /// 清理，退出前调用
  void cleanup() {
    if (_isInit) {
      IMClient.singleton.observerVOIPService("IMAVChat", this, false);

      // destroy sdk
      AgoraRtcEngine.leaveChannel();
      AgoraRtcEngine.destroy();
    }
    _isInit = false;
  }

  /// 启用视频
  void enableVideo(bool enable) {
    if (enable) {
      AgoraRtcEngine.enableVideo();
    } else {
      AgoraRtcEngine.disableVideo();
    }
  }

  /// 扬声器
  void enableSpeakerphone(bool enable){
    AgoraRtcEngine.setEnableSpeakerphone(enable);
  }

  /// 信令层发起双人通话
  /// 在信令层发起呼叫, 成功调用此接口后对方会收到相应的会话通知。 在呼叫过程中需要上层实现定时器, 当超过一定时间对方未接听时 需要 hangUp2(long, AVChatCallback) 挂断会话。
  /// 状态在observeAVChatState注册的回调接口中
  /// [userId] 对方ID
  /// [callType] 呼叫类型
  /// [notifyOption] 推送通知选项参数，预留
  /// AVChatStateObserverLite.onTrying: 和服务端接通
  /// AVChatStateObserverLite.onRinging: 等待对方接听中
  /// AVChatStateObserverLite.onCallEstablished: 对方接听
  void call(
      Int64 userId, CIMVoipInviteType callType, AVChatNotifyOption notifyOption, CallSuccess success, CallError error) {
    this.callSuccessCallback = success;
    this.callErrorCallback = error;
    this.avState = AVState.Default;

    var req = CIMVoipInviteReq();
    req.inviteType = callType;
    req.inviteUserList.add(userId); // invite user list

    // enable timer
    req.creatorUserId = IMClient.singleton.userId;
    _callTimer = Timer.periodic(Duration(seconds: 1), (t) {
      if (this.avState == AVState.Hangup || this.avState == AVState.Established) {
        t.cancel();
      }
      if (t.tick > _callTimeOut) {
        if (error != null) {
          error(-2, "call time out");
        }
        t.cancel();
      }
    });

    // save chat info
    this.chatData = new AVChatData(
        req.creatorUserId, userId, "unknown", "", callType, DateTime.now().millisecondsSinceEpoch ~/ 1000);
    IMClient.singleton.send(CIMCmdID.kCIM_CID_VOIP_INVITE_REQ.value, req);
  }

  /// 信令层接听双人通话
  /// 在程序启动时需要注册 observeIncomingCall(Observer, boolean), 这样在有其他用户 呼叫时将会收到来电通知, 收到来电通知后一般会有相应的界面展示,
  /// 如果需要接听电话则需要调用此接口, 如果需要拒绝通话请调用 hangUp(long, AVChatCallback)。在成功接听会话后, 引擎就会自动去连接预先分配好的媒体服务器。
  /// 连接媒体服务器的结果将会在 AVChatStateObserverLite.onJoinedChannel(int, String, String, int) 中进行通知。
  /// [callback] 回调
  void accept(/*String chatId,*/ CallAccept callback) {
    acceptCallback = callback;

    // OK
    if (avState == AVState.Ringing || avState == AVState.Trying) {
      print("send 200 ok");

      // join channel (agora)
      AgoraRtcEngine.leaveChannel();
      // AgoraRtcEngine.joinChannel(chatData.channelToken, chatData.channelName, "", IMClient.singleton.userId);
      // Fixed Me, prd env need use channel token
      AgoraRtcEngine.joinChannel(null, chatData.channelName, "", IMClient.singleton.userId.toInt());

      // send 200 ok
      var req = new CIMVoipInviteReply();
      req.channelInfo = new CIMChannelInfo();
      req.channelInfo.channelName = this.chatData.channelName;
      req.channelInfo.channelToken = this.chatData.channelToken;
      req.channelInfo.creatorId = this.chatData.creatorId;
      req.rspCode = CIMInviteRspCode.KCIM_VOIP_INVITE_CODE_OK;
      req.userId = IMClient.singleton.userId;

      IMClient.singleton.send(CIMCmdID.kCIM_CID_VOIP_INVITE_REPLY.value, req);
    }
  }

  /// 信令层挂断或者拒绝通话请求
  /// 在程序启动时需要注册 observeIncomingCall(Observer, boolean), 这样在有其他用户 呼叫时将会收到来电通知, 收到来电通知后一般会有相应的界面展示,
  /// 如果需要拒绝电话调用此接口, 如果需要接听通话请调用 accept2(long, AVChatCallback)。
  /// 如果在通话过程中调用此接口,则会直接挂断通话, 同时对方会收到你挂断通知信令。
  /// 如果是对方挂断，无需调用此方法
  /// [reason] 挂断原因
  void hangUp(/*String chatId,*/ CIMVoipByeReason reason, CallHangup callback) {
    hangupCallback = callback;
    print("hangUp");

    if (chatData != null && this.avState != AVState.Default) {
      // level channel
      AgoraRtcEngine.leaveChannel();

      // send bye
      var req = new CIMVoipByeReq();
      req.channelInfo = new CIMChannelInfo();
      req.channelInfo.channelName = this.chatData.channelName;
      req.channelInfo.channelToken = this.chatData.channelToken;
      req.channelInfo.creatorId = this.chatData.creatorId;
      req.userId = IMClient.singleton.userId;
      if (this.avState == AVState.Established) {
        req.localCallTimeLen = Int64((DateTime.now().millisecondsSinceEpoch ~/ 1000) - this.chatData.timeTag);
      } else {
        req.localCallTimeLen = Int64(0);
      }
      req.byeReason = reason;
      IMClient.singleton.send(CIMCmdID.kCIM_CID_VOIP_BYE_REQ.value, req);
    }

    avState = AVState.Hangup;
  }

  /// 获取挂断原因(中文)
  String getHangupReasonStr(Int64 hangupUserId, AVChatEventType e) {
    var msgTips = "通话结束";
    switch (e) {
      case AVChatEventType.CALLEE_CANCEL:
        if (hangupUserId == IMClient.singleton.userId) {
          msgTips = "已取消";
        } else {
          msgTips = "对方已取消";
        }
        break;
      case AVChatEventType.CALLEE_ACK_BUSY:
        msgTips = "对方正忙";
        break;
      case AVChatEventType.CALLEE_ACK_REJECT:
        if (hangupUserId == IMClient.singleton.userId) {
          msgTips = "已取消";
        } else {
          msgTips = "对方拒绝通话";
        }
        break;
      case AVChatEventType.CALLEE_ONLINE_CLIENT_ACK_REJECT:
        msgTips = "对方其他端拒绝通话";
        break;
      case AVChatEventType.CALLEE_END:
      case AVChatEventType.UNDEFINE:
        msgTips = "通话结束";
        break;
    }
    return msgTips;
  }

  AVChatEventType convertAVChatCommonEvent(CIMVoipByeReason reason) {
    if (reason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_BUSY) {
      return AVChatEventType.CALLEE_ACK_BUSY;
    }
    // 对方拒绝
    if (reason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_REJECT) {
      return AVChatEventType.CALLEE_ACK_REJECT;
    }
    // 通话结束
    if (reason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_END) {
      return AVChatEventType.CALLEE_END;
    }
    // 对方其他端拒绝
    if (reason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_ONLINE_CLIENT_REJECT) {
      return AVChatEventType.CALLEE_ONLINE_CLIENT_ACK_REJECT;
    }
    // 我方 取消
    if (reason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_CANCEL) {
      return AVChatEventType.CALLEE_CANCEL;
    }
    // 未知
    if (reason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_UNKNOWN) {
      return AVChatEventType.UNDEFINE;
    }
    return AVChatEventType.UNDEFINE;
  }

  /// 注册/注销网络来电. 当收到对方来电请求时，会通知上层通话信息。 用户可以选择 accept2(long, AVChatCallback) 来接听电话， 或者
  /// hangUp2(long, AVChatCallback) 来挂断电话，最好能够先发送一个正忙的指令给对方 sendControlCommand(long, byte, AVChatCallback)。
  /// 通常在收到来电请求时，上层需要维持 一个超时器，当超过一定时间没有操作时直接调用 hangUp2(long, AVChatCallback) 来挂断。
  void observeIncomingCall(AVChatIncomingCallObserver observer, bool register) {
    if (register) {
      _incomingCallHandleList.add(observer);
    } else {
      _incomingCallHandleList.remove(observer);
    }
  }

  /// 注册/注销网络通话状态通知 网络通话开始后，所有的通话状态通过 AVChatStateObserverLite 进行通知。
  void observeAVChatState(AVChatStateObserverLite observer, bool register) {
    if (register) {
      _avChatStateHandleList.add(observer);
    } else {
      _avChatStateHandleList.remove(observer);
    }
  }

  /// 注册/注销网络通话被叫方的响应（接听、拒绝、忙）
//  void observeCalleeAckNotification(Observer<AVChatCalleeAckEvent> observer, bool register) {
////    if (register) {
////      _calleeAckHandleList.add(observer);
////    } else {
////      _calleeAckHandleList.remove(observer);
////    }
////  }

  /// 注册/注销网络通话对方挂断的通知
  void observeHangUpNotification(AVChatHangUpObserver observer, bool register) {
    if (register) {
      _hangUpHandleList.add(observer);
    } else {
      _hangUpHandleList.remove(observer);
    }
  }

  /// 注册/注销网络通话控制消息（音视频模式切换通知）会话相关的控制指令通知，用户可以自定义私有的控制指令。
  //void observeControlNotification(Observer<AVChatControlEvent> observer, bool register)

  /// 注册/注销同时在线的其他端对主叫方的响应
//void observeOnlineAckNotification(Observer<AVChatOnlineAckEvent> observer, bool register)

  /// 当前通话打分
//void rate(int rate, String description){}

  /// Interface IAVChat
  void onHandleInviteReq(IMHeader header, CIMVoipInviteReq data) {
    // save channel info
    this.chatData = new AVChatData(data.creatorUserId, IMClient.singleton.userId, data.channelInfo.channelName,
        data.channelInfo.channelToken, data.inviteType, DateTime.now().millisecondsSinceEpoch ~/ 1000);

    // FIXED ME
    this.avState = AVState.Ringing;
    new Timer(Duration(seconds: 1), () {
      // reply 180 ringing
      var req = new CIMVoipInviteReply();
      req.userId = IMClient.singleton.userId;
      req.rspCode = CIMInviteRspCode.kCIM_VOIP_INVITE_CODE_RINGING;
      req.channelInfo = data.channelInfo;
      IMClient.singleton.send(CIMCmdID.kCIM_CID_VOIP_INVITE_REPLY.value, req);
    });

    // callback there has incoming call
    _incomingCallHandleList.forEach((v) {
      v.onIncomingCall(this.chatData);
    });
  }

  void onHandleInviteReply(IMHeader header, CIMVoipInviteReply data) {
    if (data.rspCode == CIMInviteRspCode.kCIM_VOIP_INVITE_CODE_TRYING) {
      if (chatData != null) {
        chatData.channelName = data.channelInfo.channelName;
        chatData.channelToken = data.channelInfo.channelToken;
        chatData.timeTag = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        // 100 trying
        avState = AVState.Trying;
        _avChatStateHandleList.forEach((v) {
          v.onTrying();
        });
      } else {
        print("onHandleInviteReply chatData is null");
      }
    } else if (data.rspCode == CIMInviteRspCode.kCIM_VOIP_INVITE_CODE_RINGING) {
      // 180 ringing
      avState = AVState.Ringing;
      _avChatStateHandleList.forEach((v) {
        v.onRinging();
      });
    } else if (data.rspCode == CIMInviteRspCode.KCIM_VOIP_INVITE_CODE_OK) {
      // 200 OK
      avState = AVState.Established;
      // 1.we need join channel
      AgoraRtcEngine.leaveChannel();
      //AgoraRtcEngine.joinChannel(chatData.channelToken, chatData.channelName, "", IMClient.singleton.userId);
      // Fixed Me, prd env need use channel token
      AgoraRtcEngine.joinChannel(null, chatData.channelName, "", IMClient.singleton.userId.toInt());

      // 2.reply ack
      var req = new CIMVoipInviteReplyAck();
      req.channelInfo = new CIMChannelInfo();
      req.channelInfo.channelName = this.chatData.channelName;
      req.channelInfo.channelToken = this.chatData.channelToken;
      req.channelInfo.creatorId = this.chatData.creatorId;
      IMClient.singleton.send(CIMCmdID.kCIM_CID_VOIP_INVITE_REPLY_ACK.value, req);

      // 3.callback
      _avChatStateHandleList.forEach((v) {
        v.onCallEstablished();
      });
      if (callSuccessCallback != null) {
        callSuccessCallback(this.chatData);
      }
    } else {
      _avChatStateHandleList.forEach((v) {
        v.onError(-1);
      });
      if (callErrorCallback != null) {
        callErrorCallback(-1, "unknown error");
      }
    }
  }

  void onHandleInviteReplyAck(IMHeader header, CIMVoipInviteReplyAck data) {
    // callback
    if (this.acceptCallback != null) {
      this.acceptCallback();
    }
    this.avState = AVState.Established;
    this.chatData.timeTag = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this._avChatStateHandleList.forEach((v) {
      v.onCallEstablished();
    });
  }

  void onHandleVOIPByeRsp(IMHeader header, CIMVoipByeRsp data) {
    if (this.hangupCallback != null) {
      this.hangupCallback();
    }
  }

  void onHandleVOIPByeNotify(IMHeader header, CIMVoipByeNotify data) {
    if (chatData != null && this.avState != AVState.Default) {
      AgoraRtcEngine.leaveChannel();
    }
    this.avState = AVState.Default;

    // hangup rsp
    this._hangUpHandleList.forEach((v) {
      AVChatEventType eventType = convertAVChatCommonEvent(data.byeReason);
      v.onHangup(new AVChatCommonEvent(eventType, this.chatData));
    });
  }

  void onHandleVOIPHeartbeat(IMHeader header, CIMVoipHeartbeat data) {
    // heartbeat
  }
}

/// 目前通话状态
enum AVState {
  Default,
  Trying,
  Ringing,
  Established,
  Hangup,
}

/// 请求音视频通话信息
class AVChatData {
  Int64 creatorId; // 创建者ID
  Int64 peerId; // 获取对方帐号, 多人通话时无效
  String channelName; // 获取通话ID
  String channelToken;
  CIMVoipInviteType chatType; // 通话类型
  int timeTag; // 当前事件发生的时间戳

  AVChatData(this.creatorId, this.peerId, this.channelName, this.channelToken, this.chatType, this.timeTag);
}

/// call result
typedef CallSuccess = void Function(AVChatData e);
typedef CallError = void Function(int errorCode, String errorDesc);
typedef CallAccept = void Function();
typedef CallHangup = void Function();

/// 网络通话回调接口
abstract class AVChatCallback<T> {
  void onException(Exception exception);

  void onFailed(int code);

  void onSuccess(T t);
}

/// 通话过程中的状态变化监听
abstract class AVChatStateObserverLite {
  /// [信令] 1.100 Trying 拨号成功
  void onTrying();

  /// [信令] 2.180 Ringing 等待对方接听。持续振铃中(持续几秒一个回调)
  void onRinging();

  /// [信令] 3.200 OK 会话成功建立，通话中
  void onCallEstablished();

  /// [引擎] 通话过程中音视频引擎发生错误
  void onError(dynamic code);

  /// [引擎] 自己加入到了频道中，等待对方加入
  //void onJoinedChannel(int code, String audioFile, String videoFile, int elapsed);
  void onJoinChannel(String channel, int uid, int elapsed);

  /// [引擎] 结束，自己离开频道
  void onLeaveChannel();

  /// [引擎] 对方已接听，某个用户加入频道
  void onUserJoined(int uid, int elapsed);

  /// [引擎] 对方挂断或掉线，某个用户离开频道
  void onUserOffline(int uid, int reason);

  /// 从服务器断开连接会收到此通知。
//void onDisconnectServer(int code);

  /// 音频设备变化
//void	onAudioDeviceChanged(int device, java.util.Set<java.lang.Integer> set, boolean shouldSelect)

  /// 语音数据处理接口, 不要改变数据的长度.
//boolean	onAudioFrameFilter(AVChatAudioFrame frame)

  /// 客户端网络类型发生了变化
//void onConnectionTypeChanged(int netType);

  /// 语音采集设备和视频采集设备事件通知
//void	onDeviceEvent(int code, java.lang.String desc)

  /// 用户第一帧视频数据绘制前通知.
//void	onFirstVideoFrameAvailable(java.lang.String account)

  /// 第一帧绘制通知
//void	onFirstVideoFrameRendered(java.lang.String account)

  /// 网络状态发生变化
//void onNetworkQuality(String account, int quality, AVChatNetworkStats stats);

  /// 双方协议版本不兼容
//void	onProtocolIncompatible(int status)

  /// 汇报正在说话的用户。 需要设置参数 AVChatParameters.KEY_AUDIO_REPORT_SPEAKER.
//void	onReportSpeaker(java.util.Map<java.lang.String,java.lang.Integer> speakers, int mixedEnergy)

  /// 实时统计信息
//void	onSessionStats(AVChatSessionStats sessionStats)

  /// 用户视频画面fps更新, 需要设置参数 AVChatParameters.KEY_VIDEO_FPS_REPORTED.
//void	onVideoFpsReported(String account, int fps)

  /// 视频数据外部处理接口, 此接口需要同步执行.
//boolean	onVideoFrameFilter(AVChatVideoFrame frame, boolean maybeDualInput)

  /// 视频数据外部处理接口, 此接口需要同步执行.
//boolean	onVideoFrameFilter(VideoFrame input, VideoFrame[] outputFrames, VideoFilterParameter filterParameter)

  /// 用户画面尺寸改变通知
//void	onVideoFrameResolutionChanged(String account, int width, int height, int rotate)
}

/// 来电
abstract class AVChatIncomingCallObserver {
  void onIncomingCall(AVChatData data);
}

/// 挂断
abstract class AVChatHangUpObserver {
  void onHangup(AVChatCommonEvent data);
}

/// 音视频通话事件枚举
enum AVChatEventType {
  UNDEFINE, // 未定义
  CALLEE_CANCEL, // 主叫方取消
  CALLEE_END, // 通话结束
  CALLEE_ACK_BUSY, // 被叫方正在忙
  CALLEE_ACK_REJECT, // 被叫方拒绝通话
  CALLEE_ONLINE_CLIENT_ACK_REJECT, // 被叫方同时在线的其他端拒绝通话
}

/// 音视频通话对方操作通知
//class AVChatCalleeAckEvent {
//  AVChatEventType event; // 事件
//  AVChatData data; // 通话信息
//
//  AVChatCalleeAckEvent(this.event, this.data);
//}

/// 推送通知选项参数
class AVChatNotifyOption {
  /// 推送是否需要角标计数(iOS) 默认为true。将这个字段设为false，网络通话请求将不再对角标计数。
  bool apnsBadge;

  ///   apns推送文案(iOS) 默认为null，用户可以设置当前通知的推送文案
  String apnsContent;

  ///   网络通话请求是否附带推送(iOS) 默认为true。将这个字段设为false，网络通话请求将不再有苹果推送通知。
  bool apnsInuse;

  ///   apns推送Payload(iOS) 可以通过这个字段定义自定义通知的推送Payload,支持字段参考苹果技术文档,最多支持2K
  String apnsPayload;

  ///   推送消息是否需要带前缀(iOS) 默认为true。将这个字段设为false，推送消息将不带有前缀(xx:)。
  bool apnsWithPrefix;

  ///   扩展消息 仅在发起网络通话时有效，用于在主被叫之间传递额外信息，被叫收到呼叫时会携带该信息
  String extendMessage;

  ///   是否强制持续呼叫 默认为true, 即使对方不在线, 呼叫也不会中断, 会持续呼叫; 如果设为false，对方不在线时，发起呼叫会返回失败
  bool forceKeepCalling;

  ///   推送声音文件(iOS) 默认为null，用户可以设置当前通知的推送声音。该设置会覆盖apnsPayload中的sound设置
  String pushSound;

  AVChatNotifyOption() {
    apnsBadge = true;
    apnsContent = null;
    apnsInuse = true;
    apnsPayload = null;
    apnsWithPrefix = true;
    forceKeepCalling = true;
    pushSound = null;
  }
}

/// 音视频通话事件
class AVChatCommonEvent {
  AVChatEventType event; // 事件
  AVChatData data; // 通话信息
  AVChatCommonEvent(this.event, this.data);
}

/// 网络通话控制命令通知
//class AVChatControlEvent extends AVChatCalleeAckEvent {
//  int controlCommand; // 控制指令
//
//  AVChatControlEvent(AVChatEventType event, AVChatData data, this.controlCommand) : super(event, data);
//}
