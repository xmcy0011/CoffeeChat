import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/imsdk/im_client.dart';
import 'package:cc_flutter_app/imsdk/model/im_header.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';

import 'model/im_request.dart';

/// 消息收发
class IMMessage {
  var ackMsgMap = new Map<String, IMMsgRequest>(); // 消息待收到成功响应队列
  var onReceiveMsgCbMap = new Map<String, Function>(); // 收到一条消息的回调队列

  /// 单实例
  static final IMMessage singleton = IMMessage._internal();

  factory IMMessage() {
    return singleton;
  }

  IMMessage._internal() {
    // 注册消息业务回调
    ImClient.singleton.registerMessageService(this);

    // timeout
    Timer.periodic(Duration(seconds: 1), (timer) {
      _checkMsgAckTimeout();
    });
  }

  /// 发送一条消息
  /// [msgId] 客户端消息ID（uuid），请使用generateMsgId()生成
  /// [toSessionId] 单聊，则为用户ID。群聊，则为群组ID
  /// [msgType] 消息类型
  /// [sessionType] 会话类型
  /// [msgData] 消息内容
  /// @return [Future] then(CIMMsgDataAck ack).error(String err)
  Future sendMessage(String msgId, Int64 toSessionId, CIMMsgType msgType,
      CIMSessionType sessionType, String msgData) async {
    var completer = new Completer();

    print("sendMessage toSessionId=$toSessionId,msgType=$msgType,"
        "sessionType=$sessionType,msgData=$msgData");

    var msg = new CIMMsgData();
    msg.fromUserId = ImClient.singleton.userId;
    msg.toSessionId = toSessionId;

    var uuid = new Uuid();
    //msg.msgId = uuid.v5(Uuid.NAMESPACE_URL, "www.coffeechat.cn");
    msg.msgId = msgId;
    msg.createTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    msg.msgType = msgType;
    msg.sessionType = sessionType;
    msg.msgData = utf8.encode(msgData);

    // 发送结果
    Function callback = (rsp) {
      if (rsp is CIMMsgDataAck) {
        completer.complete(rsp);
      } else {
        completer.completeError(rsp);
      }
    };

    // add
    if (!ackMsgMap.containsKey(msg.msgId)) {
      var request = new IMMsgRequest(msg.msgId, null, callback, DateTime.now());
      ackMsgMap[msg.msgId] = request;
    } else {
      print("msgId=${msg.msgId} is find,resend msg");
    }

    // 注意，CIM_CID_MSG_DATA对应的返回是kCIM_CID_MSG_DATA_ACK，且不能用序号
    ImClient.singleton.send(CIMCmdID.kCIM_CID_MSG_DATA.value, msg);
    return completer.future;
  }

  /// 生成客户端消息ID（UUID）
  String generateMsgId() {
    var uuid = new Uuid();
    //return uuid.v5(Uuid.NAMESPACE_URL, "www.coffeechat.cn");
    return uuid.v4();
  }

  /// 查询历史漫游消息
  /// [toSessionId] 会话ID
  /// [sessionType] 会话类型
  /// [endMsgId] 结束服务器消息id(不包含在查询结果中)，第一次请求设置为0
  /// [limitCount] 本次查询消息的条数上线(最多100条)
  Future getMessageList(Int64 toSessionId, CIMSessionType sessionType,
      Int64 endMsgId, int limitCount) async {
    print("getMessageList toSessionId=$toSessionId,sessionType=$sessionType,"
        "endMsgId=$endMsgId,limitCount=$limitCount");

    var completer = new Completer();

    var req = new CIMGetMsgListReq();
    req.userId = ImClient.singleton.userId;
    req.sessionId = toSessionId;
    req.sessionType = sessionType;
    req.limitCount = limitCount;
    req.endMsgId = endMsgId;

    if (!ImClient.singleton.isLogin) {
      new Timer(Duration(milliseconds: 200), () {
        completer.completeError("network is unavailable");
      });
      return completer.future;
    }

    ImClient.singleton.sendRequest(CIMCmdID.kCIM_CID_LIST_MSG_REQ.value, req,
        (rsp) {
      if (rsp is CIMGetMsgListRsp) {
        completer.complete(rsp);
      } else {
        completer.completeError(rsp);
      }
    });
    return completer.future;
  }

  /// 注册收到新消息的回调
  /// [name] 标志符，用于反注册使用
  /// [callback] 回调，void onReceiveMsg(CIMMsgData msg)
  void registerReceiveCallback(String name, Function callback) {
    print("registerReceiveCallback key=$name");
    onReceiveMsgCbMap[name] = callback;
  }

  /// 取消收到新消息的回调
  /// [name] 标志符
  void unregisterReceiveCallback(String name) {
    print("unregisterReceiveCallback key=$name");
    onReceiveMsgCbMap.remove(name);
  }

  void _checkMsgAckTimeout() {
    Map<String, IMMsgRequest> tempList;

    ackMsgMap.forEach((k, v) {
      var reqTime = v.requestTime;
      var timespan = DateTime.now().difference(reqTime).inSeconds;
      if (timespan >= kRequestMsgTimeout) {
        print("timeout msgId=${v.msgId}");
        v.callback("timeout");
        if (tempList == null) {
          tempList = new Map<String, IMMsgRequest>();
        }
        tempList[v.msgId] = v;
      }
    });

    // clear timeout request
    if (tempList != null) {
      tempList.forEach((k, v) {
        ackMsgMap.remove(k);
      });
      tempList.clear();
    }
  }

  void onHandle(IMHeader header, List<int> data) {
    if (header.commandId == CIMCmdID.kCIM_CID_MSG_DATA.value) {
      _handleMsgData(header, data);
    } else if (header.commandId == CIMCmdID.kCIM_CID_MSG_DATA_ACK.value) {
      _handleMsgDataAck(header, data);
    } else {
      print("unknow command:${header.commandId}");
    }
  }

  void _handleMsgData(IMHeader header, List<int> data) {
    var msg = CIMMsgData.fromBuffer(data);
    print("_handleMsgData fromId=${msg.fromUserId},toId=${msg.toSessionId},"
        "msgType=${msg.msgType},msgId=${msg.msgId}"
        "sessionType=${msg.sessionType}");
    // 回复ack
    var ack = new CIMMsgDataAck();
    ack.msgId = msg.msgId;
    if (ack.sessionType == CIMSessionType.kCIM_SESSION_TYPE_SINGLE) {
      ack.toSessionId = msg.fromUserId;
    } else {
      ack.toSessionId = msg.toSessionId;
    }
    ack.fromUserId = ImClient.singleton.userId;
    ack.sessionType = msg.sessionType;
    ack.createTime = msg.createTime;
    ack.serverMsgId = Int64(0); // 不用填
    ImClient.singleton.send(CIMCmdID.kCIM_CID_MSG_DATA_ACK.value, ack);

    // 回调
    onReceiveMsgCbMap.forEach((name, callback) {
      callback(msg);
    });
  }

  void _handleMsgDataAck(IMHeader header, List<int> data) {
    var ack = CIMMsgDataAck.fromBuffer(data);

    if (ackMsgMap.containsKey(ack.msgId)) {
      print("_handleMsgDataAck msgId=${ack.msgId} send success");
      ackMsgMap[ack.msgId].callback(ack);
      ackMsgMap.remove(ack.msgId);
    } else {
      print("_handleMsgDataAck msgId=${ack.msgId} not find");
    }
  }
}
