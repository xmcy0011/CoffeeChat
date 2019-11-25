import 'dart:convert';

import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:fixnum/fixnum.dart';

class UserModel {
  Int64 userId; // 用户ID

  String nickName; // 用户昵称
  /*optional*/
  String attachInfo; // 自定义字段

  String avatarURL; // 头像URL
}

class MessageModel {
  String clientMsgId; // 客户端消息ID（UUID）
  Int64 serverMsgId; // 服务端消息ID

  CIMResCode msgResCode; // 消息错误码
  CIMMsgFeature msgFeature; // 消息属性
  CIMSessionType sessionType; // 会话类型
  Int64 fromUserId; // 来源会话ID
  Int64 toSessionId; // 目标会话ID
  int createTime; // 消息创建时间戳（毫秒）

  CIMMsgType msgType; // 消息类型
  CIMMsgStatus msgStatus; // 消息状态（预留）
  String msgData; // 消息内容
  /*optional*/
  String attach; // 消息附件（预留）
  CIMClientType senderClientType; // 发送者客户端类型

  MessageModel(CIMMsgInfo msgInfo) {
    this.clientMsgId = msgInfo.clientMsgId;
    this.serverMsgId = msgInfo.serverMsgId;
    this.msgResCode = msgInfo.msgResCode;
    this.msgFeature = msgInfo.msgFeature;
    this.sessionType = msgInfo.sessionType;
    this.fromUserId = msgInfo.fromUserId;
    this.toSessionId = msgInfo.toSessionId;
    this.createTime = msgInfo.createTime;
    this.msgType = msgInfo.msgType;
    this.msgStatus = msgInfo.msgStatus;
    this.msgData = utf8.decode(msgInfo.msgData);
    this.attach = msgInfo.attach;
    this.senderClientType = msgInfo.senderClientType;
  }
}

class SessionModel {
  Int64 sessionId; // 会话id
  CIMSessionType sessionType; // 会话类型
  CIMSessionStatusType sessionStatus; // 会话修改命令，预留

  int unreadCnt; // 该会话未读消息数量
  int updatedTime; // 更新时间

  String clientMsgId; // 最新一条消息的id（UUID）
  Int64 serverMsgId; // 最新一条消息服务端的id（顺序递增）
  int msgTimeStamp; // 最新一条消息时间戳（毫秒）
  String msgData; // 最新一条消息的内容
  CIMMsgType msgType; // 最新一条消息的类型
  Int64 msgFromUserId; // 最新一条消息的发送者
  CIMMsgStatus msgStatus; // 最新一条消息的状态（预留）
  /*optional*/
  String msgAttach; // 最新一条消息的附件（预留）
  /*optional*/
  String extendData; // 本地扩展字段（限制4096）
  /*optional*/
  bool isRobotSession; // 是否为机器人会话

  String sessionName; // 会话名称
  String avatarUrl; // 会话头像

  SessionModel(
      CIMContactSessionInfo sessionInfo, this.sessionName, this.avatarUrl) {
    this.sessionId = sessionInfo.sessionId;
    this.sessionType = sessionInfo.sessionType;
    this.sessionStatus = sessionInfo.sessionStatus;

    this.unreadCnt = sessionInfo.unreadCnt;
    this.updatedTime = sessionInfo.updatedTime;

    this.clientMsgId = sessionInfo.msgId;
    this.serverMsgId = sessionInfo.serverMsgId;
    this.msgTimeStamp = sessionInfo.msgTimeStamp;
    this.msgData = utf8.decode(sessionInfo.msgData);
    this.msgType = sessionInfo.msgType;
    this.msgFromUserId = sessionInfo.msgFromUserId;
    this.msgStatus = sessionInfo.msgStatus;
    this.msgAttach = sessionInfo.msgAttach;
    this.extendData = sessionInfo.extendData;
    this.isRobotSession = sessionInfo.isRobotSession;
  }
}
