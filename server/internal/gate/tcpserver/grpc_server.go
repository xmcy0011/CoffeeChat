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
func (g *GrpcGateServer) SendMsgData(ctx context.Context, in *cim.CIMMsgData) (*cim.CIMMsgDataAck, error) {
	return nil, nil
}

// 消息收到ACK
func (g *GrpcGateServer) AckMsgData(ctx context.Context, in *cim.CIMMsgDataAck) (*cim.Empty, error) {
	return nil, nil
}

// 停止接收消息
func (g *GrpcGateServer) StopReceivePacket(ctx context.Context, in *cim.Empty) (*cim.Empty, error) {
	return nil, nil
}

// 群成员变更通知
func (g *GrpcGateServer) GroupMemberChanged(ctx context.Context, in *cim.CIMGroupMemberChangedNotify) (*cim.Empty, error) {
	logger.Sugar.Info("GroupMemberChanged groupId:%d,memberId:%v", in.GroupId, in.ChangedList)
	return nil, nil
}
