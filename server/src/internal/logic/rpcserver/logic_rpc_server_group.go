package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/logger"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
)

const kGroupNameQueryMaxUserCount = 3

// 创建群
func (s *LogicServer) CreateGroup(ctx context.Context, in *cim.CIMGroupCreateReq) (*cim.CIMGroupCreateRsp, error) {
	logger.Sugar.Infof("CreateGroup userId=%d,groupName=%s,memberIdListLen=%d", in.UserId, in.GroupName, len(in.MemberIdList))

	rsp := &cim.CIMGroupCreateRsp{}
	rsp.UserId = in.UserId
	rsp.MemberIdList = in.MemberIdList

	// create default group name
	nickNames := make([]string, 0)
	if in.GroupName == "" {
		ids := make([]uint64, 0)
		ids = append(ids, in.UserId)
		for i, v := range in.MemberIdList {
			if i < kGroupNameQueryMaxUserCount {
				ids = append(ids, v)
			} else {
				break
			}
		}

		users, err := dao.DefaultUser.GetBatch(ids)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return nil, err
		}
		for i, v := range users {
			if i == len(users)-1 {
				in.GroupName += fmt.Sprintf("%s", v.UserNickName)
			} else {
				in.GroupName += fmt.Sprintf("%s,", v.UserNickName)
			}
			// 被邀请者昵称
			if i > 0 {
				nickNames = append(nickNames, v.UserNickName)
			}
		}
	}

	// create group
	info, err := dao.DefaultGroup.Add(in.GroupName, in.UserId, len(rsp.MemberIdList))
	if err != nil {
		return nil, err
	}

	rsp.ResultCode = uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS)
	rsp.GroupInfo = info

	// add member myself
	err = dao.DefaultGroupMember.Add(info.GroupId, rsp.UserId)
	if err != nil {
		logger.Sugar.Warn(err.Error())
	}
	rsp.MemberIdList = append(rsp.MemberIdList, rsp.UserId)

	// add members
	for _, v := range in.MemberIdList {
		err := dao.DefaultGroupMember.Add(info.GroupId, v)
		if err != nil {
			logger.Sugar.Warn("CreateGroup add member err:", err.Error())
		}
	}

	for _, v := range rsp.MemberIdList {
		// create session
		err = dao.DefaultSession.AddGroupSession(v, info.GroupId, cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP,
			cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK)
		if err != nil {
			logger.Sugar.Warnf(err.Error())
		}
	}

	// send group msg notification
	ids := make([]string, 0)
	for _, v := range in.MemberIdList {
		ids = append(ids, strconv.FormatUint(v, 10))
	}
	notify := dao.CIMMsgNotificationCreateGroup{
		GroupId:   strconv.FormatUint(info.GroupId, 10),
		GroupName: info.GroupName,
		Owner:     strconv.FormatUint(info.GroupOwnerId, 10),
		OwnerNick: strconv.FormatUint(info.GroupOwnerId, 10),
		Ids:       ids,
		NickNames: nickNames,
	}

	msg, err := dao.DefaultMessage.CreateMsgSystemNotification(
		cim.CIMMsgNotificationType_kCIM_MSG_NOTIFICATION_GROUP_CREATE,
		notify, info.GroupId, cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP)
	if err != nil {
		logger.Sugar.Warnf(err.Error())
	} else {
		_, err = dao.DefaultMessage.SaveMessage(info.GroupId, info.GroupId, msg.ClientMsgId, msg.MsgType,
			msg.SessionType, string(msg.MsgData), false)
		if err != nil {
			logger.Sugar.Warnf(err.Error())
		} else {
			// 记录群创建系统通知，交由gate广播给其他成员
			buff, err := json.Marshal(msg)
			if err == nil {
				rsp.AttachNotificatinoMsg = buff
			}
		}
	}

	return rsp, nil
}

// 解散
func (s *LogicServer) DisbandingGroup(ctx context.Context, in *cim.CIMGroupDisbandingReq) (*cim.CIMGroupDisbandingRsp, error) {
	logger.Sugar.Infof("DisbandingGroup userId=%d,groupId=%s", in.UserId, in.GroupId)

	err := dao.DefaultGroup.Del(in.UserId, in.GroupId)
	if err != nil {
		return nil, err
	}

	info := &cim.CIMGroupDisbandingRsp{
		UserId:     in.UserId,
		GroupId:    in.GroupId,
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS),
	}
	return info, nil
}

// 查询群列表
func (s *LogicServer) QueryGroupList(ctx context.Context, in *cim.CIMGroupListReq) (*cim.CIMGroupListRsp, error) {
	logger.Sugar.Infof("QueryGroupList user_id=%d", in.UserId)

	ids, err := dao.DefaultGroupMember.ListGroup(in.UserId)
	if err != nil {
		return nil, err
	}

	rsp := &cim.CIMGroupListRsp{
		UserId: in.UserId,
	}
	for _, id := range ids {
		versionInfo := &cim.CIMGroupVersionInfo{
			GroupId:      id,
			GroupVersion: dao.KGroupCurrentVersion,
		}
		rsp.GroupVersionList = append(rsp.GroupVersionList, versionInfo)
	}

	return rsp, nil
}

// 查询群成员列表
func (s *LogicServer) QueryGroupMemberList(ctx context.Context, in *cim.CIMGroupMemberListReq) (*cim.CIMGroupMemberListRsp, error) {
	logger.Sugar.Infof("QueryGroupMemberList user_id=%d", in.UserId)

	ids, err := dao.DefaultGroupMember.ListMember(in.GroupId)
	if err != nil {
		return nil, err
	}

	rsp := &cim.CIMGroupMemberListRsp{
		UserId:       in.UserId,
		GroupId:      in.GroupId,
		MemberIdList: ids,
	}
	return rsp, nil
}

// 查询群详情
func (s *LogicServer) QueryGroupInfo(ctx context.Context, in *cim.CIMGroupInfoReq) (*cim.CIMGroupInfoRsp, error) {
	logger.Sugar.Infof("QueryGroupInfo user_id=%d,group_version_list_len=%d", in.UserId, len(in.GroupVersionList))

	rsp := &cim.CIMGroupInfoRsp{}
	rsp.ResultCode = uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS)
	rsp.UserId = in.UserId

	for _, v := range in.GroupVersionList {
		info, err := dao.DefaultGroup.Get(v.GroupId)
		if err == nil {
			rsp.GroupInfoList = append(rsp.GroupInfoList, info)
		}
	}
	return rsp, nil
}

// 加人
func (s *LogicServer) GroupInviteMember(ctx context.Context, in *cim.CIMGroupInviteMemberReq) (*cim.CIMGroupInviteMemberRsp, error) {
	logger.Sugar.Infof("GroupInviteMember user_id=%d,group_id=%d,member_id_list_len=%d", in.UserId, in.GroupId, len(in.MemberIdList))

	rsp := &cim.CIMGroupInviteMemberRsp{
		UserId:     in.UserId,
		GroupId:    in.GroupId,
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS),
	}
	for _, v := range in.MemberIdList {
		err := dao.DefaultGroupMember.Add(in.GroupId, v)
		if err != nil {
			logger.Sugar.Warnf("GroupInviteMember group_id=%d add member=%d error:%s", in.GroupId, v, err.Error())
		}
	}

	return rsp, nil
}

// 踢人
func (s *LogicServer) GroupKickOutMember(ctx context.Context, in *cim.CIMGroupKickOutMemberReq) (*cim.CIMGroupKickOutMemberRsp, error) {
	logger.Sugar.Infof("GroupKickOutMember user_id=%d,group_id=%d,member_id_list=%d", in.UserId, in.GroupId, len(in.MemberIdList))

	rsp := &cim.CIMGroupKickOutMemberRsp{
		UserId:     in.UserId,
		GroupId:    in.GroupId,
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS),
	}

	for _, v := range in.MemberIdList {
		err := dao.DefaultGroupMember.Del(in.GroupId, v)
		if err != nil {
			logger.Sugar.Warnf("GroupKickOutMember group_id=%d del member=%d error:%s", in.GroupId, v, err.Error())
		}
	}

	return rsp, nil
}

// 退出群
func (s *LogicServer) GroupExit(ctx context.Context, in *cim.CIMGroupExitReq) (*cim.CIMGroupExitRsp, error) {
	logger.Sugar.Infof("GroupExit user_id=%d,group_id=%d", in.UserId, in.GroupId)

	id, err := dao.DefaultGroup.GetOwnerId(in.GroupId)
	if err != nil {
		return nil, err
	}

	if id == in.UserId {
		// change group owner
		// FIX ME
		return nil, errors.New("can't support group owner exist")
	}

	err = dao.DefaultGroupMember.Del(in.GroupId, in.UserId)
	if err != nil {
		return nil, err
	}
	rsp := &cim.CIMGroupExitRsp{
		UserId:     in.UserId,
		GroupId:    in.GroupId,
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS),
	}
	return rsp, nil
}
