//
//  IMConversationMemberViewCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/11/8.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

class IMConversationMemberViewCell: UICollectionViewCell {
    @IBOutlet var headerImg: UIImageView!
    @IBOutlet var labNickName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setContent(info: CIM_Def_CIMUserInfo) {
        headerImg.image = IMAssets.Chat_icon_avatar.image
        labNickName.text = info.nickName
    }
}
