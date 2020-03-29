//
//  IMChatContentViewController.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/28.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import UIKit

/// 聊天页面
class IMChatContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var msgTabView: UITableView!

    /// 会话信息
    var session: SessionModel
    var msgList: [IMMessage] = []

    init(session: SessionModel) {
        self.session = session

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        msgTabView.delegate = self
        msgTabView.dataSource = self

        // 注册自定义Cell
        msgTabView.register(UINib(nibName: "IMMessageTextCell", bundle: nil), forCellReuseIdentifier: "IMMessageTextCell")
        // 不显示分割线
        msgTabView.separatorStyle = .none

        queryMsgList()
    }

    func queryMsgList() {
        let sId = session.rectSession.session.sessionId
        let sType = session.rectSession.session.sessionType
        var endMsgId = session.rectSession.latestMsg.serverMsgId
        let limitCount = 20

        if endMsgId == nil {
            endMsgId = 0
        }

        // 查询历史消息
        IMManager.singleton.conversationManager.queryMsgList(sessionId: sId, sessionType: sType, endMsgId: endMsgId!, limitCount: limitCount, callback: { rsp in
            //print("success query msg list\(rsp)")
            for item in rsp.msgList {
                let msg = IMMessage(clientId: item.clientMsgID, sessionType: item.sessionType, fromId: item.fromUserID, toId: item.toSessionID, time: item.createTime, msgType: item.msgType, data: String(data: item.msgData, encoding: .utf8)!)
                msg.serverMsgId = item.serverMsgID
                msg.msgResCode = item.msgResCode
                msg.msgFeature = item.msgFeature
                msg.senderClientType = item.senderClientType
                msg.attach = item.attach
                msg.msgStatus = item.msgStatus
                self.msgList.append(msg)
            }

            DispatchQueue.main.async {
                self.msgTabView.reloadData()
            }
        }, timeout: {
            print("timeout")
        })
    }
}

// MARK: UITableViewDataSource

extension IMChatContentViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = msgList[indexPath.row]
        let cellId = String(describing: IMMessageTextCell.self)

//        switch msg.msgType {
//        case .kCimMsgTypeText:
//
//        default:
//            print("unknown msg type")
//        }

        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IMMessageTextCell
        if cell == nil {
            cell = IMMessageTextCell()
        }
        cell!.setContent(message: msg)
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
}
