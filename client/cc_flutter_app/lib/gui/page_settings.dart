import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageSettingsStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageSettingsStatefulWidgetState();
}

class _PageSettingsStatefulWidgetState extends State<PageSettingsStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Center(child: Text("settings page")),
    );
  }
}
