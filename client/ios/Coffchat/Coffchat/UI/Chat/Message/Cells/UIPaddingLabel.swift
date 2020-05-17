//
//  PaddingLabel.swift
//  Coffchat
//
//  Created by fei.xu on 2020/5/17.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation
import UIKit

/// 带内边距的文本
/// label = HomePaddingLabel()
/// label.font = .systemFont(ofSize: 10, weight: .regular)
/// label.textInsets = UIEdgeInsets(3, 6, 3, 6)
class UIPaddingLabel: UILabel {
    /// 内边距，UIEdgeInsets(3, 6, 3, 6)
    var textInsets: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)

        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
