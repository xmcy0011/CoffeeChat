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

  static MessageModel copyFrom(CIMMsgInfo msgInfo) {
    MessageModel messageModel = new MessageModel();
    messageModel.clientMsgId = msgInfo.clientMsgId;
    messageModel.serverMsgId = msgInfo.serverMsgId;
    messageModel.msgResCode = msgInfo.msgResCode;
    messageModel.msgFeature = msgInfo.msgFeature;
    messageModel.sessionType = msgInfo.sessionType;
    messageModel.fromUserId = msgInfo.fromUserId;
    messageModel.toSessionId = msgInfo.toSessionId;
    messageModel.createTime = msgInfo.createTime;
    messageModel.msgType = msgInfo.msgType;
    messageModel.msgStatus = msgInfo.msgStatus;
    messageModel.msgData = utf8.decode(msgInfo.msgData);
    messageModel.attach = msgInfo.attach;
    messageModel.senderClientType = msgInfo.senderClientType;
    return messageModel;
  }
}

class SessionModel {
  Int64 sessionId; // 会话id
  CIMSessionType sessionType; // 会话类型
  CIMSessionStatusType sessionStatus; // 会话修改命令，预留

  int unreadCnt; // 该会话未读消息数量
  int updatedTime; // 更新时间

  MessageModel latestMsg; // 最新的消息

  String extendData; // 扩展信息，本地使用
  bool isRobotSession; // 是否机器人会话

  String sessionName; // 会话名称
  String avatarUrl; // 会话头像

  static SessionModel copyFrom(
      CIMContactSessionInfo sessionInfo, String sessionName, String avatarUrl) {
    SessionModel sessionModel = new SessionModel();
    sessionModel.sessionId = sessionInfo.sessionId;
    sessionModel.sessionType = sessionInfo.sessionType;
    sessionModel.sessionStatus = sessionInfo.sessionStatus;

    sessionModel.unreadCnt = sessionInfo.unreadCnt;
    sessionModel.updatedTime = sessionInfo.updatedTime;

    sessionModel.latestMsg = new MessageModel();
    sessionModel.latestMsg.clientMsgId = sessionInfo.msgId;
    sessionModel.latestMsg.serverMsgId = sessionInfo.serverMsgId;
    sessionModel.latestMsg.createTime = sessionInfo.msgTimeStamp;
    sessionModel.latestMsg.msgData = utf8.decode(sessionInfo.msgData);
    sessionModel.latestMsg.msgType = sessionInfo.msgType;
    sessionModel.latestMsg.fromUserId = sessionInfo.msgFromUserId;
    sessionModel.latestMsg.msgStatus = sessionInfo.msgStatus;
    sessionModel.latestMsg.attach = sessionInfo.msgAttach;

    sessionModel.extendData = sessionInfo.extendData;
    sessionModel.isRobotSession = sessionInfo.isRobotSession;

    return sessionModel;
  }
}
