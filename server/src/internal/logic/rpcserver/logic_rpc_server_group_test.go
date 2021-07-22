package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/conf"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"context"
	"github.com/BurntSushi/toml"
	"google.golang.org/grpc"
	"testing"
	"time"
)

const kTestUserId = 12345
const kTestGroupName = "测试群组grpc调用"

func TestLogicServer_CreateGroup(t *testing.T) {
	logger.InitLogger("log/log", "debug")
	_, err := toml.DecodeFile("../../../app/im_logic/logic-example.toml", conf.DefaultLogicConfig)
	if err != nil {
		t.Fatal(err.Error())
	}

	// init db
	err = db.DefaultManager.Init(conf.DefaultLogicConfig.Db)
	if err != nil {
		t.Fatal(err.Error())
	}

	go StartRpcServer("127.0.0.1", 10600)

	conn, err := grpc.Dial("127.0.0.1:10600", grpc.WithInsecure())
	if err != nil {
		t.Error(err)
	}

	clientConn := cim.NewLogicClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(time.Second*3))
	defer cancel()

	// 1
	t.Log("test no memberIdList")
	rsp, err := clientConn.CreateGroup(ctx, &cim.CIMGroupCreateReq{
		UserId:    kTestUserId,
		GroupName: kTestGroupName,
	})
	if err != nil {
		t.Error(err)
		return
	}

	if rsp.ResultCode != uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS) || len(rsp.MemberIdList) <= 0 {
		t.Fail()
	} else {
		t.Logf("test success,memberIdList=%v", rsp.MemberIdList)
	}

	// 2
	t.Log("test have memberIdList")
	ids := make([]uint64, 0)
	ids = append(ids, kTestUserId+1)
	ids = append(ids, kTestUserId+2)
	rsp, err = clientConn.CreateGroup(ctx, &cim.CIMGroupCreateReq{
		UserId:       kTestUserId,
		GroupName:    kTestGroupName,
		MemberIdList: ids,
	})

	if rsp.ResultCode != uint32(cim.CIMErrorCode_kCIM_ERR_SUCCESS) || len(rsp.MemberIdList) <= 0 {
		t.Fail()
	} else {
		t.Logf("test success,memberIdList=%v", rsp.MemberIdList)
	}
}
