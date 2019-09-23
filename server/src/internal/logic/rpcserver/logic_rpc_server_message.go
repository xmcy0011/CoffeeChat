package rpcserver

import (
	"context"
	"errors"
	"fmt"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
	"github.com/CoffeeChat/server/src/pkg/db"
	"github.com/CoffeeChat/server/src/pkg/logger"
)

// 发消息
func (s *LogicServer) SendMsgData(ctx context.Context, in *cim.CIMMsgData) (*cim.CIMMsgDataAck, error) {
	logger.Sugar.Infof("sendMsgData,fromId=%d,toId=%d,msgId=%s,createTime=%d,msgType=%d,sessionType=%d",
		in.FromUserId, in.ToSessionId, in.MsgId, in.CreateTime, in.MsgType, in.SessionType)

	if in.FromUserId == in.ToSessionId {
		return nil, errors.New("FromUserId equals ToSessionId")
	}

	serverMsgId, err := dao.DefaultMessage.SaveMessage(in.FromUserId, in.ToSessionId, in.MsgId, in.CreateTime, in.MsgType, in.SessionType, string(in.MsgData))
	if err != nil {
		logger.Sugar.Error("save message failed:%s,fromId=%d,toId=%d,msgId=%s", err.Error(), in.FromUserId, in.ToSessionId, in.MsgId)
		return nil, err
	}

	// sync broadcast user
	s.messageBroadcastSingle(in)

	// return ack
	ack := &cim.CIMMsgDataAck{
		FromUserId:  in.FromUserId,
		ToSessionId: in.ToSessionId,
		MsgId:       in.MsgId,
		ServerMsgId: serverMsgId,
		ResCode:     cim.CIMResCode_kCIM_RES_CODE_OK,
		CreateTime:  in.CreateTime,
		SessionType: in.SessionType,
	}
	return ack, nil
}

// 消息收到ACK
func (s *LogicServer) AckMsgData(ctx context.Context, in *cim.CIMMsgDataAck) (*cim.Empty, error) {
	return nil, nil
}

func (s *LogicServer) messageBroadcastSingle(in *cim.CIMMsgData) {
	// 1.find online user
	// 2.find gate gRPC server
	// 3.call SendMsgData
	// 4.etc ...
	redisConn := db.DefaultRedisPool.GetOnlinePool()
	key := fmt.Sprintf("%s_%d", db.KOnlineKeyName, in.ToSessionId)
	userMap, err := redisConn.HGetAll(key).Result()
	if err != nil || len(userMap) == 0 {
		logger.Sugar.Debugf("from:%d,to:%d,he/she is not online,don't need broadcast", in.FromUserId, in.ToSessionId, in.ToSessionId /*, err.Error()*/)
		return
	}

	// serverIp:true/false
	for i := range userMap {
		if userMap[i] == "true" {
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
