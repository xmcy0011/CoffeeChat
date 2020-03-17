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

class LoginViewController: UIViewController {
    var client = IMClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // 使用Alamofire发送HTTP请求
//        let req = Login(userName: "10091009", pwd: "12345")
//        AF.request("www.baidu.com", method: .post, parameters: req, encoder: JSONParameterEncoder.default).response { res in
//            debugPrint(res)
//        }
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
        client.connect(ip: "10.0.106.117", port: 8000, callback: nil)
    }
    
    @IBAction func onCancelBtnClick(_ sender: Any) {
        //client.close()
        self.dismiss(animated: true, completion: nil)
    }
}
