package dao

import (
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/conf"
	"github.com/CoffeeChat/server/src/pkg/db"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"testing"
	"time"
)

func TestSession_AddUserSession(t *testing.T) {
	logger.InitLogger("../../../log/log.log", "debug")
	_, err := toml.DecodeFile("../../../app/logic/logic-example.toml", conf.DefaultLogicConfig)
	if err != nil {
		t.Fatal(err.Error())
	}
	err = db.DefaultManager.Init(conf.DefaultLogicConfig.Db)
	if err != nil {
		t.Fatal(err.Error())
	}

	data := &cim.CIMMsgData{
		FromUserId:  1001, // user 1001
		ToSessionId: 1002, // user 1002
		SessionType: cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
	}

	id1, id2, err := DefaultSession.AddUserSession(data.FromUserId, data.ToSessionId, data.SessionType,
		cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK, false)

	if err != nil {
		t.Fatal(err.Error())
	}

	t.Logf("added success,from user session_id:%d,to user session_id:%d", id1, id2)
}

func TestSession_UpdateUpdated(t *testing.T) {
	logger.InitLogger("../../../log/log.log", "debug")
	_, err := toml.DecodeFile("../../../app/logic/logic-example.toml", conf.DefaultLogicConfig)
	if err != nil {
		t.Fatal(err.Error())
	}
	err = db.DefaultManager.Init(conf.DefaultLogicConfig.Db)
	if err != nil {
		t.Fatal(err.Error())
	}

	data := &cim.CIMMsgData{
		FromUserId:  1009, // user 1001
		ToSessionId: 1002, // user 1002
		SessionType: cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
	}

	t.Logf("insert time is %d", time.Now().Unix())
	id1, id2, err := DefaultSession.AddUserSession(data.FromUserId, data.ToSessionId, data.SessionType,
		cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK, false)

	if err != nil {
		t.Fatal(err.Error())
	}

	time.Sleep(time.Second * 3)
	timeStamp := int(time.Now().Unix())
	err = DefaultSession.UpdateUpdated(id1, timeStamp)
	if err != nil {
		t.Fatal(err.Error())
	}

	err = DefaultSession.UpdateUpdated(id2, timeStamp)
	if err != nil {
		t.Fatal(err.Error())
	}
	t.Logf("update success,new time is :%d", timeStamp)
}
