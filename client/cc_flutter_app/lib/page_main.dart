import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/gui/imsdk_helper.dart';
import 'package:cc_flutter_app/gui/page_address.dart';
import 'package:cc_flutter_app/gui/page_avchat_ringing.dart';
import 'package:cc_flutter_app/gui/page_settings.dart';
import 'package:cc_flutter_app/gui/widget/badge_bottom_tab_bar.dart';
import 'package:cc_flutter_app/gui/widget/badge_bottom_tab_bar_item.dart';
import 'package:cc_flutter_app/imsdk/im_avchat.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'gui/page_home.dart';
import 'gui/page_chat.dart';

class PageMainStatefulApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageMainStatefulAppState();
}

/// 主页面，下面3个Table
/// 主页、消息、我
class _PageMainStatefulAppState extends State<PageMainStatefulApp> implements AVChatIncomingCallObserver {
  var _selectedIndex = 0;
  var totalUnreadCount = 0;
  String messageBadgeCount = "";

  static List<Widget> _pages = <Widget>[
    PageHomeStatefulWidget(),
    PageChatStateWidget(),
    PageAddressStatefulWidget(),
    PageSettingsStatefulWidget(),
  ];

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    IMSDKHelper.singleton.registerOnRefresh("_PageMainStatefulAppState", _onRefresh);
    //IMSDKHelper.singleton.registerOnRecvReceipt("_PageMainStatefulAppState", _onRecvReceipt);
    IMSDKHelper.singleton.onTotalUnreadMsgCb = _onUpdateTotalUnreadCount;
    IMAVChat.singleton.observeIncomingCall(this, true);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // cleanup
    IMManager.singleton.cleanup();
    IMAVChat.singleton.observeIncomingCall(this, false);
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
      List<IMSession> list = v;
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          totalUnreadCount += list[i].unreadCnt;
        }
      }
      updateTotalUnreadCount(totalUnreadCount);
    });
  }

  void _onUpdateTotalUnreadCount(bool add, int count) {
    if (add) {
      totalUnreadCount += count;
      updateTotalUnreadCount(totalUnreadCount);
    } else {
      totalUnreadCount -= count;
      updateTotalUnreadCount(totalUnreadCount);
    }
  }

  //void _onRecvReceipt(var session, int msgId) {}

  void updateTotalUnreadCount(int total) {
    setState(() {
      if (total > 0) {
        this.messageBadgeCount = total > 99 ? "99+" : total.toString();
      } else {
        this.messageBadgeCount = null;
      }
    });
  }

  /// Observer<AVChatData>
  /// observeIncomingCall：有来电
  @override
  void onIncomingCall(AVChatData data) {
    _requirePermissionsAndPushPage(data);
  }

  void _requirePermissionsAndPushPage(AVChatData data) async {
    if (await _handleCameraAndMic()) {
      navigatePushPage(context, PageAVChatRingingStatefulWidget(data));
    }
  }

  /// require permissions
  _handleCameraAndMic() async {
    // 请求权限
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );

    //校验权限
    if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
      print("无照相权限");
      return false;
    }
    if (permissions[PermissionGroup.microphone] != PermissionStatus.granted) {
      print("无麦克风权限");
      return false;
    }
    return true;
  }
}
