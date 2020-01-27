import 'package:cc_flutter_app/imsdk/im_avchat.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbenum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 跳转某个页面，无法返回
void navigatePage(BuildContext context, Widget widget) {
  // 路由实例
  var pageRoute = new MaterialPageRoute(builder: (BuildContext context) => widget);
  var where = (Route route) => route == null; // 清除条件

  try {
    Navigator.of(context).pushAndRemoveUntil(pageRoute, where);
  } catch (e) {
    print(e);
  }
}

/// 跳转某个页面，放入到路由表中，可以返回
Future navigatePushPage(BuildContext context, Widget widget) {
  var pageRoute = new MaterialPageRoute(builder: (BuildContext context) => widget);
//  try {
//    Navigator.of(context).push(pageRoute);
//  } catch (e) {
//    print(e);
//  }
  return Navigator.of(context).push(pageRoute);
}

/// 格式化音视频通话消息
String formatAVChatMsg(AVChatMsgContent msgContent) {
  var text = "";
  if (msgContent.callType == CIMVoipInviteType.kCIM_VOIP_INVITE_TYPE_VOICE_CALL) {
    text = "📞 "; // 电话 前缀
  } else if (msgContent.callType == CIMVoipInviteType.kCIM_VOIP_INVITE_TYPE_VIDEO_CALL) {
    text = "📹 "; // 录像机 前缀
  }

  var eventType = IMAVChat.singleton.convertAVChatCommonEvent(msgContent.hangupReason);
  text += IMAVChat.singleton.getHangupReasonStr(msgContent.hangupUserId, eventType);

  if (msgContent.timeLen > 0 && msgContent.hangupReason == CIMVoipByeReason.kCIM_VOIP_BYE_REASON_END) {
    var min = msgContent.timeLen ~/ 60;
    var second = msgContent.timeLen % 60;
    var hour = msgContent.timeLen ~/ 3600;
    var timeLenStr = "";
    if (hour > 10) {
      timeLenStr = hour.toString();
    } else {
      timeLenStr = "0" + hour.toString();
    }

    if (min > 10) {
      timeLenStr += ":" + min.toString();
    } else {
      timeLenStr += ":0" + min.toString();
    }

    if (second > 10) {
      timeLenStr += ":" + second.toString();
    } else {
      timeLenStr += ":0" + second.toString();
    }

    text += timeLenStr;
  }

  return text;
}
