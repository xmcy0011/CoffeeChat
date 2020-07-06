package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/gate/conf"
	"coffeechat/pkg/logger"
	"context"
	"google.golang.org/grpc"
	"net"
	"strconv"
)

type GrpcGateServer struct {
}

var DefaultGateServer = &GrpcGateServer{}

func StartGrpcServer() {
	var address = conf.DefaultConfig.ListenIpGrpc + ":" + strconv.Itoa(conf.DefaultConfig.ListenPortGrpc)
	listener, err := net.Listen("tcp", address)
	if err != nil {
		logger.Sugar.Fatalf("grpc gate listen on %s error:%s", address, err.Error())
	}
	logger.Sugar.Info("grpc gate server listen on:", address)

	server := grpc.NewServer()
	// gate server
	cim.RegisterGateServer(server, DefaultGateServer)

	if err := server.Serve(listener); err != nil {
		logger.Sugar.Fatalf("server.Serve error:", err.Error())
	}
}

// ping
func (g *GrpcGateServer) Ping(ctx context.Context, in *cim.CIMHeartBeat) (*cim.CIMHeartBeat, error) {
	logger.Sugar.Debug("ping")

	heart := &cim.CIMHeartBeat{}
	return heart, nil
}

// 发消息
func (g *GrpcGateServer) SendMsgData(ctx context.Context, in *cim.CIMInternalMsgData) (*cim.Empty, error) {
	logger.Sugar.Info("SendMsgData ,from:%d,to:%d,sessionType:%d,msgType:%d,msgTime:%d", in.MsgData.FromUserId,
		in.MsgData.ToSessionId, in.MsgData.SessionType, in.MsgData.MsgType, in.MsgData.CreateTime)

	// send to peer
	if in.MsgData.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		user := DefaultUserManager.FindUser(in.MsgData.ToSessionId)
		if user != nil {
			user.BroadcastMessage(in.MsgData)
		}
	}
	return nil, nil
}

// 消息已读ACK通知
func (g *GrpcGateServer) AckMsgData(ctx context.Context, in *cim.CIMInternalMsgDataReadNotify) (*cim.Empty, error) {
	return nil, nil
}

// 停止接收消息
func (g *GrpcGateServer) StopReceivePacket(ctx context.Context, in *cim.Empty) (*cim.Empty, error) {
	return nil, nil
}
