package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"google.golang.org/grpc"
	"testing"
	"time"
)

func TestStartRpcServer(t *testing.T) {
	logger.InitLogger("log/log", "debug")

	go StartRpcServer("127.0.0.1", 10600)

	conn, err := grpc.Dial("127.0.0.1:10600", grpc.WithInsecure())
	if err != nil {
		t.Error(err)
	}

	clientConn := cim.NewLogicClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(time.Second*3))
	defer cancel()

	res, err := clientConn.AuthToken(ctx, &cim.CIMAuthTokenReq{
		UserId:        12323,
		NickName:      "test",
		UserToken:     "sdfasdfasdf",
		ClientVersion: "go_test/0.1",
		ClientType:    cim.CIMClientType_kCIM_CLIENT_TYPE_WEB,
	})

	if err != nil {
		t.Error(err)
	}

	logger.Sugar.Info("auth token res:", res.String())
}
