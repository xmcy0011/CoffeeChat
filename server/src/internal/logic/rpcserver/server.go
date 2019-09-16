package rpcserver

import (
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"google.golang.org/grpc"
	"net"
	"strconv"
)

func StartRpcServer(listenIp string, listenPort int) {
	var address = listenIp + ":" + strconv.Itoa(listenPort)
	listener, err := net.Listen("tcp", address)
	if err != nil {
		logger.Sugar.Fatalf("listen on %s error:%s", address, err.Error())
	}
	logger.Sugar.Info("server listen on:", address)

	server := grpc.NewServer()
	// auth
	cim.RegisterLogicServer(server, DefaultAuthRpcServer)

	if err := server.Serve(listener); err != nil {
		logger.Sugar.Fatalf("server.Serve error:", err.Error())
	}
}
