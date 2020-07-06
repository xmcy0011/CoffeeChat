package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/conf"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"coffeechat/pkg/mq"
	"context"
	"errors"
	"github.com/golang/protobuf/proto"
)

// 发消息
func (s *LogicServer) SendMsgData(ctx context.Context, in *cim.CIMInternalMsgData) (*cim.CIMMsgDataAck, error) {
	msg := in.MsgData

	logger.Sugar.Infof("SendMsgData,fromId=%d,toId=%d,msgId=%s,createTime=%d,msgType=%d,sessionType=%d",
		msg.FromUserId, msg.ToSessionId, msg.MsgId, msg.CreateTime, msg.MsgType, msg.SessionType)

	if msg.FromUserId == msg.ToSessionId {
		return nil, errors.New("FromUserId equals ToSessionId")
	}

	// 机器人消息，对方无需未读计数
	isToRobot := def.IsRobot(msg.ToSessionId) // && msg.MsgType == cim.CIMMsgType_kCIM_MSG_TYPE_ROBOT

	serverMsgId, err := dao.DefaultMessage.SaveMessage(msg.FromUserId, msg.ToSessionId, msg.MsgId, msg.CreateTime,
		msg.MsgType, msg.SessionType, string(msg.MsgData), isToRobot)
	if err != nil {
		logger.Sugar.Error("save message failed:%s,fromId=%d,toId=%d,msgId=%s", err.Error(), msg.FromUserId, msg.ToSessionId, msg.MsgId)
		return nil, err
	}

	// if enable rocketMq,
	// producer mq to rocketMq,then job server will consume and broadcast on other gate server user,without in.Server
	if conf.DefaultLogicConfig.RocketMq.Enable && !isToRobot {
		s.mqMessagePush(in)
	}

	// return ack
	ack := &cim.CIMMsgDataAck{
		FromUserId:  msg.FromUserId,
		ToSessionId: msg.ToSessionId,
		MsgId:       msg.MsgId,
		ServerMsgId: serverMsgId,
		ResCode:     cim.CIMResCode_kCIM_RES_CODE_OK,
		CreateTime:  msg.CreateTime,
		SessionType: msg.SessionType,
	}
	return ack, nil
}

// 消息已读
func (s *LogicServer) ReadAckMsgData(ctx context.Context, in *cim.CIMInternalMsgDataReadAck) (*cim.Empty, error) {
	logger.Sugar.Infof("ReadAckMsgData,userId=%d,toSessionId=%d,msgId=%d,sessionType=%d",
		in.ReadAck.UserId, in.ReadAck.SessionId, in.ReadAck.MsgId, in.ReadAck.SessionType)

	// 清除该用户的未读消息计数
	dao.DefaultUnread.ClearUnreadCount(in.ReadAck.UserId, in.ReadAck.SessionId, in.ReadAck.SessionType)

	// FIXED ME
	// 单聊广播已读消息通知，群聊目前没有已读未读功能
	if conf.DefaultLogicConfig.RocketMq.Enable && in.ReadAck.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		data, err := proto.Marshal(in)
		if err != nil {
			logger.Sugar.Warnf("marshal error:", err.Error())
		} else {
			err = mq.DefaultMsgProducer.PushMsg(in.ReadAck.SessionId, in.Server.Server, uint32(cim.CIMCmdID_kCIM_CID_MSG_READ_NOTIFY), 0, data)
			if err != nil {
				logger.Sugar.Warnf(err.Error())
			}
		}
	}

	return &cim.Empty{}, nil
}

// 广播消息
func (s *LogicServer) mqMessagePush(in *cim.CIMInternalMsgData) {
	logger.Sugar.Infof("mqMessagePush toId:%d,fromServer:%s", in.MsgData.ToSessionId, in.Server.Server)

	data, err := proto.Marshal(in)
	if err != nil {
		logger.Sugar.Warnf("marshal error:", err.Error())
		return
	}
	if in.MsgData.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
		err = mq.DefaultMsgProducer.PushRoomMsg(in.MsgData.ToSessionId, in.Server.Server, uint32(cim.CIMCmdID_kCIM_CID_MSG_DATA), 0, data)
	} else if in.MsgData.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		err = mq.DefaultMsgProducer.PushMsg(in.MsgData.ToSessionId, in.Server.Server, uint32(cim.CIMCmdID_kCIM_CID_MSG_DATA), 0, data)
	}
	if err != nil {
		logger.Sugar.Warnf(err.Error())
	}
}
