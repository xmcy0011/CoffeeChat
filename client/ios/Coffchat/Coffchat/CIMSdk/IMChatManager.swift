//
//  IMChatManager.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/4.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
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
        msg.clientMsgID = getUUID()
        msg.createTime = Int32(NSDate().timeIntervalSince1970)
        msg.msgType = msgType
        msg.sessionType = sessionType
        msg.msgData = msgData

        let msg2 = IMMessage(clientId: msg.clientMsgID, sessionType: sessionType, fromId: msg.fromUserID, toId: toSessionId, time: UInt32(msg.createTime), msgType: msg.msgType, data: String(data: msg.msgData, encoding: .utf8)!)

        // 缓存，确认发送成功，超时则失败
        let ackInfo = IMAckInfo(data: msg2)
        ackMsgDic[msg.clientMsgID] = ackInfo

        IMLog.info(item: "send msg,clientMsgId:\(msg2.clientMsgId),msgType:\(msg2.msgType),to:\(msg2.toSessionId)")

        // 更新会话最后一条消息
        let message = IMMessage(clientId: msg.clientMsgID, sessionType: msg.sessionType, fromId: msg.fromUserID, toId: msg.toSessionID, time: UInt32(msg.createTime), msgType: msg.msgType, data: String(data: msg.msgData, encoding: .utf8)!)
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

    /// 设置消息已读
    /// - Parameters:
    ///   - sessionId: 会话ID
    ///   - sessionType: 会话类型
    ///   - endMsgId: 已读的消息ID，在这之前的消息都设置为已读状态，目前只针对整个会话生效。
    ///   - timeStamp: 时间戳
    func sendMessageReceipt(sessionId: UInt64, sessionType: CIM_Def_CIMSessionType /* , endMsgId: UInt64, timeStamp: UInt64 */ ) {
        IMManager.singleton.conversationManager.notifyAllMsgsRead(sessionId: sessionId, sessionType: sessionType)
    }

    /// 获取SessionId
    /// - Parameter msg: 消息
    /// - Returns: 结果
    internal class func getSessionIdFromMsg(msg: CIM_Message_CIMMsgData) -> UInt64 {
        // 单聊的时候，toSessionId代表自己的ID，为了便于UI更新，需要转换一下
        if msg.sessionType == .kCimSessionTypeSingle {
            return msg.fromUserID
        }
        return msg.toSessionID
    }

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
        } else {
            IMLog.warn(item: "duplicate key:\(key)")
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

extension IMChatManager {
    // 处理数据
    func onHandleData(_ header: IMHeader, _ data: Data) -> Bool{
        if header.commandId == CIM_Def_CIMCmdID.kCimCidMsgDataAck.rawValue {
            _onHandleMsgAck(data: data)
            return false
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidMsgData.rawValue {
            _onHandleMsgData(data: data)
            // msg broadcast to other modules
            return false
        }
        return false
    }

    // 消息发送结果
    fileprivate func _onHandleMsgAck(data: Data) {
        var res = CIM_Message_CIMMsgDataAck()
        do {
            res = try CIM_Message_CIMMsgDataAck(serializedData: data)
        } catch {
            IMLog.error(item: "parse error:\(error)")
        }

        IMLog.info(item: "recv msg ack,msgId:\(res.clientMsgID),from:\(res.fromUserID),to\(res.toSessionID)")

        // 回调结果，且标记从待响应队列中移除
        let ack = ackMsgDic[res.clientMsgID]
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

        // 回复ack
        var req = CIM_Message_CIMMsgDataAck()
        req.fromUserID = IMManager.singleton.loginManager.userId!
        req.toSessionID = res.fromUserID
        req.serverMsgID = 0 // fixed me
        req.clientMsgID = res.clientMsgID
        req.sessionType = res.sessionType
        _ = client.send(cmdId: .kCimCidMsgDataAck, body: try! req.serializedData())
        //IMLog.info(item: "send msg ack from:\(res.fromUserID),to:\(res.toSessionID)")

        // 处理一下sessionId，单聊时代表接收方的用户ID，此时需要替换成fromUserId
        let sessionId = IMChatManager.getSessionIdFromMsg(msg: res)

        // 回调
        let msg = IMMessage(clientId: res.clientMsgID, sessionType: res.sessionType, fromId: res.fromUserID, toId: sessionId, time: UInt32(res.createTime), msgType: res.msgType, data: String(data: res.msgData, encoding: .utf8)!)
        for item in delegateDic {
            item.value.onRecvMessage(msg: msg)
        }
    }
}
