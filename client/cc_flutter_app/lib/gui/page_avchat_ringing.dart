import 'package:cc_flutter_app/imsdk/im_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 被呼叫
class PageAVChatRingingStatefulWidget extends StatefulWidget {
  final peerUserId;

  PageAVChatRingingStatefulWidget(this.peerUserId);

  @override
  State<StatefulWidget> createState() => PageAVChatRingingWidgetState(peerUserId);
}

class PageAVChatRingingWidgetState extends State<PageAVChatRingingStatefulWidget> {
  final peerUserId; // 对方ID

  var nickName; // 对方昵称
  var progress = "拨号中";

  PageAVChatRingingWidgetState(this.peerUserId);

  @override
  Widget build(BuildContext context) {
    return _buildRinging();
  }

  Widget _buildRinging() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // background
            gradient: LinearGradient(
          colors: [Color(0xFF442923), Color(0xFF2b2723), Color(0xFF442923)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(children: <Widget>[
//          Padding(
//            padding: EdgeInsets.only(top: 60, left: 20),
//            child: Row(
//              children: <Widget>[
//                Container(
//                  width: 55,
//                  child: RaisedButton(
//                    child: Icon(
//                      Icons.call_received,
//                      color: Colors.white70,
//                    ),
//                    color: Colors.transparent,
//                    onPressed: _onMinimum,
//                    shape: RoundedRectangleBorder(
//                        side: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
//                  ),
//                ),
//              ],
//            ),
//          ),
          Container(height: 90),
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50)),
              Image.asset(
                "assets/default_avatar.png",
                width: 128,
                height: 128,
                fit: BoxFit.fill,
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                nickName,
                style: new TextStyle(fontSize: 20, color: Colors.white),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text("邀请你语音通话", style: new TextStyle(fontSize: 16, color: Colors.white70))
            ],
          ),
          Expanded(child: Container()),
          Container(
            height: 200,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: RaisedButton(
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.red,
                          elevation: 60,
                          shape: CircleBorder(),
                          onPressed: _onCancel,
                        ),
                      ),
                      Padding(
                        child: Text("拒 绝", style: new TextStyle(fontSize: 14, color: Colors.white)),
                        padding: EdgeInsets.only(top: 10),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: RaisedButton(
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Color.fromARGB(255, 0x52, 0xb0, 0x34),
                          elevation: 60,
                          shape: CircleBorder(),
                          onPressed: _onHandsFree,
                        ),
                      ),
                      Padding(
                        child: Text("接 听", style: new TextStyle(fontSize: 14, color: Colors.white)),
                        padding: EdgeInsets.only(top: 10),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    IMUser.singleton.queryUserNickName(this.peerUserId, false).then((v) {
      RegisterUserResult i = v as RegisterUserResult;
      if (i != null && i.errorCode == 0) {
        this.nickName = i.nickName;
      }
    }).catchError((e) {});
  }

  void _onCancel() {
    Navigator.of(this.context).pop();
  }

  void _onMute() {}

  void _onMinimum() {}

  void _onHandsFree() {}
}
