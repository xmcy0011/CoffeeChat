import 'package:cc_flutter_app/gui/model/model.dart';
import 'package:cc_flutter_app/imsdk/im_client.dart';
import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.Def.pbserver.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pbserver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'package:toast/toast.dart';

// 单次拉取历史记录的最大数量
const kMaxPullMsgLimitCount = 20;

// 聊天详情页面
class PageMessage extends StatefulWidget {
  final SessionModel sessionInfo;

  PageMessage(this.sessionInfo);

  @override
  State<StatefulWidget> createState() => _PageMessageState(this.sessionInfo);
}

class _PageMessageState extends State<PageMessage> {
  SessionModel sessionInfo; // 聊天对应的会话信息
  List<MessageModel> _msgList = new List<MessageModel>(); // 历史消息

  ScrollController _scrollController; // 历史消息滚动
  TextEditingController _textEditingController; // 输入的文本

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
    _onRefresh();
  }

  // 生成历史聊天记录
  Widget _onBuildMsgItem(context, position) {
    MessageModel msg = _msgList[position];

    // FIXED ME
    UserModel fromUser = new UserModel();
    fromUser.userId = msg.fromUserId;
    fromUser.nickName = msg.fromUserId.toString();
    fromUser.avatarURL = "";

    //print("_onBuildMsgItem=${msg.serverMsgId},msg=${msg.msgData}");

    //return MsgItem(msg, fromUser);
    if (ImClient.singleton.isSelf(msg.fromUserId)) {
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
                  controller: _textEditingController,
                  onSubmitted: _onSendMsg,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _onSendMsg(_textEditingController.text),
                ),
              )
            ],
          ),
        ));
  }

  // 生成聊天内容
  Widget _buildMsgContent(MessageModel msg) {
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
          child: Text(text,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subhead),
        ),
      ),
    );
  }

  // 自己的消息
  Widget _buildMeAvatarItem(MessageModel msg, UserModel fromUser) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(fromUser.nickName,
                  style: Theme.of(context).textTheme.subhead),
              Row(
                children: <Widget>[
                  msg.msgStatus == CIMMsgStatus.kCIM_MSG_STATUS_SENDING
                      ? CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black12),
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
  Widget _buildOtherAvatarItem(MessageModel msg, UserModel fromUser) {
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
                Text(fromUser.nickName,
                    style: Theme.of(context).textTheme.subhead),
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
  void _reSendMsg(MessageModel msg) {}

  // 刷新消息
  Future _onRefresh() async {
    var msg = IMMessage();
    var id = sessionInfo.sessionId;
    var type = sessionInfo.sessionType;
    Int64 endMsgId = Int64(0);
    if (_msgList.length > 0) {
      endMsgId = _msgList[0].serverMsgId;
    }

    msg.getMessageList(id, type, endMsgId, kMaxPullMsgLimitCount).then((rsp) {
      if (rsp is CIMGetMsgListRsp) {
        List<MessageModel> msg = new List<MessageModel>();
        rsp.msgList.forEach((v) {
          var msgModel = new MessageModel(v);
          print("msgId=${msgModel.serverMsgId},msg=${msgModel.msgData}");
          msg.add(msgModel);
        });

        _msgList.insertAll(0, msg);
        //_msgList.addAll(msg);
        setState(() {
          if (_msgList.length == 0) {
            scrollEnd();
          }
        });
      } else {
        print("getMessageList error,rsp is not CIMGetMsgListRsp");
      }
    }).catchError((err) {
      Toast.show("刷新消息失败：${err.toString()}", context, duration: 3);
    });
  }

  scrollEnd([animationTime = 500]) {
    double scrollValue = _scrollController.position.maxScrollExtent;
    if (scrollValue < 10) {
      scrollValue = 1000000;
    }

    //_controller.jumpTo(scrollValue);
    _scrollController.animateTo(scrollValue,
        duration: Duration(milliseconds: animationTime), curve: Curves.easeIn);
  }

  // 缩小消息输入框
  void _hideBottomLayout() {}

  // 发送文本
  void _onSendMsg(String text) {}
}
