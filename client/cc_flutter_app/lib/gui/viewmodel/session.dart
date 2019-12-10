import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbenum.dart';

/// 会话
class SessionViewModel {
  int sessionId; // 会话id，单聊：用户ID，群聊：群ID
  String sessionName; // 会话名称，群聊时有效
  CIMSessionType sessionType; // 会话类型

  int unreadCnt; // 该会话未读消息数量
  int updatedTime; // 更新时间
  IMMessage latestMsg; // 最新的消息

  SessionViewModel(
      this.sessionId, this.sessionName, this.sessionType, this.unreadCnt, this.updatedTime, this.latestMsg);
}
