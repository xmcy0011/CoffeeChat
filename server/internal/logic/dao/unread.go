package dao

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/db"
	"coffeechat/pkg/logger"
	"errors"
	"fmt"
	"strconv"
)

const kRedisKeyUnread = "unread"
const kRedisKeyUnreadSinglePrefix = "peer"

const kRedisKeyUnreadGroup = "unread_group_"
const kRedisKeyUnreadGroupTotalMsg = "count"
const kRedisKeyUnreadGroupMemberPrefix = "member_"

// 单聊redis数据结构，一个key存这个用户所有的单聊未读
// unread_UserId:
//     peer_Id1:Value
//     peer_Id2:Value
//
// 群聊数据结构，群总的未读计数+群成员已读计数
// unread_group_GroupId:
//     count:10
//     member_userId1:1
//     member_userId2:2

type Unread struct {
}

var DefaultUnread = &Unread{}

var redisNotConnectError = errors.New("redis is not connect")

// 未读计数+1
func (u *Unread) IncUnreadCount(userId uint64, toSessionId uint64, sessionType cim.CIMSessionType) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool == nil {
		logger.Sugar.Warn("redis is not connect")
		return
	}
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		result := pool.HIncrBy(getUnreadKey1(userId), getUnreadKey2(toSessionId, sessionType), 1)
		if result.Err() != nil {
			logger.Sugar.Warn("IncUnreadCount error:%s", result.Err().Error())
		}
	} else if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP { // 群聊
		// 群消息总数+1
		key := getUnreadGroupKey(toSessionId)
		result := pool.HIncrBy(key, kRedisKeyUnreadGroupTotalMsg, 1)
		if result.Err() != nil {
			logger.Sugar.Warn("IncUnreadCount group error:%s", result.Err().Error())
		} else {
			// 取出群消息总数
			r := pool.HGet(key, kRedisKeyUnreadGroupTotalMsg)
			count, err := r.Result()
			if err != nil {
				logger.Sugar.Warn("IncUnreadCount err:%s", err.Error())
			} else {
				// 群成员已读消息数更新为群消息总数，即发消息的用户，未读消息为0
				success := pool.HSet(key, getUnreadGroupMemberKey(userId), count)
				if success.Err() != nil {
					logger.Sugar.Warn("IncUnreadCount set member read total count error:%s", success.Err().Error())
				}
			}
		}
	} else {
		logger.Sugar.Warn("IncUnreadCount invalid session type")
	}
}

// 清除未读消息计数
func (u *Unread) ClearUnreadCount(userId uint64, toSessionId uint64, sessionType cim.CIMSessionType) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool == nil {
		logger.Sugar.Warn("redis is not connect")
		return
	}

	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		result := pool.HDel(getUnreadKey1(userId), getUnreadKey2(toSessionId, sessionType))
		if result.Err() != nil {
			logger.Sugar.Warn("ClearUnreadCount error:%s", result.Err().Error())
		}
	} else if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
		key := getUnreadGroupKey(toSessionId)
		subKey := getUnreadGroupMemberKey(userId)

		// get total group count
		result := pool.HIncrBy(key, kRedisKeyUnreadGroupTotalMsg, 1)
		if result.Err() != nil {
			logger.Sugar.Warn("ClearUnreadCount %s", result.Err().Error())
		} else {
			// set group member read count = totalGroupCount
			b := pool.HSet(key, subKey, result.String())
			if b.Err() != nil {
				logger.Sugar.Warn("ClearUnreadCount %s", b.Err().Error())
			}
		}
	} else {
		logger.Sugar.Warn("ClearUnreadCount invalid sessionType:%d", sessionType)
	}
}

// 获取某个用户的未读消息计数列表
// peer_userId
// group_groupId
func (u *Unread) GetUnreadCount(userId uint64) map[string]string {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool == nil {
		logger.Sugar.Warn("redis is not connect")
		return nil
	}
	// all single unread
	result := pool.HGetAll(getUnreadKey1(userId))
	if result.Err() != nil {
		logger.Sugar.Warn("GetUnreadCount error:%s", result.Err().Error())
	}

	unreadMap := result.Val()

	// get all group unread
	ids, err := DefaultGroupMember.ListGroup(userId)
	if err != nil {
		logger.Sugar.Warn("GetUnreadCount error:%s", err.Error())
	} else {
		for _, v := range ids {
			count, err := getGroupMemberUnreadCount(userId, v)
			if err == nil {
				unreadMap[fmt.Sprintf("group_%d", v)] = strconv.FormatUint(count, 10)
			}
		}
	}

	return unreadMap
}

func getUnreadKey1(userId uint64) string {
	return fmt.Sprintf("%s_%d", kRedisKeyUnread, userId)
}

func getUnreadKey2(toSessionId uint64, sessionType cim.CIMSessionType) string {
	var key = fmt.Sprintf("unknown_%d", toSessionId)
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		key = fmt.Sprintf("%s_%d", kRedisKeyUnreadSinglePrefix, toSessionId)
	}
	return key
}

func getUnreadGroupKey(groupId uint64) string {
	return fmt.Sprintf("%s_%d", kRedisKeyUnreadGroup, groupId)
}

func getUnreadGroupMemberKey(userId uint64) string {
	return fmt.Sprintf("%s_%d", kRedisKeyUnreadGroupMemberPrefix, userId)
}

// 获取群成员未读消息总数
func getGroupMemberUnreadCount(userId, groupId uint64) (uint64, error) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool != nil {
		groupMsgTotalCount, err := getGroupTotalMsgCount(groupId)
		if err != nil {
			return 0, err
		}

		memberReadTotalMsgCount, err := getGroupMemberReadTotalMsgCount(userId, groupId)
		if err != nil {
			return 0, err
		}

		// 群消息总数 - 成员已读消息总数 = 未读消息总数
		if groupMsgTotalCount >= memberReadTotalMsgCount {
			return groupMsgTotalCount - memberReadTotalMsgCount, nil
		}
		return 0, nil
	}
	return 0, redisNotConnectError
}

// 获取群消息总数
func getGroupTotalMsgCount(groupId uint64) (uint64, error) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool != nil {
		key := getUnreadGroupKey(groupId)
		result := pool.HGet(key, kRedisKeyUnreadGroupTotalMsg)
		if result.Err() != nil {
			return 0, result.Err()
		}

		countStr := result.Val()
		count, err := strconv.ParseUint(countStr, 10, 64)
		if err != nil {
			return 0, err
		}
		return count, nil
	}
	return 0, redisNotConnectError
}

// 获取群成员已读消息总数
func getGroupMemberReadTotalMsgCount(userId, groupId uint64) (uint64, error) {
	pool := db.DefaultRedisPool.GetUnreadPool()
	if pool != nil {
		key := getUnreadGroupKey(groupId)
		subKey := getUnreadGroupMemberKey(userId)
		result := pool.HGet(key, subKey)
		if result.Err() != nil {
			return 0, result.Err()
		}

		countStr := result.Val()
		count, err := strconv.ParseUint(countStr, 10, 64)
		if err != nil {
			return 0, err
		}
		return count, nil
	}
	return 0, redisNotConnectError
}
