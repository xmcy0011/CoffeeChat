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
func (s *LogicServer) CreateUser(ctx context.Context, req *cim.CreateUserAccountInfo) (*cim.Empty, error) {
	if len(req.UserToken) < 5 || len(req.UserToken) > 16 {
		return nil, errors.New("invalid user_token, 5 <= need <= 16")
	}
	if strings.TrimSpace(req.UserNickName) == "" {
		return nil, errors.New("user_nick_name must be not empty")
	}

	err := dao.DefaultUser.Add(req.UserId, req.UserNickName, req.UserToken)
	if err != nil {
		return nil, err
	}

	logger.Sugar.Infof("CreateUser userId=%d,userToken=%s", req.UserId, req.UserToken)
	return &cim.Empty{}, nil
}
