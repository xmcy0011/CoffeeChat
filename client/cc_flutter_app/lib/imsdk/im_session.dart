import 'dart:convert';

import 'package:cc_flutter_app/imsdk/core/business/message_business.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'core/model/model.dart';

/// 会话业务
class IMSession {
  int sessionId; // 会话id，单聊：用户ID，群聊：群ID
  String sessionName; // 会话名称，群聊时有效
  CIMSessionType sessionType; // 会话类型

  int unreadCnt; // 该会话未读消息数量
  int updatedTime; // 更新时间
  MessageModelBase latestMsg; // 最新的消息

  IMSession(this.sessionId, this.sessionName, this.sessionType, this.unreadCnt, this.updatedTime, this.latestMsg);

  /// 格式化时间
  /// 今天，显示时分；昨天，显示昨天；其他，显示年月日
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

  /// 生成客户端消息ID（UUID）
  static String generateMsgId() {
    var uuid = new Uuid();
    //return uuid.v5(Uuid.NAMESPACE_URL, "www.coffeechat.cn");
    return uuid.v4();
  }

  /// 发送一条消息
  /// [msgId] 客户端消息ID（uuid），请使用generateMsgId()生成
  /// [toSessionId] 单聊，则为用户ID。群聊，则为群组ID
  /// [msgType] 消息类型
  /// [sessionType] 会话类型
  /// [msgData] 消息内容
  /// @return [Future] then(CIMMsgDataAck ack).error(String err)
  Future sendMessage(
      String msgId, int toSessionId, CIMMsgType msgType, CIMSessionType sessionType, String msgData) async {
    MessageBusiness.singleton.sendMessage(msgId, toSessionId, msgType, sessionType, msgData);
  }

  /// 从本地数据库中获取历史消息，拉取不到时，可调用getMessage拉取云端消息
  /// [toSessionId] 会话ID
  /// [sessionType] 会话类型
  /// [endMsgId] 结束服务器消息id(不包含在查询结果中)，第一次请求设置为0
  /// [limitCount] 本次查询消息的条数上线(最多100条)
  Future getLocalMessage(int toSessionId, CIMSessionType sessionType, int endMsgId, int limitCount) async {}

  /// 从云端拉取历史消息
  /// [toSessionId] 会话ID
  /// [sessionType] 会话类型
  /// [endMsgId] 结束服务器消息id(不包含在查询结果中)，第一次请求设置为0
  /// [limitCount] 本次查询消息的条数上线(最多100条)
  Future getMessage(int toSessionId, CIMSessionType sessionType, int endMsgId, int limitCount) async {
    return MessageBusiness.singleton.getMessageList(toSessionId, sessionType, endMsgId, limitCount);
  }
}
