//
//  IMSettingViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/4/15.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
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
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tabView.estimatedRowHeight
    }
    
    // 点击某一个
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
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
