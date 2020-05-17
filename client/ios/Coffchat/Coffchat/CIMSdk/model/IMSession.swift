//
//  IMSession.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/25.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 会话信息
class IMSession {
    var sessionId: UInt64 // 会话id
    var sessionType: CIM_Def_CIMSessionType // 会话类型
    var sessionStatus: CIM_Def_CIMSessionStatusType? // 会话修改命令，预留

    init(id: UInt64, type: CIM_Def_CIMSessionType) {
        sessionId = id
        sessionType = type
    }
}
