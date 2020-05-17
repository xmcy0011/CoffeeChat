//
//  IMMessageTimeCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/5/13.
//  Copyright © 2020 fei.xu Inc. All rights reserved.
//

import UIKit

private let kMsgTimeLabelMaxWdith: CGFloat = UIScreen.main.bounds.size.width - 30 * 2
private let kMsgTimeLabelPaddingLeft: CGFloat = 6 // 左右分别留出 6 像素的留白
private let kMsgTimeLabelPaddingTop: CGFloat = 3 // 上下分别留出 3 像素的留白
private let kMsgTimeLabelMarginTop: CGFloat = 10 // 顶部 10 px

class IMMessageTimeCell: UITableViewCell {
    @IBOutlet var timeLabel: UIPaddingLabel! { didSet {
        timeLabel.layer.cornerRadius = 4
        timeLabel.layer.masksToBounds = true
        timeLabel.textColor = UIColor.white
        timeLabel.textInsets = .init(top: kMsgTimeLabelPaddingLeft, left: kMsgTimeLabelPaddingLeft, bottom: kMsgTimeLabelPaddingLeft, right: kMsgTimeLabelPaddingLeft)
        timeLabel.backgroundColor = UIColor(red: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 0.6)
    } }

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
    }

    func setContent(model: LocalIMMessage) {
        self.model = model
        self.model!.msgData = String(format: "%@", Date.messageAgoSinceDate(Date(timeIntervalSince1970: TimeInterval(model.createTime))))
        timeLabel.text = self.model!.msgData
        IMLog.debug(item: "\(String(describing: timeLabel.text))")
    }

    override func layoutSubviews() {
        setFrameWithString(model!.msgData, width: kMsgTimeLabelMaxWdith)
        timeLabel.frame.origin.x = (UIScreen.main.bounds.size.width - timeLabel.frame.size.width) / 2
        timeLabel.frame.origin.y = kMsgTimeLabelMarginTop
        timeLabel.frame.size.height = timeLabel.frame.size.height + kMsgTimeLabelPaddingTop * 2
        timeLabel.frame.size.width = timeLabel.frame.size.width + kMsgTimeLabelPaddingLeft * 2 // 左右的留白
    }

    /**
     Set UILabel's frame with the string, and limit the width.

     - parameter string: text
     - parameter width:  your limit width
     */
    func setFrameWithString(_ string: String, width: CGFloat) {
        timeLabel.numberOfLines = 0
        let attributes: [NSAttributedString.Key: AnyObject] = [
            .font: timeLabel.font,
        ]
        let resultSize: CGSize = string.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).size
        let resultHeight: CGFloat = resultSize.height
        let resultWidth: CGFloat = resultSize.width
        var frame: CGRect = timeLabel.frame
        frame.size.height = resultHeight
        frame.size.width = resultWidth
        timeLabel.frame = frame
    }

    /// 获取Cell的高度
    /// - Returns: 高度
    class func getCellHeight() -> CGFloat {
        return 40
    }
}
