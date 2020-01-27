import 'dart:async';

import 'package:cc_flutter_app/gui/widget/toast_widget.dart';
import 'package:cc_flutter_app/imsdk/core/business/im_client.dart';
import 'package:cc_flutter_app/imsdk/im_avchat.dart';
import 'package:cc_flutter_app/imsdk/im_user.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';

/// 被呼叫
class PageAVChatRingingStatefulWidget extends StatefulWidget {
  final AVChatData avChatData;

  PageAVChatRingingStatefulWidget(this.avChatData);

  @override
  State<StatefulWidget> createState() => PageAVChatRingingWidgetState(avChatData);
}

class PageAVChatRingingWidgetState extends State<PageAVChatRingingStatefulWidget>
    implements AVChatHangUpObserver, AVChatStateObserverLite {
  final AVChatData avChatData; // 对方ID

  var nickName; // 对方昵称
  var progress = "邀请你语音通话";
  AVState avState = AVState.Default; // 通话状态
  Timer timer;
  bool enableSpeakerphone = false; // 扬声器

  PageAVChatRingingWidgetState(this.avChatData);

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
              Text(progress, style: new TextStyle(fontSize: 16, color: Colors.white70))
            ],
          ),
          Expanded(child: Container()),
          Container(
            height: 200,
            child: Row(
              children: <Widget>[
                avState == AVState.Established
                    ? Expanded(
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
                                color: Colors.red,
                                elevation: 60,
                                shape: CircleBorder(),
                                onPressed: _onHangup,
                              ),
                            ),
                            Padding(
                              child: Text("挂 断", style: new TextStyle(fontSize: 14, color: Colors.white)),
                              padding: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      )
                    : Container(),
                avState != AVState.Established
                    ? Expanded(
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
                      )
                    : Container(),
                avState != AVState.Established
                    ? Expanded(
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
                                onPressed: _onAccept,
                              ),
                            ),
                            Padding(
                              child: Text("接 听", style: new TextStyle(fontSize: 14, color: Colors.white)),
                              padding: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      )
                    : Container(),
                avState == AVState.Established
                    ? Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 80,
                              child: RaisedButton(
                                child: Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                color: Colors.transparent,
                                elevation: 60,
                                shape: CircleBorder(side: BorderSide(color: Colors.white)),
                                onPressed: _onHandsFree,
                              ),
                            ),
                            Padding(
                              child: Text("免 提", style: new TextStyle(fontSize: 14, color: Colors.white)),
                              padding: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      )
                    : Container(),
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
    setState(() {
      this.nickName = this.avChatData.creatorId.toString();
    });

    IMUser.singleton.queryUserNickName(this.avChatData.creatorId, false).then((v) {
      RegisterUserResult i = v as RegisterUserResult;
      if (i != null && i.errorCode == 0) {
        setState(() {
          this.nickName = i.nickName;
        });
      }
    }).catchError((e) {});

    IMAVChat.singleton.observeHangUpNotification(this, true);
    IMAVChat.singleton.observeAVChatState(this, true);
  }

  @override
  void dispose() {
    IMAVChat.singleton.observeHangUpNotification(this, false);
    IMAVChat.singleton.observeAVChatState(this, false);
    if (timer != null) {
      timer.cancel();
    }

    super.dispose();
  }

  void _onCancel() {
    IMAVChat.singleton.hangUp(CIMVoipByeReason.kCIM_VOIP_BYE_REASON_REJECT, null); // 拒绝，挂断
    _showEndTips(IMClient.singleton.userId, AVChatEventType.CALLEE_ACK_REJECT);
  }

  void _onHangup() {
    IMAVChat.singleton.hangUp(CIMVoipByeReason.kCIM_VOIP_BYE_REASON_END, null); // 挂断，通话结束
    _showEndTips(IMClient.singleton.userId, AVChatEventType.CALLEE_END);
  }

  void _onAccept() {
    IMAVChat.singleton.accept(() {
      print("accpet success");
    });
  }

  void _onHandsFree() {
    enableSpeakerphone = !enableSpeakerphone;
    IMAVChat.singleton.enableSpeakerphone(enableSpeakerphone);
    Toast.toast(context, msg: enableSpeakerphone ? "外置扬声器" : "内置扬声器", position: ToastPostion.center);
  }

  /// AVChatHangUpObserver
  @override
  void onHangup(AVChatCommonEvent data) {
    _showEndTips(data.data.creatorId, data.event);
  }

  void _showEndTips(Int64 hangupUserId, AVChatEventType eventType) {
    var msgTips = IMAVChat.singleton.getHangupReasonStr(hangupUserId, eventType);
    Toast.toast(this.context, msg: msgTips, position: ToastPostion.center);
    new Timer(Duration(seconds: 1), () {
      setState(() {
        Navigator.of(this.context).pop();
      });
    });
  }

  /// AVChatStateObserverLite
  @override
  void onTrying() {}

  @override
  void onRinging() {}

  @override
  void onCallEstablished() {
    print("onCallEstablished");

    setState(() {
      avState = AVState.Established;
    });
    timer = new Timer.periodic(Duration(seconds: 1), (t) {
      if (avState != AVState.Established) {
        t.cancel();
      } else {
        var hourStr, minStr, secondStr;
        var hour = t.tick ~/ 3600;
        var min = t.tick ~/ 60;
        var second = t.tick % 60;

        // 补0
        if (hour < 10) {
          hourStr = "0" + hour.toString();
        } else {
          hourStr = hour.toString();
        }
        if (min < 10) {
          minStr = "0" + min.toString();
        } else {
          minStr = min.toString();
        }
        if (second < 10) {
          secondStr = "0" + second.toString();
        } else {
          secondStr = second.toString();
        }

        setState(() {
          this.progress = hourStr + ":" + minStr + ":" + secondStr;
        });
      }
    });
  }

  @override
  void onError(code) {}

  @override
  void onJoinChannel(String channel, int uid, int elapsed) {}

  @override
  void onLeaveChannel() {}

  @override
  void onUserJoined(int uid, int elapsed) {}

  @override
  void onUserOffline(int uid, int reason) {}
}
