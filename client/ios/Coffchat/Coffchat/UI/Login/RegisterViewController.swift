//
//  RegisterViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2021/1/14.
//  Copyright © 2021 Coffeechat Inc. All rights reserved.
//

import UIKit

typealias RegisterResult = (_ code: Int, _ desc: String) -> Void

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var tfUserPwd: UITextField!
    @IBOutlet var tfUserName: UITextField!
    @IBOutlet var tfNickName: UITextField!
    @IBOutlet var backBtn: BEButton!
    @IBOutlet weak var tfServerIp: UITextField!
    
    var registerCall: RegisterResult?

    override func viewDidLoad() {
        super.viewDidLoad()

        tfUserName.delegate = self
        tfUserPwd.delegate = self
        tfNickName.delegate = self

        backBtn.setEnlargeEdge(20)
    }

    @IBAction func registerPress(_ sender: Any) {
        if !check() {
            return
        }
        
        // http服务地址
        IMManager.singleton.userManager.setHttpHost(addr: tfServerIp.text!)
        
        // 注册用户
        IMManager.singleton.userManager.registerUser(userName: tfUserName.text!, userPwd: tfUserPwd.text!, userNickName: tfNickName.text!) { result in

            IMLog.info(item: "code=\(result.errorCode),msg=\(result.errorMsg)")

            DispatchQueue.main.async {
                if result.errorCode == CIM_Def_CIMErrorCode.kCimErrSuccess.rawValue {
                    let alert = UIAlertController(title: "提醒", message: "注册成功，点击跳转登录界面", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "确定", style: .cancel, handler: { _ in
                        // pop myself, then go to login
                        self.navigationController?.popViewController(animated: false)
                        if self.registerCall != nil {
                            self.registerCall!(result.errorCode, result.errorMsg)
                        }
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "提醒", message: "注册失败:\(result.errorMsg)", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func onBackBtnDown(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func check() -> Bool {
        var text = ""
        if tfUserName.text?.isEmpty ?? true {
            text = "请输入用户名"
        } else if tfUserName.text!.count < 6 || tfUserName.text!.count > 32 {
            text = "用户名为6-32位字符"
        } else if tfUserPwd.text?.isEmpty ?? true {
            text = "请输入密码"
        } else if tfUserPwd.text!.count < 6 || tfUserPwd.text!.count > 32 {
            text = "密码为6-32字符"
        } else if tfNickName.text?.isEmpty ?? true {
            text = "请输入昵称"
        }

        if text != "" {
            let alert = UIAlertController(title: "提醒", message: text, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return false
        }

        return true
    }

    // 点击空白处，隐藏键盘
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        tfUserName.resignFirstResponder()
        tfUserPwd.resignFirstResponder()
        tfNickName.resignFirstResponder()
    }
}

// MARK: UITextFieldDelegate

extension RegisterViewController {
    // 点击返回，隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view?.endEditing(false)
        return true
    }
}
