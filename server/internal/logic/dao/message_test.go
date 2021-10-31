package dao

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/conf"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"github.com/BurntSushi/toml"
	"testing"
	"time"
)

func TestMessage_SaveMessage(t *testing.T) {
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

	data := &cim.CIMMsgData{
		FromUserId:  1009, // user 1001
		ToSessionId: 1002, // user 1002
		SessionType: cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
		CreateTime:  int32(time.Now().Unix()),
		MsgType:     cim.CIMMsgType_kCIM_MSG_TYPE_TEXT,
		//MsgData:     []byte("hello cim"),
	}
	msgId, err := DefaultMessage.SaveMessage(data.FromUserId, data.ToSessionId, data.MsgId,
		data.MsgType, data.SessionType, "hello cim", false)
	if err != nil {
		t.Fatal(err.Error())
	}

	t.Logf("save message,msgId=%d", msgId)
}
