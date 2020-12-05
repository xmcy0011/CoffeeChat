//
//  IMConversationSettingsViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/11/8.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

let kMemberCellHeight = 70 // 成员高度（包括头像+昵称）
let kMemberCellWidth = 60 // 成员Cell宽度

// 会话详情页面
class IMConversationSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource {
    @IBOutlet var settingTabView: UITableView!
    var collectionView: UICollectionView!

    var session: SessionModel
    var memberList: [CIM_Def_CIMUserInfo] = []
    var settingItemSource: [String] = ["Group Name", "Search Message Content"]

    init(sessionInfo: SessionModel) {
        session = sessionInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 成员列表
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.itemSize = CGSize(width: kMemberCellWidth, height: kMemberCellHeight) // 元素高宽
        let screenWidth = UIScreen.main.bounds.size.width
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(kMemberCellHeight + 10))
        collectionView = UICollectionView(frame: rect, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "IMConversationMemberViewCell", bundle: nil), forCellWithReuseIdentifier: "IMConversationMemberViewCell")

        settingTabView.dataSource = self
        settingTabView.delegate = self
        // 不显示分割线
        settingTabView.separatorStyle = .none
        settingTabView.backgroundColor = IMUIResource.chatBackground
        settingTabView.estimatedRowHeight = 0
        settingTabView.estimatedSectionHeaderHeight = 0
        settingTabView.estimatedSectionFooterHeight = 0
        // 头视图显示UICollectionView
        settingTabView.tableHeaderView = collectionView

        title = "会话详情"

        // 查询群组成员列表
        IMManager.singleton.groupManager.queryGroupMember(groupId: session.rectSession.session.sessionId, callback: { rsp in
            for id in rsp.memberIDList {
                var userInfo = CIM_Def_CIMUserInfo()
                userInfo.userID = id
                userInfo.nickName = String(id)
                self.memberList.append(userInfo)
            }

            self.collectionView.reloadData()
        }) {
            IMLog.warn(item: "query group member time out")
        }
    }
}

// MARK: UITableViewDelegate

extension IMConversationSettingsViewController {
    // 取消选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension IMConversationSettingsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItemSource.count
    }

    // 距离header的间距
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }

    // 元素高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(35)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell()
        }

        cell?.textLabel?.text = settingItemSource[indexPath.row]
        return cell!
    }
}

// MARK: UICollectionViewDataSource

extension IMConversationSettingsViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IMConversationMemberViewCell", for: indexPath) as? IMConversationMemberViewCell
        if cell == nil {
            cell = IMConversationMemberViewCell()
        }
        cell!.backgroundColor = .none
        cell!.layer.cornerRadius = 5
        cell!.layer.masksToBounds = true
        cell!.setContent(info: memberList[indexPath.row])
        return cell!
    }
}
