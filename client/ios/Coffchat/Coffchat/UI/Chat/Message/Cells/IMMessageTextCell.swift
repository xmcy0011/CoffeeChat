//
//  IMMessageTextCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/28.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import SwiftyJSON
import UIKit

let kMinCellHeight = 65 // 一行最小的高度
let kMinTextHeight = 45 // 文本最小的高度，保持和头像一样

let kImageHeight = 45 // 头像高度
let kImageWidth = 45 // 头像宽度
let kImageMarginLeft = 16 // 头像距离左边的间距

let kTextImageMarginLet = 8 // 文本距离头像的间距
let kTextMarginTop = 10 // 文本上面的距离
let kTextMarginLeft = 69 // 文本离屏幕左边的距离（头像宽度45 + 头像左边剧16）
let kTextMarginRight = 69 // 文本离屏幕右边的距离（头像宽度45 + 头像右边剧16）
let kTextPadding = 10 // 文本内边距

let kLabelNickNameHeight = 21 // 昵称高度

/// 显示一条文本消息
class IMMessageTextCell: UITableViewCell {
    // 头像
    @IBOutlet var imageHead: UIImageView!
    // 文本
    // 被CocoaTouch框架赋值的时候，改变文本默认样式
    // 没有内边距，需要自定义，比较难看，先这样
    @IBOutlet var labelMessage: UIPaddingLabel! { didSet {
        labelMessage.numberOfLines = 0 // 自动换行
        // 圆角
        labelMessage.layer.cornerRadius = CGFloat(4)
        labelMessage.layer.masksToBounds = true
        labelMessage.backgroundColor = UIColor(red: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 0.6)
        // 内容剧中
        labelMessage.contentMode = .center
        // 内边距
        labelMessage.textInsets = UIEdgeInsets(top: CGFloat(kTextPadding), left: CGFloat(kTextPadding), bottom: CGFloat(kTextPadding), right: CGFloat(kTextPadding))
        } }
    // 昵称
    @IBOutlet var labelNickName: UILabel!

    // 数据模型
    var model: LocalIMMessage?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // 背景色，通过UITabView和TabCell同时控制
        backgroundColor = IMUIResource.chatBackground
        // 选中样式，不需要选择效果
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// 设置消息
    /// - Parameter message: 消息
    func setContent(message: LocalIMMessage) {
        model = message
        // 更新文本内容和头像
        imageHead.image = UIImage(named: "icon_avatar")

        // 文本内容
        if message.msgType == .kCimMsgTypeRobot {
            labelMessage.text = IMMsgParser.resolveRobotMsg(msgType: message.msgType, msgData: message.msgData)
        } else {
            labelMessage.text = message.msgData
        }

        // 昵称
        if message.sessionType == .kCimSessionTypeGroup {
            labelNickName.text = message.fromUserNickName
        } else {
            labelNickName.isHidden = true
        }

        // 标记需要重新刷新布局，但layoutSubviews不会立即调用
        setNeedsLayout()
        // self.setNeedsDisplay(self.bounds)
        // self.draw(self.bounds)
    }

    /// 计算文本高度
    /// - Parameters:
    ///   - text: 文本
    /// - Returns: 高度
    class func getCellHeight(text: String, sessionType: CIM_Def_CIMSessionType) -> CGFloat {
        let textSize = getTextSize(text: text)
        if textSize.height > 90 {
            // IMLog.debug(item: "text height=\(textSize.height),width=\(textSize.width),text=\(text)")
        }

        var cellHeight = textSize.height + // 文字高度
            CGFloat(kTextMarginTop * 2) + // 外边距
            CGFloat(kTextPadding * 2) // 内边距

        // 群聊，显示昵称，增加昵称高度
        if sessionType == CIM_Def_CIMSessionType.kCimSessionTypeGroup {
            cellHeight += CGFloat(kLabelNickNameHeight)
        }

        // 限制最小高度
        cellHeight = cellHeight < CGFloat(kMinCellHeight) ? CGFloat(kMinCellHeight) : cellHeight
        return cellHeight
    }

    /// 计算文本大小
    class func getTextSize(text: String) -> CGSize {
        // 创建即可
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0 // 自动换行
        label.font = .systemFont(ofSize: 13) // 字体

        let screenWidth = UIScreen.main.bounds.size.width
        // 文本最大宽度，减去左边距（对方头像）、右边距（我方头像）
        let width = Int(screenWidth) - kTextMarginLeft - kTextMarginRight - (kTextPadding * 2)
        let boundingRect = label.text!.boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], context: nil)

        let boundSize = boundingRect.size
        return CGSize(width: boundSize.width + CGFloat(kTextPadding * 2), height: boundSize.height + CGFloat(kTextMarginTop * 2))
    }

    /// 确定子视图的布局，这里可以自定义控件位置
    override func layoutSubviews() {
        super.layoutSubviews()

        let userId = IMManager.singleton.loginManager.userId!
        // 是来自于我的消息，显示在右侧
        if userId == model!.fromUserId {
            layoutMeSubviews()
        } else {
            layoutOtherSubviews()
        }
    }

    // 我发的消息
    func layoutMeSubviews() {
        let screenWidth = UIScreen.main.bounds.size.width
        // 计算头像左边距，屏幕 - 我自己头像宽度 - 和我头像的间距
        let left = screenWidth - CGFloat(kImageMarginLeft) - CGFloat(kImageWidth)
        // 设置头像的x坐标
        imageHead.frame.origin.x = left

        // 设置昵称的左边距 = 头像左边距 - 文本离头像的左边距
        labelNickName.frame.origin.x = left - labelNickName.frame.size.width - CGFloat(kTextImageMarginLet)
        labelNickName.textAlignment = .right
        
        // 测量文本宽高
        let size = IMMessageTextCell.getTextSize(text: model!.msgData)
        // 文本左边距 = 屏幕宽度 - 文本宽度 - 左边距离（对方头像大小+固定16边距) - 文本离头像的宽度
        let leftLabel = screenWidth - size.width - CGFloat(kImageWidth + kImageMarginLeft) - CGFloat(kTextImageMarginLet)
        // 限制文本最小高度
        let h = size.height > CGFloat(kMinTextHeight) ? size.height : CGFloat(kMinTextHeight)

        // 文本的y坐标
        var y = CGFloat(kTextMarginTop)
        if model?.sessionType == CIM_Def_CIMSessionType.kCimSessionTypeGroup {
            y += CGFloat(kLabelNickNameHeight)
        }

        // 这里吃了大亏，搞了很久。
        // 如果不生效，请检查是否设置了约束
        labelMessage.frame = CGRect(x: leftLabel, y: y, width: size.width, height: h)
        labelMessage.backgroundColor = IMUIResource.chatTextMineColor
    }

    // 别人发的消息
    func layoutOtherSubviews() {
        // 转换文本
        var test = model!.msgData
        if model!.msgType == .kCimMsgTypeRobot {
            test = IMMsgParser.resolveRobotMsg(msgType: model!.msgType, msgData: model!.msgData)
        }

        let size = IMMessageTextCell.getTextSize(text: test)
        let w = size.width
        // 限制文本最小高度
        let h = size.height > CGFloat(kMinTextHeight) ? size.height : CGFloat(kMinTextHeight)

        // 文本的y坐标
        var y = CGFloat(kTextMarginTop)
        if model?.sessionType == CIM_Def_CIMSessionType.kCimSessionTypeGroup {
            y += CGFloat(kLabelNickNameHeight)
        }

        labelMessage.frame = CGRect(x: CGFloat(kTextMarginLeft), y: y, width: w, height: h)
        labelMessage.backgroundColor = IMUIResource.chatTextPeerColor

        // 头像默认即可，在xib里面有初始位置
        imageHead.frame.origin.x = CGFloat(kImageMarginLeft)
        labelNickName.textAlignment = .left
        
        // 昵称的左边距 = 头像左边距 + 头像宽度 + 昵称左边距
        labelNickName.frame.origin.x = CGFloat(kImageMarginLeft) + CGFloat(kImageWidth) + CGFloat(kTextImageMarginLet)
    }
}
