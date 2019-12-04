import 'dart:async';

import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbenum.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:fixnum/fixnum.dart';

import '../../im_manager.dart';
import 'im_client.dart';

/// 会话业务
class SessionBusiness {
  static final SessionBusiness singleton = SessionBusiness._internal();

  factory SessionBusiness() {
    return singleton;
  }

  SessionBusiness._internal();

  /// 查询最近会话列表
  /// [Future] CIMRecentContactSessionRsp
  Future getRecentSessionList() async {
    var complete = new Completer();

    var req = new CIMRecentContactSessionReq();
    req.userId = IMManager.singleton.userId;
    req.latestUpdateTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print("getRecentSessionList userId=${req.userId}");

    var cmd = CIMCmdID.kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ.value;
    IMClient.singleton.sendRequest(cmd, req, (rsp) {
      if (rsp is CIMRecentContactSessionRsp) {
        complete.complete(rsp);
      } else {
        complete.completeError(rsp);
      }
    });
    return complete.future;
  }

  /// 设置消息已读，针对真个会话，而不是某一条消息
  /// [toSessionId] 会话ID
  /// [sessionType] 会话类型
  /// [endMsgId] 最新服务器消息id，在该ID之前的所有消息被标记为已读。设置为0，则整个会话已读
  setReadMessage(int toSessionId, CIMSessionType sessionType, int endMsgId) async {
    var req = new CIMMsgDataReadAck();
    req.userId = IMManager.singleton.userId;
    req.sessionId = Int64(toSessionId);
    req.sessionType = sessionType;
    req.msgId = Int64(endMsgId);

    print("getRecentSessionList userId=${req.userId}");

    var cmd = CIMCmdID.kCIM_CID_MSG_READ_ACK.value;
    return IMClient.singleton.send(cmd, req) > 0;
  }
}
