import 'package:cc_flutter_app/imsdk/model/im_header.dart';

/// 请求消息
class IMRequest {
  IMHeader header; // 消息
  Function callback; // 回调函数

  IMRequest(this.header, this.callback);
}
