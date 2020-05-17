//
//  IMChatSendMsgBar.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/2.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

/// 消息输入框的委托
protocol IMChatSendMsgBarDelegate {
    // 发送消息
    func onSendMsg(_ text: String)
}

/// 消息输入框
class IMChatSendMsgBar: UIView,UITextViewDelegate {
    @IBOutlet var textInput: UITextView! { didSet {
        textInput.layer.cornerRadius = 4
        textInput.backgroundColor = UIColor(red: 0xFE / 255, green: 1, blue: 1, alpha: 1)
        textInput.delegate = self
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

// MARK: UITextViewDelegate

extension IMChatSendMsgBar{
    // 文本改变回调
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 如果输入了\n 即 return键，则隐藏键盘
        if text == "\n"{
            // 放弃第一响应者身份，键盘隐藏
            textInput.resignFirstResponder()
            return false
        }
        return true
    }
}
