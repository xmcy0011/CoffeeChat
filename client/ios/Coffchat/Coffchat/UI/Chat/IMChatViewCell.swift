//
//  IMChatViewCell.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/25.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
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
        
        let seconds = Double(sessionModel.rectSession.updatedTime)
        let timeInterval: TimeInterval = TimeInterval(seconds)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let formmat1 = DateFormatter()
        formmat1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let string = formmat1.string(from: date)
        // 最后一条消息发送时间
        updateDate.text = string
        
        // 未读计数
        unreadCnt.text = sessionModel.unreadNumber > 99 ? "99+" : String(sessionModel.unreadNumber)
        unreadCnt.isHidden = sessionModel.unreadNumber == 0
        
        // 最近一条消息
        latestMsg.text = sessionModel.rectSession.latestMsg.msgData
        
        // 最近一条消息
        let msg = sessionModel.rectSession.latestMsg
        if msg.msgType == .kCimMsgTypeRobot {
            let dataFromString = msg.msgData.data(using: .utf8)
            do {
                let json = try JSON(data: dataFromString!)
                let type = json["content"]["type"].string
                if type == "text" {
                    latestMsg.text = json["content"]["content"].string
                } else {
                    IMLog.error(item: "unknown type:\(String(describing: type))")
                }
            } catch {
                IMLog.error(item: "parse json error:\(error)")
            }
        } else {
            latestMsg.text = msg.msgData
        }
    }
}
