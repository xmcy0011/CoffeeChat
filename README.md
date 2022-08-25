# CoffeeChat

opensource im with server(go) and client(flutter+swift)

> ⚠️⚠️Warnning⚠️⚠️
> 持续开发中，仅适合学习使用。

## News

有网友在Issues询问后续更新一事，这里回复一下：
> 今年事情比较多，所以进展十分缓慢，会不会放弃这个项目我也不能肯定，主要是作者精力有限，请大家原谅。发起这个项目的初衷，是为了更深入的学习IM服务端开发，如果有更好的开源go语言实现的im项目，我可能会考虑作为Contributor参与其中。

最后，放出最近的一些动态以感谢大家的关心。

最新动态：
- 至今: 生命不息，探索不止💪💪
- 2022/07/01: 目前正在开发v2架构（基于kratos v2框架），总体设计由pb+tcp变更为http+json接口方式，降低上手成本。考虑到自由度和方便体验，目前正在开发android app。
- ~~2022/04/10：制定Monthly Release计划，每个月至少要保证一次Release~~
- 2021/08: 作者最近在考虑跳槽，故精力主要放在研究[OpenIM](https://github.com/OpenIMSDK/Open-IM-Server)，学习Kafka，微服务，收件箱，Etcd，Docker，K8S等使用，提升技术深度。
- 2021/03 - 07: 开发QT客户端和C++跨平台SDK，受限于精力进展缓慢。
- 2021/02: 使用sketch设计win+mac客户端界面。

总结：
- `2022`: 再出发，学习android + kratos + k8s，实现go服务端v2版本重构
- `2021`: 主要精力在探索百万级的架构，C++跨平台SDK，QT，Go微服务，Docker，Etcd等等，coffeechat几乎没有更新
- `2020`: 这一年coffeechat不断完善，作者主要在学习ios开发，实现简单ios app
- `2019/08`: coffeechat诞生，学习flutter，实现简单flutter客户端，后续因为flutter聊天界面下拉感觉效果不理想放弃

## Client

支持的客户端有：

- 开发中（V2）
  - [Android](https://github.com/gomicroim/client-android): 基于android 7.0 + java实现，目前正在开发中（2022年8月），适用于 `V2版本` 服务端。

- 暂停中（V1）
  - [iOS](https://github.com/xmcy0011/CoffeeChat-iOS)：基于swift5实现，目前主要维护的客户端，推荐使用。适用于 `V1版本` 服务端。
  - [Flutter](https://github.com/xmcy0011/CoffeeChat-Flutter)：基于flutter2和dart实现，目前已不再维护，仅供学习。
  - [Windows](https://github.com/xmcy0011/CoffeeChat-Win)：基于c++和网易duilib实现，目前只实现了登录功能。
  - [Mac](https://github.com/xmcy0011/CoffeeChat-Desktop)：基于c++和Qt6实现，目前只实现了登录功能。

请点击对应的链接查看详情。

## Preview

### flutter

see [CoffeeChat-Flutter](https://github.com/xmcy0011/CoffeeChat-Flutter) 暂不维护，仅供参考。

### swift
![screenshot](./docs/images/swift/screenshot.png)  

## Features

### 设计

- [x] 架构设计：参考瓜子 IM
- [x] 协议设计：参考网易云 IM、环信、TeamTalk
- [x] 数据库设计
- [x] 消息分表存储设计
- [x] IM 消息 ID 生成设计

### 单聊群聊

- [x] flutter 客户端
- [x] 单聊
- [x] 消息格式
    - [x] 文本
    - [ ] 表情
    - [ ] 图片
- [x] 会话列表
- [x] 消息存储
- [x] 历史消息
- [x] 漫游消息（用户切换到任何设备都可以读取到最近的历史消息）
- [ ] 离线消息（用户离线重新上线后收到最近 30 天的未读消息）
- [x] 未读消息计数
- [ ] 消息推送(APNS)
- [ ] 群聊
- [ ] 群最高人数：200
- [ ] 群管理：群主、加人、踢人
- [ ] 群消息免打扰
- [ ] 群成员管理

### 服务端特有

- [ ] consul注册中心
- [ ] 分布式配置（nacos、etcd...）
- [x] dockerfile & docker compose
- [ ] admin后台和web界面，简化安装（参考wordpress）

## 客户端特有

- [ ] 消息推送提醒（系统通知栏消息提醒）
- [ ] 消息转发
- [ ] 网络连接状态
- [ ] 图片管理器
- [ ] 查找聊天记录
- [ ] 消息同步缓存
- [x] 会话同步缓存
- [ ] 头像同步缓存
- [ ] 未读计数桌面角标
- [ ] 免打扰模式
- [ ] 图片压缩

### 特色功能

- [ ] 阅后即焚
- [ ] 撤回
- [ ] 正在输入
- [ ] 已读回执（用户发送消息，获取对方是否已读状态 ）
- [ ] 多终端已读同步（同个产品多终端情况下，同步消息已读未读的状态）
- [ ] 端到端加密
- [ ] 高清语音消息
- [ ] 文件上传下载
- [x] 语音通话(声网FlutterSDK)
- [ ] 视频通话
- [ ] electron 跨平台桌面客户端
- [x] flutter 跨平台移动端
- [ ] swift/iOS 客户端+SDK

### 聊天机器人功能

- [ ] 图灵机器人接入
- [ ] 小爱机器人接入
- [x] 思知机器人接入
- [x] 微信机器人接入

## Architecture

模块架构:  
![模块架构](https://raw.githubusercontent.com/xmcy0011/CoffeeChat/master/docs/images/structure-v2.png)

单聊模块交互图:
![单聊](https://raw.githubusercontent.com/xmcy0011/CoffeeChat/master/docs/images/seq-c2c.png)

See More [architecture](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/02-%E6%9E%B6%E6%9E%84%E5%92%8C%E5%8D%8F%E8%AE%AE%E8%AE%BE%E8%AE%A1.md)

## Quick Start

> PS：请切换到**master**分支，编译和运行！

1. 启动Server（要求安装docker desktop >= 4.0.1）:

```bash
$ git clone https://github.com/xmcy0011/CoffeeChat.git
$ cd CoffeeChat/server
# 从代码编译docker镜像，安装mysql,redis等依赖，并自动初始化mysql数据
$ docker-compose up -d
```

1. 编译客户端。推荐iOS客户端（模拟器选择iphone 11），请移步：[client](https://github.com/xmcy0011/CoffeeChat/blob/master/client/cc_flutter_app/README.md)
1. iOS模拟器和app启动后，点击“注册”，更改服务器IP地址为本机IP（不需要输入端口），注册成功后，登录即可。
1. 内置了2个机器人（思知和微信）和3个好友，可以测试聊天功能。

更多细节，请移步：

- [client](https://github.com/xmcy0011/CoffeeChat/blob/master/client/cc_flutter_app/README.md)
- [server](https://github.com/xmcy0011/CoffeeChat/blob/master/server/src/README.md)

停止：

```bash
$ cd CoffeeChat/server
$ docker-compose down -v
```

### Document

1. [产品介绍](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/01-%E4%BA%A7%E5%93%81%E4%BB%8B%E7%BB%8D.md)
2. [架构和协议设计](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/02-%E6%9E%B6%E6%9E%84%E5%92%8C%E5%8D%8F%E8%AE%AE%E8%AE%BE%E8%AE%A1.md)
3. [消息分表存储](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/03-%E6%B6%88%E6%81%AF%E5%88%86%E8%A1%A8%E5%AD%98%E5%82%A8.md)
4. [IM 消息 ID 生成原理和常见技术难点](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/04_IM%e5%b8%b8%e8%a7%81%e6%8a%80%e6%9c%af%e9%9a%be%e7%82%b9.md)
5. [进度计划](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/05-%E8%BF%9B%E5%BA%A6%E8%AE%A1%E5%88%92.md)
6. [MQ在IM中的实践和选型](https://github.com/xmcy0011/CoffeeChat/blob/master/docs/06_MQ%e5%9c%a8IM%e4%b8%ad%e7%9a%84%e5%ae%9e%e8%b7%b5.md)

更多文章请移步：

- [CoffeeChat-GitBook](https://xmcy0011.github.io/CoffeeChat-GitBook/)

### Thinks

- [mattermost](https://github.com/mattermost/mattermost-server)：主要学习其go工程实践方面的一些技巧，目前还处在研究阶段。
- [Open-IM-Server](https://github.com/OpenIMSDK/Open-IM-Server)：通过分析它的架构和代码，理解了收件箱机制和im 微服务(go)的划分实践。
- [goim](https://github.com/Terry-Mao/goim)：学习到百万级架构下kafka是如何应用在聊天室场景的。
- [Terry-Ye/im](https://github.com/Terry-Ye/im)：结合goim，理解了所谓的job含义，看懂了goim的架构。
- [gim](https://github.com/alberliu/gim)：一个简单的写扩散项目，可以更深入理解写扩散的架构和原理。

更多开源im，请移步：[史上最全开源IM盘点](https://blog.csdn.net/xmcy001122/article/details/110679978)

## Contact

email：xmcy0011@sina.com  
微信交流：xuyc1992（请备注：im）  

喜欢的话，关注下公众号吧😊  
《Go和分布式IM》👈👈  
![qrcode](./docs/images/qrcode.png)

## LICENSE

CoffeeChat is provided under the [mit license](https://github.com/xmcy0011/CoffeeChat/blob/master/LICENSE).