import 'dart:convert';

import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:intl/intl.dart';

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
