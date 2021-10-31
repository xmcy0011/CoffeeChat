package dao

import (
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"errors"
	"fmt"
	"time"
)

const kGroupMemberTable = "im_group_member"

type GroupMember struct {
}

var DefaultGroupMember = &GroupMember{}

// 添加群成员，检查是否存在
// 不去检查用户是否在im_user中存在，因为账号信息可以不托管给IM Server
func (g *GroupMember) Add(groupId uint64, memberId uint64) error {
	session := db.DefaultManager.GetDbMaster()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return unConnectError
	}

	// group check
	_, err := DefaultGroup.Get(groupId)
	if err != nil {
		err = errors.New(fmt.Sprintf("group=%d not exist", groupId))
		logger.Sugar.Warn(err.Error())
		return err
	}

	// member check
	sql := fmt.Sprintf("select count(1) from %s where group_id=%d and user_id=%d",
		kGroupMemberTable, groupId, memberId)
	r := session.QueryRow(sql)
	count := 0
	err = r.Scan(&count)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return err
	}

	timeStamp := time.Now().Unix()
	if count >= 1 {
		// update del_flag
		sql := fmt.Sprintf("update %s set del_flag=0,updated=%d where group_id=%d and user_id=%d",
			kGroupMemberTable, timeStamp, groupId, memberId)
		r, err := session.Exec(sql)
		if err != nil {
			logger.Sugar.Warn(err)
			return err
		}
		count, err := r.RowsAffected()
		if err != nil {
			return err
		}
		if count <= 0 {
			err = errors.New("unknown error")
			logger.Sugar.Warn(err.Error())
			return err
		}
		return nil
	} else {
		// insert
		sql := fmt.Sprintf("insert into %s(group_id,user_id,created,updated) values(%d,%d,%d,%d)",
			kGroupMemberTable, groupId, memberId, timeStamp, timeStamp)
		e, err := session.Exec(sql)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return err
		}

		count, err := e.RowsAffected()
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return err
		}

		if count <= 0 {
			return errors.New("unknown error")
		}
	}
	return nil
}

// 删除群成员，不检查是否存在
func (g *GroupMember) Del(groupId uint64, memberId uint64) error {
	session := db.DefaultManager.GetDbMaster()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return unConnectError
	}

	isExist, err := g.Exist(groupId, memberId)
	if err != nil {
		return err
	}

	if !isExist {
		err = errors.New(fmt.Sprintf("group or member not exist,group=%d,member=%d", groupId, memberId))
		logger.Sugar.Warnf(err.Error())
		return err
	}

	sql := fmt.Sprintf("update %s set del_flag=1 where group_id=%d and user_id=%d", kGroupMemberTable, groupId, memberId)
	r, err := session.Exec(sql)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return err
	}

	row, err := r.RowsAffected()
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return err
	}

	if row <= 0 {
		logger.Sugar.Warn("Del update success but RowsAffected count = 0")
	}
	return nil
}

// 群成员是否已存在
func (g *GroupMember) Exist(groupId, memberId uint64) (bool, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return false, unConnectError
	}

	sql := fmt.Sprintf("select count(1) from %s where group_id=%d and user_id=%d and del_flag=0",
		kGroupMemberTable, groupId, memberId)
	r := session.QueryRow(sql)
	count := 0
	err := r.Scan(&count)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return false, err
	}

	return count >= 1, nil
}

// 查询所在群列表
func (g *GroupMember) ListGroup(memberId uint64) ([]uint64, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return nil, unConnectError
	}

	sql := fmt.Sprintf("select group_id from %s where user_id=%d and del_flag=0", kGroupMemberTable, memberId)
	rows, err := session.Query(sql)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return nil, err
	}

	groupIdArr := make([]uint64, 0)
	for rows.Next() {
		id := uint64(0)
		err := rows.Scan(&id)
		if err == nil {
			groupIdArr = append(groupIdArr, id)
		}
	}
	return groupIdArr, nil
}

// 查询群成员列表
func (g *GroupMember) ListMember(groupId uint64) ([]uint64, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return nil, unConnectError
	}

	sql := fmt.Sprintf("select user_id from %s where group_id=%d and del_flag=0", kGroupMemberTable, groupId)
	rows, err := session.Query(sql)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return nil, err
	}

	memberIdArr := make([]uint64, 0)
	for rows.Next() {
		id := uint64(0)
		err := rows.Scan(&id)
		if err == nil {
			memberIdArr = append(memberIdArr, id)
		}
	}
	return memberIdArr, nil
}
