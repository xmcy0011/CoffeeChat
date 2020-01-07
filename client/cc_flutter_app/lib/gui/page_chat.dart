import 'dart:convert';

import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/gui/imsdk_helper.dart';
import 'package:cc_flutter_app/gui/imsdk_helper.dart' as prefix0;
import 'package:cc_flutter_app/gui/page_message.dart';
import 'package:cc_flutter_app/gui/viewmodel/session.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:fixnum/fixnum.dart';

import '../imsdk/core/model/model.dart';

// 会话列表，聊天首页
class PageChatStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageChatStateWidgetState();
}

class _PageChatStateWidgetState extends State<PageChatStateWidget> {
  List<SessionViewModel> _sessionList = new List<SessionViewModel>();
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

  Widget _buildBadge(SessionViewModel session) {
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
    SessionViewModel session = _sessionList[index];

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
          subtitle: new Text(session.latestMsg.msgData, maxLines: 1),
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
    // FIXED ME
    setState(() {
      _sessionList.clear();
    });

    IMManager.singleton.getSessionList().then((value) {
      List<IMSession> list = value;
      for (var i = 0; list != null && i < list.length; i++) {
        var displayName = list[i].sessionName;
        if (list[i].sessionId == 2020010702) {
          displayName = "思知机器人";
        }

        setState(() {
          SessionViewModel model = new SessionViewModel(list[i].sessionId, displayName, list[i].sessionType,
              list[i].unreadCnt, list[i].updatedTime, list[i].latestMsg);
          _sessionList.add(model);
        });
      }
    }).catchError((e) {
      print("_onRefreshSession 获取会话列表失败：" + e);
    });
  }

  void _onRefreshSession(List<IMSession> session) {
    session.forEach((v) {
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

            break;
          }
        }
      }
    });
  }

  void _onTap(var index) {
    SessionViewModel model = _sessionList[index];
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

    var session = IMManager.singleton.createSession(userId, CIMSessionType.kCIM_SESSION_TYPE_SINGLE);

    SessionViewModel model = new SessionViewModel(
      userId,
      userId.toString(),
      CIMSessionType.kCIM_SESSION_TYPE_SINGLE,
      0,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      session.latestMsg,
    );

    _sessionList.insert(0, model);
    navigatePushPage(context, PageMessage(session));
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
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
