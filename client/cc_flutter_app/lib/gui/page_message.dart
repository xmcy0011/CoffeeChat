import 'package:cc_flutter_app/gui/model/model.dart';
import 'package:cc_flutter_app/gui/widget/msg_item_widget.dart';
import 'package:cc_flutter_app/imsdk/im_message.dart';
import 'package:cc_flutter_app/imsdk/proto/CIM.List.pbserver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'package:toast/toast.dart';

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
    UserModel model = new UserModel();
    model.userId = msg.fromUserId;
    model.nickName = msg.fromUserId.toString();
    model.avatarURL = "";

    return MsgItem(msg, model);
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

  // 刷新消息
  Future _onRefresh() async {
    _msgList.clear();
    var msg = IMMessage();
    var id = sessionInfo.sessionId;
    var type = sessionInfo.sessionType;
    msg.getMessageList(id, type, Int64(0), 20).then((rsp) {
      if (rsp is CIMGetMsgListRsp) {
        rsp.msgList.forEach((v) {
          setState(() {
            var msgModel = new MessageModel(v);
            _msgList.add(msgModel);
          });
        });
      } else {
        print("getMessageList error,rsp is not CIMGetMsgListRsp");
      }
    }).catchError((err) {
      Toast.show("刷新消息失败：${err.toString()}", context, duration: 3);
    });
  }

  // 缩小消息输入框
  void _hideBottomLayout() {}

  // 发送文本
  void _onSendMsg(String text) {}
}
