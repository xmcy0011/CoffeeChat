//
//  ImageTextTableViewCell.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/14.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

class ImageTextTableViewCell: UITableViewCell {
    @IBOutlet var headImage: UIImageView!
    @IBOutlet var headTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // 显示右侧可点击箭头
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setContent(title: String, image: UIImage?) {
        headImage.image = image
        headTitle.text = title
    }
}
