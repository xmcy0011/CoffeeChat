//
//  IMMsgParser.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/19.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class IMMsgParser {
    /// 解析机器人回答
    /// - Parameters:
    ///   - msgType: 消息类型
    ///   - msgData: 消息内容
    /// - Returns: 文本答案
    class func resolveRobotMsg(msgType: CIM_Def_CIMMsgType, msgData: String) -> String {
        var robotMsg = "unknown robot msg"
        
        if msgType == .kCimMsgTypeRobot {
            do {
                let json = try JSON(data: msgData.data(using: .utf8)!)
                let type = json["content"]["type"].string
                if type == "text" {
                    robotMsg = json["content"]["content"].string!
                } else {
                    IMLog.error(item: "unknown type:\(String(describing: type))")
                }
            } catch {
                IMLog.error(item: "parse json error:\(error),msgData:\(msgData)")
            }
        }
        return robotMsg
    }
    
    /// 解析系统通知消息
    /// - Parameters:
    ///   - msgType: 消息类型
    ///   - msgData: 消息内容
    /// - Returns: 通知文本
    class func resolveNotificationMsg(msgType: CIM_Def_CIMMsgType, msgData: String) -> String {
        if msgType == .kCimMsgTypeNotifacation {
            do {
                let json = try JSON(data: msgData.data(using: .utf8)!)
                let type = json["notificationType"].int
                if type == CIM_Def_CIMMsgNotificationType.kCimMsgNotificationGroupCreate.rawValue {
                    return _resolveNotifyCreateGroup(json: json)
                } else {
                    IMLog.error(item: "unknown type:\(String(describing: type))")
                }
            } catch {
                IMLog.error(item: "parse json error:\(error),msgData:\(msgData)")
            }
        }
        return "unknown"
    }
    
    class func _resolveNotifyCreateGroup(json: JSON) -> String {
        // {"groupId":"22","groupName":"测试群","owner":"1008","ownerNick":"1008",ids:["1001","1002"],nickNames:["1001","1002"]}
        // "xxx"邀请[你和]"yyy、zzz"加入了群聊
        var text = "unknown"
        let ownerNick = json["data"]["ownerNick"].string
        
        if ownerNick == nil {
            return text
        }
        
        // 组装被邀请人
        let jsonIds = json["data"]["ids"]
        let jsonNames = json["data"]["nickNames"]
        var isInviteMe = false
        var ex = ""
        for (index, subJSON): (String, JSON) in jsonIds {
            let id = UInt64(subJSON.string!)
            let indexInt = Int(index)
            let name = jsonNames[indexInt!].string
            
            if name == nil {
                continue
            }
            
            if id == IMManager.singleton.userId {
                isInviteMe = true
            } else {
                ex += "\(name!)、"
            }
        }
        ex = String(ex.prefix(ex.count - 1))
        
        text = "\"\(ownerNick!)\"邀请\"\(String(describing: ex))\"加入了群聊"
        if isInviteMe {
            text = "\"\(ownerNick!)\"邀请你和\"\(String(describing: ex))\"加入了群聊"
        }
        return text
    }
    
    /// 会话更新时间
    /// "时分"；"昨天 时分"；上周 "星期几 时分"；其他，显示"年月日 时分"
    class func timeFormat(timestamp: UInt32) -> String {
        let calendar = Calendar.current
        let target = Date(timeIntervalSince1970: Double(timestamp))
        let now = Date()
        let unit: NSCalendar.Unit = [
            NSCalendar.Unit.minute,
            NSCalendar.Unit.hour,
            NSCalendar.Unit.day,
            NSCalendar.Unit.month,
            NSCalendar.Unit.year,
        ]
        let nowComponents: DateComponents = (calendar as NSCalendar).components(unit, from: now)
        let targetComponents: DateComponents = (calendar as NSCalendar).components(unit, from: target)
        
        let year = nowComponents.year! - targetComponents.year!
        let month = nowComponents.month! - targetComponents.month!
        let day = nowComponents.day! - targetComponents.day!
        
        let formart = DateFormatter()
        formart.dateFormat = "HH:mm"
        
        // 今天，显示 时分
        // 昨天，显示 昨天
        // 本周内，显示 星期几
        // 其他，显示 年月日
        if year == 0, month == 0, day <= 7 {
            if day == 0 {
                return formart.string(from: target)
            } else if day == 1 {
                return "昨天"
            } else if day < 7 {
                return String(format: "%@", target.week())
            }
        }
        
        formart.dateFormat = "yyyy/MM/dd"
        return formart.string(from: target)
    }
}
