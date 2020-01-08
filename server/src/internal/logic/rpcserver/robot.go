package rpcserver

import (
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/satori/go.uuid"
	"time"
)

var (
	//tuRingRobotUserId = uint64(2020010701) // year-month-day id 图灵机器人
	//tuRingWelcomeMsg  = "您好，小主人，我是你刚创建的机器人，我已经具备了25项聊天技能，赶快和我聊天试试吧！您现在也可以通过左侧的接入方式，把我接入您的产品中去为您提供服务！"
	ownThinkRobotUserId = uint64(2020010702) // 思知机器人
	ownThinkWelcomeMsg  = "知识图谱问答机器人，聊天机器人，基于知识图谱、语义理解等的对话机器人。https://robot.ownthink.com/"
)

// 是否机器人账号
func IsRobot(userId uint64) bool {
	return userId == ownThinkRobotUserId
}

// 默认会话列表中显示机器人，并且显示欢迎语句
func AddRobotSession(userId uint64) {
	s := dao.DefaultSession

	session := s.Get(userId, ownThinkRobotUserId)
	if session == nil {
		_, _, err := s.AddUserSession(userId, ownThinkRobotUserId, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
			cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK, true)
		if err != nil {
			logger.Sugar.Warnf("add robot session error:%s", err.Error())
		} else {
			// 显示欢迎语
			u4 := uuid.NewV4()
			_, err := dao.DefaultMessage.SaveMessage(ownThinkRobotUserId, userId, u4.String(), int32(time.Now().Unix()),
				cim.CIMMsgType_kCIM_MSG_TYPE_TEXT, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE, ownThinkWelcomeMsg, false)
			if err != nil {
				logger.Sugar.Warnf("add robot welcome msg error:%s", err.Error())
			} else {
				logger.Sugar.Infof("add robot session success")
			}
		}
	}
}
