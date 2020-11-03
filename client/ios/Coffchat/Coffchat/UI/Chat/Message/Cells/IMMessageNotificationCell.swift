//
//  IMMessageNotificationCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/11/3.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import SwiftyJSON
import UIKit

let kMinNotificationCellHeight = 21 // 通知的最小高度

class IMMessageNotificationCell: UITableViewCell {
    @IBOutlet var labText: UILabel!
    var model: IMMessage?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// 计算文本高度
    /// - Parameters:
    ///   - text: 文本
    /// - Returns: 高度
    class func getCellHeight(text: String) -> CGFloat {
        let textSize = IMMessageTextCell.getTextSize(text: text)
        if textSize.height > 90 {
            // IMLog.debug(item: "text height=\(textSize.height),width=\(textSize.width),text=\(text)")
        }

        var cellHeight = textSize.height + // 文字高度
            CGFloat(kTextMarginTop) + // 外边距
            CGFloat(kTextPadding) // 内边距

        // 限制最小高度
        cellHeight = cellHeight < CGFloat(kMinNotificationCellHeight) ? CGFloat(kMinNotificationCellHeight) : cellHeight
        return cellHeight
    }

    func setContent(message: LocalIMMessage) {
        if message.msgType == .kCimMsgTypeNotifacation {
            labText.text = IMMsgParser.resolveNotificationMsg(msgType: message.msgType, msgData: message.msgData)
        }
        self.model = message
        IMLog.debug(item: "\(String(describing: labText.text))")
    }
}
