import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageSettingsStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageSettingsStatefulWidgetState();
}

class _PageSettingsStatefulWidgetState extends State<PageSettingsStatefulWidget> {
  var _items = ["账号与安全", "关于"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我"),
        ),
        body: Stack(
          children: <Widget>[
            ListView.builder(itemCount: _items.length, itemBuilder: _build),
            RaisedButton(
              child: Text("登 出"),
              elevation: 7.0,
              color: Colors.red,
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
            )
          ],
        ));
  }

  Widget _build(context, index) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            title: Text(_items[index]),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Divider(
          height: 12,
        )
      ],
    );
  }
}
