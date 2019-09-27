import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageMeStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageMeStatefulWidgetState();
}

class _PageMeStatefulWidgetState extends State<PageMeStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我"),
      ),
      body: Center(child: Text("me page")),
    );
  }
}
