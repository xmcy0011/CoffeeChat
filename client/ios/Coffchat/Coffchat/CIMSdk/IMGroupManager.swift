//
//  IMGroupManager.swift
//  Coffchat
//
//  Created by fei.xu on 2020/10/27.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 群组管理回调对象
protocol IMGroupManagerDelegate {
    /// 群成员变更通知
    /// - Parameter memberInfo: 成员信息
    func memberChangedNotify(memberInfo: CIM_Group_CIMGroupMemberChangedNotify)
}

/// 群组管理
class IMGroupManager: IMClientDelegateData {
    fileprivate var client: IMClient
    fileprivate var createGroupCallback: IMResultCallback<CIM_Group_CIMGroupCreateRsp>?
    fileprivate var disbandingCallback: IMResultCallback<CIM_Group_CIMGroupDisbandingRsp>?
    fileprivate var exitGroupCallback: IMResultCallback<CIM_Group_CIMGroupExitRsp>?
    fileprivate var groupListCallback: IMResultCallback<CIM_Group_CIMGroupListRsp>?
    fileprivate var groupInfoCallback: IMResultCallback<CIM_Group_CIMGroupInfoRsp>?
    fileprivate var groupMemberListCallback: IMResultCallback<CIM_Group_CIMGroupMemberListRsp>?
    fileprivate var inviteCallback: IMResultCallback<CIM_Group_CIMGroupInviteMemberRsp>?
    fileprivate var kickoutCallback: IMResultCallback<CIM_Group_CIMGroupKickOutMemberRsp>?
    
    init() {
        client = DefaultIMClient
        client.register(key: "IMGroupManager", delegateData: self)
    }
    
    /// 创建群组
    /// - Parameters:
    ///   - memberIdList: 成员ID列表
    ///   - groupName: 群组名，可空
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func createGroup(memberIdList: [UInt64], groupName: String, callback: IMResultCallback<CIM_Group_CIMGroupCreateRsp>?, timeout: IMResponseTimeoutCallback?) {
        createGroupCallback = callback
        
        IMLog.info(item: "createGroup groupName:\(groupName),memberIdListLen:\(memberIdList.count)")
        
        var req = CIM_Group_CIMGroupCreateReq()
        req.userID = IMManager.singleton.userId!
        req.groupName = groupName
        req.memberIDList = memberIdList
        
        client.sendRequest(cmdId: .kCimCidGroupCreateDefaultReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 解散
    /// - Parameters:
    ///   - groupId: 群ID
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func disbandingGroup(groupId: UInt64, callback: IMResultCallback<CIM_Group_CIMGroupDisbandingRsp>?, timeout: IMResponseTimeoutCallback?) {
        disbandingCallback = callback
        
        IMLog.info(item: "disbandingGroup groupId:\(groupId)")
        
        var req = CIM_Group_CIMGroupDisbandingReq()
        req.userID = IMManager.singleton.userId!
        req.groupID = groupId
        
        client.sendRequest(cmdId: .kCimCidGroupDisbingdingReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 退出群聊
    /// - Parameters:
    ///   - groupId: 群ID
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func exitGroup(groupId: UInt64, callback: IMResultCallback<CIM_Group_CIMGroupExitRsp>?, timeout: IMResponseTimeoutCallback?) {
        exitGroupCallback = callback
        
        IMLog.info(item: "exitGroup groupId:\(groupId)")
        
        var req = CIM_Group_CIMGroupExitReq()
        req.userID = IMManager.singleton.userId!
        req.groupID = groupId
        
        client.sendRequest(cmdId: .kCimCidGroupExitReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 查询群列表
    /// - Parameters:
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func queryGroupList(callback: IMResultCallback<CIM_Group_CIMGroupListRsp>?, timeout: IMResponseTimeoutCallback?) {
        groupListCallback = callback
        
        IMLog.info(item: "queryGroupList")
        
        var req = CIM_Group_CIMGroupListReq()
        req.userID = IMManager.singleton.userId!
        
        client.sendRequest(cmdId: .kCimCidGroupListReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 查询群详情
    /// - Parameters:
    ///   - groupVersionInfo: 群基础信息
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func queryGroupInfo(groupVersionInfo: [CIM_Group_CIMGroupVersionInfo], callback: IMResultCallback<CIM_Group_CIMGroupInfoRsp>?, timeout: IMResponseTimeoutCallback?) {
        groupInfoCallback = callback
        
        if groupVersionInfo.count == 0 {
            IMLog.warn(item: "invliad groupVersionInfo")
            return
        }
        
        IMLog.info(item: "queryGroupInfo groupVersionListLen:\(groupVersionInfo.count)")
        
        var req = CIM_Group_CIMGroupInfoReq()
        req.groupVersionList = groupVersionInfo
        req.userID = IMManager.singleton.userId!
        
        client.sendRequest(cmdId: .kCimCidGroupInfoReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 查询群成员列表
    /// - Parameters:
    ///   - groupVersionInfo: 群组信息
    ///   - callback: 结果
    ///   - timeout: 超时
    func queryGroupMember(groupId: UInt64, callback: IMResultCallback<CIM_Group_CIMGroupMemberListRsp>?, timeout: IMResponseTimeoutCallback?) {
        groupMemberListCallback = callback
        
        IMLog.info(item: "queryGroupMember groupId:\(groupId)")
        
        var req = CIM_Group_CIMGroupMemberListReq()
        req.groupID = groupId
        req.userID = IMManager.singleton.userId!
        
        client.sendRequest(cmdId: .kCimCidGroupListMemberReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 邀请加入群
    /// - Parameters:
    ///   - groupId: 群ID
    ///   - memberIdList: 成员ID列表
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func inviteMember(groupId: UInt64, memberIdList: [UInt64], callback: IMResultCallback<CIM_Group_CIMGroupInviteMemberRsp>?, timeout: IMResponseTimeoutCallback?) {
        inviteCallback = callback
        
        IMLog.info(item: "inviteMember groupId:\(groupId),memberIdListLen:\(memberIdList.count)")
        
        var req = CIM_Group_CIMGroupInviteMemberReq()
        req.userID = IMManager.singleton.userId!
        req.memberIDList = memberIdList
        req.groupID = groupId
        
        client.sendRequest(cmdId: .kCimCidVoipInviteReq, body: try! req.serializedData(), timeout: timeout)
    }
    
    /// 踢人
    /// - Parameters:
    ///   - groupId: 群ID
    ///   - memberIdList: 成员ID列表
    ///   - callback: 结果
    ///   - timeout: 超时回调
    func kickoutMember(groupId: UInt64, memberIdList: [UInt64], callback: IMResultCallback<CIM_Group_CIMGroupKickOutMemberRsp>?, timeout: IMResponseTimeoutCallback?) {
        kickoutCallback = callback
        
        IMLog.info(item: "kickoutMember groupId:\(groupId),memberIdListLen:\(memberIdList.count)")
        
        var req = CIM_Group_CIMGroupKickOutMemberReq()
        req.userID = IMManager.singleton.userId!
        req.groupID = groupId
        req.memberIDList = memberIdList
        
        client.sendRequest(cmdId: .kCimCidGroupKickOutMemberReq, body: try! req.serializedData(), timeout: timeout)
    }
}

// MARK: IMClientDelegateData

extension IMGroupManager {
    // 处理数据
    func onHandleData(_ header: IMHeader, _ data: Data) -> Bool {
        if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupCreateDefaultRsp.rawValue {
            _onHandleGroupCreateRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupDisbingdingRsp.rawValue {
            _onHandleGroupDisbindingRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupExitRsp.rawValue {
            _onHandleGroupExitRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupListRsp.rawValue {
            _onHandleGroupListRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupInfoRsp.rawValue {
            _onHandleGroupInfoRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupInviteMemberRsp.rawValue {
            _onHandleGroupMemberInviteRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupKickOutMemberRsp.rawValue {
            _onHandleGroupMemberKickoutRsp(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupMemberChangedNotify.rawValue {
            _onHandleMemberChangedNotify(data: data)
            return true
        } else if header.commandId == CIM_Def_CIMCmdID.kCimCidGroupListMemberRsp.rawValue {
            _onHandleMemberListRsp(data: data)
            return true
        }
        return false
    }
    
    // MARK: handle
    
    func _onHandleGroupCreateRsp(data: Data) {
        var res: CIM_Group_CIMGroupCreateRsp?
        do {
            res = try CIM_Group_CIMGroupCreateRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupCreateRsp res_code:\(res!.resultCode),groupId:\(res!.groupInfo.groupID),memberIdListLen:\(res!.memberIDList.count)")
        
        if createGroupCallback != nil {
            createGroupCallback!(res!)
        }
    }
    
    func _onHandleGroupDisbindingRsp(data: Data) {
        var res: CIM_Group_CIMGroupDisbandingRsp?
        do {
            res = try CIM_Group_CIMGroupDisbandingRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupDisbindingRsp res_code:\(res!.resultCode),groupId:\(res!.groupID)")
        
        if disbandingCallback != nil {
            disbandingCallback!(res!)
        }
    }
    
    func _onHandleGroupExitRsp(data: Data) {
        var res: CIM_Group_CIMGroupExitRsp?
        do {
            res = try CIM_Group_CIMGroupExitRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupExitRsp res_code:\(res!.resultCode),groupId:\(res!.groupID)")
        
        if exitGroupCallback != nil {
            exitGroupCallback!(res!)
        }
    }
    
    func _onHandleGroupListRsp(data: Data) {
        var res: CIM_Group_CIMGroupListRsp?
        do {
            res = try CIM_Group_CIMGroupListRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupListRsp groupVersionListLen:\(res!.groupVersionList.count)")
        
        if groupListCallback != nil {
            groupListCallback!(res!)
        }
    }
    
    func _onHandleGroupInfoRsp(data: Data) {
        var res: CIM_Group_CIMGroupInfoRsp?
        do {
            res = try CIM_Group_CIMGroupInfoRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupInfoRsp groupInfoListLen:\(res!.groupInfoList.count)")
        
        if groupInfoCallback != nil {
            groupInfoCallback!(res!)
        }
    }
    
    func _onHandleGroupMemberInviteRsp(data: Data) {
        var res: CIM_Group_CIMGroupInviteMemberRsp?
        do {
            res = try CIM_Group_CIMGroupInviteMemberRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupMemberInviteRsp res_code:\(res!.resultCode),groupId:\(res!.groupID)")
        
        if inviteCallback != nil {
            inviteCallback!(res!)
        }
    }
    
    func _onHandleGroupMemberKickoutRsp(data: Data) {
        var res: CIM_Group_CIMGroupKickOutMemberRsp?
        do {
            res = try CIM_Group_CIMGroupKickOutMemberRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleGroupMemberKickoutRsp res_code:\(res!.resultCode),groupId:\(res!.groupID)")
        
        if kickoutCallback != nil {
            kickoutCallback!(res!)
        }
    }
    
    func _onHandleMemberChangedNotify(data: Data) {
        var res: CIM_Group_CIMGroupMemberChangedNotify?
        do {
            res = try CIM_Group_CIMGroupMemberChangedNotify(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleMemberChangedNotify groupId:\(res!.groupID),changeListLen:\(res!.changedList.count)")
    }
    
    func _onHandleMemberListRsp(data: Data) {
        var res: CIM_Group_CIMGroupMemberListRsp?
        do {
            res = try CIM_Group_CIMGroupMemberListRsp(serializedData: data)
        } catch {
            IMLog.warn(item: "parse pb error")
            return
        }
        
        IMLog.info(item: "_onHandleMemberListRsp res_code:\(res!.userID),groupId:\(res!.groupID),listLen:\(res!.memberIDList.count)")
        
        if groupMemberListCallback != nil {
            groupMemberListCallback!(res!)
        }
    }
}
