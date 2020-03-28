//
//  IMChatViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/25.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

/// 会话列表
class IMChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var sessionTabView: UITableView!
    var list: [SessionModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CoffeeChat"

        // 注册自定义的Cell的实际类型
        sessionTabView.register(UINib(nibName: "IMChatViewCell", bundle: nil), forCellReuseIdentifier: "IMChatViewCell")
        sessionTabView.estimatedRowHeight = 65

        sessionTabView.dataSource = self
        sessionTabView.delegate = self

        // Do any additional setup after loading the view.
        IMManager.singleton.conversationManager.queryAllRecentSessions(callback: { rsp in
            for item in rsp.contactSessionList {
                let session = IMSession(id: item.sessionID, type: item.sessionType)

                let msgDataText = String(data: item.msgData, encoding: String.Encoding.utf8)

                let message = IMMessage(clientId: item.msgID, sessionType: item.sessionType, fromId: item.msgFromUserID, toId: item.sessionID, time: item.msgTimeStamp, msgType: item.msgType, data: msgDataText!)
                let recentSession = IMRecentSession(sessionInfo: session, latestMsg: message, unreadCount: item.unreadCnt, updateTime: item.updatedTime)
                let sessionModel = SessionModel(recentSession: recentSession)
                self.list.append(sessionModel)
            }

            // 加载数据，渲染列表
            DispatchQueue.main.async {
                self.sessionTabView.reloadData()
            }
        }, timeout: {
            print("查询会话超时")
        })
    }
}

// MARK: UITableViewDelegate

extension IMChatViewController {
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 自动计算行高，需要先设置estimatedRowHeight 或者 写死 return 65.0
        return sessionTabView.estimatedRowHeight
    }

    // 选中一行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sessionInfo = list[indexPath.row]
        let chatContentView = IMChatContentViewController(session: sessionInfo)
        // 跳转聊天页面
        navigationController?.pushViewController(chatContentView, animated: true)
    }
}

// MARK: UITableViewDataSource

extension IMChatViewController {
    // 返回数据源有多少行，便于渲染
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    // 返回一个TabViewCell实例，TabViewCell就是一行数据，真正用来显示的
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellId是类名
        let classType = IMChatViewCell.self
        let cellId = String(describing: classType)

        // 获取一个可重复使用的Cell，没有就收到创建
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IMChatViewCell
        if cell == nil {
            cell = IMChatViewCell(style: .default, reuseIdentifier: cellId)
        }

        // 渲染一行
        cell!.setContent(sessionModel: list[indexPath.row])
        return cell!
    }
}
