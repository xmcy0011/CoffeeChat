//
//  IMChatManager.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/4.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation

/// 消息回调
protocol IMChatManagerDelegate {
    /// 发送消息结果
    /// - Parameters:
    ///   - msg: 消息
    ///   - result: 结果
    ///   - code: 结果描述
    func sendMessageResult(msg: IMMessage, result: IMSendResult, _ code: CIM_Def_CIMResCode)
    /// 收到一条消息
    /// - Parameter msg: 消息
    func onRecvMessage(msg: IMMessage) -> Void
}

// 消息发送结果
enum IMSendResult: Int {
    case Success = 0
    case Timeout
    case Error
}

// 回调消息
typealias IMSendMsgResultCallback = (_ result: IMSendResult, _ code: CIM_Def_CIMResCode) -> Void

// 保存回调信息
class IMAckInfo {
    var msgData: IMMessage
    var isDeal: Bool = false // 是否收到响应，供定时器使用
    var createTime: Int32

    init(data: IMMessage) {
        msgData = data
        createTime = Int32(NSDate().timeIntervalSince1970)
    }
}

let sendMsgTimeout = 10

/// 消息消息
class IMChatManager: IMClientDelegateData {
    fileprivate var client: IMClient
    fileprivate var timer: Timer?
    fileprivate var ackMsgDic: [String: IMAckInfo] = [:]
    // 委托回调列表
    fileprivate var delegateDic: [String: IMChatManagerDelegate] = [:]

    // 获取UUID
    fileprivate func getUUID() -> String {
        let uuidRef = CFUUIDCreate(nil)
        let uuidStringRef = CFUUIDCreateString(nil, uuidRef)
        return uuidStringRef! as String
    }

    init() {
        client = DefaultIMClient
        client.register(key: "IMChatManager", delegateData: self)

        timer = Timer(timeInterval: 1, repeats: true, block: timerTick)
    }

    /// 发送消息
    /// - Parameters:
    ///   - toSessionId: 消息接受方，单聊用户ID，群聊群ID
    ///   - msgType: 消息类型
    ///   - sessionType: 会话类型
    ///   - msgData: 消息内容
    ///   - callback：结果回调
    func sendMessage(toSessionId: UInt64, msgType: CIM_Def_CIMMsgType, sessionType: CIM_Def_CIMSessionType, msgData: Data) {
        var msg = CIM_Message_CIMMsgData()
        msg.fromUserID = IMManager.singleton.userId!
        msg.fromNickName = IMManager.singleton.userNick!
        msg.toSessionID = toSessionId
        msg.msgID = getUUID()
        msg.createTime = Int32(NSDate().timeIntervalSince1970)
        msg.msgType = msgType
        msg.sessionType = sessionType
        msg.msgData = msgData

        let msg2 = IMMessage(clientId: msg.msgID, sessionType: sessionType, fromId: msg.fromUserID, toId: toSessionId, time: UInt32(msg.createTime), msgType: msg.msgType, data: String(data: msg.msgData, encoding: .utf8)!)

        // 缓存，确认发送成功，超时则失败
        let ackInfo = IMAckInfo(data: msg2)
        ackMsgDic[msg.msgID] = ackInfo

        IMLog.info(item: "send msg,clientMsgId:\(msg2.clientMsgId),msgType:\(msg2.msgType),to:\(msg2.toSessionId)")

        // 更新会话最后一条消息
        let message = IMMessage(clientId: msg.msgID, sessionType: msg.sessionType, fromId: msg.fromUserID, toId: msg.toSessionID, time: UInt32(msg.createTime), msgType: msg.msgType, data: String(data: msg.msgData, encoding: .utf8)!)
        IMManager.singleton.conversationManager.updateRecentSession(sessionId: msg.toSessionID, sessionType: msg.sessionType, msg: message)

        _ = client.send(cmdId: .kCimCidMsgData, body: try! msg.serializedData())
    }

    /// 发送文本
    /// - Parameters:
    ///   - toSessionId: 消息接受方，单聊用户ID，群聊群ID
    ///   - sessionType: 会话类型
    ///   - text: 文本
    ///   - callback: 结果回调
    func sendTextMessage(toSessionId: UInt64, sessionType: CIM_Def_CIMSessionType, text: String) {
        let textData = text.data(using: .utf8)!
        sendMessage(toSessionId: toSessionId, msgType: .kCimMsgTypeText, sessionType: sessionType, msgData: textData)
    }

    func sendMessageReceipt() {}

    // 检测
    func timerTick(_ t: Timer) {
        let now = Int32(NSDate().timeIntervalSince1970)

        var tempDic: [String: IMAckInfo] = [:]
        for item in ackMsgDic {
            // 处理过，需要移除
            if item.value.isDeal {
                tempDic[item.key] = item.value
                continue
            }

            // 超时，回调
            if abs(now - item.value.createTime) >= sendMsgTimeout {
                for instance in delegateDic {
                    instance.value.sendMessageResult(msg: item.value.msgData, result: .Timeout, .kCimResCodeUnknown)
                }
                // 待移除
                tempDic[item.key] = item.value
            }
        }

        // 移除收到响应的消息
        for item in tempDic {
            ackMsgDic.removeValue(forKey: item.key)
        }
    }

    /// 注册回调
    /// - Parameters:
    ///   - key: 唯一标识
    ///   - delegate: 回调
    func register(key: String, delegate: IMChatManagerDelegate) {
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

extension IMChatManager {
    // 处理数据
    func onHandleData(_ header: IMHeader, _ data: Data) {
        if header.commandId == CIM_Def_CIMCmdID.kCimCidMsgDataAck.rawValue {
            _onHandleMsgAck(data: data)
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidMsgData.rawValue {
            _onHandleMsgData(data: data)
        }
    }

    // 消息发送结果
    fileprivate func _onHandleMsgAck(data: Data) {
        var res = CIM_Message_CIMMsgDataAck()
        do {
            res = try CIM_Message_CIMMsgDataAck(serializedData: data)
        } catch {
            IMLog.error(item: "parse error:\(error)")
        }

        IMLog.info(item: "recv msg ack,msgId:\(res.msgID),from:\(res.fromUserID),to\(res.toSessionID)")

        // 回调结果，且标记从待响应队列中移除
        let ack = ackMsgDic[res.msgID]
        if ack != nil {
            ack!.isDeal = true
            for item in delegateDic {
                item.value.sendMessageResult(msg: ack!.msgData, result: .Success, .kCimResCodeOk)
            }
        }
    }

    // 收到一条消息
    fileprivate func _onHandleMsgData(data: Data) {
        var res = CIM_Message_CIMMsgData()
        do {
            res = try CIM_Message_CIMMsgData(serializedData: data)
        } catch {
            IMLog.error(item: "parse error:\(error)")
        }

        IMLog.info(item: "recv new msg,from:\(res.fromUserID),to:\(res.toSessionID),msgType:\(res.msgType)")

        // 回调
        let msg = IMMessage(clientId: res.msgID, sessionType: res.sessionType, fromId: res.fromUserID, toId: res.toSessionID, time: UInt32(res.createTime), msgType: res.msgType, data: String(data: res.msgData, encoding: .utf8)!)
        for item in delegateDic {
            item.value.onRecvMessage(msg: msg)
        }
    }
}
