import 'dart:convert';

import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageChatStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageChatStateWidgetState();
}

class _PageChatStateWidgetState extends State<PageChatStateWidget> {
  List<Widget> _items = new List<Widget>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        // 将数据items[index]返回给item组件. 进行数据绑定
        return _items[index];
      },
    );
  }

  @override
  void initState() {
    super.initState();

    var session = new IMSession();
    session.getRecentSessionList().then((data) {
      if (data is CIMRecentContactSessionRsp) {
        for (var i = 0; i < data.contactSessionList.length; i++) {
          var sessionInfo = data.contactSessionList.elementAt(i);
          var subtitle = utf8.decode(sessionInfo.msgData);
          subtitle = "[${sessionInfo.msgFromUserId}]" + subtitle;
          setState(() {
            _items.add(ListTile(
              leading: Icon(Icons.map),
              title: Text(sessionInfo.sessionId.toString()),
              subtitle: Text(subtitle),
            ));
          });
        }
      }
    });
  }
}
