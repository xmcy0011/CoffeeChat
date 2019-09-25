import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageHomeStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageStateWidgetState();
}

class _HomePageStateWidgetState extends State<PageHomeStatefulWidget> {
  void _onPressedKefu() {
    _neverSatisfied();
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You will never be satisfied.')
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 80,
        margin: EdgeInsets.all(20),
        //alignment: AlignmentDirectional.center,
        child: OutlineButton(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.message,
                color: Colors.grey,
                size: 32,
              ),
              Text("客服", style: TextStyle(color: Colors.grey, fontSize: 20)),
            ],
          ),
          onPressed: _onPressedKefu,
        ),
      ),
    );
  }
}
