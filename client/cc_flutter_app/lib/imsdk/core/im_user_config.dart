import 'package:cc_flutter_app/imsdk/im_session.dart';

typedef ForceOfflineCallback = void Function();
typedef UserSigExpiredCallback = void Function();

typedef ConnectedCallback = void Function();
typedef DisconnectedCallback = void Function(int code, String desc);
typedef WifiNeedAuthCallback = void Function(String name);

typedef RefreshCallback = void Function();
typedef RefreshConversationCallback = void Function(List<IMSession> sessions);

typedef RecvReceiptCallback = void Function(IMSession session, int endMsgId);

/// IM 用户配置（登录前设置）
class IMUserConfig {
  ForceOfflineCallback onForceOffline; // 被其他终端踢下线
  UserSigExpiredCallback onUserSigExpired; // 用户签名过期了，需要刷新 userSig 重新登录 IM SDK

  ConnectedCallback onConnected; // 连接上IM服务器
  DisconnectedCallback onDisconnected; // 与IM服务器连接断开
  WifiNeedAuthCallback onWifiNeedAuth; // WIFI需要密码认证

  RefreshCallback onRefresh; // 数据刷新通知回调（如未读计数，会话列表等）
  RefreshConversationCallback onRefreshConversation; // 部分会话刷新（包括多终端已读上报同步）

  RecvReceiptCallback onRecvReceipt; // 已读回执回调

  /// 设置用户状态变更事件回调对象
  /// [onForceOffline] 被其他终端踢下线
  /// [onUserSigExpired] 用户签名过期了，需要刷新 userSig 重新登录 IM SDK
  void setUserStatusListener(ForceOfflineCallback onForceOffline, UserSigExpiredCallback onUserSigExpired) {
    this.onForceOffline = onForceOffline;
    this.onUserSigExpired = onUserSigExpired;
  }

  /// 设置连接状态变更事件回调对象
  /// [onConnected] 连接上IM服务器
  /// [onDisconnected] 与IM服务器连接断开
  /// [onWifiNeedAuth] WIFI需要密码认证
  void setConnectionListener(
      ConnectedCallback onConnected, DisconnectedCallback onDisconnected, WifiNeedAuthCallback onWifiNeedAuth) {
    this.onConnected = onConnected;
    this.onDisconnected = onDisconnected;
    this.onWifiNeedAuth = onWifiNeedAuth;
  }

  /// 设置群组事件回调对象
  /// [onGroupTipsEvent] void onGroupTipsEvent(IMMessage elem)
//void setGroupEventListener(Function onGroupTipsEvent) {}

  /// 设置会话刷新回调对象
  /// [onRefresh] 数据刷新通知回调（如未读计数，会话列表等）
  /// [onRefreshConversation] 部分会话刷新（包括多终端已读上报同步、会话最新消息更新等）
  void setRefreshListener(RefreshCallback onRefresh, RefreshConversationCallback onRefreshConversation) {
    this.onRefresh = onRefresh;
    this.onRefreshConversation = onRefreshConversation;
  }

  /// 设置已读回执监听器
  /// [onRecvReceipt] 回调
  void setMessageReceiptListener(RecvReceiptCallback onRecvReceipt) {
    this.onRecvReceipt = onRecvReceipt;
  }
}
