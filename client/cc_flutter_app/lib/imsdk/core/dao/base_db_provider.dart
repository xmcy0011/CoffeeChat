import 'package:cc_flutter_app/imsdk/core/dao/sql_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqlite_api.dart';

/// SQL操作基类
abstract class BaseDbProvider {
  bool isTableExits = false;

  /// 创表语句
  createTableString();

  /// 表名称
  tableName();

  /// 创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  /// super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await SQLManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await SQLManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  /// super 打开数据表
  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await SQLManager.getCurrentDatabase();
  }
}
