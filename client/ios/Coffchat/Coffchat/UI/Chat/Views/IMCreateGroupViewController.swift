//
//  IMCreateGroupViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/30.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

/// 创建群组控制器
class IMCreateGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var userTabView: UITableView!
    var userList: [PeopleUserModel] = []
    var group: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "选择联系人"
        
        // 注册自定义的Cell的实际类型
        userTabView.register(UINib(nibName: "IMPeopleViewCell", bundle: nil), forCellReuseIdentifier: "IMPeopleViewCell")
        userTabView.estimatedRowHeight = 65
        userTabView.tableFooterView = UIView() // 设置之后可以去除空行单元格之间的空白线
        userTabView.dataSource = self
        userTabView.delegate = self
        
        // Do any additional setup after loading the view.
        // 左上角取消按钮
        let cancel = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(titleBarButtonItemMethod))
        navigationItem.leftBarButtonItem = cancel
        
        IMManager.singleton.friendManager.queryUserList(callback: { rsp in
            // 加载用户列表
            for item in rsp.userInfoList {
                let model = PeopleUserModel(user: item)
                self.userList.append(model)
            }

            // 计算首字母分组
            for item in self.userList {
                // 去重判断
                if self.group.firstIndex(of: item.nameFirstCharacter) == nil {
                    self.group.append(item.nameFirstCharacter)
                }
            }

            // 排序
            self.group = self.group.sorted(by: { (caracter0, character1) -> Bool in
                caracter0 < character1
            })

            // 刷新tabview
            DispatchQueue.main.async {
                self.userTabView.reloadData()
            }
        }) {
            IMLog.warn(item: "IMCreateGroupViewController queryUserList timeout!")
        }
    }

    @objc
    func titleBarButtonItemMethod() {}

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

// MARK: UITableViewDelegate

extension IMCreateGroupViewController {
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 自动计算行高，需要先设置estimatedRowHeight 或者 写死 return 65.0
        return userTabView.estimatedRowHeight
    }

    // 选中一行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消选择
        userTabView.deselectRow(at: indexPath, animated: true)

        // let user = userList[indexPath.row]
        // let chatContentView = IMChatContentViewController(session: sessionInfo)
    }
}

// MARK: UITableViewDataSource

extension IMCreateGroupViewController {
    // 分组
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return group.count
//    }

    // 有几组？
    func numberOfSections(in tableView: UITableView) -> Int {
        return group.count
    }

    // 每组多少人
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.filter { (emp) -> Bool in emp.nameFirstCharacter == group[section] }.count
    }

    // 组名
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if group.count > 0 {
            return String(group[section])
        }
        return nil
    }

    // 如果不需要分组，直接返回列表的大小
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return userList.count
//    }

    // 返回一个TabViewCell实例，TabViewCell就是一行数据，真正用来显示的
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellId是类名
        let classType = IMPeopleViewCell.self
        let cellId = String(describing: classType)

        // 找到当前组要显示的用户
        let showUsers: [PeopleUserModel] = userList.filter { (emp) -> Bool in
            emp.nameFirstCharacter == group[indexPath.section]
        }

        // 获取一个可重复使用的Cell，没有就收到创建
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IMPeopleViewCell
        if cell == nil {
            cell = IMPeopleViewCell(style: .default, reuseIdentifier: cellId)
        }

        // 渲染一行
        cell!.setContent(user: showUsers[indexPath.row])
        return cell!
    }
}
