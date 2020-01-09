import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:sqflite/sqlite_api.dart';

import 'base_db_provider.dart';

class UserDbProvider extends BaseDbProvider {
  final String name = 'im_user'; //表名
  final String columnUserId = "user_id"; // 这个会话属于那个用户
  final String columnUserNickName = "user_nick_name";
  final String columnAttachInfo = "attach_info"; // 自定义信息，预留
  final String columnUserAvatarUrl = "user_avatar_url"; // 用户头像url
  final String columnUserAvatarPath = "user_avatar_path"; // 头像本地缓存路径
  final String columnCreated = "created";
  final String columnUpdated = "updated";

  UserDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        id integer primary key AUTOINCREMENT,
        $columnUserId integer not null,
        $columnUserNickName text not null,
        $columnAttachInfo text not null,
        $columnUserAvatarUrl text not null,
        $columnUserAvatarPath text not null,
        $columnCreated integer default 0,
        $columnUpdated integer default 0,
        reserve1 text default null,
        reserve2 integer default null,
        reserve3 integer default null)
      ''';
  }

  /// 查询
  Future<UserModel> get(int userId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name where $columnUserId=$userId");
    if (maps.length > 0) {
      UserModel user = new UserModel();
      user.userId = maps[0][columnUserId];
      user.nickName = maps[0][columnUserNickName];
      user.attachInfo = maps[0][columnAttachInfo];
      user.avatarURL = maps[0][columnUserAvatarUrl];
      user.avatarPath = maps[0][columnUserAvatarPath];

      return user;
    }
    return null;
  }

  /// 用户是否存在
  Future<int> existUser(int userId) async {
    Database database = await getDataBase();
    List<Map<String, dynamic>> maps = await database.rawQuery("select count(1) from $name where $columnUserId=$userId");
    return maps.length > 0 ? maps[0]["count(1)"] : 0;
  }

  /// 插入到数据库
  Future insert(int userId, UserModel user) async {
    Database db = await getDataBase();
    var userProvider = await existUser(userId);
    if (userProvider > 0) {
      print("alread exist user with userId:$userId");
      return null;
    }
    var sql = '''
    insert into $name ($columnUserId,$columnUserNickName,$columnAttachInfo,$columnUserAvatarUrl,$columnUserAvatarPath,$columnCreated,
    $columnUpdated) values (?,?,?,?,?,?,?)''';
    int result = await db.rawInsert(sql, [
      userId,
      user.nickName,
      user.attachInfo,
      user.avatarURL,
      user.avatarPath,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      DateTime.now().millisecondsSinceEpoch ~/ 1000
    ]);
    //print(result);
  }

  /// 更新用户信息
  Future<void> update(int userId, UserModel user) async {
    Database database = await getDataBase();
    var sql = '''
    update $name set $columnUserNickName = ?,$columnAttachInfo = ?,$columnUserAvatarUrl = ?,$columnUserAvatarPath = ?,
    $columnUpdated = ? where $columnUserId = ?
    ''';
    int result = await database.rawUpdate(sql, [
      user.nickName,
      user.attachInfo,
      user.avatarURL,
      user.avatarPath,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      userId
    ]);
    //print(result);
  }

  /// 更新昵称
  Future<void> updateNickName(int userId, String nickName) async {
    Database database = await getDataBase();
    var sql = '''
    update $name set $columnUserNickName = ?,$columnUpdated = ? where $columnUserId = ?
    ''';
    int result = await database.rawUpdate(sql, [nickName, DateTime.now().millisecondsSinceEpoch ~/ 1000, userId]);
    //print(result);
  }
}
