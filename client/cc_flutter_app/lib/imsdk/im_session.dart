import 'dart:async';

import 'package:cc_flutter_app/imsdk/core/im_client.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';

/// 会话业务
class IMSession {
  /// 查询最近会话列表
  /// [Future] CIMRecentContactSessionReq
  Future getRecentSessionList() async {
    var complete = new Completer();

    var req = new CIMRecentContactSessionReq();
    req.userId = ImClient.singleton.userId;
    req.latestUpdateTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print("getRecentSessionList userId=${req.userId}");

    var cmd = CIMCmdID.kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ.value;
    ImClient.singleton.sendRequest(cmd, req, (rsp) {
      if (rsp is CIMRecentContactSessionRsp){
        complete.complete(rsp);
      }else{
        complete.completeError(rsp);
      }
    });
    return complete.future;
  }
}
