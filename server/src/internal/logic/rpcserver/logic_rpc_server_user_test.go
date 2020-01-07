package rpcserver

import (
	"context"
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/conf"
	"github.com/CoffeeChat/server/src/pkg/db"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"google.golang.org/grpc"
	"testing"
	"time"
)

func TestLogicServer_CreateUser(t *testing.T) {
	logger.InitLogger("../../../log/log.log", "debug")
	_, err := toml.DecodeFile("../../../app/im_logic/logic-example.toml", conf.DefaultLogicConfig)
	if err != nil {
		t.Fatal(err.Error())
	}

	// init db
	err = db.DefaultManager.Init(conf.DefaultLogicConfig.Db)
	if err != nil {
		t.Fatal(err.Error())
	}

	// init cache
	redis := conf.DefaultLogicConfig.Redis
	err = db.InitCache(redis.Ip, redis.Port, redis.Password, redis.KeyPrefix, redis.Pool)
	if err != nil {
		t.Fatal(err.Error())
	}

	go StartRpcServer("127.0.0.1", 10600)

	conn, err := grpc.Dial("127.0.0.1:10600", grpc.WithInsecure())
	if err != nil {
		t.Error(err)
	}

	clientConn := cim.NewLogicClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()

	res, err := clientConn.CreateUser(ctx, &cim.CreateUserAccountInfo{
		UserId:       1001,
		UserNickName: "小姐姐真美腻",
		//UserNickName: "  ", //test empty
		UserToken:    "123456",
	})

	if err != nil {
		t.Error(err)
	}

	logger.Sugar.Info("create user res:", res.String())
}
