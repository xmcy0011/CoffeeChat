//
//  UITabView+Chat.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/4.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation
import UIKit

// 扩展
extension UITableView{
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y:self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
