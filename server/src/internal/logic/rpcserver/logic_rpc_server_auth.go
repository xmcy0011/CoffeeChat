package rpcserver

import (
	"context"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"google.golang.org/grpc"
	"strconv"
	"time"
)

type LogicServer struct {
}

var DefaultLogicRpcServer = &LogicServer{}
var gateRpcClientMap map[string]cim.GateClient

// 传递我方信息，双向GRPC
func (s *LogicServer) SayHello(ctx context.Context, in *cim.Hello) (*cim.Empty, error) {
	address := in.Ip + ":" + strconv.Itoa(int(in.Port))
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		return nil, err
	}
	// save
	gateClient := cim.NewGateClient(conn)
	if _, ok := gateRpcClientMap[address]; !ok {
		gateRpcClientMap[address] = gateClient
	} else {
		logger.Sugar.Warnf("address %s gRPC client already register!",address)
	}
	empty := &cim.Empty{}
	return empty, nil
}

// ping
func (s *LogicServer) Ping(ctx context.Context, in *cim.CIMHeartBeat) (*cim.CIMHeartBeat, error) {
	logger.Sugar.Debug("ping")

	heart := &cim.CIMHeartBeat{}
	return heart, nil
}

// 验证token
func (s *LogicServer) AuthToken(ctx context.Context, in *cim.CIMAuthTokenReq) (*cim.CIMAuthTokenRsp, error) {
	logger.Sugar.Infof("authToken userId=%d,nickName=%s,userToken=%s,clientType=%d,ClientVersion=%s",
		in.UserId, in.NickName, in.UserToken, in.ClientType, in.ClientVersion)

	rsp := &cim.CIMAuthTokenRsp{}
	rsp.ServerTime = uint32(time.Now().Unix())

	exist, err := dao.DefaultUser.Validate(in.UserId, in.UserToken)
	if err != nil {
		rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR
		rsp.ResultString = "服务器内部错误"
	} else {
		if exist {
			rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_SUCCSSE
			rsp.ResultString = "success"

			// user info
			user := dao.DefaultUser.Get(in.UserId)
			rsp.UserInfo = &cim.CIMUserInfo{
				UserId:     in.UserId,
				NickName:   in.NickName,
				AttachInfo: user.UserAttach,
			}
		} else {
			rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_LOGIN_INVALID_USER_TOKEN
			rsp.ResultString = "非法的口令"
		}
	}

	return rsp, nil
}
