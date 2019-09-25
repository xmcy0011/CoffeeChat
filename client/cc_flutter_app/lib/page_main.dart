import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gui/page_home.dart';
import 'gui/page_me.dart';
import 'gui/page_message.dart';

class PageMainStatefulApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageMainStatefulAppState();
}

/// 主页面，下面3个Table
/// 主页、消息、我
class _PageMainStatefulAppState extends State<PageMainStatefulApp> {
  var _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    PageHomeStatefulWidget(),
    PageMessageStateWidget(),
    PageMeStatefulWidget(),
  ];

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoffeeChat"),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("主页")),
          BottomNavigationBarItem(icon: Icon(Icons.message), title: Text("消息")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("我")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onTapItem,
      ),
    );
  }
}
