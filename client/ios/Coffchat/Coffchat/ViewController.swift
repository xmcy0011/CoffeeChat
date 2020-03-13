//
//  ViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/7.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

//        let imageView = UIImageView()
//        let image = UIImage(named: "lanuch")
//        imageView.image = image
//
//        self.view.addSubview(imageView)
    }

    @IBAction func onLoginBtnClick(_ sender: Any) {
        let loginView = LoginViewController()
        self.present(loginView, animated: true, completion: nil)
    }
}
