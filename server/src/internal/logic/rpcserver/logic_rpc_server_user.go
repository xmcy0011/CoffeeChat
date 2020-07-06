package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/logger"
	"context"
	"errors"
	"strings"
)

// 新增一个授权用户
func (s *LogicServer) CreateUser(ctx context.Context, req *cim.CreateUserAccountInfoReq) (*cim.CreateUserAccountInfoRsp, error) {
	if len(req.UserToken) < 5 || len(req.UserToken) > 16 {
		return nil, errors.New("invalid user_token, 5 <= need <= 16")
	}
	if strings.TrimSpace(req.UserNickName) == "" {
		return nil, errors.New("user_nick_name must be not empty")
	}

	rsp := &cim.CreateUserAccountInfoRsp{}
	u := dao.DefaultUser.Get(req.UserId)
	if u != nil {
		rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERROR_USER_ALREADY_EXIST
		logger.Sugar.Warnf("CreateUser failed:user already exist,userId=%d,userToken=%s", req.UserId, req.UserToken)
		return rsp, nil
	}

	err := dao.DefaultUser.Add(req.UserId, req.UserNickName, req.UserToken)
	if err != nil {
		return nil, err
	}

	// 1.create user
	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCSSE
	logger.Sugar.Infof("CreateUser userId=%d,userToken=%s", req.UserId, req.UserToken)

	// 2.create robot session
	AddRobotSession(req.UserId)
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
