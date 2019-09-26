import 'dart:convert';

import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/gui/page_message.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/model.dart';

// 会话列表，聊天首页
class PageChatStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageChatStateWidgetState();
}

class _PageChatStateWidgetState extends State<PageChatStateWidget> {
  List<SessionModel> _sessionList = new List<SessionModel>();

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
        child: ListView.builder(
          itemCount: _sessionList.length,
          itemBuilder: _buildSession,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 拉取会话列表
    var session = new IMSession();
    session.getRecentSessionList().then((data) {
      if (data is CIMRecentContactSessionRsp) {
        for (var i = 0; i < data.contactSessionList.length; i++) {
          var sessionInfo = data.contactSessionList.elementAt(i);

          SessionModel model = new SessionModel(
              sessionInfo, sessionInfo.sessionId.toString(), "");
          //subtitle = "[${sessionInfo.msgFromUserId}]" + subtitle;
          setState(() {
            _sessionList.add(model);
          });
        }
      }
    });
  }

  Widget _buildSession(context, index) {
    SessionModel session = _sessionList[index];

    return Column(children: <Widget>[
      GestureDetector(
        onTap: () => _onTap(index),
        child: ListTile(
          // 头像
          leading: ClipOval(
            child: FadeInImage(
              image: NetworkImage(session.avatarUrl),
              placeholder: AssetImage('assets/default_avatar.png'),
            ),
          ),
          // 标题
          title: Text(session.sessionName,
              style: Theme.of(context).textTheme.subhead),
          // 副标题
          subtitle: new Text(session.msgData, maxLines: 1),
          trailing: Icon(
            Icons.arrow_forward_ios,
          ),
        ),
      ),
      Divider(
        height: 12.0,
      ),
    ]);
  }

  void _onAdd() {}

  void _onTap(var index) {
    SessionModel model = _sessionList[index];
    navigatePushPage(context, PageMessage(model));
  }
}
