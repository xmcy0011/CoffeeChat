//
//  SessionModel.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/25.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation

/// 会话数据模型
class SessionModel {
    var rectSession: IMRecentSession
    /// 头像
    var nickName: String
    var middleImageURL: String?
    var unreadNumber: UInt32 { return rectSession.unreadCnt }

    init(recentSession: IMRecentSession) {
        rectSession = recentSession
        nickName = String(rectSession.session.sessionId)
    }
}
