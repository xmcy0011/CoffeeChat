/// IM 用户配置（登录前设置）
class IMUserConfig {
  Function funcOnForceOffline; // 被其他终端踢下线
  Function funcOnUserSigExpired; // 用户签名过期了，需要刷新 userSig 重新登录 IM SDK

  Function funcOnConnected; // 连接上IM服务器
  Function funcOnDisconnected; // 与IM服务器连接断开
  Function funcOnWifiNeedAuth; // WIFI需要密码认证

  Function funcOnRefresh; // 数据刷新通知回调（如未读计数，会话列表等）
  Function funcOnRefreshConversation; // 部分会话刷新（包括多终端已读上报同步）

  Function funcOnRecvReceipt; // 已读回执回调

  /// 设置用户状态变更事件回调对象
  /// [onForceOffline] void onForceOffline() 被其他终端踢下线
  /// [onUserSigExpired] void onUserSigExpired() 用户签名过期了，需要刷新 userSig 重新登录 IM SDK
  void setUserStatusListener(Function onForceOffline, Function onUserSigExpired) {
    this.funcOnForceOffline = onForceOffline;
    this.funcOnUserSigExpired = onUserSigExpired;
  }

  /// 设置连接状态变更事件回调对象
  /// [onConnected] void onConnected() 连接上IM服务器
  /// [onDisconnected] void onDisconnected(int code, String desc) 与IM服务器连接断开
  /// [onWifiNeedAuth] void onWifiNeedAuth(String name) WIFI需要密码认证
  void setConnectionListener(Function onConnected, Function onDisconnected, Function onWifiNeedAuth) {
    this.funcOnConnected = onConnected;
    this.funcOnDisconnected = onDisconnected;
    this.funcOnWifiNeedAuth = onWifiNeedAuth;
  }

  /// 设置群组事件回调对象
  /// [onGroupTipsEvent] void onGroupTipsEvent(IMMessage elem)
//void setGroupEventListener(Function onGroupTipsEvent) {}

  /// 设置会话刷新回调对象
  /// [onRefresh] void onRefresh() 数据刷新通知回调（如未读计数，会话列表等）
  /// [onRefreshConversation] void onRefreshConversation(List<IMSession> sessions) 部分会话刷新（包括多终端已读上报同步）
  void setRefreshListener(Function onRefresh, Function onRefreshConversation) {
    this.funcOnRefresh = onRefresh;
    this.funcOnRefreshConversation = onRefreshConversation;
  }

  /// 设置已读回执监听器
  /// [onRecvReceipt] void callback(IMSession session,int endMsgId)
  void setMessageReceiptListener(Function onRecvReceipt) {
    this.funcOnRecvReceipt = onRecvReceipt;
  }
}
