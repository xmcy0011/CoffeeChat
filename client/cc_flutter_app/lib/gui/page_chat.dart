import 'dart:convert';

import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/gui/imsdk_helper.dart';
import 'package:cc_flutter_app/gui/imsdk_helper.dart' as prefix0;
import 'package:cc_flutter_app/gui/page_message.dart';
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
    IMManager.singleton.addMessageListener("_PageChatStateWidgetState", _onReceiveMsg);
    IMSDKHelper.singleton.registerOnRefresh("_PageChatStateWidgetState", _onRefreshSession);
    _onRefreshSession();
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

  Future _onRefreshSession() async {
    // FIXED ME
    setState(() {
      _sessionList.clear();
    });

    IMManager.singleton.getSessionList().then((value) {
      List<IMSession> list = value;
      for (var i = 0; list != null && i < list.length; i++) {
        setState(() {
          _sessionList.add(list[i]);
        });
      }
    }).catchError((e) {
      print("_onRefreshSession 获取会话列表失败：" + e);
    });
  }

  // 接收一条消息
  void _onReceiveMsg(CIMMsgData msg) {
    for (var i = 0; i < _sessionList.length; i++) {
      if (msg.sessionType == CIMSessionType.kCIM_SESSION_TYPE_SINGLE) {
        if (msg.fromUserId == _sessionList[i].sessionId) {
          setState(() {
            _sessionList[i].latestMsg.msgData = utf8.decode(msg.msgData);
            _sessionList[i].latestMsg.clientMsgId = msg.msgId;
            _sessionList[i].latestMsg.createTime = msg.createTime;
            _sessionList[i].latestMsg.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_RECEIPT;
            _sessionList[i].latestMsg.msgType = msg.msgType;
            _sessionList[i].latestMsg.fromUserId = msg.fromUserId.toInt();
            if (_selectedSessionIndex != i) {
              _sessionList[i].unreadCnt++;
            }
            // 通知tab更新总的未读计数
            IMSDKHelper.singleton.onTotalUnreadMsgCb(true, 1);
          });
        }
      }
    }
  }

  void _onTap(var index) {
    IMSession model = _sessionList[index];
    _selectedSessionIndex = index;
    if (model.unreadCnt != 0) {
      // 通知tab更新总的未读计数
      IMSDKHelper.singleton.onTotalUnreadMsgCb(false, model.unreadCnt);
      model.setReadMessage(model.sessionId, model.sessionType, model.latestMsg.serverMsgId);
      setState(() {
        model.unreadCnt = 0;
      });
    }

    navigatePushPage(context, PageMessage(model)).then((v) {
      _selectedSessionIndex = -1;
    });
  }

  void _onCreateSession(int userId) {
    CIMContactSessionInfo info = new CIMContactSessionInfo();
    info.sessionId = Int64(userId);
    info.sessionType = CIMSessionType.kCIM_SESSION_TYPE_SINGLE;
    info.sessionStatus = CIMSessionStatusType.kCIM_SESSION_STATUS_OK;
    info.isRobotSession = false;

    IMMessage msg = new IMMessage();
    msg.msgData = "";

    IMSession model = new IMSession(
      userId,
      userId.toString(),
      CIMSessionType.kCIM_SESSION_TYPE_SINGLE,
      0,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      new IMMessage(),
    );

    _sessionList.add(model);
    navigatePushPage(context, PageMessage(model));
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
