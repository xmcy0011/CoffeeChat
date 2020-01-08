import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/imsdk/core/business/message_business.dart';
import 'package:cc_flutter_app/imsdk/core/business/session_business.dart';
import 'package:cc_flutter_app/imsdk/core/dao/session_db_provider.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'core/log_util.dart';

/// 会话业务
class IMSession {
  int sessionId; // 会话id，单聊：用户ID，群聊：群ID
  String sessionName; // 会话名称，群聊时有效
  CIMSessionType sessionType; // 会话类型
  bool isRobotSession; // 是否为机器人会话

  int unreadCnt; // 该会话未读消息数量
  int updatedTime; // 更新时间
  IMMessage latestMsg; // 最新的消息

  IMSession(this.sessionId, this.sessionName, this.sessionType, this.unreadCnt, this.updatedTime, this.latestMsg,
      this.isRobotSession);

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

  /// 格式化时间2
  /// "时分"；"昨天 时分"；上周 "星期几 时分"；其他，显示"年月日 时分"
  static String timeFormatEx(int time) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var now = DateTime.now();

    // 今天，显示时分
    // 昨天，显示昨天
    // 其他，显示年月日
    var formatter = new DateFormat('HH:mm');
    String formatted = formatter.format(dateTime);
    if (dateTime.day == now.day) {
      return formatted;
    }

    var yesterday = now.subtract(Duration(days: 1));
    if (dateTime.day == yesterday.day) {
      return "昨天 " + formatted;
    }

    var week = now.subtract(Duration(days: 7));
    if (dateTime.millisecondsSinceEpoch > week.millisecondsSinceEpoch) {
      var weekday = "星期一";
      switch (dateTime.weekday) {
        case 2:
          weekday = "星期二";
          break;
        case 3:
          weekday = "星期三";
          break;
        case 4:
          weekday = "星期四";
          break;
        case 5:
          weekday = "星期五";
          break;
        case 6:
          weekday = "星期六";
          break;
        case 7:
          weekday = "星期日";
          break;
      }

      return weekday + " " + formatted;
    }

    formatter = new DateFormat('yyyy年MM月dd日 HH:mm');
    formatted = formatter.format(dateTime);
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
    return IMManager.singleton.sendMessage(msgId, toSessionId, msgType, sessionType, msgData);
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
  /// [return] void callback(List<IMMessage> msgList)
  Future getMessage(int toSessionId, CIMSessionType sessionType, int endMsgId, int limitCount) async {
    var completer = new Completer();
    MessageBusiness.singleton.getMessageList(toSessionId, sessionType, endMsgId, limitCount).then((v) {
      List<IMMessage> msgList = new List<IMMessage>();
      if (v is CIMGetMsgListRsp) {
        v.msgList.forEach((v) {
          IMMessage msg = new IMMessage();
          msg.clientMsgId = v.clientMsgId;
          msg.serverMsgId = v.serverMsgId.toInt();

          msg.msgResCode = v.msgResCode; // 消息错误码
          msg.msgFeature = v.msgFeature; // 消息属性
          msg.sessionType = v.sessionType; // 会话类型
          msg.fromUserId = v.fromUserId.toInt(); // 来源会话ID
          msg.toSessionId = v.toSessionId.toInt(); // 目标会话ID
          msg.createTime = v.createTime; // 消息创建时间戳（毫秒）

          msg.msgType = v.msgType; // 消息类型
          msg.msgStatus = v.msgStatus; // 消息状态（预留）
          msg.msgData = utf8.decode(v.msgData); // 消息内容
          /*optional*/
          msg.attach = v.attach; // 消息附件（预留）
          msg.senderClientType = v.senderClientType; // 发送者客

          msgList.add(msg);
        });
      }
      completer.complete(msgList);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  /// 设置消息已读，针对真个会话，而不是某一条消息
  /// [toSessionId] 会话ID
  /// [sessionType] 会话类型
  /// [endMsgId] 最新客户端消息id，在该ID之前的所有消息被标记为已读。设置为0，则整个会话已读
  setReadMessage(int toSessionId, CIMSessionType sessionType, int endMsgId) async {
    var result = await SessionBusiness.singleton.setReadMessage(toSessionId, sessionType, endMsgId);
    if (result) {
      // 重制会读消息计数
      var sessionMap = IMManager.singleton.sessions;
      for (var i = 0; i < sessionMap.length; i++) {
        var key;
        if (sessionType == CIMSessionType.kCIM_SESSION_TYPE_GROUP) {
          key = "GROUP_" + sessionId.toString();
        } else if (sessionType == CIMSessionType.kCIM_SESSION_TYPE_SINGLE) {
          key = "PEER_" + sessionId.toString();
        } else {
          LogUtil.error("IMSession setReadMessage", "unknow sessionType");
        }

        if (sessionMap[key] != null &&
            sessionMap[key].sessionId == toSessionId &&
            sessionMap[key].sessionType == sessionType) {
          // 会读消息计数
          sessionMap[key].unreadCnt = 0;
          // 清除本地SQlite中会话未读计数
          SessionDbProvider session = new SessionDbProvider();
          session.updateUnreadCount(IMManager.singleton.userId.toInt(), sessionId, sessionType.value, 0);
          break;
        }
      }
    }
    return result;
  }
}
