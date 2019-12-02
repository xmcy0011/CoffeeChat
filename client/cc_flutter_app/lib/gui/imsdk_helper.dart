import 'package:cc_flutter_app/imsdk/core/im_user_config.dart';

/// IM SDK辅助类
class IMSDKHelper extends IMUserConfig {
  var _onRefreshCbMap = new Map<String, Function>(); // 收到一条消息的回调队列

  /// 单实例
  static final IMSDKHelper singleton = IMSDKHelper._internal();

  factory IMSDKHelper() {
    return singleton;
  }

  IMSDKHelper._internal() {
    this.setRefreshListener(_onRefresh, _onRefreshConversation);
  }

  // SDK会话更新回调
  void _onRefresh() {}

  void _onRefreshConversation() {}

  void registerOnRefresh(String key, Function callback) {
    _onRefreshCbMap[key] = callback;
  }

  void unRegisterOnRefresh(String key) {
    _onRefreshCbMap.remove(key);
  }
}
