import 'dart:convert';

import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:intl/intl.dart';

/// 用户信息
class UserModel {
  int userId; // 用户ID

  String nickName; // 用户昵称
  /*optional*/
  String attachInfo; // 自定义字段

  String avatarURL; // 头像URL
}

/// 消息基类（所有消息类型都具有这些属性）
class MessageModelBase {
  String clientMsgId; // 客户端消息ID（UUID）
  int serverMsgId; // 服务端消息ID

  CIMResCode msgResCode; // 消息错误码
  CIMMsgFeature msgFeature; // 消息属性
  CIMSessionType sessionType; // 会话类型
  int fromUserId; // 来源会话ID
  int toSessionId; // 目标会话ID
  int createTime; // 消息创建时间戳（毫秒）

  CIMMsgType msgType; // 消息类型
  CIMMsgStatus msgStatus; // 消息状态（预留）
  String msgData; // 消息内容
  /*optional*/
  String attach; // 消息附件（预留）
  CIMClientType senderClientType; // 发送者客户端类型

  static MessageModelBase copyFrom(CIMMsgInfo msgInfo) {
    MessageModelBase messageModel = new MessageModelBase();
    messageModel.clientMsgId = msgInfo.clientMsgId;
    messageModel.serverMsgId = msgInfo.serverMsgId.toInt();
    messageModel.msgResCode = msgInfo.msgResCode;
    messageModel.msgFeature = msgInfo.msgFeature;
    messageModel.sessionType = msgInfo.sessionType;
    messageModel.fromUserId = msgInfo.fromUserId.toInt();
    messageModel.toSessionId = msgInfo.toSessionId.toInt();
    messageModel.createTime = msgInfo.createTime;
    messageModel.msgType = msgInfo.msgType;
    messageModel.msgStatus = msgInfo.msgStatus;
    messageModel.msgData = utf8.decode(msgInfo.msgData);
    messageModel.attach = msgInfo.attach;
    messageModel.senderClientType = msgInfo.senderClientType;
    return messageModel;
  }
}

/// 会话
class SessionModel {
  int sessionId; // 会话id
  CIMSessionType sessionType; // 会话类型
  CIMSessionStatusType sessionStatus; // 会话修改命令，预留

  int unreadCnt; // 该会话未读消息数量
  int updatedTime; // 更新时间
  String updateTimeFormat; // 更新时间（美化）

  MessageModelBase latestMsg; // 最新的消息

  String extendData; // 扩展信息，本地使用
  bool isRobotSession; // 是否机器人会话

  String sessionName; // 会话名称
  String avatarUrl; // 会话头像

  static SessionModel copyFrom(CIMContactSessionInfo sessionInfo, String sessionName, String avatarUrl) {
    SessionModel sessionModel = new SessionModel();
    sessionModel.sessionId = sessionInfo.sessionId.toInt();
    sessionModel.sessionType = sessionInfo.sessionType;
    sessionModel.sessionStatus = sessionInfo.sessionStatus;
    sessionModel.sessionName = sessionName;
    sessionModel.avatarUrl = avatarUrl;

    sessionModel.unreadCnt = sessionInfo.unreadCnt;
    sessionModel.updatedTime = sessionInfo.updatedTime;
    sessionModel.updateTimeFormat = timeFormat(sessionInfo.updatedTime);

    sessionModel.latestMsg = new MessageModelBase();
    sessionModel.latestMsg.clientMsgId = sessionInfo.msgId;
    sessionModel.latestMsg.serverMsgId = sessionInfo.serverMsgId.toInt();
    sessionModel.latestMsg.createTime = sessionInfo.msgTimeStamp;
    sessionModel.latestMsg.msgData = utf8.decode(sessionInfo.msgData);
    sessionModel.latestMsg.msgType = sessionInfo.msgType;
    sessionModel.latestMsg.fromUserId = sessionInfo.msgFromUserId.toInt();
    sessionModel.latestMsg.msgStatus = sessionInfo.msgStatus;
    sessionModel.latestMsg.attach = sessionInfo.msgAttach;

    sessionModel.extendData = sessionInfo.extendData;
    sessionModel.isRobotSession = sessionInfo.isRobotSession;

    return sessionModel;
  }

  static String timeFormat(int time) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var now = DateTime.now();

    // 今天，显示时分
    // 昨天，显示昨天
    // 其他，显示年月日
    if (dateTime.day == now.day) {
      //
      var formatter = new DateFormat('HH:mm');
      String formatted = formatter.format(dateTime);
      return formatted;
    }

    var yesterday = now.subtract(Duration(days: 1));
    if (dateTime.day == yesterday.day) {
      return "昨天";
    }

    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    return formatted;
  }
}
