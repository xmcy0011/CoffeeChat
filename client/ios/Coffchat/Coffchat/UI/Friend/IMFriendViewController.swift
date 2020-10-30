//
//  IMFriendViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/24.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

class FriendUserModel {
    var userInfo: CIM_Def_CIMUserInfo!
    var nameFirstCharacter: Character! // 昵称首字母

    init(user: CIM_Def_CIMUserInfo) {
        userInfo = user

        // 汉字转成拼音
        let str = NSMutableString(string: user.nickName) as CFMutableString
        CFStringTransform(str, nil, kCFStringTransformToLatin, false)

        // 拼音去掉拼音的音标
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)

        // 大写字母
        var s: String = String(str)
        s = s.capitalized // 大写首字母
        nameFirstCharacter = s[s.startIndex]
    }
}

class IMFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var userTabview: UITableView!

    var userList: [FriendUserModel] = []
    var group: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "用户"

        // 注册自定义的Cell的实际类型
        userTabview.register(UINib(nibName: "IMFriendViewCell", bundle: nil), forCellReuseIdentifier: "IMFriendViewCell")
        userTabview.estimatedRowHeight = 65
        userTabview.tableFooterView = UIView() // 设置之后可以去除空行单元格之间的空白线
        userTabview.dataSource = self
        userTabview.delegate = self

        IMManager.singleton.friendManager.queryUserList(callback: { rsp in
            // 加载用户列表
            for item in rsp.userInfoList {
                let model = FriendUserModel(user: item)
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
                self.userTabview.reloadData()
            }
        }) {
            IMLog.warn(item: "IMFriendViewController queryUserList timeout!")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        userTabview.reloadData()
    }
}

// MARK: UITableViewDelegate

extension IMFriendViewController {
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 自动计算行高，需要先设置estimatedRowHeight 或者 写死 return 65.0
        return userTabview.estimatedRowHeight
    }

    // 选中一行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消选择
        userTabview.deselectRow(at: indexPath, animated: true)

        // let user = userList[indexPath.row]
        // let chatContentView = IMChatContentViewController(session: sessionInfo)
    }
}

// MARK: UITableViewDataSource

extension IMFriendViewController {
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
        let classType = IMFriendViewCell.self
        let cellId = String(describing: classType)

        // 找到当前组要显示的用户
        let showUsers: [FriendUserModel] = userList.filter { (emp) -> Bool in
            emp.nameFirstCharacter == group[indexPath.section]
        }

        // 获取一个可重复使用的Cell，没有就收到创建
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IMFriendViewCell
        if cell == nil {
            cell = IMFriendViewCell(style: .default, reuseIdentifier: cellId)
        }

        // 渲染一行
        cell!.setContent(user: showUsers[indexPath.row].userInfo)
        return cell!
    }
}
