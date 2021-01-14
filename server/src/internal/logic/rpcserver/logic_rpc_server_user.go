package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/logger"
	"context"
)

// 新增一个授权用户
func (s *LogicServer) CreateUser(ctx context.Context, req *cim.CreateUserAccountInfoReq) (*cim.CreateUserAccountInfoRsp, error) {
	rsp := &cim.CreateUserAccountInfoRsp{}
	u := dao.DefaultUser.GetByUserName(req.UserName)
	if u != nil {
		rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERROR_USER_ALREADY_EXIST
		logger.Sugar.Warnf("CreateUser failed:user already exist,userId=%d,userName=%s", u.UserId, req.UserName)
		return rsp, nil
	}

	userId, err := dao.DefaultUser.Add(req.UserName, req.UserNickName, req.UserPwd)
	if err != nil {
		return nil, err
	}

	// 1.create user
	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCSSE
	logger.Sugar.Infof("CreateUser userName=%s,userNickName=%s,userId=%d", req.UserName, req.UserNickName, userId)

	// 2.create robot session
	AddRobotSession(uint64(userId))
	return rsp, nil
}

// 查询用户昵称
func (s *LogicServer) QueryUserNickName(ctx context.Context, in *cim.QueryUserNickNameReq) (*cim.QueryUserNickNameRsp, error) {
	rsp := &cim.QueryUserNickNameRsp{}
	u := dao.DefaultUser.Get(in.UserId)
	if u == nil {
		rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERROR_USER_NOT_EXIST
		logger.Sugar.Warnf("QueryUserNickName failed:user not exist,userId=%d", in.UserId)
		return rsp, nil
	}

	// success
	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCSSE
	rsp.NickName = u.UserNickName
	logger.Sugar.Infof("QueryUserNickName userId=%d,nickName=%s", in.UserId, rsp.NickName)

	return rsp, nil
}

// 查询系统中已注册用户的列表（上限50）
func (s *LogicServer) QuerySystemUserRandomList(ctx context.Context, in *cim.CIMFriendQueryUserListReq) (*cim.CIMFriendQueryUserListRsp, error) {
	rsp := &cim.CIMFriendQueryUserListRsp{}
	users, err := dao.DefaultUser.ListRandom(in.UserId)
	if err != nil {
		logger.Sugar.Warnf("QuerySystemUserRandomList failed:%s,userId=%d", err.Error(), in.UserId)
		return nil, err
	}

	rsp.UserId = in.UserId
	rsp.UserInfoList = users
	logger.Sugar.Infof("QuerySystemUserRandomList userId=%d,userListLen=%d", in.UserId, len(rsp.UserInfoList))

	return rsp, nil
}
