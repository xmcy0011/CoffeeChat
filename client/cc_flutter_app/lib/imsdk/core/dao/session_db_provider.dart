import 'dart:convert';

import 'package:cc_flutter_app/imsdk/core/dao/base_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:fixnum/fixnum.dart';

import '../../im_session.dart';

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
  final String columnLatestMsgType = "latest_msg_type";
  final String columnLatestMsgFromId = "latest_msg_from_id";
  final String columnLatestMsgStatus = "latest_msg_status";
  final String columnUnreadCount = "unread_count";

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
        $columnLatestMsgType integer default 0,
        $columnLatestMsgFromId text default null,
        $columnLatestMsgStatus integer default 0,
        $columnUnreadCount integer default 0,
        reserve1 text default null,
        reserve2 integer default null,
        reserve3 integer default null)
      ''';
  }

  ///查询数据库
  Future<List<Map<String, dynamic>>> _getPersonProvider(Database db, int sessionId) async {
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name where $columnSessionId = $sessionId");
    return maps;
  }

  Future<int> existSession(int sessionId, int sessionType) async {
    Database database = await getDataBase();
    List<Map<String, dynamic>> maps = await database
        .rawQuery("select count(1) from $name where $columnSessionId=$sessionId and $columnSessionType=$sessionType");
    return maps[0]["count(1)"];
  }

  ///插入到数据库
  Future insert(IMSession session) async {
    Database db = await getDataBase();
    var userProvider = await _getPersonProvider(db, session.sessionId);
    if (userProvider != null && userProvider.length > 0) {
      print("alread exist session with sessionId:${session.sessionId}");
      return null;
    }
    var sql = '''
    insert into $name ($columnSessionId,$columnSessionType,$columnSessionStatus,
    $columnUpdatedTime,$columnLatestClientMsgId,$columnLatestServerMsgId,
    $columnLatestMsgData,$columnLatestMsgType,$columnLatestMsgFromId,$columnLatestMsgStatus,$columnUnreadCount) 
    values (?,?,?,?,?,?,?,?,?,?,?)
    ''';
    int result = await db.rawInsert(sql, [
      session.sessionId.toString(),
      session.sessionType.value,
      CIMSessionStatusType.kCIM_SESSION_STATUS_OK.value,
      session.updatedTime,
      session.latestMsg.clientMsgId,
      session.latestMsg.serverMsgId,
      session.latestMsg.msgData,
      session.latestMsg.msgType.value,
      session.latestMsg.fromUserId.toString(),
      session.latestMsg.msgStatus.value,
      session.unreadCnt,
    ]);
    //print(result);
  }

  ///更新数据库
  Future<void> update(int sessionId, int sessionType, IMSession session) async {
    Database database = await getDataBase();
    var sql = '''
    update $name set $columnSessionStatus = ?,
    $columnUpdatedTime = ?,$columnLatestClientMsgId = ?,$columnLatestServerMsgId = ?,
    $columnLatestMsgData = ?,$columnLatestMsgType = ?,$columnLatestMsgFromId = ?,$columnLatestMsgStatus = ?,
    $columnUnreadCount = ? where $columnSessionId = ? and $columnSessionType = ?
    ''';
    int result = await database.rawUpdate(sql, [
      CIMSessionStatusType.kCIM_SESSION_STATUS_OK.value,
      session.updatedTime,
      session.latestMsg.clientMsgId,
      session.latestMsg.serverMsgId,
      session.latestMsg.msgData,
      session.latestMsg.msgType.value,
      session.latestMsg.fromUserId,
      session.latestMsg.msgStatus.value,
      session.unreadCnt,
      session.sessionId,
      session.sessionType.value
    ]);
    //print(result);
  }

  Future<void> updateUnreadCount(int sessionId, int sessionType) async {}

  /// 获取所有会话
  Future<List<IMSession>> getAllSession() async {
    Database db = await getDataBase();
    //List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name where session_status != 1");
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name order by $columnUpdatedTime desc");
    if (maps.length > 0) {
      List<IMSession> list = new List<IMSession>();
      for (var i = 0; i < maps.length; i++) {
        MessageModelBase msg = new MessageModelBase();
        msg.clientMsgId = maps[i][columnLatestClientMsgId];
        msg.serverMsgId = maps[i][columnLatestServerMsgId];
        msg.createTime = maps[i][columnUpdatedTime];
        msg.msgData = maps[i][columnLatestMsgData];
        msg.msgType = CIMMsgType.valueOf(maps[i][columnLatestMsgType]);
        msg.fromUserId = int.parse(maps[i][columnLatestMsgFromId]); // String
        msg.msgStatus = CIMMsgStatus.valueOf(maps[i][columnLatestMsgStatus]);

        IMSession session = new IMSession(
            int.parse(maps[i][columnSessionId]), // String
            "",
            CIMSessionType.valueOf(maps[i][columnSessionType]),
            maps[i][columnUnreadCount],
            maps[i][columnUpdatedTime],
            msg);
        list.add(session);
      }
      return list;
    }
    return null;
  }
}
