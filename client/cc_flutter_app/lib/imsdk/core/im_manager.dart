import 'dart:async';

import 'package:cc_flutter_app/imsdk/core/dao/session_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/business/im_client.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Login.pb.dart';
import 'package:fixnum/fixnum.dart';

import 'im_user_config.dart';

/// 核心类，负责IM SDK的基本操作，初始化、登录、注销、创建会话等
class IMManager {
  var isInit = false;
  var sessionDbProvider = new SessionDbProvider();
  var userConfig;

  /// 单实例
  static final IMManager singleton = IMManager._internal();

  factory IMManager() {
    return singleton;
  }

  IMManager._internal();

  /// 初始化
  bool init() {
    isInit = true;
    return true;
  }

  /// 设置当前用户的用户配置，登录前设置
  /// [userConfig] 用户配置
  void setUserConfig(IMUserConfig userConfig) {
    this.userConfig = userConfig;
  }

  /// 登录认证
  /// [userId] 用户ID
  /// [nickName] 昵称
  /// [userToken] 认证口令
  /// [ip] 服务器IP
  /// [port] 服务器端口
  /// [callback] (CIMAuthTokenRsp)
  Future login(Int64 userId, var nick, var userToken, var ip, var port) {
    var com = new Completer();
    IMClient.singleton.auth(userId, nick, userToken, ip, port).then((value) {
      com.complete(value);

      if (value is CIMAuthTokenRsp) {
        // 登录成功
        if (value.resultCode == CIMErrorCode.kCIM_ERR_SUCCSSE) {
          // 同步会话列表
          _syncSessionAndUnread();
        }
      }
    }).catchError((e) {
      com.completeError(e);
    });
    return com.future;
  }

  /// 注销
  void logout() {}

  /// 获取所有会话
  List<IMSession> getSessionList() {
    sessionDbProvider.getAllSession();
    return null;
  }



  // 同步会话列表和未读计数
  void _syncSessionAndUnread() {}

  // 同步历史消息
  void _syncMessage() {}
}
