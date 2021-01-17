//
//  ViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/23.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let loginView = LoginViewController()
    let registerView = RegisterViewController()
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        // self.navigationItem.title = "欢迎主人回来"
        // self.title = "欢迎主人回来"
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // 设置圆角
        self.loginBtn.layer.cornerRadius = 4
    }
        
    @IBAction func loginPress(_ sender: Any) {
        self.loginView.loginResultCallback = self.loginCallback
        
        // 界面跳转
        self.navigationController?.pushViewController(self.loginView, animated: true)
        // 模态弹窗
        // self.present(loginView, animated: true, completion: nil)
    }
    
    @IBAction func registerPress(_ sender: Any) {
        self.registerView.registerCall = self.registerCallback
        // 跳转注册界面
        self.navigationController?.pushViewController(self.registerView, animated: true)
    }
    
    // 登录进度
    func onLogin(step: IMLoginStep) {}
    
    // 登录成功回调
    func loginCallback(code: Int, desc: String) {
        // 如果登录成功，跳转到主页面
        if IMManager.singleton.loginManager.isLogin {
            // 隐藏导航栏
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.navigationBar.isHidden = true
            
            let home = IMTabViewController()
            // self.navigationController?.popViewController(animated: false) // 移除登录界面
            self.navigationController?.pushViewController(home, animated: true) // 主界面
            // self.navigationController?.popToViewController(loginView, animated: false) // 移除其他界面，直到该界面为止
        }
    }
    
    // 注册成功回调
    func registerCallback(code: Int, desc: String) {
        self.loginPress(0)
    }
}
