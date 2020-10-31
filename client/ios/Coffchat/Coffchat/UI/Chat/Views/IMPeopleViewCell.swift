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
    var nameFirstCharacter: Character! // 昵称首字母

    init(user: CIM_Def_CIMUserInfo) {
        userInfo = user

        // 汉字转成拼音
        let str = NSMutableString(string: user.nickName) as CFMutableString
        CFStringTransform(str, nil, kCFStringTransformToLatin, false)

        // 拼音去掉拼音的音标
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)

        // 大写字母
        var s: String = String(str)
        s = s.capitalized // 大写首字母
        nameFirstCharacter = s[s.startIndex]
    }
}

/// 创建群组中寻找成员的cell
class IMPeopleViewCell: UITableViewCell {
    @IBOutlet var nickname: UILabel!
    @IBOutlet var header: UIImageView!
    @IBOutlet var cb: BEMCheckBox!

    var userModel: PeopleUserModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        cb.onAnimationType = .fade
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

    func on(on: Bool) {
        cb.on = on
        userModel?.check = on
    }

    @IBAction func cbValueChanged(_ sender: Any) {
        userModel?.check = cb.isSelected
    }
}
