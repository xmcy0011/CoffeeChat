package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"encoding/json"
	"github.com/golang/protobuf/proto"
	"strconv"
	"time"
)

// 创建群
func (tcp *TcpConn) onHandleCreateGroupReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupCreateReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleCreateGroup error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleCreateGroup group_name=%s,member_id_list_len=%d", req.GroupName, len(req.MemberIdList))

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.CreateGroup(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleCreateGroup CreateGroup(gRPC) err:%s, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_CREATE_DEFAULT_RSP), rsp)
		logger.Sugar.Infof("onHandleCreateGroup CreateGroup(gRPC) res,user_id:%d,result_code:%d,"+
			"group_id=%d,group_name=%s,member_id_list_len=%d",
			rsp.UserId, rsp.ResultCode, rsp.GroupInfo.GroupId, rsp.GroupInfo.GroupName, len(rsp.MemberIdList))

		// broadcast group notification msg
		if rsp.AttachNotificatinoMsg != nil {
			msg := cim.CIMMsgData{}
			err := json.Unmarshal(rsp.AttachNotificatinoMsg, &msg)
			if err != nil {
				logger.Sugar.Warnf(err.Error())
				return
			}

			for _, v := range rsp.MemberIdList {
				u := DefaultUserManager.FindUser(v)
				if u != nil {
					u.Broadcast(uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA), &msg)
				}
			}
		}
	}
}

// 解散群
func (tcp *TcpConn) onHandleDisbandingGroupReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupDisbandingReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleDisbandingGroup error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleDisbandingGroup user_id=%s,group_id=%d", req.UserId, req.GroupId)

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.DisbandingGroup(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleDisbandingGroup DisbandingGroup(gRPC) err:%s, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_DISBINGDING_RSP), rsp)
		logger.Sugar.Infof("onHandleDisbandingGroup DisbandingGroup(gRPC) res,user_id:%d,result_code:%d,"+
			"group_id=%d", rsp.UserId, rsp.ResultCode, rsp.GroupId)
	}
}

// 退出群
func (tcp *TcpConn) onHandleGroupExitReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupExitReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warn("onHandleGroupExitReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleGroupExitReq user_id=%s,group_id=%d", req.UserId, req.GroupId)

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.GroupExit(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupExitReq GroupExit(gRPC) err:, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_EXIT_RSP), rsp)
		logger.Sugar.Infof("onHandleGroupExitReq GroupExit(gRPC) res,user_id:%d,result_code:%d,"+
			"group_id=%d", rsp.UserId, rsp.ResultCode, rsp.GroupId)
	}
}

// 查询群列表请求
func (tcp *TcpConn) onHandleGroupListReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupListReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warn("onHandleGroupListReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleGroupListReq user_id=%s", req.UserId)

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.QueryGroupList(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupListReq GroupList(gRPC) err:, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_LIST_RSP), rsp)
		logger.Sugar.Infof("onHandleGroupListReq GroupList(gRPC) res,user_id:%d,result_code:%d,"+
			"group_version_list=%d", rsp.UserId, len(rsp.GroupVersionList))
	}
}

// 查询群成员列表
func (tcp *TcpConn) onHandleGroupMemberListReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupMemberListReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupMemberListReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleGroupMemberListReq user_id=%d,group_id=%d", req.UserId, req.GroupId)

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.QueryGroupMemberList(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupMemberListReq QueryGroupMemberList(gRPC) err:,user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_LIST_MEMBER_RSP), rsp)
		logger.Sugar.Infof("onHandleGroupMemberListReq QueryGroupMemberList(gRPC) res,user_id:%d,"+
			"group_member_list_len=%d", rsp.UserId, len(rsp.MemberIdList))
	}
}

// 查询群信息
func (tcp *TcpConn) onHandleGroupInfoReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupInfoReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupInfoReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}
	if req.GroupVersionList == nil || len(req.GroupVersionList) <= 0 {
		logger.Sugar.Warnf("onHandleGroupInfoReq invalid group_version_list,user_id:%d", tcp.userId)
		return
	}

	idArr := ""
	for _, v := range req.GroupVersionList {
		idArr += strconv.FormatUint(v.GroupId, 10) + ","
	}
	logger.Sugar.Info("onHandleGroupInfoReq user_id=%s,group_info_list=%d", req.UserId, idArr[0:len(idArr)-1])

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.QueryGroupInfo(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupInfoReq QueryGroupInfo(gRPC) err:%s, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_INFO_RSP), rsp)
		logger.Sugar.Infof("onHandleGroupInfoReq QueryGroupInfo(gRPC) res,user_id:%d,result_code:%d,"+
			"group_info_list_len=%d", rsp.UserId, rsp.ResultCode, len(rsp.GroupInfoList))
	}
}

// 加人
func (tcp *TcpConn) onHandleGroupInviteMemberReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupInviteMemberReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupInviteMemberReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}
	if req.MemberIdList == nil || len(req.MemberIdList) <= 0 {
		logger.Sugar.Warnf("onHandleGroupInviteMemberReq invalid group_version_list,user_id:%d", tcp.userId)
		return
	}

	idArr := ""
	for _, v := range req.MemberIdList {
		idArr += strconv.FormatUint(v, 10) + ","
	}
	logger.Sugar.Info("onHandleGroupInviteMemberReq user_id=%s,group_id=%d,member_id_list=%s",
		req.UserId, req.GroupId, idArr[0:len(idArr)-1])

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.GroupInviteMember(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupInviteMemberReq GroupInviteMember(gRPC) err:%s, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_INVITE_MEMBER_RSP), rsp)
		logger.Sugar.Infof("onHandleGroupInviteMemberReq GroupInviteMember(gRPC) res,user_id:%d,result_code:%d,"+
			"group_id=%d", rsp.UserId, rsp.ResultCode, rsp.GroupId)
	}
}

// 踢人
func (tcp *TcpConn) onHandleGroupKickOutMemberReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGroupKickOutMemberReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupKickOutMemberReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}
	if req.MemberIdList == nil || len(req.MemberIdList) <= 0 {
		logger.Sugar.Warnf("onHandleGroupKickOutMemberReq invalid group_version_list,user_id:%d", tcp.userId)
		return
	}

	idArr := ""
	for _, v := range req.MemberIdList {
		idArr += strconv.FormatUint(v, 10) + ","
	}
	logger.Sugar.Info("onHandleGroupKickOutMemberReq user_id=%s,group_id=%d,member_id_list=%s",
		req.UserId, req.GroupId, idArr[0:len(idArr)-1])

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.GroupKickOutMember(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleGroupKickOutMemberReq GroupKickOutMember(gRPC) err:%s, user_id:%d", err.Error(), req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_GROUP_INVITE_MEMBER_RSP), rsp)
		logger.Sugar.Infof("onHandleGroupKickOutMemberReq GroupKickOutMember(gRPC) res,user_id:%d,result_code:%d,"+
			"group_id=%d", rsp.UserId, rsp.ResultCode, rsp.GroupId)
	}
}
