//
//  IMMessage.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/25.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 消息信息
class IMMessage {
    var clientMsgId: String // 客户端消息ID（UUID）
    var serverMsgId: UInt64? // 服务端消息ID

    var msgResCode: CIM_Def_CIMResCode? // 消息错误码
    var msgFeature: CIM_Def_CIMMsgFeature? // 消息属性
    var sessionType: CIM_Def_CIMSessionType // 会话类型
    var fromUserId: UInt64 // 来源会话ID
    var toSessionId: UInt64 // 目标会话ID
    var createTime: UInt32 // 消息创建时间戳（毫秒）

    var msgType: CIM_Def_CIMMsgType // 消息类型
    var msgStatus: CIM_Def_CIMMsgStatus? // 消息状态（预留）
    var msgData: String // 消息内容

    /* optional */
    var attach: String? // 消息附件（预留）
    var senderClientType: CIM_Def_CIMClientType? // 发送者客户端类型

    init(clientId: String, sessionType: CIM_Def_CIMSessionType, fromId: UInt64, toId: UInt64, time: UInt32, msgType: CIM_Def_CIMMsgType, data: String) {
        clientMsgId = clientId
        self.sessionType = sessionType
        fromUserId = fromId
        toSessionId = toId
        createTime = time
        self.msgType = msgType
        self.msgData = data
    }
}
