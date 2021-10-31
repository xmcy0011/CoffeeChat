package dao

import (
	"coffeechat/internal/logic/conf"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"github.com/BurntSushi/toml"
	"testing"
)

const kTestGroupName = "测试群组1"
const kTestOwnerId = 12345
const kTestGroupId = 2

func TestGroup_Add(t *testing.T) {
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

	info, err := DefaultGroup.Add(kTestGroupName, kTestOwnerId, 2)
	if err != nil {
		t.Fatal(err.Error())
	}

	t.Logf("create group,id=%d", info.GroupId)
}

func TestGroup_Del(t *testing.T) {
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

	t.Logf("test del incorrect group")
	err = DefaultGroup.Del(kTestOwnerId, kTestGroupId+1)
	if err == nil {
		t.Fail()
		return
	}

	t.Logf("test del incorrect owner group")
	err = DefaultGroup.Del(kTestOwnerId+1, kTestGroupId)
	if err == nil {
		t.Fail()
		return
	}

	t.Logf("test del group")
	err = DefaultGroup.Del(kTestOwnerId, kTestGroupId)
	if err != nil {
		t.Fail()
	} else {
		t.Logf("del group,id=%d", kTestGroupId)
	}
}

func TestGroup_GetOwnerId(t *testing.T) {
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

	id, err := DefaultGroup.GetOwnerId(kTestGroupId)
	if err != nil {
		t.Fail()
		return
	}
	t.Logf("group_id=%d owner=%d", kTestGroupId, id)

	if id != kTestOwnerId {
		t.Fail()
	}
}

func TestGroup_Get(t *testing.T) {
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

	info, err := DefaultGroup.Get(kTestGroupId)
	if err != nil {
		t.Fail()
		return
	}

	t.Logf("groupInfo=%v", info)

	if info == nil || info.GroupName != kTestGroupName {
		t.Fail()
	}
}
