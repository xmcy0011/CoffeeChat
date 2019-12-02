# cc_flutter_app

A new Flutter project with CoffeeChat

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 目录结构说明

- Flutter SDK
    - /model：实体类
    - /proto：protobuf3协议文件
    - im_client.dart：登录、和服务器通信（其他业务模块调用send发送请求，收到结果后回调）
    - im_message.dart：发送消息、获取历史消息
    - im_session.dart：获取会话列表
- gui
    - /model：实体类
    - /widget：各种组件
    - page_chat.dart：消息tab
    - page_home.dart：主页
    - page_me.dart：我
    - page_message.dart：聊天界面

## 实现的功能

-[x] 闪屏页
-[x] 登录
    -[x] 记住密码
    -[x] 自动重连（可能有BUG）
-[x] 会话列表
    -[x] 最新消息
    -[x] 圆角头像
    -[x] 未读计数小红点
-[x] 聊天
    -[x] 收发文本
    -[x] 失败重发
    -[x] 下拉查询加载历史消息
-[ ] SDK
    -[ ] SQFilte缓存会话列表
    -[ ]  

## 预览
具体见 demo 文件夹下的图片

## 联系我
email：xmcy0011@sina.com