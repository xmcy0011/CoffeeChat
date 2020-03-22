//
//  LoginViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/10.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Alamofire
import UIKit

// 请定义请求参数
struct Login: Encodable {
    let userName: String
    let pwd: String
}

class LoginViewController: UIViewController, IMLoginManagerDelegate {
    @IBOutlet var id: UITextField!
    @IBOutlet var token: UITextField!
    @IBOutlet var nick: UITextField!
    @IBOutlet var server: UITextField!
    @IBOutlet var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = IMManager.singleton.loginManager.register(key: "LoginViewController", delegate: self)

        // Do any additional setup after loading the view.
        // 使用Alamofire发送HTTP请求
//        let req = Login(userName: "10091009", pwd: "12345")
//        AF.request("www.baidu.com", method: .post, parameters: req, encoder: JSONParameterEncoder.default).response { res in
//            debugPrint(res)
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        _ = IMManager.singleton.loginManager.unregister(key: "LoginViewController")
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    @IBAction func onLoginBtnClick(_ sender: Any) {
        if check() {
            let userId = UInt64(id.text!)
            if userId == nil {
                return
            }
            _ = IMManager.singleton.loginManager.login(userId: userId!, nick: nick.text!, userToken: token.text!, serverIp: server.text!, port: 8000) { rsp in
                // 线程安全
                DispatchQueue.main.async {
                    if rsp.resultCode != .kCimErrSuccsse {
                        let alert = UIAlertController(title: "提醒", message: "登录失败:\(rsp.resultString)", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "提醒", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {}
                }
            }
        }
        // _ = client.connect(ip: "10.0.106.117", port: 8000)
    }

    @IBAction func onCancelBtnClick(_ sender: Any) {
        // client.close()
        dismiss(animated: true, completion: nil)
    }

    func check() -> Bool {
        var text = ""
        if id.text?.isEmpty ?? true {
            text = "请输入ID"
        } else if token.text?.isEmpty ?? true {
            text = "请输入Token"
        } else if nick.text?.isEmpty ?? true {
            text = "请输入昵称"
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
            default:
                self.btnLogin.setTitle("登录", for: .normal)
            }
        }
    }

    func onAutoLoginFailed(code: Error) {}
}
