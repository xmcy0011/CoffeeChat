import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageMessageStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageMessageStateWidgetState();
}

class _PageMessageStateWidgetState extends State<PageMessageStateWidget> {
  @override
  Widget build(BuildContext context) {
    // items
    List<Widget> items = new List<Widget>();
    for (var i = 0; i < 4; i++) {
      items.add(ListTile(
        leading: Icon(Icons.map),
        title: Text('Map' + i.toString()),
        subtitle: Text("你好"),
      ));
    }
    return ListView(children: items);
  }
}
