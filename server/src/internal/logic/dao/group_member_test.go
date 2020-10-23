package dao

import (
	"coffeechat/internal/logic/conf"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"github.com/BurntSushi/toml"
	"testing"
)

const kTestMemberUserId = 12366

func TestGroupMember_Add(t *testing.T) {
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

	t.Log("test incorrect group id")
	err = DefaultGroupMember.Add(kTestGroupId+1, kTestMemberUserId)
	if err == nil {
		t.Fail()
		return
	}

	t.Log("test add")
	err = DefaultGroupMember.Add(kTestGroupId, kTestMemberUserId)
	if err != nil {
		t.Fail()
		return
	}

	isExist, err := DefaultGroupMember.Exist(kTestGroupId, kTestMemberUserId)
	if err != nil || !isExist {
		t.Fail()
	} else {
		t.Log("add success")
	}
}

func TestGroupMember_Del(t *testing.T) {
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

	t.Log("test incorrect group id")
	err = DefaultGroupMember.Del(kTestGroupId+1, kTestMemberUserId)
	if err == nil {
		t.Fail()
		return
	}

	t.Log("test incorrect member id")
	err = DefaultGroupMember.Del(kTestGroupId, kTestMemberUserId+1)
	if err == nil {
		t.Fail()
		return
	}

	t.Log("test")
	err = DefaultGroupMember.Del(kTestGroupId, kTestMemberUserId)
	if err == nil {
		t.Fail()
		return
	}

	isExist, err := DefaultGroupMember.Exist(kTestGroupId, kTestMemberUserId)
	if err != nil || isExist {
		t.Fail()
	} else {
		t.Log("del success")
	}
}

func TestGroupMember_ListGroup(t *testing.T) {
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

	t.Log("test ListGroup")
	ids, err := DefaultGroupMember.ListGroup(kTestMemberUserId)
	if err != nil {
		t.Error(err)
		return
	}

	if len(ids) <= 0 {
		t.Fail()
		return
	}
	t.Logf("test success,%v", ids)
}
