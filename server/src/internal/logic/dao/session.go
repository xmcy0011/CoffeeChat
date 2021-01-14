package dao

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/model"
	"coffeechat/pkg/db"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"fmt"
	"time"
)

const kSessionTableName = "im_session"

type Session struct {
}

var DefaultSession = &Session{}

// 获取1个会话详情
func (t *Session) Get(userId uint64, peerId uint64) *model.SessionModel {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select id,user_id,peer_id,session_type,session_status,"+
			"is_robot_session,created,updated from %s where user_id=%d and peer_id=%d", kSessionTableName, userId, peerId)
		row := session.QueryRow(sql)

		sessionModel := &model.SessionModel{}
		err := row.Scan(&sessionModel.Id, &sessionModel.UserId, &sessionModel.PeerId, &sessionModel.SessionType,
			&sessionModel.SessionStatus, &sessionModel.IsRobotSession, &sessionModel.Created, &sessionModel.Updated)
		if err == nil {
			return sessionModel
		}
		/*else {
			logger.Sugar.Errorf("no result for sql:%s,error:%s", sql, err.Error())
		}*/
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return nil
}

// 查询会话列表
func (t *Session) GetSessionList(userId uint64) ([]model.SessionModel, error) {
	session := db.DefaultManager.GetDBSlave()
	if session != nil {
		sql := fmt.Sprintf("select id,user_id,peer_id,session_type,session_status,"+
			"is_robot_session,created,updated from %s where user_id=%d and session_status=%d order by updated desc",
			kSessionTableName, userId, cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK)
		rows, err := session.Query(sql)
		if err != nil {
			logger.Sugar.Error(err.Error())
			return nil, err
		}
		defer rows.Close()

		sessionArr := make([]model.SessionModel, 0, 5)
		for rows.Next() {
			sessionInfo := model.SessionModel{}
			err := rows.Scan(&sessionInfo.Id, &sessionInfo.UserId, &sessionInfo.PeerId, &sessionInfo.SessionType,
				&sessionInfo.SessionStatus, &sessionInfo.IsRobotSession, &sessionInfo.Created, &sessionInfo.Updated)
			if err != nil {
				logger.Sugar.Error(err.Error())
				return nil, err
			}
			sessionArr = append(sessionArr, sessionInfo)
		}
		return sessionArr, nil
	} else {
		logger.Sugar.Error("no db connect for slave")
	}
	return nil, def.DefaultError
}

// 添加一个用户和用户的会话记录
// 注：以事物的方式添加双向关系,a->b,b->a
func (t *Session) AddUserSession(userId uint64, peerId uint64, sessionType cim.CIMSessionType, sessionStatus cim.CIMSessionStatusType,
	isRobotSession bool) (int, int, error) {
	session := db.DefaultManager.GetDbMaster()
	if session != nil {
		robotSession := 0
		if isRobotSession {
			robotSession = 1
		}
		timeStamp := time.Now().Unix()

		// begin transaction
		err := session.Begin()
		if err != nil {
			logger.Sugar.Error("session begin error:", err.Error())
			return 0, 0, err
		}

		result := false
		id1 := int64(0)
		id2 := int64(0)

		// insert a->b
		sql := fmt.Sprintf("insert into %s(user_id,peer_id,session_type,session_status,"+
			"is_robot_session,created,updated) values(%d,%d,%d,%d,%d,%d,%d)",
			kSessionTableName, userId, peerId, int(sessionType), int(sessionStatus), robotSession, timeStamp, timeStamp)
		r, err := session.Exec(sql)
		if err != nil {
			logger.Sugar.Errorf("Exec error:%s,sql:%s", err.Error(), sql)
		} else if id1, err = r.LastInsertId(); err != nil {
			logger.Sugar.Errorf("Exec error:%s,sql:%s", err.Error(), sql)
		} else {
			result = true
		}

		// insert b->a
		if result {
			result = false
			sql = fmt.Sprintf("insert into %s(user_id,peer_id,session_type,session_status,"+
				"is_robot_session,created,updated) values(%d,%d,%d,%d,%d,%d,%d)",
				kSessionTableName, peerId, userId, int(sessionType), int(sessionStatus), robotSession, timeStamp, timeStamp)
			r, err = session.Exec(sql)
			if err != nil {
				logger.Sugar.Errorf("Exec error:%s,sql:%s", err.Error(), sql)
			} else if id2, err = r.LastInsertId(); err != nil {
				logger.Sugar.Errorf("Exec error:%s,sql:%s", err.Error(), sql)
			} else {
				result = true
			}
		}

		// commit transaction
		if result {
			err := session.Commit()
			if err != nil {
				logger.Sugar.Errorf("session commit error:%s,sql:%s", err.Error(), sql)
			} else {
				result = true
			}
		}

		// if error, then rollback transaction
		if !result {
			err := session.Rollback()
			if err != nil {
				logger.Sugar.Errorf("session rollback error:%s,sql:%s", err.Error(), sql)
				return 0, 0, err
			}
		} else {
			return int(id1), int(id2), nil
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return 0, 0, def.DefaultError
}

// 添加用户和群的会话关系
func (t *Session) AddGroupSession(userId uint64, groupId uint64, sessionType cim.CIMSessionType, sessionStatus cim.CIMSessionStatusType) error {
	session := db.DefaultManager.GetDbMaster()
	if session != nil {
		robotSession := 0
		timeStamp := time.Now().Unix()

		sql := fmt.Sprintf("insert into %s(user_id,peer_id,session_type,session_status,"+
			"is_robot_session,created,updated) values(%d,%d,%d,%d,%d,%d,%d)",
			kSessionTableName, userId, groupId, int(sessionType), int(sessionStatus), robotSession, timeStamp, timeStamp)
		r, err := session.Exec(sql)
		if err != nil {
			logger.Sugar.Errorf("sql Exec error:%s,sql:%s", err.Error(), sql)
		} else if _, err := r.RowsAffected(); err != nil {
			logger.Sugar.Errorf("sql Exec error:%s,sql:%s", err.Error(), sql)
		} else {
			return nil // success
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return def.DefaultError
}

// 更新会话最后修改时间
func (t *Session) UpdateUpdated(id uint64, updated int) error {
	session := db.DefaultManager.GetDbMaster()
	if session != nil {
		sql := fmt.Sprintf("update %s set updated=%d where id=%d", kSessionTableName, updated, id)
		r, err := session.Exec(sql)
		if err != nil {
			logger.Sugar.Error("sql Exec error:", err.Error())
		} else {
			_, err := r.RowsAffected()
			if err != nil {
				return err
			} else {
				// if value not change, then affect row num = 0
				//if row != 1 {
				//	logger.Sugar.Warnf("update success,but row num != 1(%d) for sql:%s", row, sql)
				//}
				// success
				return nil
			}
		}
	} else {
		logger.Sugar.Error("no db connect for master")
	}
	return def.DefaultError
}
