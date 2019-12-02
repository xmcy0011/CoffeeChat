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
