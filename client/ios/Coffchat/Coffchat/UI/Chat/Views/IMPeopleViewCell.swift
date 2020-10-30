//
//  IMPeopleTableViewCell.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/30.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import BEMCheckBox
import UIKit

class PeopleUserModel {
    var check: Bool?
    var userInfo: CIM_Def_CIMUserInfo

    init(user: CIM_Def_CIMUserInfo) {
        userInfo = user
    }
}

class IMPeopleViewCell: UITableViewCell {
    @IBOutlet var nickname: UILabel!
    @IBOutlet weak var header: UIImageView!
    @IBOutlet weak var cb: BEMCheckBox!
    
    var userModel: PeopleUserModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setContent(user: PeopleUserModel) {
        // 头像
        header.image = IMAssets.Chat_icon_avatar.image
        nickname.text = "\(user.userInfo.nickName)（\(user.userInfo.userID)）"

        userModel = user

        // 头像
        // headImage.image = UIImage(named: "icon_avatar")
    }

    @IBAction func cbValueChanged(_ sender: Any) {
        userModel?.check = cb.isSelected
    }
}
