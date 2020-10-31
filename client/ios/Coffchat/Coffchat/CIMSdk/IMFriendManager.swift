//
//  IMFriend.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/30.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

// 好友管理
class IMFriendManager {
    fileprivate var client: IMClient
    
    fileprivate var queryCallback: IMResultCallback<CIM_Friend_CIMFriendQueryUserListRsp>?
    
    init() {
        client = DefaultIMClient
        client.register(key: "IMFriendManager", delegateData: self)
    }
    
    func queryUserList(callback: IMResultCallback<CIM_Friend_CIMFriendQueryUserListRsp>?, timeout: IMResponseTimeoutCallback?) {
        queryCallback = callback
        
        var req = CIM_Friend_CIMFriendQueryUserListReq()
        req.userID = IMManager.singleton.userId!
        
        client.sendRequest(cmdId: .kCimCidFriendQueryUserListReq, body: try! req.serializedData(), timeout: timeout)
    }
}

// MARK: IMClientDelegateData

extension IMFriendManager: IMClientDelegateData {
    // 处理数据
    func onHandleData(_ header: IMHeader, _ data: Data) -> Bool {
        if header.commandId == CIM_Def_CIMCmdID.kCimCidFriendQueryUserListRsp.rawValue {
            _onHandleQueryUserListRsp(data: data)
            return true
        }
        return false
    }
    
    func _onHandleQueryUserListRsp(data: Data) {
        var rsp: CIM_Friend_CIMFriendQueryUserListRsp?
        do {
            rsp = try CIM_Friend_CIMFriendQueryUserListRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleQueryUserListRsp listLen:\(rsp!.userInfoList.count)")
        
        if queryCallback != nil {
            queryCallback!(rsp!)
        }
    }
}
