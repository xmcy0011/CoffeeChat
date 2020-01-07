package rpcserver

import (
	"context"
	"errors"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
	"github.com/CoffeeChat/server/src/pkg/logger"
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

	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCSSE
	logger.Sugar.Infof("CreateUser userId=%d,userToken=%s", req.UserId, req.UserToken)
	return rsp, nil
}
