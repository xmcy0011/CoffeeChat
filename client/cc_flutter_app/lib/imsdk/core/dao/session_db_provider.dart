import 'dart:convert';

import 'package:cc_flutter_app/imsdk/core/dao/base_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:fixnum/fixnum.dart';

class SessionDbProvider extends BaseDbProvider {
  ///表名
  final String name = 'im_session';
  final String columnSessionId = "session_id";
  final String columnSessionType = "session_type";
  final String columnSessionStatus = "session_status";
  final String columnUpdatedTime = "updated_time";
  final String columnLatestClientMsgId = "latest_client_msg_id";
  final String columnLatestServerMsgId = "latest_server_msg_id";
  final String columnLatestMsgData = "latest_msg_data";
  final String columnLatestMsgFromId = "latest_msg_from_id";
  final String columnLatestMsgStatus = "latest_msg_status";

  SessionDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        id integer primary key AUTOINCREMENT,
        $columnSessionId text not null,
        $columnSessionType integer not null,
        $columnSessionStatus integer not null,
        $columnUpdatedTime integer not null,
        $columnLatestClientMsgId text not null,
        $columnLatestServerMsgId integer default 0,
        $columnLatestMsgData text default null,
        $columnLatestMsgFromId text default null,
        $columnLatestMsgStatus integer default 0,
        reserve1 text default null,
        reserve2 integer default null,
        reserve3 integer default null)
      ''';
  }

  ///查询数据库
  Future _getPersonProvider(Database db, Int64 sessionId) async {
    List<Map<String, dynamic>> maps = await db
        .rawQuery("select * from $name where $columnSessionId = $sessionId");
    return maps;
  }

  ///插入到数据库
  Future insert(SessionModel session) async {
    Database db = await getDataBase();
    var userProvider = await _getPersonProvider(db, session.sessionId);
    if (userProvider != null) {
      print("alread exist session with sessionId:${session.sessionId}");
      return null;
    }
    var sql = '''
    insert into $name ($columnSessionId,$columnSessionType,$columnSessionStatus,
    $columnUpdatedTime,$columnLatestClientMsgId,$columnLatestServerMsgId,
    $columnLatestMsgData,$columnLatestMsgFromId,$columnLatestMsgStatus) 
    values (?,?,?,?,?,?,?,?,?)
    ''';
    return await db.rawInsert(sql, [
      session.sessionId,
      session.sessionType.value,
      session.sessionStatus.value,
      session.updatedTime,
      session.latestMsg.clientMsgId,
      session.latestMsg.serverMsgId,
      session.latestMsg.msgData,
      session.latestMsg.fromUserId,
      session.latestMsg.msgStatus.value,
    ]);
  }

  ///更新数据库
//  Future<void> update(UserModel model) async {
//    Database database = await getDataBase();
//    await database.rawUpdate(
//        "update $name set $columnMobile = ?,$columnHeadImage = ? where $columnId= ?",
//        [model.mobile, model.headImage, model.id]);
//  }

  /// 获取所有会话
  Future<List<SessionModel>> getAllSession() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $name where session_status != 1");
    if (maps.length > 0) {
      List<SessionModel> list = new List<SessionModel>();
      for (var i = 0; i < maps.length; i++) {
        CIMContactSessionInfo sessionInfo = new CIMContactSessionInfo();
        sessionInfo.sessionId = maps[i][columnSessionId];
        // 会话类型
        if (maps[i][columnSessionType] == 1) {
          sessionInfo.sessionType = CIMSessionType.kCIM_SESSION_TYPE_SINGLE;
        } else if (maps[i][columnSessionType] == 2) {
          sessionInfo.sessionType = CIMSessionType.kCIM_SESSION_TYPE_GROUP;
        } else {
          sessionInfo.sessionType = CIMSessionType.kCIM_SESSION_TYPE_Invalid;
        }
        sessionInfo.sessionStatus = maps[i][columnSessionStatus];
        sessionInfo.updatedTime = maps[i][columnUpdatedTime];

        sessionInfo.msgId = maps[i][columnLatestClientMsgId];
        sessionInfo.serverMsgId = maps[i][columnLatestServerMsgId];
        sessionInfo.msgTimeStamp = sessionInfo.updatedTime;
        sessionInfo.msgData = utf8.encode(maps[i][columnLatestMsgData]);
        //sessionInfo.msgType =
        sessionInfo.msgFromUserId = maps[i][columnLatestMsgFromId];
        sessionInfo.msgStatus = maps[i][columnLatestMsgStatus];
        //sessionInfo.msgAttach

        SessionModel model =
            SessionModel.copyFrom(sessionInfo, maps[i]["session_id"], "");
        list.add(model);
      }
    }
    return null;
  }
}
