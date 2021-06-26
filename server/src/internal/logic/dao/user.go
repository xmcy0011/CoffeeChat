package dao

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/model"
	"coffeechat/pkg/db"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"crypto/md5"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"time"
)

const kUserTableName = "im_user"
const kUserRandomListLimit = 50

type User struct {
}

var DefaultUser = &User{}
var unConnectError = errors.New("dbSlave not connected")

// 查询用户信息
func (u *User) Get(userId uint64) *model.UserModel {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select id,user_nick_name,user_token,user_attach,created,updated from "+
			"%s where id = %d", kUserTableName, userId)
		row := session.QueryRow(sql)

		userInfo := &model.UserModel{}
		err := row.Scan(&userInfo.UserId, &userInfo.UserNickName, &userInfo.UserToken, &userInfo.UserAttach,
			&userInfo.Created, &userInfo.Updated)
		if err == nil {
			return userInfo
		} else {
			logger.Sugar.Info("no result for sql:", sql, "err:", err.Error())
		}
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return nil
}

func (u *User) GetByUserName(userName string) *model.UserModel {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select id,user_nick_name,user_token,user_attach,user_pwd_salt,user_pwd_hash,"+
			"created,updated from %s where user_name = '%s'",
			kUserTableName, userName)
		row := session.QueryRow(sql)

		userInfo := &model.UserModel{UserName: userName}
		err := row.Scan(&userInfo.UserId, &userInfo.UserNickName, &userInfo.UserToken,
			&userInfo.UserAttach, &userInfo.UserPwdSalt, &userInfo.UserPwdHash, &userInfo.Created, &userInfo.Updated)
		if err == nil {
			return userInfo
		} else {
			//logger.Sugar.Info("no result for sql:", sql, "err:", err.Error())
		}
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return nil
}

// 批量查询用户信息
func (u *User) GetBatch(ids []uint64) ([]*model.UserModel, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		return nil, def.DBSlaveUnConnectError
	}

	sql := fmt.Sprintf("select id,user_nick_name,user_attach,created,updated from "+
		"%s where", kUserTableName)
	for index, v := range ids {
		if index+1 == len(ids) {
			sql += fmt.Sprintf(" id = %d", v)
		} else {
			sql += fmt.Sprintf(" id = %d or", v)
		}
	}

	rows, err := session.Query(sql)
	if err != nil {
		return nil, err
	}

	users := make([]*model.UserModel, 0)
	for {
		if !rows.Next() {
			break
		}
		user := &model.UserModel{}
		err := rows.Scan(&user.UserId, &user.UserNickName, &user.UserAttach, &user.Created, &user.Updated)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			continue
		}
		users = append(users, user)
	}

	return users, nil
}

// 验证用户id和口令
func (u *User) Validate(userId uint64, userToken string) (bool, error) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select count(1) from %s where id=? and user_token=?", kUserTableName)
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

// 验证用户名和密码
func (u *User) Validate2(userName, userPwd string) (bool, *model.UserModel) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		// select pwdSalt and pwdHash
		sql := fmt.Sprintf("select id,user_pwd_salt,user_pwd_hash,user_nick_name,user_attach from %s where user_name=?", kUserTableName)
		row := session.QueryRow(sql, userName)

		user := &model.UserModel{}
		err := row.Scan(&user.UserId, &user.UserPwdSalt, &user.UserPwdHash, &user.UserNickName, &user.UserAttach)
		if err != nil {
			logger.Sugar.Error("Validate failed, user_name could not exist, error:", err.Error())
			return false, nil
		} else {
			// calc pwdHash
			inPwdHash := GetPwdHash(userPwd, user.UserPwdSalt)
			if inPwdHash == user.UserPwdHash {
				return true, user
			}
			// userName and pwd not math
			return false, nil
		}
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return false, nil
}

//返回一个32位md5加密后的字符串
func GetPwdHash(pwd, salt string) string {
	// md5(md5(pwd)+salt)

	h := md5.New()
	h.Write([]byte(pwd))
	tempHash := hex.EncodeToString(h.Sum(nil))

	h.Reset()
	h.Write([]byte(tempHash + salt))
	tempHash = hex.EncodeToString(h.Sum(nil))

	return tempHash
}

// 用户信息
func (u *User) Add(userName, userNickName, userPwd string) (int64, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return 0, unConnectError
	}

	// check exist
	sql := fmt.Sprintf("select count(1) from %s where user_name='%s'", kUserTableName, userName)
	row := session.QueryRow(sql)

	count := int64(0)
	if err := row.Scan(&count); err != nil {
		logger.Sugar.Warnf("QueryRow error:%d,user_name=%d", userName)
		return 0, err
	} else if count > 0 {
		logger.Sugar.Warnf("user already exist,user_name=%d", userName)
		return 0, errors.New("user already exist")
	}

	// build 32 bytes salt
	saltArr := make([]byte, 32)
	if _, err := rand.Reader.Read(saltArr); err != nil {
		logger.Sugar.Warn("build random salt error:", err.Error())
		return 0, err
	}
	salt := hex.EncodeToString(saltArr)

	// calc pwdHash,md5(md5(pwd)+salt)
	pwdHash := GetPwdHash(userPwd, salt)

	logger.Sugar.Infof("userName:%s,userPwdSalt:%s,userPwdHash:%s", userName, salt, pwdHash)

	// insert
	sql = fmt.Sprintf("insert into %s(user_name,user_pwd_salt,user_pwd_hash,user_nick_name,"+
		"user_token,user_attach,created,updated) values('%s','%s','%s','%s','','',%d,%d)",
		kUserTableName, userName, salt, pwdHash, userNickName, time.Now().Unix(), time.Now().Unix())
	r, err := session.Exec(sql)
	if err != nil {
		logger.Sugar.Warn("Exec error:", err.Error())
		return 0, err
	}
	userId, err := r.LastInsertId()
	if err != nil {
		logger.Sugar.Warnf("RowsAffected error:%s ", err.Error())
		return 0, err
	} else {
		if userId > 0 {
			return userId, nil
		} else {
			logger.Sugar.Warn("unknown error, no effect row")
			return 0, errors.New("unknown error, no effect row")
		}
	}
}

// 更新用户信息
func (u *User) Update(userId uint64, userNickName string) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return
	}

	sql := fmt.Sprintf("update %s set user_nick_name=?,updated=? where id=?", kUserTableName)
	_, err := session.Exec(sql, userNickName, time.Now().Unix(), userId)
	if err != nil {
		logger.Sugar.Error("update user error:", err.Error())
	} else {
		logger.Sugar.Debugf("update user_nick_name success userId=%d", userId)
	}
}

// 查询系统用户列表，按照创建时间取最新的50个
func (u *User) ListRandom(userId uint64) ([]*cim.CIMUserInfo, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return nil, unConnectError
	}

	sql := fmt.Sprintf("select id,user_nick_name from %s where id!=%d order by created desc limit %d",
		kUserTableName, userId, kUserRandomListLimit)
	rows, err := session.Query(sql)
	if err != nil {
		logger.Sugar.Error(err.Error())
		return nil, err
	}

	userList := make([]*cim.CIMUserInfo, 0)

	for {
		if !rows.Next() {
			break
		}
		user := &cim.CIMUserInfo{}
		err := rows.Scan(&user.UserId, &user.NickName)
		if err != nil {
			logger.Sugar.Info(err.Error())
		} else {
			userList = append(userList, user)
		}
	}

	return userList, nil
}
