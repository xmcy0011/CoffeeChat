package dao

import (
	"errors"
	"fmt"
	"github.com/CoffeeChat/server/src/internal/logic/model"
	"github.com/CoffeeChat/server/src/pkg/db"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"time"
)

const kUserTableName = "im_user"

type User struct {
}

var DefaultUser = &User{}
var unConnectError = errors.New("dbSlave not connected")

// 查询用户信息
func (u *User) Get(userId uint64) *model.UserModel {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select id,user_id,user_nick_name,user_token,user_attach,created,updated from "+
			"%s where user_id = %d", kUserTableName, userId)
		row := session.QueryRow(sql)

		userInfo := &model.UserModel{}
		err := row.Scan(userInfo.Id, userInfo.UserId, userInfo.UserNickName, userInfo.UserToken, userInfo.UserAttach,
			userInfo.Created, userInfo.Updated)
		if err != nil {
			return userInfo
		} else {
			logger.Sugar.Info("no result for sql:", sql)
		}
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return nil
}

// 验证用户id和口令
func (u *User) Validate(userId uint64, userToken string) (bool, error) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select count(1) from %s where user_id=? and user_token=?", kUserTableName)
		row := session.QueryRow(sql, userId, userToken)

		userCount := 0
		err := row.Scan(&userCount)
		if err != nil {
			logger.Sugar.Error("Validate error:", err.Error())
			return false, err
		} else if userCount > 0 {
			return true, nil
		} else {
			logger.Sugar.Infof("no result for sql,userId=%d,userToken=%s", userId, userToken)
		}
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return false, unConnectError
}

// 用户信息
func (u *User) Add(userId uint64, userNickName, userToken string) error {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return unConnectError
	}

	// check exist
	sql := fmt.Sprintf("select count(1) from %s where user_id=%d", kUserTableName, userId)
	row := session.QueryRow(sql)

	count := int64(0)
	if err := row.Scan(&count); err != nil {
		logger.Sugar.Warnf("QueryRow error:%d,userId=%d", userId)
		return err
	} else if count > 0 {
		logger.Sugar.Warnf("user already exist,userId=%d", userId)
		return errors.New("user already exist")
	}

	// insert
	sql = fmt.Sprintf("insert into %s(user_id,user_nick_name,user_token,created) values(%d,'%s','%s',%d)",
		kUserTableName, userId, userNickName, userToken, time.Now().Unix())
	r, err := session.Exec(sql)
	if err != nil {
		logger.Sugar.Warn("Exec error:", err.Error())
		return err
	}
	count, err = r.RowsAffected()
	if err != nil {
		logger.Sugar.Warnf("RowsAffected error:%s ", err.Error())
		return err
	} else {
		if count > 0 {
			return nil
		} else {
			logger.Sugar.Warn("unknown error, no effect row")
			return errors.New("unknown error, no effect row")
		}
	}
}
