//
//  IMChatViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/25.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

/// 会话列表
class IMChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IMConversationManagerDelegate {
    @IBOutlet var sessionTabView: UITableView!
    var list: [SessionModel] = []
    var actionFloat: IMActionFloatView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "消息"

        // 在顶部右侧添加按钮（加群、扫一扫、加朋友等）
        navigationItem.rightButtonAction(IMAssets.Chat_add.image) { () -> Void in
            self.actionFloat.hide(!self.actionFloat.isHidden)
        }

        // Init ActionFloatView
        actionFloat = IMActionFloatView()
        actionFloat.delegate = self
        view.addSubview(actionFloat)
        actionFloat.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 85, left: 0, bottom: 0, right: 0))
        }

        // 注册自定义的Cell的实际类型
        sessionTabView.register(UINib(nibName: "IMChatViewCell", bundle: nil), forCellReuseIdentifier: "IMChatViewCell")
        sessionTabView.estimatedRowHeight = 65
        sessionTabView.tableFooterView = UIView() // 设置之后可以去除空行单元格之间的空白线
        sessionTabView.dataSource = self
        sessionTabView.delegate = self

        // 顶部菊花
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 注册委托
        IMManager.singleton.conversationManager.register(key: "IMChatViewController", delegate: self)
        // 查询会话列表
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

    deinit {
        IMManager.singleton.conversationManager.unregister(key: "IMChatViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionTabView.reloadData()
    }
}

// MARK: IMConversationManagerDelegate - 会话委托回调

extension IMChatViewController {
    func didLoadAllRecentSession() {}

    func didUpdateRecentSession(session: IMRecentSession, totalUnreadCount: Int32) {
        IMLog.info(item: "didUpdateRecentSession sessionId:\(session.session.sessionId),total:\(totalUnreadCount),sessionUnread:\(session.unreadCnt)")

        var isFind = false
        // 更新最后一条会话信息
        for i in 0..<list.count {
            if list[i].rectSession.session.sessionId == session.session.sessionId {
                IMLog.debug(item: "didUpdateRecentSession find sessionId:\(session.session.sessionId),update unreadCount")
                list[i].rectSession.latestMsg = session.latestMsg
                list[i].rectSession.unreadCnt = session.unreadCnt
                list[i].rectSession.updatedTime = session.updatedTime
                DispatchQueue.main.async {
                    self.sessionTabView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
                }
                isFind = true
                break
            }
        }

        // 新的会话，插入
        if !isFind {
            let model = SessionModel(recentSession: session)
            list.insert(model, at: 0)
            sessionTabView.reloadData()
        }
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
        sessionTabView.deselectRow(at: indexPath, animated: true)

        let sessionInfo = list[indexPath.row]
        let chatContentView = IMChatContentViewController(session: sessionInfo)
        // 隐藏UITabBarController下面的按钮（好奇怪的写法，怎么不是在self上呢？）
        chatContentView.hidesBottomBarWhenPushed = true
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

// MARK: - @protocol ActionFloatViewDelegate

extension IMChatViewController: ActionFloatViewDelegate {
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        IMLog.info(item: "floatViewTapItemIndex:\(type)")
        switch type {
        case .groupChat:
            let view = IMCreateGroupViewController()
            // 隐藏UITabBarController下面的按钮（好奇怪的写法，怎么不是在self上呢？）
            view.hidesBottomBarWhenPushed = true
            // 跳转聊天页面
            navigationController?.pushViewController(view, animated: true)
            break
        case .addFriend:
            break
        case .scan:
            break
        case .payment:
            break
        }
    }
}
