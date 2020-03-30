//
//  IMMessageTextCell.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/28.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

/// 显示一条文本消息
class IMMessageTextCell: UITableViewCell {
    @IBOutlet var imageHead: UIImageView!
    @IBOutlet var labelMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// 设置消息
    /// - Parameter message: 消息
    func setContent(message: IMMessage) {
        imageHead.image = UIImage(named: "icon_avatar")
        labelMessage.text = message.msgData
    }

    /// 计算文本高度
    /// - Parameters:
    ///   - width: 宽带
    ///   - text: 文本
    /// - Returns: 高度
    class func getTextHeight(text: String) -> CGFloat {
        // 创建即可
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0 // 自动换行
        label.font = .systemFont(ofSize: 13) // 字体

        let screenWidth = UIScreen.main.bounds.size.width
        let kMarginLeft = 72 // 文本离屏幕左边的距离
        let kMarginRight = 65 // 文本离屏幕右边的距离
        let kMarginTop = 10 // 文本上面的距离
        // let kPaddingTop = 5 // 文本内边距

        let width = Int(screenWidth) - kMarginLeft - kMarginRight

        let boundingRect = label.text!.boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], context: nil)

        return boundingRect.size.height + CGFloat(kMarginTop*2)
    }
}
