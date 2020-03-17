//
//  CIMClient.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/10.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import CocoaAsyncSocket
import Foundation

// IM结果回调
typealias IMResultCallback<T> = (_ res: T) -> Void
// 消息驱动表处理函数
typealias IMHandleFunc = (_ header: IMHeader, _ data: Data) -> Void

protocol IMClientProtocol {
    /// 登录
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - nick: 昵称
    ///   - userToken: 认证口令
    ///   - serverIp: 服务器IP
    ///   - port: 服务器端口
    ///   - callback: 登录结果回调
    func auth(userId: UInt64, nick: String, userToken: String, serverIp: String, port: UInt16, callback: IMResultCallback<CIM_Login_CIMAuthTokenRsp>?) -> Bool
}

let kClientVersion = "0.0.1"
let singletonIMClient = IMClient()

// IM连接
// 负责与服务端通信
class IMClient: NSObject, GCDAsyncSocketDelegate, IMClientProtocol {
    fileprivate var tcpClient: GCDAsyncSocket?
    fileprivate var ip: String = "10.0.106.117"
    fileprivate var port: UInt16 = 8000
    fileprivate var seq: UInt16 = 1 // 序号，发送一次后即递增，没加锁FIXME
    // fileprivate var recvBuffer:Data // TCP缓冲区，粘包处理
    fileprivate var lastHeartBeat: Int32 = 0 // 上一次收到服务器心跳的时间戳
    
    // dic
    fileprivate var requestDic: [UInt16: IMRequest]
    fileprivate var handleMap: [UInt16: IMHandleFunc]
    
    // callback
    fileprivate var connectCallback: IMResultCallback<Bool>?
    
    // 是否已连接
    var isConnected: Bool? { return tcpClient?.isConnected }
    
    /// 单实例
    public class var singleton: IMClient {
        return singletonIMClient
    }
    
    override init() {
        requestDic = [:]
        handleMap = [:]
        // recvBuffer = Data()
        
        super.init()
        print("CIMClient init")
        tcpClient = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        initHandleMap()
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
    internal func connect(ip: String, port: UInt16, callback: IMResultCallback<Bool>?) -> Bool {
        self.ip = ip
        self.port = port
        connectCallback = callback
        
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
    
    /// send raw data to server
    /// - Parameter data: raw data
    func send(data: Data) {
        tcpClient?.write(data, withTimeout: -1, tag: 0)
    }
    
    // 2、主界面UI显示数据
//        DispatchQueue.main.async {
//            let showStr: NSMutableString = NSMutableString()
//            showStr.append(self.msgView.text)
//            showStr.append(readClientDataString! as String)
//            showStr.append("\r\n")
//            self.msgView.text = showStr as String
//        }
    
    // 3、处理请求，返回数据给客户端OK
//        let serviceStr: NSMutableString = NSMutableString()
//        serviceStr.append("OK")
//        serviceStr.append("\r\n")
//        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
    
    // 4、每次读完数据后，都要调用一次监听数据的方法
//        clientSocket.readData(withTimeout: -1, tag: 0)
}

// MARK: GCDAsyncSocketDelegate

extension IMClient {
    // connect
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("successful connected to \(host):\(port)")
        if connectCallback != nil {
            connectCallback!(true)
        }
        
        // 监听数据
        tcpClient?.readData(withTimeout: -1, tag: 0)
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
                print("parse IMHeader success,cmd=\(header.commandId),seq=\(header.seqNumber)")
                
                // 处理消息
                let bodyData = data[Int(kHeaderLen)..<data.count] // 去掉头部，只放裸数据
                _onHandle(header: header, data: bodyData)
            }
        }
        
        // 监听数据
        tcpClient?.readData(withTimeout: -1, tag: 0)
    }
    
    // disconnect
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket disconnected,error:\(String(describing: err))")
    }
}

// MARK: IMClientProtocol

extension IMClient {
    /// 发送一个具有响应的请求
    /// - Parameters:
    ///   - cmdId: 命令ID，见CIM_Def_CIMCmdID
    ///   - body: 数据部
    ///   - callback: 响应结果回调
    func sendRequest(cmdId: CIM_Def_CIMCmdID, body: Data, callback: IMResponseCallback?) {
        print("sendRequest cmdId=\(cmdId.rawValue),dataLen=\(body.count)")
        
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
        
        // 加入请求字典中
        let req = IMRequest(header: header, callback: callback)
        requestDic[tempSeq] = req
        
        // 发送
        // header.getBuffer()包含协议头和数据部
        send(data: header.getBuffer()!)
        
        // debug big-endian
        // let bytes = [UInt8](header.getBuffer()!)
        // print(bytes)
    }
    
    /// 发送不需要响应的消息
    /// - Parameters:
    ///   - cmdId: 命令ID，见CIM_Def_CIMCmdID
    ///   - body: 数据部
    func sendNotify(cmdId: CIM_Def_CIMCmdID, body: Data) {
        print("sendNotify cmdId=\(cmdId.rawValue)")
        
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
        send(data: header.getBuffer()!)
    }
    
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
        
        let res = connect(ip: serverIp, port: port) { _ in // 连接成功回调
            // 这个写法，根据XCode提示修改后，有点看不懂啊
            // sendRequest的回调函数
            let authCallback: (IMHeader, Data) -> Void = { (_: IMHeader, data: Data) in
                var res = CIM_Login_CIMAuthTokenRsp()
                do {
                    res = try CIM_Login_CIMAuthTokenRsp(serializedData: data)
                    
                    print("auth resultCode=\(res.resultCode),resultString=\(res.resultString)")
                    // 回调auth结果
                    if callback != nil {
                        callback!(res)
                    }
                } catch {
                    print("parse error:\(error)")
                }
            }
            
            // 登录请求
            var req = CIM_Login_CIMAuthTokenReq()
            req.clientType = CIM_Def_CIMClientType.kCimClientTypeIos
            req.userID = userId
            req.nickName = nick
            req.userToken = userToken
            req.clientVersion = kClientVersion
            
            let body = try! req.serializedData()
            
            // authCallback as? IMResponseCallback
            self.sendRequest(cmdId: CIM_Def_CIMCmdID.kCimCidLoginAuthTokenReq, body: body, callback: authCallback)
        }
        return res
    }
}

// MARK: HandleMap

extension IMClient {
    /// 初始化消息驱动表
    internal func initHandleMap() {
        // 认证
        handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidLoginAuthTokenRsp.rawValue)] = _handleAuthRsp
        // 会话列表
        handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidListRecentContactSessionRsp.rawValue)] = _handleRecentSessionList
        // 历史消息
        handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidListMsgRsp.rawValue)] = _handleGetMsgList
        
        // 消息收发
        handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidMsgData.rawValue)] = _handleMsgData
        // 消息收到ACK
        handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidMsgDataAck.rawValue)] = _handleMsgDataAck
        // 已读消息通知
        handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidMsgReadAck.rawValue)] = _handleMsgReadNotify
    }
    
    // 消息处理
    internal func _onHandle(header: IMHeader, data: Data){
        // 心跳包，直接回复
        if header.commandId == CIM_Def_CIMCmdID.kCimCidLoginHeartbeat.rawValue {
            lastHeartBeat = Int32(NSDate().timeIntervalSince1970)
            print("receive headerbeat,lastHeartBeat=\(lastHeartBeat)")
            //sendNotify(cmdId: CIM_Def_CIMCmdID.kCimCidLoginHeartbeat, body: try! CIM_Login_CIMHeartBeat().serializedData())
            return
        }
        
        switch Int(header.commandId)  {
        case CIM_Def_CIMCmdID.kCimCidLoginAuthTokenRsp.rawValue:
            _handleAuthRsp(header: header, data: data)
        case CIM_Def_CIMCmdID.kCimCidListRecentContactSessionRsp.rawValue:
            _handleRecentSessionList(header: header, data: data)
        case CIM_Def_CIMCmdID.kCimCidListMsgRsp.rawValue:
            _handleGetMsgList(header: header, data: data)
        case CIM_Def_CIMCmdID.kCimCidMsgData.rawValue:
            _handleMsgData(header: header, data: data)
        case CIM_Def_CIMCmdID.kCimCidMsgDataAck.rawValue:
            _handleMsgDataAck(header: header, data: data)
        case CIM_Def_CIMCmdID.kCimCidMsgReadNotify.rawValue:
            _handleMsgReadNotify(header: header, data: data)
        default:
            print("unknown msg,cmdId=\(header.commandId)")
        }
    }
    
    // 认证
    internal func _handleAuthRsp(header: IMHeader, data: Data) {
        // 查找响应对应的请求并回调结果
        let item = requestDic.removeValue(forKey: header.seqNumber)
        if item == nil {
            print("WARRN:unknown msg,cmdId=\(header.commandId),seq=\(header.seqNumber)")
        } else {
            print("DEBUG:find callback,cmdId=\(header.commandId),seq=\(header.seqNumber)")
            
            // IMRequest.IMResponseCallback?
            // 回调结果
            if item?.callback != nil {
                item?.callback!(header, data)
            }
        }
    }
    
    // 会话列表
    internal func _handleRecentSessionList(header: IMHeader, data: Data) {
        var rsp: CIM_List_CIMRecentContactSessionRsp?
        do {
            rsp = try CIM_List_CIMRecentContactSessionRsp(serializedData: data)
        } catch {
            print("parse _handleRecentSessionList error")
        }
        if rsp != nil {
            print("_handleRecentSessionList unreadCount=\(rsp!.unreadCounts),count=\(rsp!.contactSessionList.count)")
        }
    }
    
    // 历史消息列表
    internal func _handleGetMsgList(header: IMHeader, data: Data) {
        var rsp: CIM_List_CIMGetMsgListRsp?
        do {
            rsp = try CIM_List_CIMGetMsgListRsp(serializedData: data)
        } catch {
            print("parse _handleGetMsgList error")
        }
        if rsp != nil {
            print("_handleGetMsgList count=\(rsp!.msgList.count)")
        }
    }
    
    // 收到消息
    internal func _handleMsgData(header: IMHeader, data: Data) {
        var msg: CIM_Message_CIMMsgData?
        do {
            msg = try CIM_Message_CIMMsgData(serializedData: data)
        } catch {
            print("parse _handleMsgData error")
        }
        if msg != nil {
            print("_handleMsgData fromId=\(msg!.fromUserID),msgType=\(msg!.msgType),sessionType=\(msg!.sessionType),clientMsgId=\(msg!.msgID)")
        }
    }
    
    // 收到消息回执ACK
    internal func _handleMsgDataAck(header: IMHeader, data: Data) {
        var ack: CIM_Message_CIMMsgDataAck?
        do {
            ack = try CIM_Message_CIMMsgDataAck(serializedData: data)
        } catch {
            print("parse _handleMsgDataAck error")
        }
        if ack != nil {
            print("_handleMsgDataAck toId=\(ack!.toSessionID),resCode=\(ack!.resCode),clientMsgId=\(ack!.msgID),serverMsgId=\(ack!.serverMsgID)")
        }
    }
    
    // 收到消息已读通知
    internal func _handleMsgReadNotify(header: IMHeader, data: Data) {
        var notify: CIM_Message_CIMMsgDataReadNotify?
        do {
            notify = try CIM_Message_CIMMsgDataReadNotify(serializedData: data)
        } catch {
            print("parse _handleMsgReadNotify error")
        }
        if notify != nil {
            print("_handleMsgReadNotify userId=\(notify!.userID),sessionId=\(notify!.sessionID),serverMsgId=\(notify!.msgID),sessionType=\(notify!.sessionType)")
        }
    }
}
