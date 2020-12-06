//
//  BEButton.swift
//  Coffchat
//
//  Created by fei.xu on 2020/12/6.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit


// from: https://www.jianshu.com/p/d8b10fceb242

class BEButton: UIButton {
    let _top = "_top"
    let _left = "_left"
    let _bottom = "_bottom"
    let _right = "_right"
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = enlargedRect()
        if rect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }
}

extension BEButton {
    func setEnlargeEdge(_ length: Float) {
        setEnlargeEdge(length, length, length, length)
    }
    
    func setEnlargeEdge(_ top: Float, _ left: Float, _ bottom: Float, _ right: Float) {
        objc_setAssociatedObject(
            self,
            UnsafeRawPointer(bitPattern: _top.hashValue)!,
            NSNumber(value: top),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(
            self,
            UnsafeRawPointer(bitPattern: _left.hashValue)!,
            NSNumber(value: left),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(
            self,
            UnsafeRawPointer(bitPattern: _bottom.hashValue)!,
            NSNumber(value: bottom),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(
            self,
            UnsafeRawPointer(bitPattern: _right.hashValue)!,
            NSNumber(value: right),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func enlargedRect() -> CGRect {
        let topEdge = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: _top.hashValue)!) as? NSNumber
        let rightEdge = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: _left.hashValue)!) as? NSNumber
        let bottomEdge = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: _bottom.hashValue)!) as? NSNumber
        let leftEdge = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: _right.hashValue)!) as? NSNumber
        
        if topEdge != nil, leftEdge != nil, bottomEdge != nil, rightEdge != nil {
            return CGRect(
                x: bounds.origin.x - CGFloat(leftEdge!.floatValue),
                y: bounds.origin.y - CGFloat(topEdge!.floatValue),
                width: bounds.width + CGFloat(leftEdge!.floatValue) + CGFloat(rightEdge!.floatValue),
                height: bounds.height + CGFloat(topEdge!.floatValue) + CGFloat(bottomEdge!.floatValue))
            
        } else {
            return bounds
        }
    }
}
