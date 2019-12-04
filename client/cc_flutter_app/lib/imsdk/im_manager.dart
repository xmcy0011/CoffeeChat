import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/imsdk/core/business/message_business.dart';
import 'package:cc_flutter_app/imsdk/core/business/session_business.dart';
import 'package:cc_flutter_app/imsdk/core/dao/session_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/business/im_client.dart';
import 'package:cc_flutter_app/imsdk/core/dao/sql_manager.dart';
import 'package:cc_flutter_app/imsdk/core/log_util.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Login.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/im_header.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'core/im_user_config.dart';
import 'im_message.dart';

/// 核心类，负责IM SDK的基本操作，初始化、登录、注销、创建会话等
class IMManager extends IMessage {
  var isInit = false;
  var sessionDbProvider = new SessionDbProvider();
  IMUserConfig userConfig;

  var messageListenerCbMap = new Map<String, Function>(); // 收到一条消息的回调队列

  Int64 userId;
  var nickName;
  var ip;
  var port;
  var userToken;

  /// 单实例
  static final IMManager singleton = IMManager._internal();

  factory IMManager() {
    return singleton;
  }

  IMManager._internal();

  /// 初始化
  bool init() {
    isInit = true;
    SQLManager.init();
    IMClient.singleton.registerMessageService("IMManager", this);

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
    if (userConfig == null) {
      com.completeError("please call setUserConfig() set user config!");
      return com.future;
    }

    this.userId = userId;
    this.nickName = nick;
    this.userToken = userToken;
    this.ip = ip;
    this.port = port;

    IMClient.singleton.onDisconnect = userConfig.funcOnDisconnected; // 绑定回调
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

  /// 判断是否是来自于自己的消息
  bool isSelf(int fromUserId) {
    return this.userId == fromUserId;
  }

  /// 获取所有会话
  Future<List<IMSession>> getSessionList() async {
    return sessionDbProvider.getAllSession(userId.toInt());
  }

  /// 增加收到新消息监听器
  /// [name] 唯一标志
  /// [**未实现**listener**] 原型：void onNewMessage(List<IMMessage> msgList)
  /// [listener] 原型：void onNewMessage(CIMMsgData msg)
  void addMessageListener(String name, Function listener) {
    if (!messageListenerCbMap.containsKey(name)) {
      messageListenerCbMap[name] = listener;
    }
  }

  /// 移除新消息监听器
  /// [name] 唯一标志
  void removeMessageListener(String name) {
    messageListenerCbMap.remove(name);
  }

  // interface IMessage
  void onHandleMsgData(IMHeader header, CIMMsgData msg) {
    // 回调
    messageListenerCbMap.forEach((k, v) {
      Function callback = v;
      callback(msg);
    });
  }

  // interface IMessage
  void onHandleMsgDataAck(IMHeader header, CIMMsgDataAck ack) {}

  // 同步会话列表和未读计数
  void _syncSessionAndUnread() async {
    LogUtil.info("_syncSessionAndUnread", "start sync session list...");
    var result = await SessionBusiness.singleton.getRecentSessionList();
    if (result is CIMRecentContactSessionRsp) {
      for (var i = 0; i < result.contactSessionList.length; i++) {
        var session = result.contactSessionList[i];
        int count =
            await sessionDbProvider.existSession(userId.toInt(), session.sessionId.toInt(), session.sessionType.value);

        IMMessage msg = new IMMessage();
        msg.clientMsgId = session.msgId;
        msg.serverMsgId = session.serverMsgId.toInt();
        msg.createTime = session.updatedTime;
        msg.msgData = utf8.decode(session.msgData);
        msg.msgType = session.msgType;
        msg.fromUserId = session.msgFromUserId.toInt();
        msg.msgStatus = session.msgStatus;

        IMSession model = new IMSession(session.sessionId.toInt(), session.sessionId.toString(), session.sessionType,
            session.unreadCnt, session.updatedTime.toInt(), msg);

        // 存在更新
        if (count > 0) {
          sessionDbProvider.update(userId.toInt(), session.sessionId.toInt(), session.sessionType.value, model);
        } else {
          sessionDbProvider.insert(userId.toInt(), model);
        }
      }

      // 回调
      userConfig.funcOnRefresh();
      LogUtil.info("_syncSessionAndUnread", "sync session success");
    } else {
      LogUtil.error("_syncSessionAndUnread", "sync session error:$result");
    }
  }

  // 同步历史消息
  void _syncMessage() {}
}
