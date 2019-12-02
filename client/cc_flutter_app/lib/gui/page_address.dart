import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageAddressStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageAddressStatefulWidgetState();
}

class _PageAddressStatefulWidgetState extends State<PageAddressStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("联系人"),
      ),
      body: Center(child: Text("address page")),
    );
  }
}