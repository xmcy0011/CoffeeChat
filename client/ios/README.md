# swift版

## build

depends
```bash
pod 'Alamofire', '~> 5.2'     # http
pod 'CocoaAsyncSocket', '~> 7.6.3'        # socket
pod 'SwiftProtobuf', '~> 1.0' # protobuf
pod 'SnapKit', '~> 5.0.0'  # 自动布局第三方库
pod 'SwiftyJSON', '~> 4.0' # json解析库
pod 'Dollar', '9.0.0'      # 操作数组的神器，比如将数组划分成若干个子集
pod 'RxSwift', '~> 5'      # 一个组合异步和事件驱动编程的库
pod 'RxCocoa', '~> 5'      # iOS响应式编程中的两个主流框架（RxSwift+RxCocoa）
pod 'BEMCheckBox'          # 高雅的iOS复选框
pod 'Chrysan'              # 菊花组件
pod 'CryptoSwift'          # hash(md5,sha256),crc32 , 1.3.8
```

1. install XCode, >= 12.3
2. install CocoaPods, >= 1.9.1
3. install depends
```bash
$ cd client/ios/Coffchat
$ pod install
```
4. run

## 运行

公网：106.14.172.35  
im_gate:8000/tcp，登录、消息处理等  
im_http:18080/http，用户注册  

测试账号：1007、1008  
密码：12345  

## 2020-04-13 近期工作计划
### 遗留问题
- [ ] 聊天样式
- [ ] 登录失败后一直重试
- [x] 收到消息未读计数增加

### 会话
- [x] 收到和发送消息后，实时更新会话最后一条消息
- [ ] 总未读计数显示
- [x] 未读计数清零
- [ ] 昵称显示
- [ ] 下拉刷新
- [ ] 空行分界线
- [ ] 聊天时间优化显示（刚刚、时分、今天、昨天、时间、很久以前）

### 消息
- [x] 下拉刷新
- [ ] 自定义键盘（发送）
- [ ] 头像
- [ ] 发起聊天
- [ ] 消息时间
- [ ] 消息发送结果显示（PS：有时候会丢包，需要配合本地存储来实现该功能较好）

### 我
- [x] 退出登录

### 登录
- [ ] 自动登录
- [ ] 记住账号