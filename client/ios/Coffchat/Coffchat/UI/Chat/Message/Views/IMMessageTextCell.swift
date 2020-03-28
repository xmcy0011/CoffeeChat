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
    @IBOutlet weak var labelMessage: UILabel!
    
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
}
