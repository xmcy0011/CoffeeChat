package job

import (
	"coffeechat/api/cim"
	"coffeechat/internal/job/conf"
	"coffeechat/pkg/logger"
	"coffeechat/pkg/mq"
	"context"
	"github.com/golang/protobuf/proto"
)

type Server struct {
}

var DefaultServer = &Server{}

func (s *Server) Start() error {

	// grpc client
	err := startRpcClient()

	// rocketmq consumer
	mqConfig := conf.DefaultConfig.RocketMq
	err = mq.DefaultMsgConsumer.StartConsumer(mqConfig.ConsumeGroup, mqConfig.NameServers)
	if err != nil {
		logger.Sugar.Error(err.Error())
		return err
	}

	// start consume
	go s.consume()

	return err
}

func (s *Server) consume() {
	for {
		select {
		case msg, ok := <-mq.DefaultMsgConsumer.Messages():
			if !ok {
				return
			}

			logger.Sugar.Infof("consume ,cmdId:%d,server:%s,to:%d,dataLen:%d", msg.CommondId, msg.Server, msg.ToId, len(msg.Data))

			switch msg.Type {
			case cim.CIMPushMsg_kCIM_PUSH:
				s.onHandlePushMsg(msg.CommondId, msg.Server, msg.ToId, msg.Data)
			case cim.CIMPushMsg_kCIM_ROOM:
				s.onHandlePushRoomMsg(msg.CommondId, msg.Server, msg.ToId, msg.Data)
			case cim.CIMPushMsg_kCIM_BROADCAST:
				s.onHandleBroadcastMsg(msg.CommondId, msg.Server, msg.ToId, msg.Data)
			default:
				logger.Sugar.Warnf("unknown push type:", msg.Type)
			}
		}
	}
}

// 消息推送给某个用户
func (s *Server) onHandlePushMsg(cmdId uint32, server string, to uint64, data []byte) {
	for address, conn := range clientMap {
		// 消息来源服务器不用推送
		if address != server {
			logger.Sugar.Info("")
			continue
		}

		switch cmdId {
		case uint32(cim.CIMIntenralCmdID_kCIM_SID_MSG_DATA):
			msg := cim.CIMInternalMsgData{}
			err := proto.Unmarshal(data, &msg)
			if err != nil {
				logger.Sugar.Warn(err.Error())
			} else {
				_, err = conn.rpcConn.SendMsgData(context.Background(), &msg)
				if err != nil {
					logger.Sugar.Warnf("SendMsgData server:%s,error:%s", address, err.Error())
				}
			}
		case uint32(cim.CIMIntenralCmdID_kCIM_SID_MSG_READ_NOTIFY):
			notify := cim.CIMInternalMsgDataReadNotify{}
			err := proto.Unmarshal(data, &notify)
			if err != nil {
				logger.Sugar.Warn(err.Error())
			} else {
				_, err = conn.rpcConn.AckMsgData(context.Background(), &notify)
				if err != nil {
					logger.Sugar.Warnf("AckMsgData server:%s,error:%s", address, err.Error())
				}
			}
		default:
			logger.Sugar.Warn("unknown cmdId:", cmdId)
		}

		logger.Sugar.Info("pushMsg gate:", address)
	}
}

// 消息推送-群发
func (s *Server) onHandlePushRoomMsg(cmdId uint32, server string, to uint64, data []byte) {

}

// 所有在线用户
func (s *Server) onHandleBroadcastMsg(cmdId uint32, server string, to uint64, data []byte) {

}
