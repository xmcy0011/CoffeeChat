//
//  IMConversationManager.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/21.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation

/// 会话管理回调
protocol IMConversationManagerDelegate {
    /// 会话列表
    /// - Parameter sessions: <#sessions description#>
    // func didLoad(sessions:[IMRecentSession])
}

/// 会话管理
class IMConversationManager: IMConversationManagerDelegate, IMClientDelegateData {
    fileprivate var client: IMClient

    fileprivate var delegateDic: [String: IMConversationManagerDelegate]
    fileprivate var queryAllRecentSessionsCallback: IMResultCallback<CIM_List_CIMRecentContactSessionRsp>?
    fileprivate var queryMsgListCallback: IMResultCallback<CIM_List_CIMGetMsgListRsp>?

    /// 总的未读消息计数
    public var totalUnreadCount: UInt32

    // public var allRecentSessions:[IMRecentSession]

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
}

// MARK: IMClientDelegateData

extension IMConversationManager {
    func onHandleData(_ header: IMHeader, _ data: Data) {
        if Int(header.commandId) == CIM_Def_CIMCmdID.kCimCidListRecentContactSessionRsp.rawValue {
            _onHandleRecentSessonList(data: data)
        } else if Int(header.commandId) == CIM_Def_CIMCmdID.kCimCidListMsgRsp.rawValue {
            _onHandleMsgList(data: data)
        }
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
            // 回调
            queryAllRecentSessionsCallback?(res!)
        }
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
            IMLog.info(item: "session_id=\(res!.sessionID),session_type=\(res!.sessionType),msg_count=\(res!.msgList.count)")
            queryMsgListCallback?(res!)
        }
    }
}

// MARK: IMConversationManagerDelegate

extension IMConversationManager {}
