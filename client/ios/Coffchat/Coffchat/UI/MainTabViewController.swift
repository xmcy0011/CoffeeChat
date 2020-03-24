//
//  MainTabViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/23.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏返回按钮
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let me = IMMeViewController()
        let social = IMSocialViewController()
        let friend = IMFriendViewController()
        let message = IMMessageViewController()

        // 如果不设置，也可以工作，但是标签栏没有任何显示
        message.tabBarItem.title = "消息"
        message.tabBarItem.image = UIImage(named: "message")
        message.tabBarItem.selectedImage = UIImage(named: "message_h")
        
        friend.tabBarItem.title = "好友"
        friend.tabBarItem.image = UIImage(named: "me")
        friend.tabBarItem.selectedImage = UIImage(named: "me_h")
        
        social.tabBarItem.title = "社区"
        social.tabBarItem.image = UIImage(named: "social")
        social.tabBarItem.selectedImage = UIImage(named: "social_h")
        
        me.tabBarItem.title = "我"
        me.tabBarItem.image = UIImage(named: "home")
        me.tabBarItem.selectedImage = UIImage(named: "home_h")
        
        // 添加需要显示的view，按照先后顺序依次显示在底部
        self.viewControllers = [message, friend, social, me]
    }
}
