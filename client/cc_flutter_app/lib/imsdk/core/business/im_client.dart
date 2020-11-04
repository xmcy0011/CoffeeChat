import 'dart:async';
import 'dart:io';

import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Voip.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/im_header.dart';
import 'package:cc_flutter_app/imsdk/proto/im_request.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Login.pbserver.dart';
import 'package:protobuf/protobuf.dart';
import 'package:fixnum/fixnum.dart';

const kReadBufferSize = 1024; // Bytes
const kRequestTimeout = 10; // 10秒请求超时
const kRequestMsgTimeout = 10; // 10秒请求超时

/// 消息接口
abstract class IMessage {
  void onHandleMsgData(IMHeader header, CIMMsgData data);

  void onHandleMsgDataAck(IMHeader header, CIMMsgDataAck ack);

  void onHandleReadNotify(IMHeader header, CIMMsgDataReadNotify readNotify);
}

/// 音视频业务接口
abstract class IAVChat {
  void onHandleInviteReq(IMHeader header, CIMVoipInviteReq data); // 邀请
  void onHandleInviteReply(IMHeader header, CIMVoipInviteReply data); // 应答
  void onHandleInviteReplyAck(IMHeader header, CIMVoipInviteReplyAck data); // 应答200 ok 的ack
  void onHandleVOIPByeRsp(IMHeader header, CIMVoipByeRsp data); // 挂断响应
  void onHandleVOIPByeNotify(IMHeader header, CIMVoipByeNotify data); // 对方挂断通知
  void onHandleVOIPHeartbeat(IMHeader header, CIMVoipHeartbeat data); // 心跳
}

class IMClient {
  RawSocket socket; // socket
  var handleMap = new Map<int, Function(IMHeader header, List<int> data)>(); // 消息驱动表

  var msgService = new Map<String, IMessage>(); // 消息处理
  var voipService = new Map<String, IAVChat>(); // VOIP信令

  var isLogin = false;
  var isReLogin = false;
  var isConnect = false;
  var isOnceConnect = false;
  var lastReConnectTick = 0;
  var reConnectInterval = 1;

  var requestMap = new Map<int, IMRequest>(); // 请求列表
  var registerCallbackList = new List<int>();
  var cache = new List<int>(); // socket receive cache
  var cacheOffset = 0; // socket receive cache offset

  var checkConnectTimeSpan = 1; // 重连间隔,指数退避算法,1s,2s,4s,8s
  var checkConnectLastTick = 0;

  Int64 userId;
  var nickName;
  var userToken;
  var ip;
  var port;

  Function onDisconnect;

  /// 单实例
  static final IMClient singleton = IMClient._internal();

  factory IMClient() {
    return singleton;
  }

  IMClient._internal() {
    isLogin = false;
    isReLogin = false;

    _initHandleMap();

    // send heartbeat
    Timer.periodic(Duration(seconds: 15), (timer) {
      if (isLogin) {
        var heartBeat = new CIMHeartBeat();
        send(CIMCmdID.kCIM_CID_LOGIN_HEARTBEAT.value, heartBeat);
      }
    });

    // timeout
    Timer.periodic(Duration(seconds: 1), (timer) {
      _checkRequestTimeout();
      _reConnect(timer.tick);
    });
  }

  // 初始化消息驱动表
  void _initHandleMap() {
    // 认证
    handleMap[CIMCmdID.kCIM_CID_LOGIN_AUTH_TOKEN_RSP.value] = _handleAuthRsp;
    // 会话列表
    handleMap[CIMCmdID.kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP.value] = _handleRecentSessionList;

    // 历史消息
    handleMap[CIMCmdID.kCIM_CID_LIST_MSG_RSP.value] = _handleGetMsgList;
    // 消息收发
    handleMap[CIMCmdID.kCIM_CID_MSG_DATA.value] = _handleMsgData;
    // 消息收到ACK
    handleMap[CIMCmdID.kCIM_CID_MSG_DATA_ACK.value] = _handleMsgDataAck;
    // 已读消息通知
    handleMap[CIMCmdID.kCIM_CID_MSG_READ_NOTIFY.value] = _handleMsgReadNotify;

    // VOIP invite req
    handleMap[CIMCmdID.kCIM_CID_VOIP_INVITE_REQ.value] = _handleInviteReq;
    // VOIP reply
    handleMap[CIMCmdID.kCIM_CID_VOIP_INVITE_REPLY.value] = _handleInviteReply;
    // VOIP reply ack
    handleMap[CIMCmdID.kCIM_CID_VOIP_INVITE_REPLY_ACK.value] = _handleInviteReplyAck;
    // VOIP heartbeat
    handleMap[CIMCmdID.kCIM_CID_VOIP_HEARTBEAT.value] = _handleVOIPHeartbeat;
    // VOIP Bye rsp
    handleMap[CIMCmdID.kCIM_CID_VOIP_BYE_RSP.value] = _handleVOIPByeRsp;
    // VOIP Bye notify
    handleMap[CIMCmdID.kCIM_CID_VOIP_BYE_NOTIFY.value] = _handleVOIPByeNotify;
  }

  /// 认证
  /// [userId] 用户ID
  /// [nickName] 昵称
  /// [userToken] 认证口令
  /// [ip] 服务器IP
  /// [port] 服务器端口
  /// [callback] (CIMAuthTokenRsp)
  Future auth(Int64 userId, var nick, var userToken, var ip, var port) async {
    if (socket != null && isConnect) {
      socket.close();
    }

    this.userId = userId;
    this.nickName = nick;
    this.userToken = userToken;
    this.ip = ip;
    this.port = port;

    var completer = new Completer();
    try {
      var feature = RawSocket.connect(ip, port, timeout: Duration(seconds: 5));
      feature.then((value) {
        print("connected");
        socket = value;
        // read data
        socket.listen(_onRead, onError: _onError, onDone: _onDone);
        isConnect = true;
        isOnceConnect = true;

        // auth request
        var req = new CIMAuthTokenReq();
        req.userId = Int64.parseInt(userId.toString());
        req.nickName = nick;
        req.userToken = userToken;
        req.clientType = CIMClientType.kCIM_CLIENT_TYPE_DEFAULT;
        req.clientVersion = "1.0/flutter";
        print("auth req,userId=$userId,nickName=$nick,token=$userToken");
        sendRequest(CIMCmdID.kCIM_CID_LOGIN_AUTH_TOKEN_REQ.value, req, (rsp) {
          if (rsp is CIMAuthTokenRsp) {
            print("auth result:${rsp.resultCode},msg:${rsp.resultString}");
            if (rsp.resultCode == CIMErrorCode.kCIM_ERR_SUCCSSE) {
              this.isLogin = true;
              this.reConnectInterval = 1;
            }
            completer.complete(rsp);
          } else {
            completer.completeError(rsp);
          }
        });
      }).catchError((err) {
        completer.completeError(err);
        print("connect error:" + err.toString());
      });
    } catch (ex) {
      print("connect error:" + ex.toString());
      completer.completeError(ex);
    }
    return completer.future;
  }

  /// 发送通知，没有响应
  /// [commandId] 命令ID
  /// [message] 数据部
  int send(int cmdId, GeneratedMessage message) {
    return sendRequest(cmdId, message, null);
  }

  /// 发送请求，获得响应后回调（包序号一样）
  /// [commandId] 命令ID
  /// [message] 数据部
  /// [callback] 结果回调
  int sendRequest(int cmdId, GeneratedMessage message, Function callback) {
    var header = new IMHeader();
    header.setCommandId(cmdId);
    header.setMsg(message);
    header.setSeq(SeqGen.singleton.gen());

    var data = header.getBuffer();
    var len = this.socket.write(data);

    // add
    if (callback != null) {
      IMRequest req = new IMRequest(header, callback, DateTime.now());
      requestMap[header.seqNumber] = req;
    }

    return len;
  }

  /// 注册收到新消息回调
  /// [name] 唯一标志
  /// [msg] 回调对象
  void registerMessageService(String name, IMessage msg) {
    this.msgService[name] = msg;
  }

  /// 注册收到新消息回调
  void observerVOIPService(String name, IAVChat callbackInterface, bool register) {
    if (register) {
      this.voipService[name] = callbackInterface;
    } else {
      this.voipService.remove(name);
    }
  }

  // 数据处理
  void _onRead(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      // 一次性读入
      while (socket.available() > 0) {
        var data = socket.read(kReadBufferSize);
        cache.addAll(data);
        cacheOffset += data.length;
      }

      // 粘包处理1
      var start = 0;
      var header = new IMHeader();
      while (true) {
        var temp = cache.sublist(start);
        if (!header.readHeader(temp)) {
          if (start == 0) {
            print("invalid IMHeader,start=" + start.toString() + ",cacheOffset=" + cacheOffset.toString());
          }
          start = cacheOffset; // delay clear
          break;
        }

        // 去掉头部
        List<int> data = List.from(temp.sublist(kHeaderLen), growable: false);
        // sync callback
        _onHandle(header, data);
        start += header.length;
      }

      // delete read buffer
      if (start == cacheOffset) {
        cache.clear();
        cacheOffset = 0;
      } else {
        cache = cache.sublist(start);
        cacheOffset -= start;
      }
    } else if (event == RawSocketEvent.closed) {
      _onClose();
    }
  }

  void _onError(var err) {
    print("socket error:" + err.toString());
  }

  void _onDone() {
    print("socket done");
  }

  void _onClose() {
    print("on close connection");
    if (isLogin) {
      isReLogin = false;
      if (onDisconnect != null) {
        onDisconnect();
      }
    }
    isLogin = false;
    isConnect = false;
  }

  // 超时
  void _checkRequestTimeout() {
    Map<int, IMRequest> tempList;

    requestMap.forEach((k, v) {
      var reqTime = v.requestTime;
      var timespan = DateTime.now().difference(reqTime).inSeconds;
      if (timespan >= kRequestTimeout) {
        print("timeout seqNumber=${v.header.seqNumber},"
            "cmdId=${v.header.commandId}");
        if (v.callback != null) {
          v.callback("timeout");
        }
        if (tempList == null) {
          tempList = new Map<int, IMRequest>();
        }
        tempList[v.header.seqNumber] = v;
      }
    });

    // clear timeout request
    if (tempList != null) {
      tempList.forEach((k, v) {
        requestMap.remove(k);
      });
      tempList.clear();
    }
  }

  // 重连
  void _reConnect(tick) {
    if (!this.isConnect && this.isOnceConnect) {
      //1 2 4 8 ...
      if (tick >= (reConnectInterval + lastReConnectTick)) {
        print("reconnect tick=$tick,lastConnectTick=$lastReConnectTick,connectInterval=$reConnectInterval");

        lastReConnectTick = tick;
        reConnectInterval *= 2;
        if (reConnectInterval >= 16) {
          reConnectInterval = 1;
        }
        this.auth(this.userId, this.nickName, this.userToken, this.ip, this.port);
      }
    }
  }

  // 消息总处理
  void _onHandle(IMHeader header, List<int> data) {
    if (header.commandId == CIMCmdID.kCIM_CID_LOGIN_HEARTBEAT.value) {
      print("onHandle heartbeat");
      return;
    }

    if (this.handleMap.containsKey(header.commandId)) {
      Function(IMHeader, List<int>) f = this.handleMap[header.commandId];
      f(header, data);
    } else {
      print("unknown message,cmdId:${header.commandId}");
    }
  }

  // 认证消息处理
  void _handleAuthRsp(IMHeader header, List<int> data) {
    var rsp = CIMAuthTokenRsp.fromBuffer(data);
    print("_handleAuthRsp result:${rsp.resultCode},desc:${rsp.resultString}");

    if (requestMap.containsKey(header.seqNumber)) {
      IMRequest req = requestMap[header.seqNumber];
      req.callback(rsp);
      requestMap.remove(header.seqNumber);
    } else {
      print("_handleAuthRsp err:can't find req:${header.seqNumber}");
    }
  }

  void _handleRecentSessionList(IMHeader header, List<int> data) {
    var rsp = CIMRecentContactSessionRsp.fromBuffer(data);
    print("_handleRecentSessionList count:${rsp.contactSessionList.length},"
        "unreadCount:${rsp.unreadCounts}");

    if (requestMap.containsKey(header.seqNumber)) {
      IMRequest req = requestMap[header.seqNumber];
      req.callback(rsp);
      requestMap.remove(header.seqNumber);
    } else {
      print("_handleRecentSessionList err:can't find req:${header.seqNumber}");
    }
  }

  void _handleGetMsgList(IMHeader header, List<int> data) {
    var rsp = CIMGetMsgListRsp.fromBuffer(data);
    print("_handleGetMsgList count:${rsp.msgList.length}");

    if (requestMap.containsKey(header.seqNumber)) {
      IMRequest req = requestMap[header.seqNumber];
      req.callback(rsp);
      requestMap.remove(header.seqNumber);
    } else {
      print("_handleGetMsgList err:can't find req:${header.seqNumber}");
    }
  }

  void _handleMsgData(IMHeader header, List<int> data) {
    var msg = CIMMsgData.fromBuffer(data);
    print("_handleMsgData fromId=${msg.fromUserId},toId=${msg.toSessionId},"
        "msgType=${msg.msgType},clientMsgId=${msg.clientMsgId},serverMsgId=${msg.serverMsgId}"
        "sessionType=${msg.sessionType}");

    // 优先激发，更新未读会话等
    if (msgService.containsKey("IMManager")) {
      msgService["IMManager"].onHandleMsgData(header, msg);
    }

    msgService.forEach((k, v) {
      if (k != "IMManager") {
        IMessage item = v;
        item.onHandleMsgData(header, msg);
      }
    });
  }

  void _handleMsgDataAck(IMHeader header, List<int> data) {
    var ack = CIMMsgDataAck.fromBuffer(data);
    print("_handleMsgDataAck userId=${ack.fromUserId},clientMsgId=${ack.clientMsgId},serverMsgId=${ack.serverMsgId},"
        "sessionId=${ack.toSessionId}");

    msgService.forEach((k, v) {
      IMessage msg = v;
      msg.onHandleMsgDataAck(header, ack);
    });
  }

  void _handleMsgReadNotify(IMHeader header, List<int> data) {
    var notify = CIMMsgDataReadNotify.fromBuffer(data);
    print("_handleMsgReadNotify userId=${notify.userId},sessionId=${notify.sessionId},msgId=${notify.msgId}");

    msgService.forEach((k, v) {
      IMessage msg = v;
      msg.onHandleReadNotify(header, notify);
    });
  }

  // VOIP
  void _handleInviteReq(IMHeader header, List<int> data) {
    var req = CIMVoipInviteReq.fromBuffer(data);
    print("_handleInviteReq creator_user_id:${req.creatorUserId},invite_user=${req.inviteUserList[0]}");

    voipService.forEach((k, v) {
      IAVChat chat = v;
      chat.onHandleInviteReq(header, req);
    });
  }

  void _handleInviteReply(IMHeader header, List<int> data) {
    var req = CIMVoipInviteReply.fromBuffer(data);
    print("_handleInviteReply reply_user_id:${req.userId},status:${req.rspCode.value}");

    voipService.forEach((k, v) {
      IAVChat chat = v;
      chat.onHandleInviteReply(header, req);
    });
  }

  void _handleInviteReplyAck(IMHeader header, List<int> data) {
    var req = CIMVoipInviteReplyAck.fromBuffer(data);
    print("_handleInviteReplyAck channel_name=${req.channelInfo.channelName}");

    voipService.forEach((k, v) {
      IAVChat chat = v;
      chat.onHandleInviteReplyAck(header, req);
    });
  }

  void _handleVOIPHeartbeat(IMHeader header, List<int> data) {
    var req = CIMVoipHeartbeat.fromBuffer(data);
    print("_handleVOIPHeartbeat time=${DateTime.now().toString()}");

    this.voipService.forEach((k, v) {
      IAVChat chat = v;
      chat.onHandleVOIPHeartbeat(header, req);
    });
  }

  void _handleVOIPByeRsp(IMHeader header, List<int> data) {
    var rsp = CIMVoipByeRsp.fromBuffer(data);
    print("_handleVOIPByeRsp error_code:${rsp.errorCode.value}");

    this.voipService.forEach((k, v) {
      IAVChat chat = v;
      chat.onHandleVOIPByeRsp(header, rsp);
    });
  }

  void _handleVOIPByeNotify(IMHeader header, List<int> data) {
    var rsp = CIMVoipByeNotify.fromBuffer(data);
    print("_handleVOIPByeRsp user_id:${rsp.userId},bye_reason:${rsp.byeReason}");

    this.voipService.forEach((k, v) {
      IAVChat chat = v;
      chat.onHandleVOIPByeNotify(header, rsp);
    });
  }
}
