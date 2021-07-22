package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/logger"
	"context"
	"google.golang.org/grpc"
	"strconv"
	"time"
)

type LogicServer struct {
}

var DefaultLogicRpcServer = &LogicServer{}
var gateRpcClientMap map[string]cim.GateClient

func init() {
	gateRpcClientMap = make(map[string]cim.GateClient)
}

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
		logger.Sugar.Warnf("address %s gRPC client already register!", address)
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
	logger.Sugar.Infof("AuthToken userId=%d,nickName=%s,userToken=%s,clientType=%d,ClientVersion=%s",
		in.UserId, in.NickName, in.UserToken, in.ClientType, in.ClientVersion)

	rsp := &cim.CIMAuthTokenRsp{}
	rsp.ServerTime = uint32(time.Now().Unix())

	exist, err := dao.DefaultUser.Validate(in.UserId, in.UserToken)
	if err != nil {
		rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_LOGIN_INVALID_USER_OR_PWD
		rsp.ResultString = "用户不存在或者密码错误"
	} else {
		if exist {
			rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_SUCCESS
			rsp.ResultString = "success"

			// update nick_name
			//if in.NickName != ""{
			//	dao.DefaultUser.Update(in.UserId, in.NickName)
			//}

			// user info
			user := dao.DefaultUser.Get(in.UserId)
			if user == nil {
				rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR
				rsp.ResultString = "服务器内部错误"
			} else {
				rsp.UserInfo = &cim.CIMUserInfo{
					UserId:     in.UserId,
					NickName:   in.NickName,
					AttachInfo: user.UserAttach,
				}
			}
		} else {
			rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_LOGIN_INVALID_USER_TOKEN
			rsp.ResultString = "非法的口令"
		}
	}

	return rsp, nil
}

// 验证用户名和密码
func (s *LogicServer) Auth(ctx context.Context, in *cim.CIMAuthReq) (*cim.CIMAuthRsp, error) {
	rsp := &cim.CIMAuthRsp{}
	rsp.ServerTime = uint32(time.Now().Unix())

	exist, u := dao.DefaultUser.Validate2(in.UserName, in.UserPwd)
	if u == nil {
		rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_LOGIN_INVALID_USER_OR_PWD
		rsp.ResultString = "用户不存在或者密码错误"
	} else {
		if exist {
			rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_SUCCESS
			rsp.ResultString = "success"
			rsp.UserInfo = &cim.CIMUserInfo{
				UserId:     u.UserId,
				NickName:   u.UserNickName,
				AttachInfo: u.UserAttach,
			}
		} else {
			rsp.ResultCode = cim.CIMErrorCode_kCIM_ERR_LOGIN_INVALID_USER_TOKEN
			rsp.ResultString = "非法的口令"
		}
	}

	logger.Sugar.Infof("AuthToken userName=%s,userPwd=%s,clientType=%d,ClientVersion=%s,resultCode=%d,resultString=%s",
		in.UserName, in.UserPwd, in.ClientType, in.ClientVersion, rsp.ResultCode, rsp.ResultString)

	return rsp, nil
}
