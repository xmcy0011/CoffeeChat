//
//  IMManager.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/10.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import CocoaAsyncSocket
import Foundation

// 消息驱动表处理函数
typealias IMHandleFunc = (_ header: IMHeader, _ data: Data) -> Void
let singletonIMManager = IMManager()

/*
 protocol IMManagerProtocol {
 /// 登录
 /// - Parameters:
 ///   - userId: 用户ID
 ///   - nick: 昵称
 ///   - userToken: 认证口令
 ///   - serverIp: 服务器IP
 ///   - port: 服务器端口
 ///   - callback: 登录结果回调
 func auth(userId: UInt64, nick: String, userToken: String, serverIp: String, port: UInt16, callback: IMResultCallback<CIM_Login_CIMAuthTokenRsp>?) -> Bool
 /// 发送一个具有响应的请求
 /// - Parameters:
 ///   - cmdId: 命令ID，见CIM_Def_CIMCmdID
 ///   - body: 数据部
 ///   - callback: 响应结果回调
 func send(cmdId: CIM_Def_CIMCmdID, body: Data, callback: IMResponseCallback?)
 /// 发送不需要响应的消息
 /// - Parameters:
 ///   - cmdId: 命令ID，见CIM_Def_CIMCmdID
 ///   - body: 数据部
 func sendNotify(cmdId: CIM_Def_CIMCmdID, body: Data)
 }
 */

// IM连接
// 负责与服务端通信
class IMManager {
    fileprivate var _chatManager: IMChatManager
    fileprivate var _loginManager: IMLoginManager
    fileprivate var _conversationManager: IMConversationManager
    fileprivate var _groupManager: IMGroupManager
    fileprivate var _friendManager: IMFriendManager
    fileprivate var _userManager: IMUserManager
    
    // dic
    fileprivate var requestDic: [UInt16: IMRequest]
    fileprivate var handleMap: [UInt16: IMHandleFunc]
    
    // 登录管理
    public var loginManager: IMLoginManager {
        return _loginManager
    }
    
    // 会话管理
    public var conversationManager: IMConversationManager {
        return _conversationManager
    }
    
    // 消息管理
    public var chatManager: IMChatManager {
        return _chatManager
    }
    
    // 群组管理
    public var groupManager: IMGroupManager {
        return _groupManager
    }
    
    // 好友管理
    public var friendManager: IMFriendManager {
        return _friendManager
    }
    
    // 用户管理
    public var userManager: IMUserManager{
        return _userManager
    }
    
    // 用户ID
    public var userId: UInt64? { return loginManager.userId }
    // 用户昵称
    public var userNick: String? { return loginManager.userNick }
    
    /// 单实例
    public class var singleton: IMManager {
        return singletonIMManager
    }
    
    init() {
        handleMap = [:]
        requestDic = [:]
        
        _loginManager = IMLoginManager()
        _conversationManager = IMConversationManager()
        _chatManager = IMChatManager()
        _groupManager = IMGroupManager()
        _friendManager = IMFriendManager()
        _userManager = IMUserManager()
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

// MARK: HandleMap

extension IMManager {
    /// 初始化消息驱动表
    internal func initHandleMap() {
        // 认证
        // handleMap[UInt16(CIM_Def_CIMCmdID.kCimCidLoginAuthTokenRsp.rawValue)] = _handleAuthRsp
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
    internal func _onHandle(header: IMHeader, data: Data) {
        switch Int(header.commandId) {
//        case CIM_Def_CIMCmdID.kCimCidLoginAuthTokenRsp.rawValue:
//            _handleAuthRsp(header: header, data: data)
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
            IMLog.warn(item: "unknown msg,cmdId=\(header.commandId)")
        }
    }
    
    // 会话列表
    internal func _handleRecentSessionList(header: IMHeader, data: Data) {
        var rsp: CIM_List_CIMRecentContactSessionRsp?
        do {
            rsp = try CIM_List_CIMRecentContactSessionRsp(serializedData: data)
        } catch {
            IMLog.error(item: "parse _handleRecentSessionList error")
        }
        if rsp != nil {
            IMLog.info(item: "_handleRecentSessionList unreadCount=\(rsp!.unreadCounts),count=\(rsp!.contactSessionList.count)")
        }
    }
    
    // 历史消息列表
    internal func _handleGetMsgList(header: IMHeader, data: Data) {
        var rsp: CIM_List_CIMGetMsgListRsp?
        do {
            rsp = try CIM_List_CIMGetMsgListRsp(serializedData: data)
        } catch {
            IMLog.error(item: "parse _handleGetMsgList error")
        }
        if rsp != nil {
            IMLog.info(item: "_handleGetMsgList count=\(rsp!.msgList.count)")
        }
    }
    
    // 收到消息
    internal func _handleMsgData(header: IMHeader, data: Data) {
        var msg: CIM_Message_CIMMsgData?
        do {
            msg = try CIM_Message_CIMMsgData(serializedData: data)
        } catch {
            IMLog.error(item: "parse _handleMsgData error")
        }
        if msg != nil {
            print("_handleMsgData fromId=\(msg!.fromUserID),msgType=\(msg!.msgType),sessionType=\(msg!.sessionType),clientMsgId=\(msg!.clientMsgID)")
        }
    }
    
    // 收到消息回执ACK
    internal func _handleMsgDataAck(header: IMHeader, data: Data) {
        var ack: CIM_Message_CIMMsgDataAck?
        do {
            ack = try CIM_Message_CIMMsgDataAck(serializedData: data)
        } catch {
            IMLog.error(item: "parse _handleMsgDataAck error")
        }
        if ack != nil {
            IMLog.info(item: "_handleMsgDataAck toId=\(ack!.toSessionID),resCode=\(ack!.resCode),clientMsgId=\(ack!.clientMsgID),serverMsgId=\(ack!.serverMsgID)")
        }
    }
    
    // 收到消息已读通知
    internal func _handleMsgReadNotify(header: IMHeader, data: Data) {
        var notify: CIM_Message_CIMMsgDataReadNotify?
        do {
            notify = try CIM_Message_CIMMsgDataReadNotify(serializedData: data)
        } catch {
            IMLog.error(item: "parse _handleMsgReadNotify error")
        }
        if notify != nil {
            IMLog.info(item: "_handleMsgReadNotify userId=\(notify!.userID),sessionId=\(notify!.sessionID),serverMsgId=\(notify!.msgID),sessionType=\(notify!.sessionType)")
        }
    }
}
