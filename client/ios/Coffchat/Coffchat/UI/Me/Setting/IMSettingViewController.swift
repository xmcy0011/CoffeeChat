//
//  IMSettingViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/4/15.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

// 设置界面
class IMSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    fileprivate var itemSource: [[String]] = [["新消息通知", "通用", "账号与安全"], ["登录"]]
    @IBOutlet var tabView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.estimatedRowHeight = 45
        tabView.dataSource = self
        tabView.delegate = self
        tabView.tableFooterView = UIView() // 去横线
        tabView.backgroundColor = UIColor(red: 0xf5 / 255, green: 0xf6 / 255, blue: 0xf7 / 255, alpha: 1)
        tabView.register(UINib(nibName: "IMLoginoutTableViewCell", bundle: nil), forCellReuseIdentifier: "IMLoginoutTableViewCell")
    }
    
    // 登出
    func onLogout(_act: UIAlertAction) {
        // self.navigationController?.popViewController(animated: false)
        // self.navigationController?.popToRootViewController(animated: false)
        // self.navigationController?.pushViewController(ViewController(), animated: false)
        
        // 把所有的释放
        self.navigationController?.popToRootViewController(animated: false)
        // 重新构建
        let view = ViewController()
        let nav = UINavigationController(rootViewController: view)
        self.view.window?.rootViewController = nav
    
        // 各种回调注销
        IMManager.singleton.conversationManager.unregisterAll()
        IMManager.singleton.chatManager.unregisterAll()
        
        _ = IMManager.singleton.loginManager.logout(callback: nil)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tabView.estimatedRowHeight
    }
    
    // 点击某一个
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, indexPath.row == 0 { // 登出
            // actionSheet会报错："<NSLayoutConstraint:0x600003fdf340 UIView:0x7f9ed0d41ae0.width == - 16   (active)>
            let alertController = UIAlertController(title: "提示", message: "确定退出吗？", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "确定", style: .destructive, handler: onLogout)
            let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(noAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSource[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "IMLoginoutTableViewCell")
            if cell == nil {
                cell = IMLoginoutTableViewCell()
            }
            return cell!
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
            cell?.textLabel?.text = itemSource[indexPath.section][indexPath.row]
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
}
