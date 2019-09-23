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

func TestMessage_SaveMessage(t *testing.T) {
	logger.InitLogger("../../../log/log.log", "debug")
	_, err := toml.DecodeFile("../../../app/logic/logic-example.toml", conf.DefaultLogicConfig)
	if err != nil {
		t.Fatal(err.Error())
	}

	// init db
	err = db.DefaultManager.Init(conf.DefaultLogicConfig.Db)
	if err != nil {
		t.Fatal(err.Error())
	}

	// init cache
	err = db.InitCache()
	if err != nil {
		t.Fatal(err.Error())
	}

	data := &cim.CIMMsgData{
		FromUserId:  1009, // user 1001
		ToSessionId: 1002, // user 1002
		SessionType: cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
		CreateTime:  int32(time.Now().Unix()),
		MsgType:     cim.CIMMsgType_kCIM_MSG_TYPE_TEXT,
		//MsgData:     []byte("hello cim"),
	}
	msgId, err := DefaultMessage.SaveMessage(data.FromUserId, data.ToSessionId, data.MsgId, data.CreateTime,
		data.MsgType, data.SessionType, "hello cim")
	if err != nil {
		t.Fatal(err.Error())
	}

	t.Logf("save message,msgId=%d", msgId)
}
