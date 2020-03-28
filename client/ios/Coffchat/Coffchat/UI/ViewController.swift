//
//  ViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/23.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let loginView = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        self.navigationItem.title = "欢迎主人回来"
        // self.navigationController?.title = "欢迎主人回来"
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func loginPress(_ sender: Any) {
        self.loginView.loginResultCallback = loginCallback
        
        // 界面跳转
        self.navigationController?.pushViewController(self.loginView, animated: true)
        // 模态弹窗
        // self.present(loginView, animated: true, completion: nil)
    }
    
    // 登录结果
    func onLogin(step: IMLoginStep) {}
    
    func loginCallback(code: Int, desc: String) {
        // 如果登录成功，跳转到主页面
        if IMManager.singleton.loginManager.isLogin {
            // 隐藏导航栏
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.navigationBar.isHidden = true
            
            let home = IMTabViewController()
            self.navigationController?.popViewController(animated: false) // 移除登录界面
            self.navigationController?.pushViewController(home, animated: true) // 主界面
            //self.navigationController?.popToViewController(loginView, animated: false) // 移除其他界面，直到该界面为止
        }
    }
}
