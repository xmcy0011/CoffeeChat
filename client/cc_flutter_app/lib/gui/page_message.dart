import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/gui/page_avchat_caller.dart';
import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbserver.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:fixnum/fixnum.dart';

import 'helper.dart';

// 单次拉取历史记录的最大数量
const kMaxPullMsgLimitCount = 10;

// 聊天详情页面
class PageMessage extends StatefulWidget {
  final IMSession sessionInfo;

  PageMessage(this.sessionInfo);

  @override
  State<StatefulWidget> createState() => _PageMessageState(this.sessionInfo);
}

class _PageMessageState extends State<PageMessage> {
  IMSession sessionInfo; // 聊天对应的会话信息
  List<IMMessage> _msgList = new List<IMMessage>(); // 历史消息

  ScrollController _scrollController; // 历史消息滚动
  TextEditingController _textController = new TextEditingController(); // 输入的文本

  var nearTime = 0;

  _PageMessageState(this.sessionInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.sessionInfo.sessionName),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.call),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                child: Text("语音通话"),
                value: "1",
              ),
              PopupMenuItem<String>(
                child: Text("视频通话"),
                value: "2",
              ),
            ],
            onSelected: (String action) {
              switch (action) {
                case "1":
                  _onVoiceCall();
                  break;
                case "2":
                  _onVideoCall();
                  break;
              }
            },
            onCanceled: () {
              print("onCanceled");
            },
          ),
        ],
      ),
      body: Container(
        child: RefreshIndicator(
          // 下拉刷新
          onRefresh: _onRefresh,
          child: Column(
            children: <Widget>[
              Flexible(
                // 构建聊天历史
                child: GestureDetector(
                  onTap: _hideBottomLayout,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _msgList == null ? 0 : _msgList.length,
                    itemBuilder: _onBuildMsgItem,
                  ),
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: new BoxDecoration(
                  // 边框
                  color: Theme.of(context).cardColor,
                ),
                // 构建发送消息界面
                child: _onBuildSendGroup(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    IMManager.singleton.addMessageListener("_PageMessageState", _onReceiveMsg);
    _onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    IMManager.singleton.removeMessageListener("_PageMessageState");
  }

  // 生成历史聊天记录
  Widget _onBuildMsgItem(context, position) {
    IMMessage msg = _msgList[position];

    // FIXED ME
    UserModel fromUser = new UserModel();
    fromUser.userId = msg.fromUserId;
    fromUser.avatarURL = "";

    //print("_onBuildMsgItem=${msg.serverMsgId},msg=${msg.msgData}");

    //return MsgItem(msg, fromUser);
    if (IMManager.singleton.isSelf(msg.fromUserId)) {
      fromUser.nickName = IMManager.singleton.nickName;
      return _buildMeAvatarItem(position, msg, fromUser);
    }
    fromUser.nickName = this.sessionInfo.sessionName;
    return _buildOtherAvatarItem(position, msg, fromUser);
  }

  Widget _onBuildTime(index) {
    if (index != 0) {
      // 10分钟内的，显示在一起，否则显示时间
      var timeDiff = _msgList[index].createTime - _msgList[index - 1].createTime;
      if (timeDiff < 10 * 60) {
        return Container();
      }
    }

    nearTime = _msgList[index].createTime;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        child: Text(IMSession.timeFormatEx(nearTime)),
        height: 30,
        padding: EdgeInsets.only(top: 7, left: 5, right: 5),
        color: Color.fromARGB(0x44, 0x66, 0x66, 0x66),
      ),
    );
  }

  // 生成发送消息界面
  Widget _onBuildSendGroup() {
    return IconTheme(
        data: IconThemeData(color: Colors.grey),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: InputDecoration.collapsed(hintText: ""),
                  controller: _textController,
                  //onSubmitted: _onSendMsg,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _onSendMsg(_textController.text),
                ),
              )
            ],
          ),
        ));
  }

  // 生成聊天内容
  Widget _buildMsgContent(IMMessage msg) {
    double maxWidth = MediaQuery.of(context).size.width * 0.7;
    var text = msg.msgData;

    if (text == '[图片]') {
//      String url = imHelper.decodeToImage(msg.msgData);
//      url = url.substring(10, url.length - 9);
//      print("url:$url");
//      return Card(
//          child: Container(
//              child: Image(
//        image: NetworkImage(url),
//        fit: BoxFit.cover,
//        width: maxWidth,
//      )));
    }
    if (msg.msgType == CIMMsgType.kCIM_MSG_TYPE_ROBOT) {
      text = IMManager.singleton.resolveRobotMessage(msg);
    } else if (msg.msgType == CIMMsgType.kCIM_MSG_TYPE_AVCHAT) {
      var msgContent = IMManager.singleton.resolveAVChatMessage(msg);
      text = formatAVChatMsg(msgContent);
    }

    var isSelf = IMManager.singleton.isSelf(msg.fromUserId);

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
          color: isSelf ? Color.fromARGB(0xBf, 0x57, 0xc2, 0x64) : Colors.white,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(text, maxLines: 10, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subhead),
        ),
      ),
    );
  }

  // 自己的消息
  Widget _buildMeAvatarItem(int index, IMMessage msg, UserModel fromUser) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _onBuildTime(index),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // 单聊时不需要显示对方昵称
                    //Text(fromUser.nickName, style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        msg.msgStatus == CIMMsgStatus.kCIM_MSG_STATUS_SENDING
                            ? CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
                              )
                            : (msg.msgStatus == CIMMsgStatus.kCIM_MSG_STATUS_FAILED
                                ? IconButton(
                                    icon: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _reSendMsg(msg);
                                    },
                                  )
                                : Center()),
                        _buildMsgContent(msg)
                      ],
                    )
                  ],
                ),
                _buildAvatar(fromUser, EdgeInsets.only(left: 8.0, top: 8.0))
              ],
            ),
          ],
        ));
  }

  // 别人的消息
  Widget _buildOtherAvatarItem(int index, IMMessage msg, UserModel fromUser) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          _onBuildTime(index),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildAvatar(fromUser, EdgeInsets.only(right: 8.0, top: 8.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 单聊时不需要显示对方昵称
                  //Text(fromUser.nickName, style: Theme.of(context).textTheme.subhead),
                  _buildMsgContent(msg)
                ],
              ),
            ],
          )
        ]));
  }

  // 头像
  Widget _buildAvatar(UserModel fromUser, edge) {
    return Container(
      width: 36,
      margin: edge,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: FadeInImage(
          image: NetworkImage(fromUser.avatarURL),
          placeholder: AssetImage("assets/default_avatar.png"),
        ),
      ),
    );
  }

  // 失败重发
  void _reSendMsg(IMMessage msg) {
    var sId = sessionInfo.sessionId;
    var sType = sessionInfo.sessionType;

    setState(() {
      if (_msgList.length == (_msgList.indexOf(msg) + 1)) {
        msg.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENDING;
      } else {
        // 如果不是最后一条消息，重新添加到末尾
        _msgList.remove(msg);
        _msgList.add(msg);
        scrollEnd2();
      }
    });

    sessionInfo.sendMessage(msg.clientMsgId, sId, msg.msgType, sType, msg.msgData).then((app) {
      setState(() {
        msg.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENT;
      });
    }).catchError((err) {
      setState(() {
        msg.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_FAILED;
      });
    });
  }

  // 刷新消息
  Future _onRefresh() async {
    var id = sessionInfo.sessionId;
    var type = sessionInfo.sessionType;
    int endMsgId = 0;
    if (_msgList.length > 0) {
      endMsgId = _msgList[0].serverMsgId;
    }

    sessionInfo.getMessage(id, type, endMsgId, kMaxPullMsgLimitCount).then((msgList) {
      if (msgList is List<IMMessage>) {
        msgList.forEach((v) {
          print("msgId=${v.serverMsgId},msg=${v.msgData}");
        });

        setState(() {
          if (_scrollController == null) {
            if (_msgList.length > 6) {
              _scrollController = new ScrollController(initialScrollOffset: 380);
            } else {
              _scrollController = new ScrollController();
            }
          }
          _msgList.insertAll(0, msgList);
        });
      } else {
        print("getMessageList error,rsp is not CIMGetMsgListRsp");
      }
    }).catchError((err) {
      Toast.show("刷新消息失败：${err.toString()}", context, duration: 3);
    });
  }

  // 延时滚动
  scrollEnd([animationTime = 200]) {
    if (_scrollController != null) {
      double scrollValue = _scrollController.position.maxScrollExtent;
      if (scrollValue < 10) {
        scrollValue = 1000000;
      }

      new Timer(Duration(milliseconds: 100), () {
        setState(() {
          //_scrollController.jumpTo(scrollValue);
          _scrollController.animateTo(scrollValue,
              duration: Duration(milliseconds: animationTime), curve: Curves.easeIn);
        });
      });
    }
  }

  scrollEnd2([animationTime = 200]) {
    if (_scrollController != null && _msgList.length > 9) {
      double scrollValue = _scrollController.position.maxScrollExtent;
      scrollValue = scrollValue + 60; // 偏移新消息的高度

      setState(() {
        //_scrollController.jumpTo(scrollValue);
        _scrollController.animateTo(scrollValue, duration: Duration(milliseconds: animationTime), curve: Curves.easeIn);
      });
    }
  }

  // 缩小消息输入框
  void _hideBottomLayout() {}

  // 发送文本
  void _onSendMsg(String text) {
    if (text.isEmpty) {
      Toast.show("请输入文字", context);
      return;
    }

    var sId = sessionInfo.sessionId;
    var sType = sessionInfo.sessionType;

    var msgInfo = new IMMessage();
    msgInfo.clientMsgId = IMSession.generateMsgId();
    msgInfo.sessionType = sessionInfo.sessionType;
    msgInfo.fromUserId = IMManager.singleton.userId.toInt();
    msgInfo.fromUserNickName = IMManager.singleton.nickName;
    msgInfo.toSessionId = sessionInfo.sessionId;
    msgInfo.createTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    msgInfo.msgResCode = CIMResCode.kCIM_RES_CODE_OK;
    msgInfo.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENDING; // 发送中
    msgInfo.msgFeature = CIMMsgFeature.kCIM_MSG_FEATURE_DEFAULT;
    msgInfo.msgData = text;
    msgInfo.msgType = CIMMsgType.kCIM_MSG_TYPE_TEXT;
    msgInfo.senderClientType = CIMClientType.kCIM_CLIENT_TYPE_DEFAULT;

    // 机器人会话，注意消息类型和内容
    if (this.sessionInfo.isRobotSession) {
      // 不需要json，直接文本即可
//      Map<String, dynamic> toJson = {
//        'body': text,
//      };
//      msgInfo.msgData = jsonEncode(toJson);
      msgInfo.msgType = CIMMsgType.kCIM_MSG_TYPE_ROBOT;
    }

    //msgInfo.clientMsgId
    setState(() {
      _msgList.add(msgInfo);
      _textController.clear();
    });
    scrollEnd2();

    sessionInfo.sendMessage(msgInfo.clientMsgId, sId, msgInfo.msgType, sType, msgInfo.msgData).then((app) {
      setState(() {
        msgInfo.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENT;
      });
    }).catchError((err) {
      setState(() {
        msgInfo.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_FAILED;
      });
    });
  }

  // 接收一条消息
  void _onReceiveMsg(CIMMsgData msg) {
    // 对方发给我 or 自己的其他端发送的
    if (msg.fromUserId == sessionInfo.sessionId || msg.toSessionId == sessionInfo.sessionId) {
      var msgInfo = new IMMessage();

      msgInfo.toSessionId = msg.toSessionId.toInt();
      msgInfo.fromUserId = msg.fromUserId.toInt();

      msgInfo.msgType = msg.msgType;
      msgInfo.msgData = utf8.decode(msg.msgData);
      msgInfo.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENT; // FIXED me
      msgInfo.msgFeature = CIMMsgFeature.kCIM_MSG_FEATURE_DEFAULT; // FIXED me
      msgInfo.msgResCode = CIMResCode.kCIM_RES_CODE_OK; // FIXED me
      msgInfo.serverMsgId = 0; // FIXED me
      msgInfo.createTime = msg.createTime;
      msgInfo.sessionType = msg.sessionType;

      setState(() {
        _msgList.add(msgInfo);
      });
      scrollEnd2();
    }
  }

  void _onVoiceCall() async {
    // await for camera and mic permissions before pushing video page
    if (await _handleCameraAndMic()) {
      navigatePushPage(this.context,
          new PageAVChatCallerStatefulWidget(Int64(this.sessionInfo.sessionId), this.sessionInfo.sessionName));
    }
  }

  void _onVideoCall() {}

  /// require permissions
  _handleCameraAndMic() async {
    // 请求权限
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );

    //校验权限
    if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
      print("无照相权限");
      return false;
    }
    if (permissions[PermissionGroup.microphone] != PermissionStatus.granted) {
      print("无麦克风权限");
      return false;
    }
    return true;
  }
}
