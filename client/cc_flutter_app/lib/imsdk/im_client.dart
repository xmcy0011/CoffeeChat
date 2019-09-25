import 'dart:async';
import 'dart:io';

import 'package:cc_flutter_app/imsdk/model/im_header.dart';
import 'package:cc_flutter_app/imsdk/model/im_request.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Login.pbserver.dart';
import 'package:protobuf/protobuf.dart';
import 'package:fixnum/fixnum.dart';

const kReadBufferSize = 1024; // Bytes

class ImClient {
  RawSocket socket; // socket

  var isLogin = false;
  Int64 userId;

  var requestMap = new Map<int, IMRequest>(); // 请求列表
  var cache = new List<int>(); // socket receive cache
  var cacheOffset = 0; // socket receive cache offset

  /// 单实例
  static final ImClient singleton = ImClient._internal();

  factory ImClient() {
    return singleton;
  }

  ImClient._internal() {
    isLogin = false;

    // send heartbeat
    Timer timer = new Timer(Duration(seconds: 15), () {
      if (isLogin) {
        var heartBeat = new CIMHeartBeat();
        send(CIMCmdID.kCIM_CID_LOGIN_HEARTBEAT.value, heartBeat);
      }
    });
  }

  /// 认证
  /// [userId] 用户ID
  /// [nickName] 昵称
  /// [userToken] 认证口令
  /// [ip] 服务器IP
  /// [port] 服务器端口
  /// [callback] (CIMAuthTokenRsp)
  Future auth(int userId, var nickName, var userToken, var ip, var port) async {
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
      req.nickName = nickName;
      req.userToken = userToken;
      req.clientType = CIMClientType.kCIM_CLIENT_TYPE_DEFAULT;
      req.clientVersion = "1.0/flutter";
      print("auth req,userId=$userId,nickName=$nickName,token=$userToken");
      sendRequest(CIMCmdID.kCIM_CID_LOGIN_AUTH_TOKEN_REQ.value, req, (rsp) {
        if (rsp is CIMAuthTokenRsp) {
          if (rsp.resultCode == CIMErrorCode.kCIM_ERR_SUCCSSE) {
            this.isLogin = true;
            this.userId = rsp.userInfo.userId;
          }
        }
        completer.complete(rsp);
      });
    }).catchError((err) {
      completer.completeError(err);
      print("connect error:" + err.toString());
    });
    return completer.future;
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
        onHandle(header, data);
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
      IMRequest req = new IMRequest(header, callback);
      requestMap[header.seqNumber] = req;
    }
  }

  // 消息总处理
  void onHandle(IMHeader header, List<int> data) {
    if (header.commandId == CIMCmdID.kCIM_CID_LOGIN_HEARTBEAT.value) {
      print("onHandle heartbeat");
      return null;
    }

    if (header.commandId == CIMCmdID.kCIM_CID_LOGIN_AUTH_TOKEN_RSP.value) {
      _handleAuthRsp(header, data);
    } else if (header.commandId ==
        CIMCmdID.kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP.value) {
      _handleRecentSessionList(header, data);
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
    } else {
      print("_handleRecentSessionList err:can't find req:${header.seqNumber}");
    }
  }
}
