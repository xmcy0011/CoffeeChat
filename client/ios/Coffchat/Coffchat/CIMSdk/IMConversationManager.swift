//
//  IMConversationManager.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/21.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 会话管理回调
protocol IMConversationManagerDelegate {
    /// 最近会话读取完成（目前是通过网络，后续会从本地数据库加载）
    func didLoadAllRecentSession()

    /// 会话更新回调
    /// 1.会话新增一条消息（收和发）
    /// 2.会话最后一条消息内容更新，比如发送失败
    /// 3.会话的未读计数被清零
    /// - Parameters:
    ///   - session: <#session description#>
    ///   - totalUnreadCount: <#totalUnreadCount description#>
    func didUpdateRecentSession(session: IMRecentSession, totalUnreadCount: Int32)
}

/// 会话管理
class IMConversationManager: IMClientDelegateData {
    fileprivate var client: IMClient

    fileprivate var delegateDic: [String: IMConversationManagerDelegate]
    fileprivate var queryAllRecentSessionsCallback: IMResultCallback<CIM_List_CIMRecentContactSessionRsp>?
    fileprivate var queryMsgListCallback: IMResultCallback<CIM_List_CIMGetMsgListRsp>?

    /// 总的未读消息计数
    public var totalUnreadCount: UInt32

    /// 所有的会话列表
    public var allRecentSessions: [String: IMRecentSession] = [:]

    init() {
        delegateDic = [:]
        totalUnreadCount = 0

        client = DefaultIMClient
        client.register(key: "IMConversationManager", delegateData: self)
    }

    /// 查询会话列表
    /// - Parameters:
    ///     - callback: 结果回调
    ///     - timeout: 超时回调
    func queryAllRecentSessions(callback: IMResultCallback<CIM_List_CIMRecentContactSessionRsp>?, timeout: IMResponseTimeoutCallback?) {
        var req = CIM_List_CIMRecentContactSessionReq()
        req.userID = IMManager.singleton.loginManager.userId!
        req.latestUpdateTime = 0

        IMLog.info(item: "queryAllRecentSessions userId=\(req.userID)")
        
        queryAllRecentSessionsCallback = callback

        // 发送请求
        client.sendRequest(cmdId: .kCimCidListRecentContactSessionReq, body: try! req.serializedData(), timeout: timeout)
    }

    /// 查询历史聊天记录
    /// - Parameters:
    ///   - sessionId：会话ID
    ///   - sessionType：会话类型
    ///   - endMsgId：结束消息ID
    ///   - limitCount：数量限制，最大100
    ///   - callback: 结果回调
    ///   - timeout: 超时回调
    func queryMsgList(sessionId: UInt64, sessionType: CIM_Def_CIMSessionType, endMsgId: UInt64, limitCount: Int, callback: IMResultCallback<CIM_List_CIMGetMsgListRsp>?, timeout: IMResponseTimeoutCallback?) {
        var req = CIM_List_CIMGetMsgListReq()
        req.userID = IMManager.singleton.loginManager.userId!
        req.sessionID = sessionId
        req.sessionType = sessionType
        req.endMsgID = endMsgId
        req.limitCount = UInt32(limitCount)

        queryMsgListCallback = callback
        client.sendRequest(cmdId: .kCimCidListMsgReq, body: try! req.serializedData(), timeout: timeout)
    }

    /// 设置会话所有消息已读
    /// - Parameters:
    ///   - sessionId: 会话
    ///   - sessionType: 会话类型
    func notifyAllMsgsRead(sessionId: UInt64, sessionType: CIM_Def_CIMSessionType) {
        var req = CIM_Message_CIMMsgDataReadAck()
        req.sessionID = sessionId
        req.userID = IMManager.singleton.loginManager.userId!
        req.msgID = 0
        req.sessionType = sessionType
        client.sendRequest(cmdId: .kCimCidMsgReadAck, body: try! req.serializedData(), timeout: nil)

        IMLog.info(item: "notifyAllMessagesRead sessionId:\(sessionId),sessionType:\(sessionType)")

        // 回调，更新UI界面
        DispatchQueue.main.async {
            for item in self.delegateDic {
                // 查找会话
                let key = self.getAllRecentSessionsKey(sessionId: sessionId, sessionType: sessionType)
                let value = self.allRecentSessions[key]
                if value != nil {
                    if self.totalUnreadCount > value!.unreadCnt{
                        self.totalUnreadCount = self.totalUnreadCount - value!.unreadCnt
                    }else{
                        self.totalUnreadCount = 0
                    }
                    value?.unreadCnt = 0
                    item.value.didUpdateRecentSession(session: value!, totalUnreadCount: Int32(self.totalUnreadCount))
                } else {
                    IMLog.debug(item: "session key:\(key) not find")
                }
            }
        }
    }

    /// 注册回调
    /// - Parameters:
    ///   - key: 唯一标识
    ///   - delegate: 回调
    func register(key: String, delegate: IMConversationManagerDelegate) {
        if delegateDic[key] == nil {
            delegateDic[key] = delegate
        }
    }

    /// 注销回调
    /// - Parameter key: 唯一标识
    func unregister(key: String) {
        delegateDic.removeValue(forKey: key)
    }

    func unregisterAll() {
        delegateDic.removeAll()
    }
}

// MARK: IMClientDelegateData

extension IMConversationManager {
    func onHandleData(_ header: IMHeader, _ data: Data) -> Bool {
        if Int(header.commandId) == CIM_Def_CIMCmdID.kCimCidListRecentContactSessionRsp.rawValue {
            _onHandleRecentSessonList(data: data)
            return true
        } else if Int(header.commandId) == CIM_Def_CIMCmdID.kCimCidListMsgRsp.rawValue {
            _onHandleMsgList(data: data)
            return true
        } else if Int(header.commandId) == CIM_Def_CIMCmdID.kCimCidMsgData.rawValue {
            _onHandleMsgData(data: data)
            return false
        } else if Int(header.commandId) == CIM_Def_CIMCmdID.kCimCidMsgDataAck.rawValue {
            _onHandleMsgDataAck(data: data)
            return false
        }
        return false
    }

    // 会话列表响应
    func _onHandleRecentSessonList(data: Data) {
        var res: CIM_List_CIMRecentContactSessionRsp?
        do {
            try res = CIM_List_CIMRecentContactSessionRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse CIM_List_CIMRecentContactSessionRsp error:\(error)")
        }

        if res != nil {
            IMLog.info(item: "unread_counts=\(res!.unreadCounts),session_count=\(res!.contactSessionList.count)")
            totalUnreadCount = res!.unreadCounts

            // 记录
            allRecentSessions.removeAll()
            for item in res!.contactSessionList {
                let message = IMMessage(clientId: item.msgID, sessionType: item.sessionType, fromId: item.msgFromUserID, toId: item.sessionID, time: item.msgTimeStamp, msgType: item.msgType, data: String(data: item.msgData, encoding: .utf8)!)
                let sessionInfo = IMSession(id: item.sessionID, type: item.sessionType)
                let recentSession = IMRecentSession(sessionInfo: sessionInfo, latestMsg: message, unreadCount: totalUnreadCount, updateTime: item.msgTimeStamp)

                // 存储
                let key = getAllRecentSessionsKey(sessionId: sessionInfo.sessionId, sessionType: sessionInfo.sessionType)
                allRecentSessions[key] = recentSession
            }

            // 回调
            queryAllRecentSessionsCallback?(res!)
        }
    }

    // 获取存储会话信息的key
    internal func getAllRecentSessionsKey(sessionId: UInt64, sessionType: CIM_Def_CIMSessionType) -> String {
        var key = "single_\(sessionId)"
        if sessionType == .kCimSessionTypeGroup {
            key = "group_\(sessionId)"
        } else {
            key = "\(sessionType)_\(sessionId)"
        }
        return key
    }

    // 聊天历史响应
    func _onHandleMsgList(data: Data) {
        var res: CIM_List_CIMGetMsgListRsp?
        do {
            try res = CIM_List_CIMGetMsgListRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse CIM_List_CIMGetMsgListRsp error:\(error)")
        }

        if res != nil {
            IMLog.info(item: "session_id=\(res!.sessionID),session_type=\(res!.sessionType),msg_count=\(res!.msgList.count),endMsgId:\(res!.endMsgID)")
            queryMsgListCallback?(res!)
        }
    }

    // 收到一条消息
    internal func _onHandleMsgData(data: Data) {
        var msg = CIM_Message_CIMMsgData()
        do {
            msg = try CIM_Message_CIMMsgData(serializedData: data)
        } catch {
            IMLog.error(item: "parse error:\(error)")
        }
        IMLog.info(item: "recv new msg,update session latestMsg,from=\(msg.fromUserID),to=\(msg.toSessionID),msgType=\(msg.msgType)")

        // 转换一下sessionId，单聊用fromId，群聊直接使用toSessionId
        let sessionId = IMChatManager.getSessionIdFromMsg(msg: msg)
        let message = IMMessage(clientId: msg.clientMsgID, sessionType: msg.sessionType, fromId: msg.fromUserID, toId: sessionId, time: UInt32(msg.createTime), msgType: msg.msgType, data: String(data: msg.msgData, encoding: .utf8)!)
        updateRecentSession(sessionId: sessionId, sessionType: msg.sessionType, msg: message)
    }

    /// 更新会话的信息，且回调界面
    /// - Parameters:
    ///   - sessionId: 会话ID
    ///   - sessionType: 会话类型
    ///   - msg: 最后一条消息
    internal func updateRecentSession(sessionId: UInt64, sessionType: CIM_Def_CIMSessionType, msg: IMMessage) {
        let key = getAllRecentSessionsKey(sessionId: sessionId, sessionType: msg.sessionType)
        var recentSession = allRecentSessions[key]

        if recentSession == nil {
            IMLog.info(item: "not find session key,create it,sessionId=\(sessionId),sessionType=\(sessionType)")
            let info = IMSession(id: sessionId, type: sessionType)
            recentSession = IMRecentSession(sessionInfo: info, latestMsg: msg, unreadCount: 0, updateTime: msg.createTime)
            allRecentSessions[key] = recentSession
        }
        // 更新最后一条消息
        recentSession!.latestMsg = msg
        recentSession!.updatedTime = UInt32(NSDate().timeIntervalSince1970)
        // 不是自己发送的消息，才更新未读计数
        if msg.fromUserId != IMManager.singleton.loginManager.userId {
            recentSession!.unreadCnt += 1
            totalUnreadCount += 1
        }

        // 回调，更新UI界面
        for item in delegateDic {
            item.value.didUpdateRecentSession(session: recentSession!, totalUnreadCount: Int32(totalUnreadCount))
        }
    }

    // 消息ACK
    func _onHandleMsgDataAck(data: Data) {
//        var msg = CIM_Message_CIMMsgDataAck()
//        do {
//            res = try CIM_Message_CIMMsgDataAck(serializedData: data)
//        } catch {
//            IMLog.error(item: "parse error:\(error)")
//        }
    }
}

// MARK: IMConversationManagerDelegate

extension IMConversationManager {}
