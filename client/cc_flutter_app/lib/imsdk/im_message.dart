import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/imsdk/im_client.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';

class IMMessage {
  Map<String, CIMMsgData> ackMsgMap = new Map<String, CIMMsgData>();

  /// 发送一条消息
  /// [toSessionId] 单聊，则为用户ID。群聊，则为群组ID
  /// [msgType] 消息类型
  /// [sessionType] 会话类型
  /// [msgData] 消息内容
  Future sendMessage(Int64 toSessionId, CIMMsgType msgType,
      CIMSessionType sessionType, String msgData) async {
    var msg = new CIMMsgData();
    msg.fromUserId = ImClient.singleton.userId;
    msg.toSessionId = toSessionId;

    var uuid = new Uuid();
    msg.msgId = uuid.v5(Uuid.NAMESPACE_URL, "www.coffeechat.cn");
    msg.createTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    msg.msgType = msgType;
    msg.sessionType = sessionType;
    msg.msgData = utf8.encode(msgData);

    // add
    if (!ackMsgMap.containsKey(msg.msgId)) {
      ackMsgMap[msg.msgId] = msg;
    }

    ImClient.singleton.send(CIMCmdID.kCIM_CID_MSG_DATA.value, msg);
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
}
