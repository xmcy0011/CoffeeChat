package dao

import (
	"fmt"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/model"
	"github.com/CoffeeChat/server/src/pkg/db"
	"github.com/CoffeeChat/server/src/pkg/def"
	"github.com/CoffeeChat/server/src/pkg/logger"
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

// 查询某条消息详情
func (m *Message) GetMessage(msgId uint64, peerId uint64) (*model.MessageModel, error) {
	tableName := fmt.Sprintf("%s%d", kIMMessageRecvTableName, peerId%kIMMessageTableCount)
	dbSlave := db.DefaultManager.GetDBSlave()
	if dbSlave != nil {
		sql := fmt.Sprintf("select id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
			"msg_res_code,msg_feature,msg_status,created,updated from %s where msg_id=%d and to_id=%d",
			tableName, msgId, peerId)
		row := dbSlave.QueryRow(sql)
		msgInfo := &model.MessageModel{}
		err := row.Scan(&msgInfo.Id, &msgInfo.ClientMsgId, &msgInfo.FromId, &msgInfo.ToId, &msgInfo.GroupId, &msgInfo.MsgType,
			&msgInfo.MsgContent, &msgInfo.MsgResCode, &msgInfo.MsgFeature, &msgInfo.MsgStatus, &msgInfo.Created, &msgInfo.Updated)
		if err != nil {
			//logger.Sugar.Error(err.Error(), ",with sql:", sql)
			return nil, err
		} else {
			msgInfo.MsgId = msgId
			return msgInfo, nil
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return nil, def.DefaultError
}
func (m *Message) getMsgId(msgId string, tableName string) int64 {
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
func (m *Message) GetSingleMsgList(userId uint64, sessionId uint64, sessionType cim.CIMSessionType,
	endMsgId uint64, limitCount uint32) ([]*model.MessageModel, error) {
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
				" order by id desc,created limit %d",
				tableNameA, userId, sessionId, limitCount)
		} else {
			sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
				"msg_res_code,msg_feature,msg_status,created,updated from %s"+
				" force index(ix_fromId_toId_msgStatus_created)"+
				" where from_id=%d and to_id=%d and msg_id<%d"+
				" order by id desc,created limit %d",
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
					" order by id desc,created limit %d",
					tableNameB, sessionId, userId, limitCount)
			} else {
				sql = fmt.Sprintf("select msg_id,client_msg_id,from_id,to_id,group_id,msg_type,msg_content,"+
					"msg_res_code,msg_feature,msg_status,created,updated from %s "+
					" force index(ix_fromId_toId_msgStatus_created)"+
					" where from_id=%d and to_id=%d and msg_id<%d"+
					" order by id desc,created limit %d",
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
			return msgArr[i].Created < msgArr[j].Created && msgArr[i].MsgId < msgArr[j].MsgId
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

// 存储消息
func (m *Message) SaveMessage(fromId uint64, toId uint64, clientMsgId string, createTime int32,
	msgType cim.CIMMsgType, sessionType cim.CIMSessionType, msgData string) (uint64, error) {
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		return m.saveSingleMessage(fromId, toId, clientMsgId, createTime, msgType, msgData)
	} else if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
		return m.saveGroupMessage(fromId, toId, clientMsgId, createTime, msgType, msgData)
	} else {
		return 0, def.DefaultError
	}
}
func (m *Message) saveSingleMessage(fromId uint64, toId uint64, clientMsgId string, createTime int32,
	msgType cim.CIMMsgType, msgData string) (uint64, error) {
	dbMaster := db.DefaultManager.GetDbMaster()
	if dbMaster != nil {
		// Get MsgId
		msgId, err := m.IncrMsgIdSingle(fromId, toId)
		if err != nil {
			return 0, err
		}

		tableName := fmt.Sprintf("%s%d", kIMMessageSendTableName, fromId%kIMMessageTableCount)
		// 去重
		if existMsgId := m.getMsgId(clientMsgId, tableName); existMsgId > 0 {
			logger.Sugar.Info("msg already exist,msg_id=%s,from_id=%d,to_id=%d", clientMsgId, fromId, toId)
			return uint64(existMsgId), nil
		}

		// create session
		sessionModel := DefaultSession.Get(fromId, toId)
		sessionModel2 := DefaultSession.Get(toId, fromId)

		timeStamp := time.Now().Unix()
		if sessionModel == nil || sessionModel2 == nil {
			logger.Sugar.Infof("session %d->%d not exist,create it,session_type=SESSION_TYPE_SINGLE", fromId, toId, )
			_, _, err = DefaultSession.AddUserSession(fromId, toId, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
				cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK, false)
			if err != nil {
				logger.Sugar.Error("create session %d->%d,session_type:SESSION_TYPE_SINGLE,error:%s", fromId, toId, err.Error())
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

			// 增加未读消息计数(对方)
			DefaultUnread.IncUnreadCount(toId, fromId, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE)

			return uint64(msgId), nil
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return 0, def.DefaultError
}

// not support
func (m *Message) saveGroupMessage(fromId uint64, groupId uint64, clientMsgId string, createTime int32,
	msgType cim.CIMMsgType, msgData string) (uint64, error) {
	return 0, def.DefaultError
}
