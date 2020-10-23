package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/logger"
	"context"
	"errors"
)

// 创建群
func (s *LogicServer) CreateGroup(ctx context.Context, in *cim.CIMGroupCreateReq) (*cim.CIMGroupCreateRsp, error) {
	logger.Sugar.Infof("CreateGroup userId=%d,groupName=%s", in.UserId, in.GroupName)

	rsp := &cim.CIMGroupCreateRsp{}
	rsp.UserId = in.UserId
	rsp.MemberIdList = in.MemberIdList

	// create group
	info, err := dao.DefaultGroup.Add(in.GroupName, in.UserId)
	if err != nil {
		return nil, err
	}

	rsp.ResultCode = uint32(cim.CIMErrorCode_kCIM_ERR_SUCCSSE)
	rsp.GroupInfo = info

	// add member myself
	err = dao.DefaultGroupMember.Add(info.GroupId, rsp.UserId)
	if err != nil {
		logger.Sugar.Warn(err.Error())
	}
	rsp.MemberIdList = append(rsp.MemberIdList, rsp.UserId)

	// add member
	for _, v := range in.MemberIdList {
		err := dao.DefaultGroupMember.Add(info.GroupId, v)
		if err != nil {
			logger.Sugar.Warn("CreateGroup add member err:", err.Error())
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
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCSSE),
	}
	return info, nil
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
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCSSE),
	}
	return rsp, nil
}

// 查询群列表
func (s *LogicServer) GroupList(ctx context.Context, in *cim.CIMGroupListReq) (*cim.CIMGroupListRsp, error) {
	logger.Sugar.Infof("GroupList user_id=%d", in.UserId)

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

// 查询群详情
func (s *LogicServer) QueryGroupInfo(ctx context.Context, in *cim.CIMGroupInfoReq) (*cim.CIMGroupInfoRsp, error) {
	logger.Sugar.Infof("QueryGroupInfo user_id=%d,group_version_list_len=%d", in.UserId, len(in.GroupVersionList))

	rsp := &cim.CIMGroupInfoRsp{}
	rsp.ResultCode = uint32(cim.CIMErrorCode_kCIM_ERR_SUCCSSE)
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
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCSSE),
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
		ResultCode: uint32(cim.CIMErrorCode_kCIM_ERR_SUCCSSE),
	}

	for _, v := range in.MemberIdList {
		err := dao.DefaultGroupMember.Del(in.GroupId, v)
		if err != nil {
			logger.Sugar.Warnf("GroupKickOutMember group_id=%d del member=%d error:%s", in.GroupId, v, err.Error())
		}
	}

	return rsp, nil
}
