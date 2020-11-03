package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"github.com/satori/go.uuid"
)

func addRobotSession(s *dao.Session, userId uint64, robotId uint64, welcomeMsg string) {
	session := s.Get(userId, robotId)
	if session == nil {
		_, _, err := s.AddUserSession(userId, robotId, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
			cim.CIMSessionStatusType_kCIM_SESSION_STATUS_OK, true)
		if err != nil {
			logger.Sugar.Warnf("add robot=%d session error:%s", robotId, err.Error())
		} else {
			// 显示欢迎语
			u4 := uuid.NewV4()
			_, err := dao.DefaultMessage.SaveMessage(robotId, userId, u4.String(),
				cim.CIMMsgType_kCIM_MSG_TYPE_TEXT, cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE, welcomeMsg, false)
			if err != nil {
				logger.Sugar.Warnf("add robot=%d welcome msg error:%s", robotId, err.Error())
			} else {
				logger.Sugar.Infof("add robot=%d session success", robotId)
			}
		}
	}
}

// 默认会话列表中显示机器人，并且显示欢迎语句
// 目前会创建2个机器人，思知、小微
func AddRobotSession(userId uint64) {
	s := dao.DefaultSession

	// 思知
	addRobotSession(s, userId, def.OwnThinkRobotUserId, def.OwnThinkWelcomeMsg)
	// 小微
	addRobotSession(s, userId, def.WeChatRobotUserId, def.WeChatWelcomeMsg)
}
