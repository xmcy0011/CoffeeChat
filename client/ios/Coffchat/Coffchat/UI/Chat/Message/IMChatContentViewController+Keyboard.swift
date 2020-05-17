//
//  IMChatContentViewController+Keyboard.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/4.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit

// MARK: Keyboard

extension IMChatContentViewController {
    // 键盘显示 得带@objc前缀
    @objc func keyboardShow(note: Notification) {
        self.msgTabView.scrollToBottomAnimated(false)
        self.keyboardControl(note, isShowing: true)
    }

    // 键盘已经显示
    @objc func keyboardDidShow(note: Notification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            _ = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    // 键盘隐藏
    @objc func keyboardHidden(note: Notification) {
        self.keyboardControl(note, isShowing: false)
    }

    /**
     控制键盘事件
     - parameter notification: NSNotification 对象
     - parameter isShowing:    是否显示键盘？
     */
    func keyboardControl(_ notification: Notification, isShowing: Bool) {
        let userInfo = notification.userInfo!
        // 键盘区域
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        // 键盘高度
        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y

        // 获取动画执行的时间
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        self.msgTabView.stopScrolling()
        // self.sendMsgBarBottomConstranit?.update(offset:-heightOffset)

        UIView.animate(
            withDuration: duration!,
            delay: 0,
            options: .allowAnimatedContent,
            animations: {
                self.sendMsgBarBottomConstranit?.update(offset: -heightOffset)
                self.view.layoutIfNeeded()
                // 有足够多的内容，才滚动到底部
                if isShowing && self.msgTabView.canScrollToBottom {
                    self.msgTabView.scrollToBottom(animated: false)
                }
            },
            completion: nil)
    }
}
