import 'package:cc_flutter_app/imsdk/core/im_user_config.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';

/// IM SDK辅助类
/// 继承IMUserConfig，主要是提供事件订阅——发布机制
class IMSDKHelper extends IMUserConfig {
  var _onRefreshCbMap = new Map<String, Function>(); // 数据刷新通知回调（如未读计数，会话列表等）
  var _onRefreshConversationCbMap = new Map<String, Function>(); // 部分会话刷新（包括多终端已读上报同步）
  var _onRecvReceiptCbMap = new Map<String, Function>(); // 已读消息回调

  var onTotalUnreadMsgCb; // 总的未读计数刷新回调

  /// 单实例
  static final IMSDKHelper singleton = IMSDKHelper._internal();

  factory IMSDKHelper() {
    return singleton;
  }

  IMSDKHelper._internal() {
    // 注册supper的回调
    this.setRefreshListener(_onRefresh, _onRefreshConversation);
    this.setMessageReceiptListener(_onRecvReceipt);
  }

  // SDK会话更新回调
  void _onRefresh() {
    _onRefreshCbMap.forEach((k, v) {
      v();
    });
  }

  void _onRefreshConversation(List<IMSession> sessions) {
    _onRefreshConversationCbMap.forEach((k, v) {
      v(sessions);
    });
  }

  void _onRecvReceipt(IMSession session, int endMsgId) {
    _onRecvReceiptCbMap.forEach((k, v) {
      v(session, endMsgId);
    });
  }

  /// 部分会话刷新（包括多终端已读上报同步）
  void registerOnRefreshConversation(String key, Function callback) {
    _onRefreshConversationCbMap[key] = callback;
  }

  void unRegisterOnRefreshConversation(String key) {
    _onRefreshConversationCbMap.remove(key);
  }

  /// 数据刷新通知回调（如未读计数，会话列表等）
  void registerOnRefresh(String key, Function callback) {
    _onRefreshCbMap[key] = callback;
  }

  void unRegisterOnRefresh(String key) {
    _onRefreshCbMap.remove(key);
  }

  /// 已读消息
  void registerOnRecvReceipt(String key, Function callback) {
    _onRecvReceiptCbMap[key] = callback;
  }

  void unRegisterOnRecvReceipt(String key) {
    _onRecvReceiptCbMap.remove(key);
  }
}
