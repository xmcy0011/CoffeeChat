//
//  UITabView+Chat.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/4.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit

// 扩展
extension UITableView{
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y:self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    func insertRowsAtBottom(_ rows: [IndexPath]) {
           //保证 insert row 不闪屏
           UIView.setAnimationsEnabled(false)
           CATransaction.begin()
           CATransaction.setDisableActions(true)
           self.beginUpdates()
           self.insertRows(at: rows, with: .none)
           self.endUpdates()
           self.scrollToRow(at: rows[0], at: .bottom, animated: false)
           CATransaction.commit()
           UIView.setAnimationsEnabled(true)
       }
}
