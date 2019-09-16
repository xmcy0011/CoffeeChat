package rpcserver

import (
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"golang.org/x/net/context"
	"time"
)

type AuthRpcServer struct {
}

var DefaultAuthRpcServer = &AuthRpcServer{}

// ping
func (s *AuthRpcServer) Ping(ctx context.Context, in *cim.CIMHeartBeat) (*cim.CIMHeartBeat, error) {
	logger.Sugar.Debug("ping")

	heart := &cim.CIMHeartBeat{}
	return heart, nil
}

// 验证token
func (s *AuthRpcServer) AuthToken(ctx context.Context, in *cim.CIMAuthTokenReq) (*cim.CIMAuthTokenRsp, error) {
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

// 查询会话列表
func (s *AuthRpcServer) RecentContactSession(ctx context.Context, in *cim.CIMRecentContactSessionReq) (*cim.CIMRecentContactSessionRsp, error) {
	return nil, nil
}

// 查询历史消息列表
func (s *AuthRpcServer) GetMsgList(ctx context.Context, in *cim.CIMGetMsgListReq) (*cim.CIMGetMsgListRsp, error) {
	return nil, nil
}

// 发消息
func (s *AuthRpcServer) SendMsgData(ctx context.Context, in *cim.CIMMsgData) (*cim.CIMMsgDataAck, error) {
	return nil, nil
}

// 消息收到ACK
func (s *AuthRpcServer) AckMsgData(ctx context.Context, in *cim.CIMMsgDataAck) (*cim.Empty, error) {
	return nil, nil
}
