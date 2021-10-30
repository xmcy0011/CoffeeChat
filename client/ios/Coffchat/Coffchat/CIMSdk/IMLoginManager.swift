//
//  IMLoginManager.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/22.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 登录进度
enum IMLoginStep: Int {
    // 默认
    case Default = 0
    // 连接中
    case Linking = 1
    // 连接成功
    case LinkOK
    // 连接失败，可能网络不通
    case LinkFailed
    // 登录中
    case Logining
    // 登录成功
    case LoginOK
    // 登录失败，用户名密码错误
    case LoginFailed
    // 同步数据中
    case Syncing
    // 同步成功
    case SyncOK
    // 连接断开
    case LoseConnection
    // 网络切换
    case NetChanged
}

// 登录委托
protocol IMLoginManagerDelegate {
    /// 登录进度，主要用户UI展示状态
    /// - Parameter step: 进度
    func onLogin(step: IMLoginStep)
    
    // func onKick()
    
    /// 自动登录失败回调
    /// - Parameter code: 失败原因
    func onAutoLoginFailed(code: Error)
}

class IMLoginManager: IMClientDelegateStatus, IMClientDelegateData {
    fileprivate var client: IMClient
    fileprivate var _serverIp: String?
    fileprivate var timer: Timer? // 自动登录，心跳超时检测定时器
    fileprivate var timerTick: UInt64 = 0
    fileprivate var lastHeartBeat: Int32 = 0 // 上一次收到服务器心跳的时间戳
    fileprivate var haveLogin: Bool = false // 是否用户主动登录过，用以区分是否启动重连机制
    
    fileprivate var lastAuthTime: Int32 = 0 // 上一次认证时间
    fileprivate var lastAuthTimeInterval: Int32 = 1 // 重连间隔，避免对服务端造成dos攻击
    
    public var loginStep = IMLoginStep.Default // 当前连接状态
    public var isLogin: Bool = false // 是否已登陆
    public var loginTime: Int32 = 0 // 登录时间戳
    
    public var serverIp: String? { return _serverIp } // 服务器IP
    
    public var userName: String?
    public var userPwd: String?
    
    public var userId: UInt64?     // 从服务端获取的
    public var userNick: String?
    
    fileprivate var delegates: [String: IMLoginManagerDelegate] = [:] // 委托字典
    fileprivate var authCallback: IMResultCallback<CIM_Login_CIMAuthRsp>? // 认证结果回调
    
    init() {
        client = DefaultIMClient
        client.register(key: "IMLoginManager", delegateStatus: self)
        client.register(key: "IMLoginManager", delegateData: self)
    }
    
    /// 登录
    /// - Parameters:
    ///   - userName: 用户ID
    ///   - userPwd: 用户口令
    ///   - serverIp: 服务器IP
    ///   - port: 服务器端口
    ///   - callback: 回调
    func login(userName: String, userPwd: String, serverIp: String, port: UInt16, callback: IMResultCallback<CIM_Login_CIMAuthRsp>?) -> Bool {
        IMLog.info(item: "auth userName=\(userName),userPwd=\(userPwd),serverIp=\(serverIp),port=\(port)")
        
        if isLogin, self.userName != nil, userName != self.userName {
            client.disconnect()
            if timer != nil {
                timer!.invalidate() // 销毁timer
                timer = nil
            }
        }
        
        haveLogin = true
        lastAuthTime = Int32(NSDate().timeIntervalSince1970) // 记住认证时间戳
        loginStep = IMLoginStep.Linking
        
        self._serverIp = serverIp
        self.userName = userName
        self.userPwd = userPwd.md5()
        authCallback = callback
        
        // 更新登录进度
        _onUpdateLoginStep(step: loginStep)
        return client.connect(ip: serverIp, port: port)
    }
    
    /// 自动登录
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - nick: 用户昵称
    ///   - userToken: 用户口令
    ///   - serverIp: 服务器IP
    ///   - port: 服务器端口
    func autoLogin(userId: UInt64, nick: String, userToken: String, serverIp: String, port: UInt16) {
        IMLog.debug(item: "unsupport")
    }
    
    /// 登出并清理数据。
    /// 收到响应后才能登出(切换界面，清理数据等)，否则会出现推送信息仍旧会发到当前手机的问题
    /// - Parameter callback:结果回调
    func logout(callback: IMResultCallback<CIM_Login_CIMLogoutRsp>?) {
        if timer != nil {
            timer!.invalidate() // 销毁timer
            timer = nil
        }
        if loginStep != .Default {
            client.disconnect()
        }
        loginStep = .Default
    }
    
    func register(key: String, delegate: IMLoginManagerDelegate) -> Bool {
        if delegates[key] == nil {
            delegates[key] = delegate
            return true
        }
        return false
    }
    
    func unregister(key: String) -> Bool {
        return delegates.removeValue(forKey: key) != nil
    }
}

// MARK: IMClientDelegateStatus

extension IMLoginManager {
    // 更新当前登录进度
    func _onUpdateLoginStep(step: IMLoginStep) {
        loginStep = step
        IMLog.debug(item: "step:\(step)")
        for item in delegates {
            item.value.onLogin(step: loginStep)
        }
    }
    
    func onDisconnect(_ err: Error?) {
        // 只通知1次
        if isLogin || loginStep == .Linking {
            _onUpdateLoginStep(step: .LoseConnection)
        } else {
            loginStep = .LoseConnection
        }
        isLogin = false
    }
    
    func onConnected(_ host: String, port: UInt16) {
        _onUpdateLoginStep(step: .LinkOK)
        
        if !isLogin, userName != nil, userPwd != nil {
            // 更新登录进度
            _onUpdateLoginStep(step: .Logining)
            
            // 登录请求
            var req = CIM_Login_CIMAuthReq()
            req.clientType = CIM_Def_CIMClientType.kCimClientTypeIos
            req.userName = userName!
            req.userPwd = userPwd!
            req.clientVersion = kClientVersion
            
            let body = try! req.serializedData()
            // sned to server
            _ = client.send(cmdId: CIM_Def_CIMCmdID.kCimCidLoginAuthReq, body: body)
        }
    }
}

// MARK: IMClientDelegateData

extension IMLoginManager {
    func onHandleData(_ header: IMHeader, _ data: Data) -> Bool {
        if header.commandId == CIM_Def_CIMCmdID.kCimCidLoginHeartbeat.rawValue {
            IMLog.debug(item: "recv hearbeat")
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidLoginAuthRsp.rawValue {
            _onHandleAuthRes(header: header, data: data)
            return true
        }
        return false
    }
    
    // auth response
    func _onHandleAuthRes(header: IMHeader, data: Data) {
        var res = CIM_Login_CIMAuthRsp()
        do {
            res = try CIM_Login_CIMAuthRsp(serializedData: data)
            
            IMLog.info(item: "auth resultCode=\(res.resultCode),resultString=\(res.resultString),userId=\(res.userInfo.userID),nick=\(res.userInfo.nickName)")
            
            // 登录成功
            if res.resultCode == CIM_Def_CIMErrorCode.kCimErrSuccess {
                isLogin = true
                loginTime = Int32(NSDate().timeIntervalSince1970)
                
                // 记录自己的昵称
                userNick = res.userInfo.nickName
                userId = res.userInfo.userID
                
                // 更新登录进度
                _onUpdateLoginStep(step: .LoginOK)
                
                // 启动定时发心跳的线程 FIXME
                if timer == nil {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: _onTimerTick)
                    timer?.fire() // 立即启动一次
                }
            } else {
                // 更新登录进度
                client.disconnect()
                _onUpdateLoginStep(step: .LoginFailed)
            }
            
            // 回调auth结果
            if authCallback != nil {
                authCallback!(res)
            }
        } catch {
            IMLog.error(item: "parse error:\(error)")
        }
    }
    
    // 定时器函数体
    func _onTimerTick(t: Timer) {
        // tcp 链接检测
        if client.isConnected != nil, !client.isConnected! {
            var needAuth = false
            
            let nowTimestamp = Int32(NSDate().timeIntervalSince1970)
            if loginStep == .Logining {
                // 如果因为发起登录请求10秒没得到响应，也重新尝试
                let isTimeout = (nowTimestamp - lastAuthTime) > 10
                needAuth = isTimeout
            } else if loginStep != .Linking { // 不是正在连接的状态，才启动乘阶算法(忘记算法名字了)
                // 超过登录间隔后就尝试登入
                needAuth = (nowTimestamp - lastAuthTime) > lastAuthTimeInterval
            }
            
            if needAuth {
                IMLog.debug(item: "lastAuthTime=\(lastAuthTime),lastAuthTimeInterval=\(lastAuthTimeInterval)s")
                // 1s 2s 4s 8s ...
                lastAuthTimeInterval = lastAuthTimeInterval * 2
                if lastAuthTimeInterval > 8 {
                    lastAuthTimeInterval = 1
                }
                _ = login(userName: userName!, userPwd: userPwd!, serverIp: client.ip, port: client.port, callback: nil)
            }
        }
        
        // 心跳
        timerTick += 1
        if timerTick % 10 == 0 { // 10秒1个
            let hearbeat = CIM_Login_CIMHeartBeat()
            _ = client.send(cmdId: .kCimCidLoginHeartbeat, body: try! hearbeat.serializedData())
        }
    }
}
