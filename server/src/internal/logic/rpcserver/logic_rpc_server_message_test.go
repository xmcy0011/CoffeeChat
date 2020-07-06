package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/conf"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"context"
	"github.com/BurntSushi/toml"
	uuid "github.com/satori/go.uuid"
	"google.golang.org/grpc"
	"testing"
	"time"
)

func TestLogicServer_SendMsgData(t *testing.T) {
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

	res, err := clientConn.SendMsgData(ctx, &cim.CIMMsgData{
		FromUserId:  1008,
		ToSessionId: 1009,
		SessionType: cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
		MsgId:       uuid.NewV4().String(),
		MsgType:     cim.CIMMsgType_kCIM_MSG_TYPE_TEXT,
		MsgData:     []byte("test"),
		CreateTime:  int32(time.Now().Unix()),
	})

	if err != nil {
		t.Error(err)
	}

	logger.Sugar.Info("send msg res:", res.String())
}
