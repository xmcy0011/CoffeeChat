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
    //func didLoad(sessions:[IMRecentSession])
}

/// 会话管理
class IMConversationManager: IMConversationManagerDelegate, IMClientDelegateData {
    fileprivate var client:IMClient
    
    fileprivate var delegateDic: [String: IMConversationManagerDelegate]

    /// 总的未读消息计数
    public var totalUnreadCount:Int
    
    //public var allRecentSessions:[IMRecentSession]
    
    init() {
        delegateDic = [:]
        totalUnreadCount = 0
        
        client = DefaultIMClient
        client.register(key: "IMConversationManager", delegateData:  self)
    }

    func getAllRecentSessions() {
        
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

extension IMConversationManager{
    func onHandleData(_ header: IMHeader, _ data: Data) {
        
    }
}

// MARK: IMConversationManagerDelegate

extension IMConversationManager {}

