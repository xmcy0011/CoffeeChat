import 'package:cc_flutter_app/gui/helper.dart';
import 'package:cc_flutter_app/imsdk/im_client.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Login.pb.dart';
import 'package:cc_flutter_app/page_main.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'package:toast/toast.dart';

const DefaultServerIp = "127.0.0.1";
const DefaultServerPort = 8000;

class PageLoginStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageLoginStatefulWidgetState();
}

class _PageLoginStatefulWidgetState extends State<PageLoginStatefulWidget> {
  final _usernameController = TextEditingController(text: "1008");
  final _nicknameController = TextEditingController(text: "三生三世十里桃花");
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
                  onPressed: _onLogin,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLogin() {
    _showLoading((closeDialog) {
      _login(closeDialog);
    });
  }

  void _login(Function closeDialog) {
    var userId = int.tryParse(_usernameController.value.text);
    var nick = _nicknameController.value.text;
    var token = _passwordController.value.text;
    var ip = DefaultServerIp;
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
    }

    ImClient.singleton.auth(Int64(userId), nick, token, ip, port).then((rsp) {
      closeDialog();

      if (rsp is CIMAuthTokenRsp) {
        if (rsp.resultCode == CIMErrorCode.kCIM_ERR_SUCCSSE) {
          navigatePage(context, PageMainStatefulApp());
        } else {
          Toast.show(rsp.resultString, context,
              gravity: Toast.CENTER, duration: 3);
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

// ignore: must_be_immutable
class NetLoadingDialog extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;

  Function dismissDialog;

  NetLoadingDialog(
      {Key key,
      this.loadingText = "loading...",
      this.outsideDismiss = true,
      this.dismissDialog})
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
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
        ),
      ),
    );
  }
}
