import 'dart:async';

import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/imsdk/im_user.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Login.pb.dart';
import 'package:cc_flutter_app/page_main.dart';
import 'package:cc_flutter_app/page_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'gui/imsdk_helper.dart';

//const DefaultServerIp = "10.0.107.254";
const DefaultServerPort = 8000;

class PageLoginStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageLoginStatefulWidgetState();
}

class _PageLoginStatefulWidgetState extends State<PageLoginStatefulWidget> {
  final _usernameController = TextEditingController(text: "1008");
  final _nicknameController = TextEditingController(text: "三生三世十里桃花");
  final _passwordController = TextEditingController(text: "12345");
  final _serverIpController = TextEditingController(text: "106.14.172.35");
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
            const SizedBox(height: 40.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'UserId',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'NickName',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Token',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _serverIpController,
                decoration: const InputDecoration(
                  labelText: 'ServerIp',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Text("还没有账号？"),
                FlatButton(
                  child: const Text(
                    '立即注册',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: _onRegister,
                ),
              ],
            ),
            // IOS Style Button
            CupertinoButton(
              child: const Text('登 录'),
              color: Colors.blueAccent,
              onPressed: _onLogin,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString("local_server_ip");
    String userId = prefs.getString("local_user_id");
    String nick = prefs.getString("local_nick_name");
    String token = prefs.getString("local_token");
    setState(() {
      _usernameController.text = userId;
      _passwordController.text = token;
      _nicknameController.text = nick;
      _serverIpController.text = ip;
    });
  }

  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_serverIpController.text.isNotEmpty) prefs.setString("local_server_ip", _serverIpController.text);
    if (_usernameController.text.isNotEmpty) prefs.setString("local_user_id", _usernameController.text);
    if (_passwordController.text.isNotEmpty) prefs.setString("local_token", _passwordController.text);
    if (_nicknameController.text.isNotEmpty) prefs.setString("local_nick_name", _nicknameController.text);
  }

  void _onLogin() {
    _showLoading((closeDialog) {
      _save();
      _login(closeDialog);
    });
  }

  void _login(Function closeDialog) {
    var userId = int.tryParse(_usernameController.value.text);
    var nick = _nicknameController.value.text;
    var token = _passwordController.value.text;
    var ip = _serverIpController.value.text;
    var port = DefaultServerPort;

    if (int.tryParse(_usernameController.value.text) == null) {
      Toast.show("用户ID必须为数字", context, gravity: Toast.CENTER, duration: 3);
      closeDialog();
      return null;
    } else if (_usernameController.value.text.isEmpty) {
      Toast.show("请输入昵称", context, gravity: Toast.CENTER, duration: 3);
      closeDialog();
      return null;
    } else if (_passwordController.value.text.isEmpty) {
      Toast.show("请输入口令", context, gravity: Toast.CENTER, duration: 3);
      closeDialog();
      return null;
    } else if (_serverIpController.value.text.isEmpty) {
      Toast.show("请输入IP", context, gravity: Toast.CENTER, duration: 3);
      closeDialog();
      return null;
    }

    IMUser.singleton.setServerIp(ip);

    IMManager.singleton.login(Int64(userId), nick, token, ip, port).then((rsp) {
      closeDialog();

      if (rsp is CIMAuthTokenRsp) {
        if (rsp.resultCode == CIMErrorCode.kCIM_ERR_SUCCSSE) {
          navigatePage(context, PageMainStatefulApp());
        } else {
          Toast.show(rsp.resultString, context, gravity: Toast.CENTER, duration: 3);
        }
      } else {
        Toast.show("系统错误", context, gravity: Toast.CENTER, duration: 3);
      }
    }, onError: (err) {
      closeDialog();
      Toast.show(err.toString(), context, gravity: Toast.CENTER, duration: 3);
    });
  }

  Future<void> _showLoading(Function closeDialog) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return new NetLoadingDialog(
          dismissDialog: closeDialog,
          outsideDismiss: false,
        );
      },
    );
  }

  void _onRegister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString("local_server_ip");
    if (ip == null) {
      ip = this._serverIpController.text;
    }
    IMUser.singleton.setServerIp(ip);

    navigatePushPage(context, PageRegisterStatefulWidget()).then((value) {
      // 返回页面时，更新用户ID
      if (value != null) {
        this._usernameController.text = value['userId'].toString();
        this._nicknameController.text = value['nickName'];
        this._passwordController.text = value['pwd'];
      }
    });
  }

/*
  Future<void> _alertLoginErr(String errDesc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("登录失败：" + errDesc),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  */
}

/// 自定义颜色
class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child}) : super(key: key);

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

// ignore: must_be_immutable
class NetLoadingDialog extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;

  Function dismissDialog;

  NetLoadingDialog({Key key, this.loadingText = "loading...", this.outsideDismiss = true, this.dismissDialog})
      : super(key: key);

  @override
  State<NetLoadingDialog> createState() => _LoadingDialog();
}

class _LoadingDialog extends State<NetLoadingDialog> {
  _dismissDialog() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dismissDialog != null) {
      widget.dismissDialog(_dismissDialog);
    }
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SafeArea(
//        child: PrimaryColorOverride(
//          color: Colors.transparent,
//          child: Center(
//            child: CircularProgressIndicator(
//              valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
//            ),
//          ),
//        ),
//      ),
//    );
    return PrimaryColorOverride(
      color: Colors.transparent,
      child: Center(
//        child: CircularProgressIndicator(
//          valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
//        ),
        child: CupertinoActivityIndicator(
          // ios style 菊花
          radius: 20.0,
          animating: false,
        ),
      ),
    );
  }
}
