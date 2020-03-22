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
    fileprivate var getAllRecentSessionsCallback: IMResultCallback<CIM_List_CIMRecentContactSessionRsp>?

    /// 总的未读消息计数
    public var totalUnreadCount: Int

    // public var allRecentSessions:[IMRecentSession]

    init() {
        delegateDic = [:]
        totalUnreadCount = 0

        client = DefaultIMClient
        client.register(key: "IMConversationManager", delegateData: self)
    }

    /// 查询会话列表
    /// - Parameter timeout: 超时回调
    func getAllRecentSessions(callback: IMResultCallback<CIM_List_CIMRecentContactSessionRsp>?, timeout: IMResponseTimeoutCallback?) {
        var req = CIM_List_CIMRecentContactSessionReq()
        req.userID = IMManager.singleton.loginManager.userId!
        req.latestUpdateTime = 0

        getAllRecentSessionsCallback = callback

        // 发送请求
        client.sendRequest(cmdId: .kCimCidListRecentContactSessionReq, body: try! req.serializedData(), timeout: timeout)
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

    func _onHandleRecentSessonList(data: Data) {
        var res: CIM_List_CIMRecentContactSessionRsp?
        do {
            try res = CIM_List_CIMRecentContactSessionRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse CIM_List_CIMRecentContactSessionRsp error:\(error)")
        }

        if res != nil {
            IMLog.info(item: "unread_counts=\(res!.unreadCounts),session_count=\(res!.contactSessionList.count)")

            // 回调
            getAllRecentSessionsCallback?(res!)
        }
    }

    func _onHandleMsgList(data: Data) {}
}

// MARK: IMConversationManagerDelegate

extension IMConversationManager {}
