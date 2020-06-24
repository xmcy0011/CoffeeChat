package mq

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"github.com/apache/rocketmq-client-go/v2"
	"github.com/apache/rocketmq-client-go/v2/primitive"
	"github.com/apache/rocketmq-client-go/v2/producer"
	"github.com/golang/protobuf/proto"
)

type MsgProducer struct {
	producer rocketmq.Producer
}

var (
	DefaultMsgProducer = &MsgProducer{}
)

// nameSrv，example: 127.0.0.1:9876
func (m *MsgProducer) StartProducer(nameServers []string) error {
	p, err := rocketmq.NewProducer(
		producer.WithNsResovler(primitive.NewPassthroughResolver(nameServers)),
		producer.WithRetry(2),
	)
	if err != nil {
		return err
	}
	m.producer = p

	return p.Start()
}

func (m *MsgProducer) Shutdown() error {
	if m.producer != nil {
		return m.producer.Shutdown()
	}
	return nil
}

func (m *MsgProducer) produce(topic string, data []byte) error {
	mqMsg := primitive.Message{
		Topic: topic,
		Body:  data,
		Batch: false,
	}
	r, err := m.producer.SendSync(context.Background(), &mqMsg)
	if err != nil {
		return err
	}
	if r != nil {
		logger.Sugar.Info("PushMsg", r.String())
	}
	return nil
}

// peer msg
func (m *MsgProducer) PushMsg(userId uint64, server string, cmdId, serviceId uint32, msg []byte) error {
	pushMsg := cim.CIMPushMsg{
		CommondId: cmdId,
		ServiceId: serviceId,
		Server:    server,
		Type:      cim.CIMPushMsg_kCIM_PUSH,
		ToId:      userId,
		Data:      msg,
	}

	data, err := proto.Marshal(&pushMsg)
	if err != nil {
		logger.Sugar.Warnf("marshal pb error:", err.Error())
		return err
	}

	return m.produce(getPushMsgTopic(), data)
}

// broadcast all online user
func (m *MsgProducer) BroadcastMsg(server string, cmdId, serviceId uint32, msg []byte) error {
	pushMsg := cim.CIMPushMsg{
		CommondId: cmdId,
		ServiceId: serviceId,
		Server:    server,
		Type:      cim.CIMPushMsg_kCIM_BROADCAST,
		ToId:      0,
		Data:      msg,
	}

	data, err := proto.Marshal(&pushMsg)
	if err != nil {
		logger.Sugar.Warnf("marshal pb error:", err.Error())
		return err
	}

	return m.produce(getPushMsgTopic(), data)
}

// broadcast room msg
func (m *MsgProducer) PushRoomMsg(room uint64, server string, cmdId, serviceId uint32, msg []byte) error {
	pushMsg := cim.CIMPushMsg{
		CommondId: cmdId,
		ServiceId: serviceId,
		Server:    server,
		Type:      cim.CIMPushMsg_kCIM_ROOM,
		ToId:      room,
		Data:      msg,
	}

	data, err := proto.Marshal(&pushMsg)
	if err != nil {
		logger.Sugar.Warnf("marshal pb error:", err.Error())
		return err
	}
	return m.produce(getPushMsgTopic(), data)
}
