import 'dart:async';

import 'package:cc_flutter_app/gui/widget/toast_widget.dart';
import 'package:cc_flutter_app/imsdk/core/business/im_client.dart';
import 'package:cc_flutter_app/imsdk/im_avchat.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbenum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';

/// 主动呼叫
class PageAVChatCallerStatefulWidget extends StatefulWidget {
  final Int64 peerUserId;
  final String nickName;

  PageAVChatCallerStatefulWidget(this.peerUserId, this.nickName);

  @override
  State<StatefulWidget> createState() => _PageAVChatCallerWidgetState(this.peerUserId, nickName);
}

class _PageAVChatCallerWidgetState extends State<PageAVChatCallerStatefulWidget>
    implements AVChatHangUpObserver, AVChatStateObserverLite {
  final Int64 peerUserId;
  final String nickName;

  var progress = "拨号中";
  var timerTick = 0;
  bool enableSpeakerphone = false;

  Timer timer;
  AVState avState;

  _PageAVChatCallerWidgetState(this.peerUserId, this.nickName);

  @override
  Widget build(BuildContext context) {
    return _buildCaller();
  }

  Widget _buildCaller() {
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
                                  Icons.call_end,
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
                              child: Text("取 消", style: new TextStyle(fontSize: 14, color: Colors.white)),
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

    IMAVChat.singleton.observeAVChatState(this, true);
    //IMAVChat.singleton.observeCalleeAckNotification(observer, true);
    IMAVChat.singleton.observeHangUpNotification(this, true);

    IMAVChat.singleton.call(this.peerUserId, CIMVoipInviteType.kCIM_VOIP_INVITE_TYPE_VOICE_CALL, null, (data) {
      print("call success");
      setState(() {
        this.avState = AVState.Established;
      });
    }, (int code, String desc) {
      IMAVChat.singleton.hangUp(CIMVoipByeReason.kCIM_VOIP_BYE_REASON_CANCEL, null); // 挂断
      Navigator.of(this.context).pop();
      Toast.toast(context, msg: "对方无应答", position: ToastPostion.center);
      print("call error:$code,$desc");
    });
  }

  @override
  void dispose() {
    super.dispose();

    IMAVChat.singleton.observeAVChatState(this, false);
    IMAVChat.singleton.observeHangUpNotification(this, false);

    if (timer != null) {
      timer.cancel();
    }
  }

  /// 取消
  void _onCancel() {
    IMAVChat.singleton.hangUp(CIMVoipByeReason.kCIM_VOIP_BYE_REASON_CANCEL, null); // 挂断
    _showEndTips(IMClient.singleton.userId, AVChatEventType.CALLEE_CANCEL);
  }

  /// 挂断
  void _onHangup() {
    IMAVChat.singleton.hangUp(CIMVoipByeReason.kCIM_VOIP_BYE_REASON_END, null); // 挂断
    _showEndTips(IMClient.singleton.userId, AVChatEventType.CALLEE_END);
  }

  /// 免提
  void _onHandsFree() {
    enableSpeakerphone = !enableSpeakerphone;
    IMAVChat.singleton.enableSpeakerphone(enableSpeakerphone);
    Toast.toast(context, msg: enableSpeakerphone ? "外置扬声器" : "内置扬声器", position: ToastPostion.center);
  }

  /// AVChatStateObserverLite
  @override
  void onTrying() {
    setState(() {
      avState = AVState.Trying;
    });

    timer = new Timer.periodic(Duration(milliseconds: 600), (t) {
      if (avState != AVState.Ringing && avState != AVState.Trying) {
        t.cancel();
      } else {
        timerTick++;

        var textLater = "";
        var tick = (timerTick % 3) + 1;
        for (var i = 0; i <= 3; i++) {
          if (i < tick) {
            textLater += ".";
          } else {
            textLater += " ";
          }
        }

        setState(() {
          this.progress = "正在等待对方接受邀请" + textLater;
        });
      }
    });
  }

  @override
  void onRinging() {
    setState(() {
      avState = AVState.Ringing;
    });

    new Timer(Duration(seconds: 1), () {
      // 对方振铃中，可以显示动画。。或者背景音乐
      Toast.toast(this.context, msg: "对方振铃中", position: ToastPostion.center);
    });
  }

  @override
  void onCallEstablished() {
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
}
