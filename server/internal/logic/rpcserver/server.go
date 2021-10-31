package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"google.golang.org/grpc"
	"google.golang.org/grpc/keepalive"
	"net"
	"strconv"
	"time"
)

const kMaxConnectionIdle = 60 * time.Second
const kMaxConnectionAgeGrace = time.Second * 20
const kKeepAliveInterval = time.Second * 60
const kKeepAliveTimeout = time.Second * 20
const kMaxLifeTime = time.Hour * 2

func StartRpcServer(listenIp string, listenPort int) {
	var address = listenIp + ":" + strconv.Itoa(listenPort)
	listener, err := net.Listen("tcp", address)
	if err != nil {
		logger.Sugar.Fatalf("listen on %s error:%s", address, err.Error())
	}
	logger.Sugar.Info("server listen on:", address)

	keepParams := grpc.KeepaliveParams(keepalive.ServerParameters{
		MaxConnectionIdle:     kMaxConnectionIdle,
		MaxConnectionAgeGrace: kMaxConnectionAgeGrace,
		Time:                  kKeepAliveInterval,
		Timeout:               kKeepAliveTimeout,
		MaxConnectionAge:      kMaxLifeTime,
	})
	server := grpc.NewServer(keepParams)
	// logic server
	cim.RegisterLogicServer(server, DefaultLogicRpcServer)

	if err := server.Serve(listener); err != nil {
		logger.Sugar.Fatalf("server.Serve error:", err.Error())
	}
}
