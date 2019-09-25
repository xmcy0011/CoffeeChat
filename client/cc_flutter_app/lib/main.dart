import 'package:cc_flutter_app/page_home.dart';
import 'package:cc_flutter_app/page_me.dart';
import 'package:cc_flutter_app/page_message.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Basic List';

    // items
    List<Widget> items = new List<Widget>();
    for (var i = 0; i < 4; i++) {
      items.add(ListTile(
        leading: Icon(Icons.map),
        title: Text('Map' + i.toString()),
        subtitle: Text("你好"),
      ));
    }

    return MaterialApp(
      title: title,
      home: MyStatefullApp(),
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}

class MyStatefullApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyStatefullAppState();
}

class _MyStatefullAppState extends State<MyStatefullApp> {
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
