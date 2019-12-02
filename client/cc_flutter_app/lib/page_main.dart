import 'package:cc_flutter_app/gui/imsdk_helper.dart';
import 'package:cc_flutter_app/gui/widget/badge_bottom_tab_bar.dart';
import 'package:cc_flutter_app/gui/widget/badge_bottom_tab_bar_item.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gui/page_home.dart';
import 'gui/page_me.dart';
import 'gui/page_chat.dart';
import 'imsdk/core/model/model.dart';

class PageMainStatefulApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageMainStatefulAppState();
}

/// 主页面，下面3个Table
/// 主页、消息、我
class _PageMainStatefulAppState extends State<PageMainStatefulApp> {
  var _selectedIndex = 0;
  String messageBadgeCount = "89";

  static List<Widget> _pages = <Widget>[
    PageHomeStatefulWidget(),
    PageChatStateWidget(),
    PageMeStatefulWidget(),
  ];

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    IMSDKHelper.singleton.registerOnRefresh("_PageMainStatefulAppState", _onRefresh);
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("CoffeeChat"),
//      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BadgeBottomTabBar(
        items: <BadgeBottomTabBarItem>[
          BadgeBottomTabBarItem(icon: Icon(Icons.home), title: Text("主页")),
          BadgeBottomTabBarItem(icon: Icon(Icons.message), title: Text("消息"), badgeNo: messageBadgeCount),
          BadgeBottomTabBarItem(icon: Icon(Icons.link), title: Text("联系人")),
          BadgeBottomTabBarItem(icon: Icon(Icons.settings), title: Text("我")),
        ],
        currentIndex: _selectedIndex,
        type: BottomTabBarType.fixed,
        isAnimation: false,
        isInkResponse: false,
        badgeColor: Colors.red,
        fixedColor: Colors.red,
        //selectedItemColor: Colors.amber[800],
        onTap: _onTapItem,
      ),
    );
  }

  void _onRefresh() {
    IMManager.singleton.getSessionList().then((v) {
      List<SessionModel> list = v;
      var totalUnreadCount = 0;
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          totalUnreadCount += list[i].unreadCnt;
        }
      }
      setState(() {
        this.messageBadgeCount = totalUnreadCount > 99 ? "99+" : totalUnreadCount.toString();
      });
    });
  }
}
