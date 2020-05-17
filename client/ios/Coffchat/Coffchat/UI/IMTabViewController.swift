//
//  MainTabViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/23.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

class IMTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let me = IMMeViewController()
        let social = IMSocialViewController()
        let friend = IMFriendViewController()
        let message = IMChatViewController()

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

        let navigation1 = UINavigationController(rootViewController: message)
        let navigation2 = UINavigationController(rootViewController: friend)
        let navigation3 = UINavigationController(rootViewController: social)
        let navigation4 = UINavigationController(rootViewController: me)
        
        // 添加需要显示的view，按照先后顺序依次显示在底部
        self.viewControllers = [navigation1, navigation2, navigation3, navigation4]
    }
}
