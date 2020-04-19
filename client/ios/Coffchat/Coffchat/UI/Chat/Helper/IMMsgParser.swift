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
}
