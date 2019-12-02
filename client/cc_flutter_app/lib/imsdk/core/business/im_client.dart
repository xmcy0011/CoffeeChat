import 'dart:async';
import 'dart:io';

import 'package:cc_flutter_app/imsdk/im_message.dart';
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

class IMClient {
  RawSocket socket; // socket
  IMMessage msgService; // 消息处理

  var isLogin = false;
  var isReLogin = false;

  var requestMap = new Map<int, IMRequest>(); // 请求列表
  var registerCallbackList = new List<int>();
  var cache = new List<int>(); // socket receive cache
  var cacheOffset = 0; // socket receive cache offset

  var checkConnectTimeSpan = 1; // 重连间隔,指数退避算法,1s,2s,4s,8s
  var checkConnectLastTick = 0;

  Function onDisconnect;

  /// 单实例
  static final IMClient singleton = IMClient._internal();

  factory IMClient() {
    return singleton;
  }

  IMClient._internal() {
    isLogin = false;
    isReLogin = false;

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
    });
  }

  /// 认证
  /// [userId] 用户ID
  /// [nickName] 昵称
  /// [userToken] 认证口令
  /// [ip] 服务器IP
  /// [port] 服务器端口
  /// [callback] (CIMAuthTokenRsp)
  Future auth(Int64 userId, var nick, var userToken, var ip, var port) async {
    if (socket != null) {
      socket.close();
    }

    var completer = new Completer();
    var feature = RawSocket.connect(ip, port, timeout: Duration(seconds: 5));
    feature.then((value) {
      print("connected");
      socket = value;
      // read data
      socket.listen(_onRead, onError: _onError, onDone: _onDone);

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
          if (rsp.resultCode == CIMErrorCode.kCIM_ERR_SUCCSSE) {
            this.isLogin = true;
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
    return completer.future;
  }

  /// 发送通知，没有响应
  /// [commandId] 命令ID
  /// [message] 数据部
  void send(int cmdId, GeneratedMessage message) {
    sendRequest(cmdId, message, null);
  }

  /// 发送请求，获得响应后回调
  /// [commandId] 命令ID
  /// [message] 数据部
  /// [callback] 结果回调
  void sendRequest(int cmdId, GeneratedMessage message, Function callback) {
    var header = new IMHeader();
    header.setCommandId(cmdId);
    header.setMsg(message);
    header.setSeq(SeqGen.singleton.gen());

    var data = header.getBuffer();
    this.socket.write(data);

    // add
    if (callback != null) {
      IMRequest req = new IMRequest(header, callback, DateTime.now());
      requestMap[header.seqNumber] = req;
    }
  }

  /// 注册消息回调
  void registerMessageService(IMMessage msg) {
    this.msgService = msg;
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
        v.callback(Future.error("timeout"));
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

  // 消息总处理
  void _onHandle(IMHeader header, List<int> data) {
    if (header.commandId == CIMCmdID.kCIM_CID_LOGIN_HEARTBEAT.value) {
      print("onHandle heartbeat");
      return null;
    }

    // 认证
    if (header.commandId == CIMCmdID.kCIM_CID_LOGIN_AUTH_TOKEN_RSP.value) {
      _handleAuthRsp(header, data);
    }
    // 会话列表
    else if (header.commandId ==
        CIMCmdID.kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP.value) {
      _handleRecentSessionList(header, data);
    }
    // 历史消息
    else if (header.commandId == CIMCmdID.kCIM_CID_LIST_MSG_RSP.value) {
      _handleGetMsgList(header, data);
    }
    // 消息收发
    else if (header.commandId == CIMCmdID.kCIM_CID_MSG_DATA.value ||
        header.commandId == CIMCmdID.kCIM_CID_MSG_DATA_ACK.value) {
      if (msgService != null) {
        msgService.onHandle(header, data);
      }
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
}
