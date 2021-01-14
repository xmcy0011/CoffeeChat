//
//  IMLog.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/22.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// IM Log日志封装
class IMLog {
    fileprivate class func getNowTheTime() -> String {
        // create a date formatter
        let dateFormatter = DateFormatter()
        // setup formate string for the date formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // format the current date and time by the date formatter
        let dateStr = dateFormatter.string(from: Date())
        return dateStr
    }
    
    /// 打印一条debug日志
    /// - Parameters:
    ///   - item: 日志内容
    ///   - file: 文件名
    ///   - function: 函数名
    ///   - line: 行号
    class func debug(item: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            // 获取文件名
            let fileName = (file as NSString).lastPathComponent
            // 打印日志内容
            print("\(getNowTheTime()) [debug] [\(fileName):\(line) \(function)] | \(item)")
        #endif
    }
    
    /// 打印一条info日志
    /// - Parameters:
    ///   - item: 日志内容
    ///   - file: 文件名
    ///   - function: 函数名
    ///   - line: 行号
    class func info(item: String, file: String = #file, function: String = #function, line: Int = #line) {
        // 获取文件名
        let fileName = (file as NSString).lastPathComponent
        // 打印日志内容
        print("\(getNowTheTime()) [info] [\(fileName):\(line) \(function)] | \(item)")
    }
    
    /// 打印一条warn日志
    /// - Parameters:
    ///   - item: 日志内容
    ///   - file: 文件名
    ///   - function: 函数名
    ///   - line: 行号
    class func warn(item: String, file: String = #file, function: String = #function, line: Int = #line) {
        // 获取文件名
        let fileName = (file as NSString).lastPathComponent
        // 打印日志内容
        print("\(getNowTheTime()) [warn] [\(fileName):\(line) \(function)] | \(item)")
    }
    
    /// 打印一条error日志
    /// - Parameters:
    ///   - item: 日志内容
    ///   - file: 文件名
    ///   - function: 函数名
    ///   - line: 行号
    class func error(item: String, file: String = #file, function: String = #function, line: Int = #line) {
        // 获取文件名
        let fileName = (file as NSString).lastPathComponent
        // 打印日志内容
        print("\(getNowTheTime()) [error] [\(fileName):\(line) \(function)] | \(item)")
    }
}
