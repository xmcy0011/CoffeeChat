package dao

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	sql2 "database/sql"
	"errors"
	"fmt"
	"time"
)

const kGroupTableName = "im_group"
const KGroupCurrentVersion = 1

type Group struct {
}

var DefaultGroup = &Group{}

// 创建群
func (g *Group) Add(groupName string, ownerId uint64, userCount int) (*cim.CIMGroupInfo, error) {
	session := db.DefaultManager.GetDbMaster()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return nil, unConnectError
	}

	info := &cim.CIMGroupInfo{
		GroupName:     groupName,
		GroupOwnerId:  ownerId,
		CreateTime:    uint32(time.Now().Unix()),
		UpdateTime:    uint32(time.Now().Unix()),
		Announcement:  "",
		GroupIntro:    "",
		GroupAvatar:   "",
		GroupType:     cim.CIMGroupType_kCIM_GROUP_TYPE_GROUP_NORMAL,               // 默认群
		JoinModel:     cim.CIMGroupJoinModel_kCIM_GROUP_JOIN_MODEL_DEFAULT,         // 所有人可邀请
		BeInviteModel: cim.CIMGroupBeInviteMode_kCIM_GROUP_BE_INVITE_MODEL_DEFAULT, // 不需要同意
		MuteModel:     cim.CIMGroupMuteModel_kCIM_GROUP_MUTE_MODEL_DEFAULT,         // 不禁言
	}

	lastChatTime := time.Now().Unix()
	sql := fmt.Sprintf("insert into %s(group_name,group_version,create_user_id,owner,announcement,intro,avatar,type,"+
		"join_model,be_invite_model,mute_model,last_chat_time,user_cnt,created,updated) values('%s',%d,%d,%d,'%s','%s','%s',"+
		"%d,%d,%d,%d,%d,%d,%d,%d)",
		kGroupTableName, groupName, KGroupCurrentVersion, ownerId, ownerId, "", "", "",
		info.GroupType, info.JoinModel, info.BeInviteModel, info.MuteModel, lastChatTime, userCount, info.CreateTime, info.UpdateTime)
	r, err := session.Exec(sql)
	if err != nil {
		logger.Sugar.Warnf(err.Error())
		return nil, err
	}

	// get insert group id
	id, err := r.LastInsertId()
	if err != nil {
		logger.Sugar.Warnf(err.Error())
		return nil, err
	}

	info.GroupId = uint64(id)
	return info, nil
}

// 逻辑删除群
func (g *Group) Del(ownerId, groupId uint64) error {
	session := db.DefaultManager.GetDbMaster()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return unConnectError
	}

	// check ownerId and group
	sql := fmt.Sprintf("select count(1) from %s where group_id=%d and owner=%d and del_flag=0", kGroupTableName, groupId, ownerId)
	r := session.QueryRow(sql)
	count := 0
	err := r.Scan(&count)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return err
	}

	if count > 0 {
		sql = fmt.Sprintf("update %s set del_flag=1 where group_id=%d", kGroupTableName, groupId)
		eff, err := session.Exec(sql)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return err
		}

		count, err := eff.RowsAffected()
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return err
		}

		if count != 1 {
			logger.Sugar.Warn("update more than one, count:", count)
		}
		return nil
	}

	err = errors.New(fmt.Sprintf("group=%d not exist or user=%d is not group owner", groupId, ownerId))
	logger.Sugar.Warn(err.Error())
	return err
}

// 获取群主ID
func (g *Group) GetOwnerId(groupId uint64) (uint64, error) {
	session := db.DefaultManager.GetDBSlave()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return 0, unConnectError
	}

	sql := fmt.Sprintf("select owner from %s where group_id=%d and del_flag=0", kGroupTableName, groupId)
	row := session.QueryRow(sql)

	ownerId := uint64(0)
	err := row.Scan(&ownerId)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return 0, err
	}
	return ownerId, nil
}

// 变更群主
//func (g *Group) ChangeOwner(groupId, ownerId uint64) error {
//	session := db.DefaultManager.GetDbMaster()
//	if session == nil {
//		logger.Sugar.Error("no db connect for slave")
//		return unConnectError
//	}
//
//	sql := fmt.Sprintf("update %s set owner=%d where group_id=%d", kGroupTableName, ownerId, groupId)
//	r, err := session.Exec(sql)
//	if err != nil {
//		return err
//	}
//
//	count, err := r.RowsAffected()
//	if err != nil {
//		return err
//	}
//
//	if count <= 0 {
//		return errors.New("unknown error")
//	}
//	return nil
//}

// 详情
func (g *Group) Get(groupId uint64) (*cim.CIMGroupInfo, error) {
	session := db.DefaultManager.GetDbMaster()
	if session == nil {
		logger.Sugar.Error("no db connect for slave")
		return nil, unConnectError
	}

	info := &cim.CIMGroupInfo{}

	sql := fmt.Sprintf("select group_name,owner,announcement,intro,avatar,"+
		"type,join_model,be_invite_model,mute_model,created,updated from %s where group_id=%d and del_flag=0", kGroupTableName, groupId)
	row := session.QueryRow(sql)

	var ant sql2.NullString
	var intro sql2.NullString

	err := row.Scan(&info.GroupName, &info.GroupOwnerId, &ant, &intro, &info.GroupAvatar,
		&info.GroupType, &info.JoinModel, &info.BeInviteModel, &info.MuteModel, &info.CreateTime, &info.UpdateTime)
	if err != nil {
		return nil, err
	}
	info.GroupId = groupId
	if ant.Valid {
		info.Announcement = ant.String
	}
	if intro.Valid {
		info.GroupIntro = intro.String
	}

	return info, nil
}
