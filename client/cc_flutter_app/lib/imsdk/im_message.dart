import 'dart:convert';

import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbenum.dart';

/// 代表一条IM消息
class IMMessage {
  String clientMsgId; // 客户端消息ID（UUID）
  int serverMsgId; // 服务端消息ID

  CIMResCode msgResCode; // 消息错误码
  CIMMsgFeature msgFeature; // 消息属性
  CIMSessionType sessionType; // 会话类型
  int fromUserId; // 来源用户ID
  String fromUserNickName; // 会话用户昵称
  int toSessionId; // 目标会话ID
  int createTime; // 消息创建时间戳（毫秒）

  CIMMsgType msgType; // 消息类型
  CIMMsgStatus msgStatus; // 消息状态（预留）
  String msgData; // 消息内容
  /*optional*/
  String attach; // 消息附件（预留）
  CIMClientType senderClientType; // 发送者客户端类型
}

/// 代表一条文本消息 msgData代表一条文本
class IMMessageText extends IMMessage {}
