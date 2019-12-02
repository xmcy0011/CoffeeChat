import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/imsdk/im_manager.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/im_session.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbserver.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pbserver.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Message.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'package:toast/toast.dart';

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
  List<MessageModelBase> _msgList = new List<MessageModelBase>(); // 历史消息

  ScrollController _scrollController; // 历史消息滚动
  TextEditingController _textController = new TextEditingController(); // 输入的文本

  _PageMessageState(this.sessionInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.sessionInfo.sessionName)),
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
    IMMessage.singleton.registerReceiveCallback("pageMessage", _onReceiveMsg);
    _onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    IMMessage.singleton.unregisterReceiveCallback("pageMessage");
  }

  // 生成历史聊天记录
  Widget _onBuildMsgItem(context, position) {
    MessageModelBase msg = _msgList[position];

    // FIXED ME
    UserModel fromUser = new UserModel();
    fromUser.userId = msg.fromUserId;
    fromUser.nickName = msg.fromUserId.toString();
    fromUser.avatarURL = "";

    //print("_onBuildMsgItem=${msg.serverMsgId},msg=${msg.msgData}");

    //return MsgItem(msg, fromUser);
    if (IMManager.singleton.isSelf(msg.fromUserId)) {
      return _buildMeAvatarItem(msg, fromUser);
    }
    return _buildOtherAvatarItem(msg, fromUser);
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
  Widget _buildMsgContent(MessageModelBase msg) {
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
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(text, maxLines: 10, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subhead),
        ),
      ),
    );
  }

  // 自己的消息
  Widget _buildMeAvatarItem(MessageModelBase msg, UserModel fromUser) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(fromUser.nickName, style: Theme.of(context).textTheme.subhead),
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
    );
  }

  // 别人的消息
  Widget _buildOtherAvatarItem(MessageModelBase msg, UserModel fromUser) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvatar(fromUser, EdgeInsets.only(right: 8.0, top: 8.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(fromUser.nickName, style: Theme.of(context).textTheme.subhead),
                _buildMsgContent(msg)
              ],
            ),
          ],
        ));
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
  void _reSendMsg(MessageModelBase msg) {
    var sId = sessionInfo.sessionId;
    var sType = sessionInfo.sessionType;

    setState(() {
      if (_msgList.length == (_msgList.indexOf(msg) + 1)) {
        msg.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENDING;
      } else {
        // 如果不是最后一条消息，重新添加到末尾
        _msgList.remove(msg);
        _msgList.add(msg);
        scrollEnd();
      }
    });

    IMMessage.singleton
        .sendMessage(msg.clientMsgId, sId, CIMMsgType.kCIM_MSG_TYPE_TEXT, sType, msg.msgData)
        .then((app) {
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
    var msg = IMMessage();
    var id = sessionInfo.sessionId;
    var type = sessionInfo.sessionType;
    int endMsgId = 0;
    if (_msgList.length > 0) {
      endMsgId = _msgList[0].serverMsgId;
    }

    msg.getMessageList(id, type, endMsgId, kMaxPullMsgLimitCount).then((rsp) {
      if (rsp is CIMGetMsgListRsp) {
        List<MessageModelBase> msg = new List<MessageModelBase>();
        rsp.msgList.forEach((v) {
          var msgModel = MessageModelBase.copyFrom(v);
          print("msgId=${msgModel.serverMsgId},msg=${msgModel.msgData}");
          msg.add(msgModel);
        });

        setState(() {
          _msgList.insertAll(0, msg);
          if (_scrollController == null) {
            if (_msgList.length > 6) {
              _scrollController = new ScrollController(initialScrollOffset: 380);
            } else {
              _scrollController = new ScrollController();
            }
          }
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

      var timer = new Timer(Duration(milliseconds: 100), () {
        setState(() {
          //_scrollController.jumpTo(scrollValue);
          _scrollController.animateTo(scrollValue,
              duration: Duration(milliseconds: animationTime), curve: Curves.easeIn);
        });
      });
    }
  }

  scrollEnd2([animationTime = 200]) {
    if (_scrollController != null) {
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

    var msgInfo = new CIMMsgInfo();
    msgInfo.clientMsgId = IMMessage.singleton.generateMsgId();
    msgInfo.sessionType = sessionInfo.sessionType;
    msgInfo.fromUserId = IMManager.singleton.userId;
    msgInfo.toSessionId = Int64(sessionInfo.sessionId);
    msgInfo.createTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    msgInfo.msgResCode = CIMResCode.kCIM_RES_CODE_OK;
    msgInfo.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENDING; // 发送中
    msgInfo.msgFeature = CIMMsgFeature.kCIM_MSG_FEATURE_DEFAULT;
    msgInfo.msgData = utf8.encode(text);
    msgInfo.msgType = CIMMsgType.kCIM_MSG_TYPE_TEXT;
    msgInfo.senderClientType = CIMClientType.kCIM_CLIENT_TYPE_DEFAULT;

    //msgInfo.clientMsgId
    MessageModelBase model = MessageModelBase.copyFrom(msgInfo);
    setState(() {
      _msgList.add(model);
      _textController.clear();
    });
    scrollEnd2();

    IMMessage.singleton.sendMessage(msgInfo.clientMsgId, sId, CIMMsgType.kCIM_MSG_TYPE_TEXT, sType, text).then((app) {
      setState(() {
        model.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENT;
      });
    }).catchError((err) {
      setState(() {
        model.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_FAILED;
      });
    });
  }

  // 接收一条消息
  void _onReceiveMsg(CIMMsgData msg) {
    if (msg.fromUserId == sessionInfo.sessionId) {
      var msgInfo = new CIMMsgInfo();
      msgInfo.toSessionId = msg.toSessionId;
      msgInfo.fromUserId = msg.fromUserId;
      msgInfo.msgType = msg.msgType;
      msgInfo.msgData = msg.msgData;
      msgInfo.msgStatus = CIMMsgStatus.kCIM_MSG_STATUS_SENT; // FIXED me
      msgInfo.msgFeature = CIMMsgFeature.kCIM_MSG_FEATURE_DEFAULT; // FIXED me
      msgInfo.msgResCode = CIMResCode.kCIM_RES_CODE_OK; // FIXED me
      msgInfo.serverMsgId = Int64(0); // FIXED me
      msgInfo.createTime = msg.createTime;
      msgInfo.sessionType = msg.sessionType;

      var model = MessageModelBase.copyFrom(msgInfo);
      setState(() {
        _msgList.add(model);
      });
      scrollEnd2();
    }
  }
}
