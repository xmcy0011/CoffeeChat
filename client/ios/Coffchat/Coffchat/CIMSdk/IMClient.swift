//
//  IMClient.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/10.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import CocoaAsyncSocket
import Foundation

// IM结果回调
typealias IMResultCallback<T> = (_ res: T) -> Void

// IMClient协议回调
protocol IMClientDelegate {
    /// connected
    /// - Parameters:
    ///   - host: IP
    ///   - port: 端口
    func onConnected(_ host: String, port: UInt16)
    /// 收到数据
    /// - Parameters:
    ///   - header: 协议头
    ///   - data: 数据体（裸数据）
    func onHandleData(_ header: IMHeader, _ data: Data?)
    /// disconnected
    /// - Parameter err: 错误
    func onDisconnect(_ err: Error?)
}

let kClientVersion = "0.0.1"

// IM连接
// 负责与服务端通信
class IMClient: NSObject, GCDAsyncSocketDelegate {
    fileprivate var tcpClient: GCDAsyncSocket?
    fileprivate var ip: String = "10.0.106.117"
    fileprivate var port: UInt16 = 8000
    fileprivate var seq: UInt16 = 1 // 序号，发送一次后即递增，没加锁FIXME
    
    // fileprivate var recvBuffer:Data // TCP缓冲区，粘包处理
    fileprivate var lastHeartBeat: Int32 = 0 // 上一次收到服务器心跳的时间戳
    fileprivate var userId: UInt64?
    fileprivate var userToken: String?
    fileprivate var userNick: String?
    
    // callback
    fileprivate var socketCallback: IMClientDelegate? // 收到服务器的消息回调给上层，处理业务
    fileprivate var authCallback: IMResultCallback<CIM_Login_CIMAuthTokenRsp>? // 认证结果回调
    
    // 是否已连接
    var isConnected: Bool? { return tcpClient?.isConnected }
    var isLogin: Bool
    
    init(delegate: IMClientDelegate?) {
        socketCallback = delegate
        isLogin = false
        // recvBuffer = Data()
        
        super.init()
        print("CIMClient init")
        tcpClient = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    deinit {
        tcpClient?.delegate = nil
        tcpClient?.delegateQueue = nil
    }
    
    /// 连接服务器
    /// - Parameters:
    ///   - ip: 服务器地址
    ///   - port: 服务器端口
    ///   - callback: 连接结果回调
    internal func connect(ip: String, port: UInt16) -> Bool {
        self.ip = ip
        self.port = port
        
        if tcpClient!.isConnected {
            tcpClient?.disconnect()
        }
        
        print("CIMClient connect to \(ip):\(port)")
        do {
            try tcpClient?.connect(toHost: ip, onPort: port)
            return true
        } catch {
            print("connect error:\(error)")
        }
        return false
    }
    
    /// 断开连接
    internal func disconnect() {
        tcpClient?.disconnect()
    }
    
    /// send raw data to server,with out header
    /// - Parameter data: raw data
    internal func sendRaw(data: Data) {
        tcpClient?.write(data, withTimeout: -1, tag: 0)
    }
}

// MARK: GCDAsyncSocketDelegate

extension IMClient {
    // connect
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("successful connected to \(host):\(port)")
        if socketCallback != nil {
            socketCallback!.onConnected(host, port: port)
        }
        
        // 监听数据
        tcpClient?.readData(withTimeout: -1, tag: 0)
        
        if !isLogin, userId != nil, userNick != nil, userToken != nil {
            // 登录请求
            var req = CIM_Login_CIMAuthTokenReq()
            req.clientType = CIM_Def_CIMClientType.kCimClientTypeIos
            req.userID = userId!
            req.nickName = userNick!
            req.userToken = userToken!
            req.clientVersion = kClientVersion
            
            let body = try! req.serializedData()
            
            // sned to server
            send(cmdId: CIM_Def_CIMCmdID.kCimCidLoginAuthTokenReq, body: body)
        }
    }
    
    // receive data
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("socket receive data,len=\(data.count)")
        
        // 是否足够长，数据包完整
        if !IMHeader.isAvailable(data: data) {
            print("bad data!")
        } else {
            // 解析协议头
            let header = IMHeader()
            if !header.readHeader(data: data) {
                print("readHeader error!")
            } else {
                debugPrint("parse IMHeader success,cmd=\(header.commandId),seq=\(header.seqNumber)")
                
                // 处理消息
                let bodyData = data[Int(kHeaderLen)..<data.count] // 去掉头部，只放裸数据
                // _onHandle(header: header, data: bodyData)
                
                if header.commandId == CIM_Def_CIMCmdID.kCimCidLoginHeartbeat.rawValue {
                    print("recv hearbeat")
                } else if header.commandId == CIM_Def_CIMCmdID.kCimCidLoginAuthTokenRsp.rawValue {
                    _onHandleAuthRes(header: header, data: bodyData)
                } else {
                    if socketCallback != nil {
                        socketCallback!.onHandleData(header, bodyData)
                    }
                }
            }
        }
        
        // 监听数据
        tcpClient?.readData(withTimeout: -1, tag: 0)
    }
    
    // auth response
    func _onHandleAuthRes(header: IMHeader, data: Data) {
        var res = CIM_Login_CIMAuthTokenRsp()
        do {
            res = try CIM_Login_CIMAuthTokenRsp(serializedData: data)
            
            print("auth resultCode=\(res.resultCode),resultString=\(res.resultString)")
            // 回调auth结果
            if authCallback != nil {
                authCallback!(res)
            }
        } catch {
            print("parse error:\(error)")
        }
        
        // 启动定时发心跳的线程 FIXME
    }
    
    // disconnect
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket disconnected,error:\(String(describing: err))")
        if socketCallback != nil {
            socketCallback!.onDisconnect(err)
        }
    }
}

// MARK: IMClientProtocol

extension IMClient {
    /// 登录
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - nick: 用户昵称
    ///   - userToken: 用户口令
    ///   - serverIp: 服务器IP
    ///   - port: 服务器端口
    ///   - callback: 回调
    func auth(userId: UInt64, nick: String, userToken: String, serverIp: String, port: UInt16, callback: IMResultCallback<CIM_Login_CIMAuthTokenRsp>?) -> Bool {
        print("auth userId=\(userId),nick=\(nick),userToken=\(userToken),serverIp=\(serverIp),port=\(port)")
        disconnect()
        
        self.userId = userId
        userNick = nick
        self.userToken = userToken
        authCallback = callback
        
        let res = connect(ip: serverIp, port: port)
        return res
    }
    
    /// 发送请求，包含协议头
    /// - Parameters:
    ///   - cmdId: 命令ID，见CIM_Def_CIMCmdID
    ///   - body: 数据部
    func send(cmdId: CIM_Def_CIMCmdID, body: Data) {
        print("send cmdId=\(cmdId.rawValue),dataLen=\(body.count)")
        
        // 自增序列号，服务器会返回设置的序号ID，此时可查找响应是属于哪一个请求，当然也可以通过CMDID来判断，可以实现广播的效果
        let tempSeq = seq
        if tempSeq > (UINT16_MAX - 1) {
            seq = 1
        } else {
            seq += 1
        }
        
        // 头部
        let header = IMHeader()
        header.setCommandId(cmdId: UInt16(cmdId.rawValue))
        header.setSeq(seq: tempSeq)
        header.setMsg(msg: body)
        
        // 发送
        // header.getBuffer()包含协议头和数据部
        sendRaw(data: header.getBuffer()!)
        
        // debug big-endian
        // let bytes = [UInt8](header.getBuffer()!)
        // print(bytes)
    }
}
