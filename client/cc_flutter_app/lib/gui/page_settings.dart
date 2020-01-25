import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../page_login.dart';
import 'helper.dart';

class PageSettingsStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageSettingsStatefulWidgetState();
}

class _PageSettingsStatefulWidgetState extends State<PageSettingsStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text("账号与安全"),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            Divider(
              height: 12,
            ),
            ListTile(
              title: Text("关于"),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            Divider(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: RaisedButton(
                child: Text(
                  "登 出",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                color: Colors.white,
                onPressed: _logout,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
              ),
            ),
          ],
        ));
  }

  void _logout() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('提示'),
              content: new Text('你确定要退出吗?'),
              actions: <Widget>[
                OutlineButton(
                  child: new Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlineButton(
                  child: new Text('确定'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    //prefs.clear();

                    // 清理SDK缓存
                    IMManager.singleton.cleanupCache().then((e) {
                      Navigator.of(context).pop();
                      navigatePage(this.context, PageLoginStatefulWidget());
                    });
                    //Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                )
              ],
            ));
  }
}
