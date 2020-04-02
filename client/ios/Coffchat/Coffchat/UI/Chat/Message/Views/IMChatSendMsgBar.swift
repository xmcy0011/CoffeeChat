//
//  IMChatSendMsgBar.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/2.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

/// 消息输入框的委托
protocol IMChatSendMsgBarDelegate {
    // 发送消息
    func onSendMsg(_ text: String)
}

/// 消息输入框
class IMChatSendMsgBar: UIView {
    @IBOutlet var textInput: UITextView! { didSet {
        textInput.layer.cornerRadius = 4
        textInput.backgroundColor = UIColor(red: 0xFE / 255, green: 1, blue: 1, alpha: 1)
        } }
    @IBOutlet var sendButton: UIButton! { didSet {
        sendButton.layer.cornerRadius = 4
        } }

    var delegate: IMChatSendMsgBarDelegate?

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */

    @IBAction func onSendButtonDown(_ sender: Any) {
        delegate?.onSendMsg(textInput.text)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override class func awakeFromNib() {}
}
