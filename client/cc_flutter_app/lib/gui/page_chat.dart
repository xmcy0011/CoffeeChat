import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/gui/imsdk_helper.dart';
import 'package:cc_flutter_app/gui/page_message.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/im_user.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:fixnum/fixnum.dart';

// 会话列表，聊天首页
class PageChatStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageChatStateWidgetState();
}

class _PageChatStateWidgetState extends State<PageChatStateWidget> {
  List<IMSession> _sessionList = new List<IMSession>();
  var _selectedSessionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _onAdd,
          )
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          // 下拉刷新
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: _sessionList.length,
            itemBuilder: _buildSession,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    IMSDKHelper.singleton.registerOnRefresh("_PageChatStateWidgetState", _onRefreshSessionAll);
    IMSDKHelper.singleton.registerOnRefreshConversation("_PageChatStateWidgetState", _onRefreshSession);
    _onRefreshSessionAll();
  }

  @override
  void dispose() {
    IMManager.singleton.removeMessageListener("_PageChatStateWidgetState");
    IMSDKHelper.singleton.unRegisterOnRefresh("_PageChatStateWidgetState");
    super.dispose();
  }

  Widget _buildBadge(IMSession session) {
    if (session.unreadCnt == 0) {
      return Container();
    }

    var textUnread = session.unreadCnt > 99 ? "99+" : session.unreadCnt.toString();

    return Container(
      width: 24,
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.red, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        textUnread,
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  Widget _buildSession(context, index) {
    IMSession session = _sessionList[index];

    return Column(children: <Widget>[
      GestureDetector(
        onTap: () => _onTap(index),
        child: ListTile(
          // 头像
          leading: Stack(
            children: <Widget>[
              Padding(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  clipBehavior: Clip.antiAlias, // 抗锯齿
//                  child: FadeInImage(
//                    //FIXED ME
//                    //image: NetworkImage(session.avatarUrl),
//                    image: AssetImage('assets/default_avatar.png'),
//                    placeholder: AssetImage('assets/default_avatar.png'),
//                  ),
                  child: Image(image: AssetImage('assets/default_avatar.png')),
                ),
                padding: EdgeInsets.only(right: 10, top: 3),
              ),
              Positioned(
                right: 1,
                top: 0,
                child: _buildBadge(session),
              ),
            ],
          ),
          // 标题
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                session.sessionName,
                style: Theme.of(context).textTheme.subhead,
              ),
              new Text(
                IMSession.timeFormat(session.updatedTime),
                style: new TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
            ],
          ),
          // 副标题
          subtitle: new Text(_getMessageText(index), maxLines: 1),
        ),
      ),
      Divider(
        height: 12.0,
      ),
    ]);
  }

  void _onAdd() {
    _asyncInputDialog(context);
  }

  Future _onRefresh() async {
    // 拉取会话列表
//    var session = new IMSession();
//    session.getRecentSessionList().then((data) {
//      setState(() {
//        _sessionList.clear();
//      });
//      if (data is CIMRecentContactSessionRsp) {
//        for (var i = 0; i < data.contactSessionList.length; i++) {
//          var sessionInfo = data.contactSessionList.elementAt(i);
//
//          SessionModel model = SessionModel.copyFrom(sessionInfo, sessionInfo.sessionId.toString(), "");
//          //subtitle = "[${sessionInfo.msgFromUserId}]" + subtitle;
//          setState(() {
//            _sessionList.add(model);
//          });
//        }
//      }
//    });
  }

  Future _onRefreshSessionAll() async {
    print("_onRefreshSessionAll 刷新会话最近列表");

    // FIXED ME
    setState(() {
      _sessionList.clear();
    });

    IMManager.singleton.getSessionList().then((value) {
      List<IMSession> list = value;
      for (var i = 0; list != null && i < list.length; i++) {
        var displayName = "";
        if (list[i].isRobotSession) {
          if (list[i].sessionId == 2020010702) {
            displayName = "思知机器人";
          } else if (list[i].sessionId == 2020010701) {
            displayName = "图灵机器人";
          } else if (list[i].sessionId == 2020010703) {
            displayName = "小微机器人";
          } else {
            displayName = "机器人";
          }
          list[i].sessionName = displayName;
        }

        setState(() {
          _sessionList.add(list[i]);
        });
      }

      // 查询昵称
      _onInitSessionName();
    }).catchError((e) {
      print("_onRefreshSession 获取会话列表失败：" + e);
    });
  }

  void _onInitSessionName() async {
    print("_onInitSessionName 刷新昵称");

    for (var i = 0; i < _sessionList.length; i++) {
      var session = _sessionList[i];
      if (!session.isRobotSession) {
        // 查询昵称
        var result = await IMUser.singleton.queryUserNickName(Int64(session.sessionId), false);
        print(
            "_onInitSessionName errorCode=${result.errorCode},errorMsg=${result.errorMsg},userId=${result.userId},nickName=${result.nickName}");
        if (result is RegisterUserResult && result.errorCode == 0) {
          setState(() {
            session.sessionName = result.nickName;
          });
        }
      }
    }
  }

  void _onRefreshSession(List<IMSession> session) {
    session.forEach((v) {
      bool exist = false;
      for (var i = 0; i < _sessionList.length; i++) {
        if (v.sessionType == CIMSessionType.kCIM_SESSION_TYPE_SINGLE) {
          if (v.sessionId == _sessionList[i].sessionId) {
            setState(() {
              if (_sessionList[i].latestMsg.clientMsgId != v.latestMsg.clientMsgId) {
                _sessionList[i].latestMsg.msgData = v.latestMsg.msgData;
                _sessionList[i].latestMsg.clientMsgId = v.latestMsg.clientMsgId;
                _sessionList[i].latestMsg.createTime = v.latestMsg.createTime;
                _sessionList[i].latestMsg.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_RECEIPT;
                _sessionList[i].latestMsg.msgType = v.latestMsg.msgType;
                _sessionList[i].latestMsg.fromUserId = v.latestMsg.fromUserId.toInt();
              }

              // 更新未读计数
              if (_sessionList[i].unreadCnt != v.unreadCnt) {
                if (_selectedSessionIndex != i) {
                  _sessionList[i].unreadCnt = v.unreadCnt;
                }
                // 通知tab更新总的未读计数
                IMSDKHelper.singleton.onTotalUnreadMsgCb(true, 1);
              }
            });
            exist = true;
            break;
          }
        }
      }

      // 没找到，加入
      if (!exist) {
        setState(() {
          _sessionList.insert(0, v);
          // 通知tab更新总的未读计数
          IMSDKHelper.singleton.onTotalUnreadMsgCb(true, 1);
        });
      }
    });
  }

  void _onTap(var index) {
    IMSession model = _sessionList[index];
    var imSession = IMManager.singleton.getSession(model.sessionId, model.sessionType);

    _selectedSessionIndex = index;
    if (imSession.unreadCnt != 0) {
      // 通知tab更新总的未读计数
      IMSDKHelper.singleton.onTotalUnreadMsgCb(false, model.unreadCnt);
      imSession.setReadMessage(model.sessionId, model.sessionType, model.latestMsg.serverMsgId);
      setState(() {
        model.unreadCnt = 0;
      });
    }

    navigatePushPage(context, PageMessage(imSession)).then((v) {
      _selectedSessionIndex = -1;
    });
  }

  void _onCreateSession(int userId) {
    CIMContactSessionInfo info = new CIMContactSessionInfo();
    info.sessionId = Int64(userId);
    info.sessionType = CIMSessionType.kCIM_SESSION_TYPE_SINGLE;
    info.sessionStatus = CIMSessionStatusType.kCIM_SESSION_STATUS_OK;
    info.isRobotSession = false;

    var key = "PEER_" + userId.toString();
    if (IMManager.singleton.sessions.containsKey(key)) {
      navigatePushPage(context, PageMessage(IMManager.singleton.sessions[key]));
    }

    var session = IMManager.singleton.createSession(userId, CIMSessionType.kCIM_SESSION_TYPE_SINGLE);
    _sessionList.insert(0, session);
    navigatePushPage(context, PageMessage(session));
  }

  String _getMessageText(int index) {
    var session = _sessionList[index];

    if (session.latestMsg.msgType == CIMMsgType.kCIM_MSG_TYPE_ROBOT) {
      return IMManager.singleton.resolveRobotMessage(session.latestMsg);
    } else if (session.latestMsg.msgType == CIMMsgType.kCIM_MSG_TYPE_AVCHAT) {
      var msgContent = IMManager.singleton.resolveAVChatMessage(session.latestMsg);
      return formatAVChatMsg(msgContent);
    }
    return session.latestMsg.msgData;
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    final textFieldController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('发起聊天'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                controller: textFieldController,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: '请输入对方ID', /*hintText: DEFAULTLOGINSERVERURL*/
                ),
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                var text = textFieldController.text;
                int userId = int.tryParse(text);
                if (text.length > 0 && userId != null) {
                  if (Int64(userId) == IMManager.singleton.userId) {
                    Toast.show('用户ID无效，不能和自己聊天', context, gravity: Toast.CENTER);
                  } else {
                    Navigator.of(context).pop();
                    _onCreateSession(userId);
                  }
                } else {
                  Toast.show('用户ID无效', context, gravity: Toast.CENTER);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
