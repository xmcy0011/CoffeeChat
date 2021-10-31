package dao

import (
	"coffeechat/internal/logic/model"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"fmt"
	"sync/atomic"
)

type NickGenerate struct {
	LastNameCountV1  atomic.Value
	FirstNameCountV1 atomic.Value
}

var DefaultNickGenerate = &NickGenerate{}

func init() {
	DefaultNickGenerate.LastNameCountV1.Store(0)
	DefaultNickGenerate.FirstNameCountV1.Store(0)
}

const kNickGenerateTableName = "im_nick_generate"

func (n *NickGenerate) QueryLastNameCount(version string) (error, int) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select count(1) from %s where gen_key='lastname_%s'", kNickGenerateTableName, version)
		row := session.QueryRow(sql)
		count := 0
		err := row.Scan(&count)
		if err != nil {
			return err, 0
		}
		return nil, count
	}
	return unConnectError, 0
}

func (n *NickGenerate) QueryFirstNameCount(version string) (error, int) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select count(1) from %s where gen_key='classical_%s'", kNickGenerateTableName, version)
		row := session.QueryRow(sql)
		count := 0
		err := row.Scan(&count)
		if err != nil {
			return err, 0
		}
		return nil, count
	}
	return unConnectError, 0
}

func (n *NickGenerate) Get(id int) (error, *model.NickGenerateModel) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select id,gen_key,gen_value from %s where id = %d and flag=1", kNickGenerateTableName, id)
		row := session.QueryRow(sql)

		nick := &model.NickGenerateModel{}
		err := row.Scan(&nick.Id, &nick.GenKey, &nick.GenValue)
		if err == nil {
			return nil, nick
		} else {
			logger.Sugar.Info("no result for sql:", sql, "err:", err.Error())
			return err, nil
		}
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return unConnectError, nil
}
