import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageHomeStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageStateWidgetState();
}

class _HomePageStateWidgetState extends State<PageHomeStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
