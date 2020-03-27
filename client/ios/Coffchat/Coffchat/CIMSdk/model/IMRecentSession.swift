//
//  IMRecentSession.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/22.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation

/// 代表一条IM会话
class IMRecentSession {
    var session: IMSession
    var latestMsg: IMMessage
    var isRobotSession: Bool? // 是否为机器人会话

    var unreadCnt: UInt32
    var updatedTime: UInt32

    init(sessionInfo: IMSession, latestMsg: IMMessage, unreadCount: UInt32, updateTime: UInt32) {
        session = sessionInfo
        self.latestMsg = latestMsg
        unreadCnt = unreadCount
        updatedTime = updateTime
    }
}
