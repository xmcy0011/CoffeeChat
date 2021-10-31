package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/db"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"context"
	"errors"
	"fmt"
	"strings"
)

// 发消息
func (s *LogicServer) SendMsgData(ctx context.Context, in *cim.CIMMsgData) (*cim.CIMMsgDataAck, error) {
	logger.Sugar.Infof("SendMsgData,fromId=%d,toId=%d,msgId=%s,createTime=%d,msgType=%d,sessionType=%d",
		in.FromUserId, in.ToSessionId, in.ClientMsgId, in.CreateTime, in.MsgType, in.SessionType)

	if in.FromUserId == in.ToSessionId {
		return nil, errors.New("FromUserId equals ToSessionId")
	}

	// 机器人消息，对方无需未读计数
	isToRobot := def.IsRobot(in.ToSessionId) && in.MsgType == cim.CIMMsgType_kCIM_MSG_TYPE_ROBOT

	serverMsgId, err := dao.DefaultMessage.SaveMessage(in.FromUserId, in.ToSessionId, in.ClientMsgId, in.MsgType, in.SessionType, string(in.MsgData), isToRobot)
	if err != nil {
		logger.Sugar.Errorf("save message failed:%s,fromId=%d,toId=%d,msgId=%s", err.Error(), in.FromUserId, in.ToSessionId, in.ClientMsgId)
		return nil, err
	}

	// sync broadcast user

	// return ack
	ack := &cim.CIMMsgDataAck{
		FromUserId:  in.FromUserId,
		ToSessionId: in.ToSessionId,
		ClientMsgId: in.ClientMsgId,
		ServerMsgId: serverMsgId,
		ResCode:     cim.CIMResCode_kCIM_RES_CODE_OK,
		CreateTime:  in.CreateTime,
		SessionType: in.SessionType,
	}
	return ack, nil
}

// 消息已读
func (s *LogicServer) ReadAckMsgData(ctx context.Context, in *cim.CIMMsgDataReadAck) (*cim.Empty, error) {
	logger.Sugar.Infof("ReadAckMsgData,userId=%d,toSessionId=%d,msgId=%d,sessionType=%d",
		in.UserId, in.SessionId, in.MsgId, in.SessionType)

	// 清除该用户的未读消息计数
	dao.DefaultUnread.ClearUnreadCount(in.UserId, in.SessionId, in.SessionType)
	return &cim.Empty{}, nil
}

// 广播单聊消息
func (s *LogicServer) messageBroadcastSingle(in *cim.CIMMsgData) {
	// 1.find online user
	// 2.find gate gRPC server
	// 3.call SendMsgData
	// 4.etc ...
	redisConn := db.DefaultRedisPool.GetOnlinePool()
	key := fmt.Sprintf("%s_%d", db.KOnlineKeyName, in.ToSessionId)
	userMap, err := redisConn.HGetAll(key).Result()
	if err != nil || len(userMap) == 0 {
		logger.Sugar.Debugf("messageBroadcastSingle from:%d,to:%d,he/she is not online,don't need broadcast",
			in.FromUserId, in.ToSessionId /*, err.Error()*/)
		return
	}

	// serverIp:true/false 用 serverId:true/false代替是不是好一些，因为可以有多个ip
	for i := range userMap {
		arr := strings.Split(userMap[i], ":")
		if len(arr) >= 2 && arr[0] == "true" {
			// find gate gRPC server
			gateClient, ok := gateRpcClientMap[i]
			if ok {
				// send msg
				ack, err := gateClient.SendMsgData(context.Background(), in)
				if err != nil {
					logger.Sugar.Errorf("%d->[%s]%d,broadcast error:%s", in.FromUserId, i, in.ToSessionId, err.Error())
				}
				if ack != nil {
					logger.Sugar.Infof("%d->[%s]%d,broadcast result_code:%s", in.FromUserId, i, in.ToSessionId, ack.ResCode)
				} else {
					logger.Sugar.Infof("%d->[%s]%d,broadcast success ,but ack is null", in.FromUserId, i, in.ToSessionId)
				}
			} else {
				logger.Sugar.Errorf("%d->[%s]%d,broadcast error,can't find %s gateClient server", in.FromUserId, i, in.ToSessionId, i)
			}
		}
	}
}
