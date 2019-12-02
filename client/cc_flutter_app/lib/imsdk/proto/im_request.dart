import 'dart:async';

import 'package:cc_flutter_app/imsdk/proto/im_header.dart';

/// 请求消息
class IMRequest {
  IMHeader header; // 消息
  Function callback; // 回调函数
  DateTime requestTime; // 发送请求的时间

  IMRequest(this.header, this.callback, this.requestTime);
}

/// 发送一条消息的请求
class IMMsgRequest extends IMRequest {
  String msgId;

  IMMsgRequest(this.msgId, IMHeader header, Function callback, DateTime reqTime)
      : super(header, callback, reqTime);
}
