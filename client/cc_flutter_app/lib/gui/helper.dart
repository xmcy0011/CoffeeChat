import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 跳转某个页面，无法返回
void navigatePage(BuildContext context, Widget widget) {
  // 路由实例
  var pageRoute = new MaterialPageRoute(builder: (BuildContext context) => widget);
  var where = (Route route) => route == null; // 清除条件

  try {
    Navigator.of(context).pushAndRemoveUntil(pageRoute, where);
  } catch (e) {
    print(e);
  }
}

/// 跳转某个页面，放入到路由表中，可以返回
void navigatePushPage(BuildContext context, Widget widget) {
  var pageRoute = new MaterialPageRoute(builder: (BuildContext context) => widget);

  try {
    Navigator.of(context).push(pageRoute);
  } catch (e) {
    print(e);
  }
}
