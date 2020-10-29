//
//  UINavigationItem+Extension.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/29.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit

//
// 来自于[TSWeChat](https://github.com/hilen/TSWeChat)
//

public typealias ActionHandler = () -> Void

public extension UINavigationItem {
    // left bar
    func leftButtonAction(_ image: UIImage, action: @escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(image, for: UIControl.State())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action()
    })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 // fix the space
        self.leftBarButtonItems = [gapItem, barButton]
    }

    // right bar
    func rightButtonAction(_ image: UIImage, action: @escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(image, for: UIControl.State())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .right
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action()
    })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 // fix the space
        self.rightBarButtonItems = [gapItem, barButton]
    }
}

/*
 Block of UIControl
*/
open class ClosureWrapper : NSObject {
    let _callback : () -> Void
    init(callback : @escaping () -> Void) {
        _callback = callback
    }
    
    @objc open func invoke() {
        _callback()
    }
}

var AssociatedClosure: UInt8 = 0

extension UIControl {
    fileprivate func ngl_addAction(forControlEvents events: UIControl.Event, withCallback callback: @escaping () -> Void) {
        let wrapper = ClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(ClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
