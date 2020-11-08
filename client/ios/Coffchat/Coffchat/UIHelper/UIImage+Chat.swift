//
//  UIImage+Chat.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/29.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit

typealias IMAssets = UIImage.Asset

extension UIImage {
    enum Asset: String {
        case Chat_add_friend = "chat_add_friend"
        case Chat_add_newmessage = "chat_add_newmessage"
        case Chat_add_scan = "chat_add_scan"
        case Chat_MessageRightTopBg = "chat_MessageRightTopBg"
        case Chat_add = "chat_add"
        case Chat_icon_avatar = "icon_avatar"
        case Conversation_info = "convisation_info"
        
        // 还可以这样写？
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    // 便利构造函数通常都是写在extension里面
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
