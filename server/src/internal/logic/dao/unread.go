package dao

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"fmt"
)

const kRedisKeyUnread = "unread"

// 单聊redis数据结构，一个key存这个用户所有的单聊未读
// UserId:
//     peer_Id1:Value
//     group_Id2:Value

type Unread struct {
}

var DefaultUnread = &Unread{}

// 未读计数+1
func (u *Unread) IncUnreadCount(userId uint64, toSessionId uint64, sessionType cim.CIMSessionType) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool != nil {
		result := pool.HIncrBy(getUnreadKey1(userId), getUnreadKey2(toSessionId, sessionType), 1)
		if result.Err() != nil {
			logger.Sugar.Warn("IncUnreadCount error:%s", result.Err().Error())
		}
	} else {
		logger.Sugar.Warn("redis is not connect")
	}
}

// 清除未读消息计数
func (u *Unread) ClearUnreadCount(userId uint64, toSessionId uint64, sessionType cim.CIMSessionType) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool != nil {
		result := pool.HDel(getUnreadKey1(userId), getUnreadKey2(toSessionId, sessionType))
		if result.Err() != nil {
			logger.Sugar.Warn("ClearUnreadCount error:%s", result.Err().Error())
		}
	} else {
		logger.Sugar.Warn("redis is not connect")
	}
}

// 获取某个用户的未读消息计数列表
func (u *Unread) GetUnreadCount(userId uint64) map[string]string {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool != nil {
		result := pool.HGetAll(getUnreadKey1(userId))
		if result.Err() != nil {
			logger.Sugar.Warn("GetUnreadCount error:%s", result.Err().Error())
		} else {
			return result.Val()
		}
	} else {
		logger.Sugar.Warn("redis is not connect")
	}
	return nil
}

func getUnreadKey1(userId uint64) string {
	return fmt.Sprintf("%s_%d", kRedisKeyUnread, userId)
}

func getUnreadKey2(toSessionId uint64, sessionType cim.CIMSessionType) string {
	var key = "'"
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		key = fmt.Sprintf("peer_%d", toSessionId)
	} else {
		key = fmt.Sprintf("group_%d", toSessionId)
	}
	return key
}
