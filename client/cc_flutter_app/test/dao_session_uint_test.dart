import 'dart:convert';
import 'dart:io';

import 'package:cc_flutter_app/imsdk/core/dao/session_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/dao/sql_manager.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';

void main() {
  test("SessionDbProvider", () {
    SQLManager.init();

    SessionDbProvider session = new SessionDbProvider();
    CIMContactSessionInfo c = new CIMContactSessionInfo();
    c.sessionId = Int64(1009);
    c.sessionType = CIMSessionType.kCIM_SESSION_TYPE_SINGLE;
    c.sessionStatus = CIMSessionStatusType.kCIM_SESSION_STATUS_OK;
    c.updatedTime = DateTime.now().millisecondsSinceEpoch ~/ 1000; // 取整
    c.msgId = new Uuid().v4();
    c.serverMsgId = Int64(23);
    c.msgFromUserId = Int64(1008);
    c.msgData = utf8.encode("hello world");
    c.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_FAILED;

    // 插入一条
    session.insert(SessionModel.copyFrom(c, "unit_test", "")).then((v) {
      print("insert session success");
    }).catchError((e) {
      print(e);
    });

    session.getAllSession().then((onValue) {
      List<SessionModel> results = onValue;
      for (var i = 0; i < results.length; i++) {
        print("sessionId=${results[i].sessionId},"
            "sessionType=${results[i].sessionType},"
            "sessionName=${results[i].sessionName},"
            "msgDate=${results[i].latestMsg.msgData}");
      }
      expect(results.length, 1);
    }).catchError((e) {
      print(e);
    });
  });
}
