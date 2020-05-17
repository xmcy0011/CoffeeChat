//
//  UIScrollView+Chat.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/4.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit

// 扩展
extension UIScrollView{
    ///  YES if the scrollView's offset is at the very top.
    public var isAtTop: Bool {
        get { return self.contentOffset.y == 0.0 ? true : false }
    }
    
    ///  YES if the scrollView's offset is at the very bottom.
    public var isAtBottom: Bool {
        get {
            let bottomOffset = self.contentSize.height - self.bounds.size.height
            return self.contentOffset.y == bottomOffset ? true : false
        }
    }
    
    ///  YES if the scrollView can scroll from it's current offset position to the bottom.
    public var canScrollToBottom: Bool {
        get { return self.contentSize.height > self.bounds.size.height ? true : false }
    }

     /**
     Sets the content offset to the top.
     
     - parameter animated: animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
     */
    public func scrollToTopAnimated(_ animated: Bool) {
        if !self.isAtTop {
            let bottomOffset = CGPoint.zero;
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }

    /**
     Sets the content offset to the bottom.
     
     - parameter animated: animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
     */
    public func scrollToBottomAnimated(_ animated: Bool) {
        if self.canScrollToBottom && !self.isAtBottom {
            let bottomOffset = CGPoint(x: 0.0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }

    /**
      Stops scrolling, if it was scrolling.
     */
    public func stopScrolling() {
        guard self.isDragging else {
            return
        }
        var offset = self.contentOffset
        offset.y -= 1.0
        self.setContentOffset(offset, animated: false)

        offset.y += 1.0
        self.setContentOffset(offset, animated: false)
    }
}
