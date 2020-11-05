//
//  IMMessage+Extension.swift
//  Coffchat
//
//  Created by fei.xu on 2020/5/14.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

enum LocalMsgType {
    case Server // 系统，此时从 var msgType: CIM_Def_CIMMsgType 取消息类型
    case LocalTime // 时间消息
}

class LocalIMMessage: IMMessage {
    var localMsgType: LocalMsgType?
    var fromUserNickName: String

    override init(clientId: String, sessionType: CIM_Def_CIMSessionType, fromId: UInt64, toId: UInt64, time: UInt32, msgType: CIM_Def_CIMMsgType, data: String) {
        fromUserNickName = String(fromId)

        super.init(clientId: clientId, sessionType: sessionType, fromId: fromId, toId: toId, time: time, msgType: msgType, data: data)
        localMsgType = .Server
    }

    init(msg: IMMessage) {
        fromUserNickName = String(msg.fromUserId)

        super.init(clientId: msg.clientMsgId, sessionType: msg.sessionType, fromId: msg.fromUserId, toId: msg.toSessionId, time: msg.createTime, msgType: msg.msgType, data: msg.msgData)
        localMsgType = .Server
    }
}
