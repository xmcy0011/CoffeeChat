//
//  IMFriendViewCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/30.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

class IMFriendViewCell: UITableViewCell {
    @IBOutlet var nickname: UILabel!
    @IBOutlet weak var header: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setContent(user: CIM_Def_CIMUserInfo) {
        // 头像
        header.image = IMAssets.Chat_icon_avatar.image
        nickname.text = "\(user.nickName)（\(user.userID)）"
    }
}
