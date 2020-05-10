//
//  IMMsgParser.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/19.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
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
                IMLog.error(item: "parse json error:\(error)")
            }
        }
        return robotMsg
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
