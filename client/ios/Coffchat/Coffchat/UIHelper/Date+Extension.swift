//
//  NSDate+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 2/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension Date {
    static var milliseconds: TimeInterval { return Date().timeIntervalSince1970 * 1000 }
    
    func week() -> String {
        let myWeekday: Int = (Calendar.current as NSCalendar).components([NSCalendar.Unit.weekday], from: self).weekday!
        switch myWeekday {
        case 1:
            return "星期天"
        case 2:
            return "星期一"
        case 3:
            return "星期二"
        case 4:
            return "星期三"
        case 5:
            return "星期四"
        case 6:
            return "星期五"
        case 7:
            return "星期六"
        default:
            break
        }
        return "星期八"
    }
    
    /// 消息时间格式化
    /// - Parameter date: 时间
    /// - Returns: 格式化时间字符串
    static func messageAgoSinceDate(_ date: Date) -> String {
        return self.timeAgoSinceDate(date)
    }
    
    /// 格式化时间
    /// - Parameters:
    ///   - date: 时间
    ///   - numericDates: 是否显示数字的时间
    /// - Returns: 格式化时间字符串
    static func timeAgoSinceDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components: DateComponents = (calendar as NSCalendar).components([
            NSCalendar.Unit.minute,
            NSCalendar.Unit.hour,
            NSCalendar.Unit.day,
            NSCalendar.Unit.weekOfYear,
            NSCalendar.Unit.month,
            NSCalendar.Unit.year,
            NSCalendar.Unit.second
        ], from: earliest, to: latest, options: NSCalendar.Options())
        
        // 今日 时分
        // 昨天 昨天 时分
        // 最近一周 星期 时分
        // 其余 年月日 时分
        let formatHm = DateFormatter()
        formatHm.dateFormat = "HH:mm"
        if components.year! >= 1 || components.month! >= 1 || components.weekOfYear! >= 2 {
            let format = DateFormatter()
            format.dateFormat = "yyyy年MM月dd日 HH:mm"
            return format.string(from: date)
        } else if components.weekOfYear! >= 1 || components.day! >= 2 {
            return "\(date.week()) \(formatHm.string(from: date))"
        } else if components.day! >= 1 { // 昨天
            return "昨天\(formatHm.string(from: date))"
        }
        return formatHm.string(from: date)
    }
}
