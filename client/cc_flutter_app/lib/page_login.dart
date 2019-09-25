import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/page_main.dart';
import 'package:flutter/material.dart';

class PageLoginStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageLoginStatefulWidgetState();
}

class _PageLoginStatefulWidgetState extends State<PageLoginStatefulWidget> {
  final _usernameController = TextEditingController(text: "1008");
  final _passwordController = TextEditingController(text: "12345");
  static const kShrineBrown900 = Color(0xFF442B2D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/coffee_128px.png'),
                const SizedBox(height: 16.0),
                Text(
                  'CoffeeChat',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            const SizedBox(height: 120.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                /*FlatButton(
                  child: const Text('CANCEL'),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),*/
                RaisedButton(
                  child: const Text('登 录'),
                  elevation: 8.0,
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: _login,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    navigatePage(context, PageMainStatefulApp());
  }
}

/// 自定义颜色
class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      // 从主题拷贝，覆盖主要颜色
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
