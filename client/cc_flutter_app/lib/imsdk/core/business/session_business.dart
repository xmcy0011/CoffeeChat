import 'dart:async';

import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbenum.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';

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

  Future setReadMessage() async{

  }
}
