//
//  IMChatViewCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/25.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import SwiftyJSON
import UIKit

class IMChatViewCell: UITableViewCell {
    @IBOutlet var headImage: UIImageView!
    @IBOutlet var unreadCnt: UILabel!
    @IBOutlet var nickName: UILabel!
    @IBOutlet var updateDate: UILabel!
    @IBOutlet var latestMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        headImage.layer.masksToBounds = true
        // 没懂，从TSWechat借用过来
        headImage.layer.cornerRadius = headImage.frame.size.width / 2 / 180 * 30
        
        // 会触发离屏渲染，性能受影响 FIXME
        unreadCnt.layer.masksToBounds = true
        unreadCnt.layer.cornerRadius = unreadCnt.frame.size.height / 2
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("not support")
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // cell 被复用
    override func prepareForReuse() {}
    
    func setContent(sessionModel: SessionModel) {
        // 头像
        headImage.image = UIImage(named: "icon_avatar")
        
        // 昵称
        nickName.text = sessionModel.nickName
        
        // 最后一条消息发送时间
        updateDate.text = IMMsgParser.timeFormat(timestamp: sessionModel.rectSession.updatedTime)
        
        // 未读计数
        unreadCnt.text = sessionModel.unreadNumber > 99 ? "99+" : String(sessionModel.unreadNumber)
        unreadCnt.isHidden = sessionModel.unreadNumber == 0
        
        // 最近一条消息
        latestMsg.text = sessionModel.rectSession.latestMsg.msgData
        
        // 最近一条消息
        let msg = sessionModel.rectSession.latestMsg
        if msg.msgType == .kCimMsgTypeRobot {
            latestMsg.text = IMMsgParser.resolveRobotMsg(msgType: msg.msgType, msgData: msg.msgData)
        } else if msg.msgType == .kCimMsgTypeNotifacation {
            latestMsg.text = IMMsgParser.resolveNotificationMsg(msgType: msg.msgType, msgData: msg.msgData)
        } else {
            latestMsg.text = msg.msgData
        }
    }
}
