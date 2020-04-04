//
//  IMChatManager.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/4.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation

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
    var msgData: CIM_Message_CIMMsgData
    var callback: IMSendMsgResultCallback?
    var isDeal: Bool = false // 是否收到响应，供定时器使用
    var createTime: Int32

    init(data: CIM_Message_CIMMsgData, callback: IMSendMsgResultCallback?) {
        msgData = data
        self.callback = callback
        createTime = Int32(NSDate().timeIntervalSince1970)
    }
}

let sendMsgTimeout = 10

/// 消息消息
class IMChatManager: IMClientDelegateData {
    fileprivate var client: IMClient
    fileprivate var timer: Timer?
    fileprivate var ackMsgDic: [String: IMAckInfo] = [:]

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
    func sendMessage(toSessionId: UInt64, msgType: CIM_Def_CIMMsgType, sessionType: CIM_Def_CIMSessionType, msgData: Data, callback: IMSendMsgResultCallback?) {
        var msg = CIM_Message_CIMMsgData()
        msg.fromUserID = IMManager.singleton.userId!
        msg.fromNickName = IMManager.singleton.userNick!
        msg.toSessionID = toSessionId
        msg.msgID = getUUID()
        msg.createTime = Int32(NSDate().timeIntervalSince1970)
        msg.msgType = msgType
        msg.sessionType = sessionType
        msg.msgData = msgData

        // 缓存，确认发送成功，超时则失败
        let ackInfo = IMAckInfo(data: msg, callback: callback)
        ackMsgDic[msg.msgID] = ackInfo

        _ = client.send(cmdId: .kCimCidMsgData, body: try! msg.serializedData())
    }

    /// 发送文本
    /// - Parameters:
    ///   - toSessionId: 消息接受方，单聊用户ID，群聊群ID
    ///   - sessionType: 会话类型
    ///   - text: 文本
    ///   - callback: 结果回调
    func sendTextMessage(toSessionId: UInt64, sessionType: CIM_Def_CIMSessionType, text: String, callback: IMSendMsgResultCallback?) {
        let textData = text.data(using: .utf8)!
        sendMessage(toSessionId: toSessionId, msgType: .kCimMsgTypeText, sessionType: sessionType, msgData: textData, callback: callback)
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
                if item.value.callback != nil {
                    item.value.callback!(IMSendResult.Timeout, CIM_Def_CIMResCode.kCimResCodeUnknown)
                }
                // 待移除
                tempDic[item.key] = item.value
            }
        }

        // 移除收到响应的消息
        for item in tempDic {
            item.value.callback = nil
            ackMsgDic.removeValue(forKey: item.key)
        }
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

        // 回调结果，且标记从待响应队列中移除
        let item = ackMsgDic[res.msgID]
        item?.callback?(IMSendResult.Success, CIM_Def_CIMResCode.kCimResCodeOk)
        item?.isDeal = true
    }

    // 收到一条消息
    fileprivate func _onHandleMsgData(data: Data) {}
}
