import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

/// 数据库管理类
/// https://www.jianshu.com/p/3995ca566d9b
class SQLManager {
  static const _VERSION = 1;

  static const _NAME = "coffeechat.db";

  static Database _database;

  /// 初始化
  static init() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});
  }

  /// 判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  /// 获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }
}
