package dao

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/model"
	"coffeechat/pkg/db"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"encoding/json"
	"errors"
	"fmt"
	uuid "github.com/satori/go.uuid"
	"sort"
	"strconv"
	"time"
)

const kRedisKeyGroupMsgId = "msg_id_group"
const KRedisKeySingleMsgId = "msg_id_single"
const kIMMessageSendTableName = "im_message_send_"
const kIMMessageRecvTableName = "im_message_recv_"
const kIMMessageTableCount = 4

type Message struct {
}

// 系统通知
type CIMMsgNotification struct {
	NotificationType int         `json:"notificationType"`
	Data             interface{} `json:"data"`
}

// 创建群系统通知
type CIMMsgNotificationCreateGroup struct {
	GroupId   string   `json:"groupId"`
	GroupName string   `json:"groupName"`
	Owner     string   `json:"owner"`
	OwnerNick string   `json:"ownerNick"`
	Ids       []string `json:"ids"`
	NickNames []string `json:"nickNames"`
}

// 群拉人通知
type CIMMsgNotificationBeInvite struct {
	GroupId string   `json:"groupId"`
	UserId  string   `json:"userId"`
	Ids     []string `json:"ids"`
}

var DefaultMessage = &Message{}

// if redis not connected then will failed
func (m *Message) IncrMsgIdGroup(groupId uint64) (int64, error) {
	conn := db.DefaultRedisPool.GetMsgIdPool()
	key := fmt.Sprintf("%s_%d", kRedisKeyGroupMsgId, groupId)
	return conn.Incr(key).Result()
}
func (m *Message) IncrMsgIdSingle(userId uint64, peerId uint64) (int64, error) {
	conn := db.DefaultRedisPool.GetMsgIdPool()
	key := ""
	if userId < peerId {
		key = fmt.Sprintf("%s_%d_%d", KRedisKeySingleMsgId, userId, peerId)
	} else {
		key = fmt.Sprintf("%s_%d_%d", KRedisKeySingleMsgId, peerId, userId)
	}
	return conn.Incr(key).Result()
}
func (m *Message) GetMsgIdSingle(userId uint64, peerId uint64) (int64, error) {
	conn := db.DefaultRedisPool.GetMsgIdPool()
	key := ""
	if userId < peerId {
		key = fmt.Sprintf("%s_%d_%d", KRedisKeySingleMsgId, userId, peerId)
	} else {
		key = fmt.Sprintf("%s_%d_%d", KRedisKeySingleMsgId, peerId, userId)
	}
	v, err := conn.Get(key).Result()
	if err != nil {
		return 0, err
	}
	id, err := strconv.ParseUint(v, 10, 64)
	if err != nil {
		return 0, err
	}
	return int64(id), nil
}
func (m *Message) GetMsgIdGroup(groupId uint64) (int64, error) {
	key := fmt.Sprintf("%s_%d", kRedisKeyGroupMsgId, groupId)
	conn := db.DefaultRedisPool.GetMsgIdPool()
	v, err := conn.Get(key).Result()
	if err != nil {
		return 0, err
	}
	id, err := strconv.ParseUint(v, 10, 64)
	if err != nil {
		return 0, err
	}
	return int64(id), nil
}

// 查询某条消息详情
func (m *Message) GetMessageSingle(msgId uint64, fromId, toId uint64) (*model.MessageModel, error) {
	tableName := fmt.Sprintf("%s%d", kIMMessageRecvTableName, toId%kIMMessageTableCount)
	dbSlave := db.DefaultManager.GetDBSlave()
	if dbSlave == nil {
		logger.Sugar.Error("no db connect for master")
		return nil, def.DefaultError
	}

	sql := fmt.Sprintf("select id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
		"msg_res_code,msg_feature,msg_status,created,updated from %s where msg_id=%d and from_id=%d and to_id=%d",
		tableName, msgId, fromId, toId)
	row := dbSlave.QueryRow(sql)
	msgInfo := &model.MessageModel{}
	err := row.Scan(&msgInfo.Id, &msgInfo.ClientMsgId, &msgInfo.FromId, &msgInfo.ToId, &msgInfo.GroupId, &msgInfo.MsgType,
		&msgInfo.MsgContent, &msgInfo.MsgResCode, &msgInfo.MsgFeature, &msgInfo.MsgStatus, &msgInfo.Created, &msgInfo.Updated)
	if err != nil {
		//logger.Sugar.Error(err.Error(), ",with sql:", sql)
		return nil, err
	}
	msgInfo.MsgId = msgId
	return msgInfo, nil
}
func (m *Message) GetMessageGroup(msgId uint64, groupId uint64) (*model.MessageModel, error) {
	tableName := fmt.Sprintf("%s%d", kIMMessageRecvTableName, groupId%kIMMessageTableCount)
	dbSlave := db.DefaultManager.GetDBSlave()
	if dbSlave == nil {
		logger.Sugar.Error("no db connect for master")
		return nil, def.DefaultError
	}

	sql := fmt.Sprintf("select id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
		"msg_res_code,msg_feature,msg_status,created,updated from %s where msg_id=%d and group_id=%d",
		tableName, msgId, groupId)
	row := dbSlave.QueryRow(sql)
	msgInfo := &model.MessageModel{}
	err := row.Scan(&msgInfo.Id, &msgInfo.ClientMsgId, &msgInfo.FromId, &msgInfo.ToId, &msgInfo.GroupId, &msgInfo.MsgType,
		&msgInfo.MsgContent, &msgInfo.MsgResCode, &msgInfo.MsgFeature, &msgInfo.MsgStatus, &msgInfo.Created, &msgInfo.Updated)
	if err != nil {
		//logger.Sugar.Error(err.Error(), ",with sql:", sql)
		return nil, err
	}
	msgInfo.MsgId = msgId
	return msgInfo, nil
}
func (m *Message) queryMsgId(msgId string, tableName string) int64 {
	dbMaster := db.DefaultManager.GetDbMaster()
	if dbMaster != nil {
		row := dbMaster.QueryRow("select msg_id from %s where client_msg_id=%s", tableName, msgId)
		if row != nil {
			var msgId int64 = 0
			_ = row.Scan(&msgId)
			return msgId
		}
	}
	return 0
}

// 查询历史消息
func (m *Message) GetMsgList(userId uint64, sessionId uint64, sessionType cim.CIMSessionType,
	endMsgId uint64, limitCount uint32) ([]*model.MessageModel, error) {
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		return m.getSingleMsgList(userId, sessionId, endMsgId, limitCount)
	} else if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
		return m.getGroupMsgList(sessionId, endMsgId, limitCount)
	}

	err := errors.New(fmt.Sprintf("GetMsgList not support sessionType:%d,userId:%d,sessionId:%d", sessionType, userId, sessionId))
	return nil, err
}
func (m *Message) getSingleMsgList(userId uint64, sessionId uint64, endMsgId uint64, limitCount uint32) ([]*model.MessageModel, error) {
	tableNameA := fmt.Sprintf("%s%d", kIMMessageSendTableName, userId%kIMMessageTableCount)
	tableNameB := fmt.Sprintf("%s%d", kIMMessageSendTableName, sessionId%kIMMessageTableCount)

	dbSlave := db.DefaultManager.GetDBSlave()
	if dbSlave != nil {
		msgArr := make([]*model.MessageModel, 0)
		// 查询A发送的消息
		sql := ""
		if endMsgId == 0 {
			sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
				"msg_res_code,msg_feature,msg_status,created,updated from %s"+
				" force index(ix_fromId_toId_msgStatus_created)"+
				" where from_id=%d and to_id=%d"+
				" order by msg_id desc,created limit %d",
				tableNameA, userId, sessionId, limitCount)
		} else {
			sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
				"msg_res_code,msg_feature,msg_status,created,updated from %s"+
				" force index(ix_fromId_toId_msgStatus_created)"+
				" where from_id=%d and to_id=%d and msg_id<%d"+
				" order by msg_id desc,created limit %d",
				tableNameA, userId, sessionId, endMsgId, limitCount)
		}

		rowA, err := dbSlave.Query(sql)
		if err != nil {
			logger.Sugar.Error(err.Error())
			return nil, err
		} else {
			for rowA.Next() {
				msgInfo := &model.MessageModel{}
				err := rowA.Scan(&msgInfo.MsgId, &msgInfo.ClientMsgId, &msgInfo.FromId, &msgInfo.ToId, &msgInfo.GroupId, &msgInfo.MsgType,
					&msgInfo.MsgContent, &msgInfo.MsgResCode, &msgInfo.MsgFeature, &msgInfo.MsgStatus, &msgInfo.Created, &msgInfo.Updated)
				if err != nil {
					logger.Sugar.Error(err.Error())
					return nil, err
				}
				msgArr = append(msgArr, msgInfo)
			}

			// 查询B发送的消息
			if endMsgId == 0 {
				sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
					"msg_res_code,msg_feature,msg_status,created,updated from %s"+
					" force index(ix_fromId_toId_msgStatus_created)"+
					" where from_id=%d and to_id=%d"+
					" order by msg_id desc,created limit %d",
					tableNameB, sessionId, userId, limitCount)
			} else {
				sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
					"msg_res_code,msg_feature,msg_status,created,updated from %s "+
					" force index(ix_fromId_toId_msgStatus_created)"+
					" where from_id=%d and to_id=%d and msg_id<%d"+
					" order by msg_id desc,created limit %d",
					tableNameB, sessionId, userId, endMsgId, limitCount)
			}
			rowB, err := dbSlave.Query(sql)
			if err != nil {
				logger.Sugar.Error(err.Error())
				return nil, err
			}

			for rowB.Next() {
				msgInfo := &model.MessageModel{}
				err := rowB.Scan(&msgInfo.MsgId, &msgInfo.ClientMsgId, &msgInfo.FromId, &msgInfo.ToId, &msgInfo.GroupId, &msgInfo.MsgType,
					&msgInfo.MsgContent, &msgInfo.MsgResCode, &msgInfo.MsgFeature, &msgInfo.MsgStatus, &msgInfo.Created, &msgInfo.Updated)
				if err != nil {
					logger.Sugar.Error(err.Error())
					return nil, err
				}
				msgArr = append(msgArr, msgInfo)
			}
		}

		// 从小到大升序排序（最新消息放最后，符合自然浏览顺序）
		sort.Slice(msgArr, func(i, j int) bool {
			//return msgArr[i].Created < msgArr[j].Created && msgArr[i].MsgId < msgArr[j].MsgId
			// fixed 2020.01.11 对话顺序问题
			return msgArr[i].MsgId < msgArr[j].MsgId
		})

		// 返回部分
		if len(msgArr) > int(limitCount) {
			return msgArr[len(msgArr)-int(limitCount):], nil
		} else {
			return msgArr, nil
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return nil, def.DefaultError
}
func (m *Message) getGroupMsgList(sessionId uint64, endMsgId uint64, limitCount uint32) ([]*model.MessageModel, error) {
	dbSlave := db.DefaultManager.GetDBSlave()
	if dbSlave == nil {
		return nil, def.DBSlaveUnConnectError
	}

	tableName := fmt.Sprintf("%s%d", kIMMessageRecvTableName, sessionId%kIMMessageTableCount)
	// 查询A发送的消息
	sql := ""
	if endMsgId == 0 {
		sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
			"msg_res_code,msg_feature,msg_status,created,updated from %s"+
			" force index(ix_fromId_toId_msgStatus_created)"+
			" where group_id=%d"+
			" order by msg_id desc,created limit %d",
			tableName, sessionId, limitCount)
	} else {
		sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
			"msg_res_code,msg_feature,msg_status,created,updated from %s"+
			" force index(ix_fromId_toId_msgStatus_created)"+
			" where group_id=%d and msg_id<%d"+
			" order by msg_id desc,created limit %d",
			tableName, sessionId, endMsgId, limitCount)
	}

	row, err := dbSlave.Query(sql)
	if err != nil {
		logger.Sugar.Error(err.Error())
		return nil, err
	}

	msgArr := make([]*model.MessageModel, 0)
	for row.Next() {
		msgInfo := &model.MessageModel{}
		err := row.Scan(&msgInfo.MsgId, &msgInfo.ClientMsgId, &msgInfo.FromId, &msgInfo.ToId, &msgInfo.GroupId, &msgInfo.MsgType,
			&msgInfo.MsgContent, &msgInfo.MsgResCode, &msgInfo.MsgFeature, &msgInfo.MsgStatus, &msgInfo.Created, &msgInfo.Updated)
		if err != nil {
			logger.Sugar.Error(err.Error())
			return nil, err
		}
		msgArr = append(msgArr, msgInfo)
	}

	// 从小到大升序排序（最新消息放最后，符合自然浏览顺序）
	sort.Slice(msgArr, func(i, j int) bool {
		return msgArr[i].MsgId < msgArr[j].MsgId
	})

	return msgArr, nil
}

// 存储消息
func (m *Message) SaveMessage(fromId uint64, toId uint64, clientMsgId string,
	msgType cim.CIMMsgType, sessionType cim.CIMSessionType, msgData string, isToRobot bool) (uint64, error) {
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		return m.saveSingleMessage(fromId, toId, clientMsgId, msgType, msgData, isToRobot)
	} else if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
		return m.saveGroupMessage(fromId, toId, clientMsgId, msgType, msgData)
	} else {
		return 0, def.DefaultError
	}
}
func (m *Message) saveSingleMessage(fromId uint64, toId uint64, clientMsgId string,
	msgType cim.CIMMsgType, msgData string, isToRobot bool) (uint64, error) {
	dbMaster := db.DefaultManager.GetDbMaster()
	if dbMaster != nil {
		// Get MsgId
		msgId, err := m.IncrMsgIdSingle(fromId, toId)
		if err != nil {
			return 0, err
		}

		tableName := fmt.Sprintf("%s%d", kIMMessageSendTableName, fromId%kIMMessageTableCount)
		// 去重
		if existMsgId := m.queryMsgId(clientMsgId, tableName); existMsgId > 0 {
			logger.Sugar.Info("msg already exist,msg_id=%s,from_id=%d,to_id=%d", clientMsgId, fromId, toId)
			return uint64(existMsgId), nil
		}

		// create session
		sessionModel := DefaultSession.Get(fromId, toId)
		sessionModel2 := DefaultSession.Get(toId, fromId)

		timeStamp := time.Now().Unix()
		if sessionModel == nil || sessionModel2 == nil {
			logger.Sugar.Infof("session %d->%d not exist,create it,session_type=SESSION_TYPE_SINGLE", fromId, toId)
			_, _, err = DefaultSession.AddUserSession(fromId, toId, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
				cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK, false)
			if err != nil {
				logger.Sugar.Errorf("create session %d->%d,session_type:SESSION_TYPE_SINGLE,error:%s", fromId, toId, err.Error())
				return 0, err
			}
		} else {
			// update latest session time
			_ = DefaultSession.UpdateUpdated(sessionModel.Id, int(timeStamp))
			_ = DefaultSession.UpdateUpdated(sessionModel2.Id, int(timeStamp))
		}

		// save to im_message_send_x
		sql := fmt.Sprintf("insert into %s(msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
			"msg_res_code,msg_feature,msg_status,created,updated) values(%d,'%s',%d,%d,%d,%d,'%s',%d,%d,%d,%d,%d)",
			tableName, msgId, clientMsgId, fromId, toId, 0, msgType, msgData, cim.CIMResCode_kCIM_RES_CODE_OK,
			cim.CIMMsgFeature_kCIM_MSG_FEATURE_DEFAULT, cim.CIMMsgStatus_kCIM_MSG_STATUS_NONE, timeStamp, timeStamp)
		_, err = dbMaster.Exec(sql)
		if err != nil {
			logger.Sugar.Errorf("exec failed,sql:%s,error:%s", sql, err.Error())
			return 0, err
		} else {
			// save to im_message_recv_x
			tableName := fmt.Sprintf("%s%d", kIMMessageRecvTableName, toId%kIMMessageTableCount)
			sql = fmt.Sprintf("insert into %s(msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
				"msg_res_code,msg_feature,msg_status,created,updated) values(%d,'%s',%d,%d,%d,%d,'%s',%d,%d,%d,%d,%d)",
				tableName, msgId, clientMsgId, fromId, toId, 0, msgType, msgData, cim.CIMResCode_kCIM_RES_CODE_OK,
				cim.CIMMsgFeature_kCIM_MSG_FEATURE_DEFAULT, cim.CIMMsgStatus_kCIM_MSG_STATUS_NONE, timeStamp, timeStamp)
			_, err = dbMaster.Exec(sql)
			if err != nil {
				logger.Sugar.Errorf("exec failed,sql:%s,error:%s", sql, err.Error())
				return 0, err
			}

			// 增加未读消息计数(对方)，如果对方是机器人，跳过
			if !isToRobot {
				DefaultUnread.IncUnreadCount(toId, fromId, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE)
			}

			return uint64(msgId), nil
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return 0, def.DefaultError
}
func (m *Message) saveGroupMessage(fromId uint64, groupId uint64, clientMsgId string,
	msgType cim.CIMMsgType, msgData string) (uint64, error) {

	dbMaster := db.DefaultManager.GetDbMaster()
	if dbMaster == nil {
		logger.Sugar.Error("no db connect for master")
	}

	// check group
	_, err := DefaultGroup.Get(groupId)
	if err != nil {
		logger.Sugar.Warnf("saveGroupMessage group=%d not exist,err:%s", groupId, err.Error())
		return 0, err
	}

	// check member in group
	timeStamp := time.Now().Unix()
	if msgType != cim.CIMMsgType_kCIM_MSG_TYPE_NOTIFACATION {
		isExist, err := DefaultGroupMember.Exist(groupId, fromId)
		if err != nil {
			logger.Sugar.Warnf("saveGroupMessage check member error:%s,group=%d,user_id:%d", err.Error(), groupId, fromId)
			return 0, err
		}

		if !isExist {
			logger.Sugar.Warnf("saveGroupMessage invalid member=%d,group_id=%d", fromId, groupId)
			return 0, def.DefaultError
		}

		// session exist?
		session := DefaultSession.Get(fromId, groupId)
		if session == nil {
			err = DefaultSession.AddGroupSession(fromId, groupId, cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP,
				cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK)
			if err != nil {
				logger.Sugar.Error("create session %d->%d,session_type:SESSION_TYPE_GROUP,error:%s", fromId, groupId, err.Error())
				return 0, err
			}
		} else {
			// update latest session time
			_ = DefaultSession.UpdateUpdated(session.Id, int(timeStamp))
		}
	}

	// Get MsgId
	msgId, err := m.IncrMsgIdGroup(groupId)
	if err != nil {
		return 0, err
	}

	tableName := fmt.Sprintf("%s%d", kIMMessageSendTableName, fromId%kIMMessageTableCount)
	// 去重
	if existMsgId := m.queryMsgId(clientMsgId, tableName); existMsgId > 0 {
		logger.Sugar.Info("msg already exist,msg_id=%s,from_id=%d,to_id=%d", clientMsgId, fromId, groupId)
		return uint64(existMsgId), nil
	}

	if msgType != cim.CIMMsgType_kCIM_MSG_TYPE_NOTIFACATION {
		// save to im_message_send_x
		sql := fmt.Sprintf("insert into %s(msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
			"msg_res_code,msg_feature,msg_status,created,updated) values(%d,'%s',%d,%d,%d,%d,'%s',%d,%d,%d,%d,%d)",
			tableName, msgId, clientMsgId, fromId, groupId, 0, msgType, msgData, cim.CIMResCode_kCIM_RES_CODE_OK,
			cim.CIMMsgFeature_kCIM_MSG_FEATURE_DEFAULT, cim.CIMMsgStatus_kCIM_MSG_STATUS_NONE, timeStamp, timeStamp)
		_, err = dbMaster.Exec(sql)
		if err != nil {
			logger.Sugar.Errorf("exec failed,sql:%s,error:%s", sql, err.Error())
			return 0, err
		}
	}

	// save to im_message_recv_x
	tableName = fmt.Sprintf("%s%d", kIMMessageRecvTableName, groupId%kIMMessageTableCount)
	sql := fmt.Sprintf("insert into %s(msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
		"msg_res_code,msg_feature,msg_status,created,updated) values(%d,'%s',%d,%d,%d,%d,'%s',%d,%d,%d,%d,%d)",
		tableName, msgId, clientMsgId, fromId, groupId, groupId, msgType, msgData, cim.CIMResCode_kCIM_RES_CODE_OK,
		cim.CIMMsgFeature_kCIM_MSG_FEATURE_DEFAULT, cim.CIMMsgStatus_kCIM_MSG_STATUS_NONE, timeStamp, timeStamp)
	_, err = dbMaster.Exec(sql)
	if err != nil {
		logger.Sugar.Errorf("exec failed,sql:%s,error:%s", sql, err.Error())
		return 0, err
	}

	// 群未读计数+1，发送方已读消息计数+1
	DefaultUnread.IncUnreadCount(groupId, fromId, cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP)
	return uint64(msgId), nil
}

// 创建消息
func (m *Message) CreateMsgSystemNotification(notificationId cim.CIMMsgNotificationType, data interface{}, to uint64,
	sessionType cim.CIMSessionType) (*cim.CIMMsgData, error) {

	content := CIMMsgNotification{
		NotificationType: int(notificationId),
		Data:             data,
	}

	buff, err := json.Marshal(content)
	if err != nil {
		return nil, err
	}

	msg := &cim.CIMMsgData{
		MsgType:     cim.CIMMsgType_kCIM_MSG_TYPE_NOTIFACATION,
		MsgData:     buff,
		FromUserId:  0,
		ToSessionId: to,
		SessionType: sessionType,
		CreateTime:  int32(time.Now().Unix()),
		ClientMsgId: uuid.NewV4().String(),
	}
	return msg, nil
}
