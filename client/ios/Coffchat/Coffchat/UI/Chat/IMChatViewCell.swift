//
//  IMChatViewCell.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/25.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

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
    }
}
