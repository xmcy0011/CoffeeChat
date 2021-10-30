//
//  LoginViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/10.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Alamofire
import UIKit

typealias LoginResult = (_ code: Int, _ desc: String) -> Void

class LoginViewController: UIViewController, IMLoginManagerDelegate, UITextFieldDelegate {
    @IBOutlet var id: UITextField!
    @IBOutlet var token: UITextField!
    @IBOutlet var server: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var backBtn: BEButton!

    var loginResultCallback: LoginResult?

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = IMManager.singleton.loginManager.register(key: "LoginViewController", delegate: self)

        id.delegate = self
        token.delegate = self
        server.delegate = self

        backBtn.setEnlargeEdge(20)
        btnLogin.layer.cornerRadius = 4

        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        // 使用Alamofire发送HTTP请求
//        let req = Login(userName: "10091009", pwd: "12345")
//        AF.request("www.baidu.com", method: .post, parameters: req, encoder: JSONParameterEncoder.default).response { res in
//            debugPrint(res)
//        }
    }

    deinit {
        _ = IMManager.singleton.loginManager.unregister(key: "LoginViewController")
    }

    // 点击空白处，隐藏键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        id.resignFirstResponder()
        token.resignFirstResponder()
        server.resignFirstResponder()
    }

    @IBAction func onBackBtnDown(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onLoginBtnClick(_ sender: Any) {
        if check() {
            _ = IMManager.singleton.loginManager.login(userName: id.text!, userPwd: token.text!, serverIp: server.text!, port: 8000) { rsp in
                // 线程安全
                DispatchQueue.main.async {
                    if rsp.resultCode != .kCimErrSuccess {
                        let alert = UIAlertController(title: "提醒", message: "登录失败:\(rsp.resultString)", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "提醒", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if self.loginResultCallback != nil {
                            self.loginResultCallback!(rsp.resultCode.rawValue, rsp.resultString)
                        }
                        // self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        // _ = client.connect(ip: "10.0.106.117", port: 8000)
    }

    func check() -> Bool {
        var text = ""
        if id.text?.isEmpty ?? true {
            text = "请输入ID"
        } else if token.text?.isEmpty ?? true {
            text = "请输入Token"
        } else if server.text?.isEmpty ?? true {
            text = "请输入服务器IP"
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

    func onLogin(step: IMLoginStep) {
        DispatchQueue.main.async {
            switch step {
            case .Linking:
                self.btnLogin.setTitle("连接中...", for: .normal)
            case .LinkOK:
                self.btnLogin.setTitle("已连接", for: .normal)
            case .Logining:
                self.btnLogin.setTitle("认证中...", for: .normal)
            case .LoginOK:
                self.btnLogin.setTitle("登录成功", for: .normal)
            case .LoseConnection:
                let alert = UIAlertController(title: "提醒", message: "登录失败:服务器无响应", preferredStyle: .alert)
                let ok = UIAlertAction(title: "提醒", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                self.btnLogin.setTitle("确定", for: .normal)
            default:
                self.btnLogin.setTitle("确定", for: .normal)
            }
        }
    }

    func onAutoLoginFailed(code: Error) {}
}

// MARK: UITextFieldDelegate

extension LoginViewController {
    // 点击返回，隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view?.endEditing(false)
        return true
    }
}
