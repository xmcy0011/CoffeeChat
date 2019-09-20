package rpcserver

import (
	"context"
	"errors"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
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

	// broadcast user
	s.messageBroadcastSingle()

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

func (s *LogicServer) messageBroadcastSingle() {
	// 1.find online user
	// 2.find gate gRPC server
	// 3.call SendMsgData
	// 4.etc ...
}
