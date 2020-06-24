package mq

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"github.com/apache/rocketmq-client-go/v2"
	"github.com/apache/rocketmq-client-go/v2/consumer"
	"github.com/apache/rocketmq-client-go/v2/primitive"
	"github.com/golang/protobuf/proto"
)

/*
import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/conf"
	"coffeechat/pkg/logger"
	"gopkg.in/Shopify/sarama.v2"
	"strconv"
)

type Consumer struct {
	config   *sarama.Config // consumer config
	consumer sarama.Consumer
}

var DefaultConsumer = &Consumer{}

func StartConsumer(kafka conf.Kafka) error {
	config := sarama.NewConfig()
	config.Version = sarama.V2_3_0_0
	config.Consumer.Return.Errors = true

	consumer, err := sarama.NewConsumer(kafka.Brokers, config)
	if err != nil {
		return err
	}
	DefaultConsumer.consumer = consumer
	DefaultConsumer.config = config

	// 有多少台kafka机器，就有多少个分区，就启动多少个consumer
	topicMessageSend := kafka.TopicPrefix + strconv.Itoa(int(cim.CIMCmdID_kCIM_CID_MSG_DATA))
	msgDataConsumer, err := consumer.ConsumePartition(topicMessageSend, 0, sarama.OffsetNewest)
	if err != nil {
		return err
	}

	topicMessageAck := kafka.TopicPrefix + strconv.Itoa(int(cim.CIMCmdID_kCIM_CID_MSG_DATA_ACK))
	msgAckConsumer, err := consumer.ConsumePartition(topicMessageAck, 0, sarama.OffsetNewest)
	if err != nil {
		return err
	}

	go onHandleMsgData(msgDataConsumer)
	go onHandleMsgAck(msgAckConsumer)

	return nil
}

func onHandleMsgData(con sarama.PartitionConsumer) {
	defer con.AsyncClose()

	for {
		select {
		//case msg := <-con.Messages():

		case err := <-con.Errors():
			logger.Sugar.Errorf("recv error,topic=%s,partition=%d,err=%s", err.Topic, err.Partition, err.Error())
		}
	}
}

func onHandleMsgAck(con sarama.PartitionConsumer) {
	defer con.AsyncClose()

	for {
		select {
		//case msg := <-con.Messages():

		case err := <-con.Errors():
			logger.Sugar.Errorf("recv error,topic=%s,partition=%d,err=%s", err.Topic, err.Partition, err.Error())
		}
	}
}
*/

type MsgConsumer struct {
	consumer    rocketmq.PushConsumer
	pushMsgChan chan *cim.CIMPushMsg
}

var DefaultMsgConsumer = NewMsgConsumer()

func NewMsgConsumer() *MsgConsumer {
	return &MsgConsumer{
		pushMsgChan: make(chan *cim.CIMPushMsg),
	}
}

func (m *MsgConsumer) StartConsumer(groupName string, nameServers []string) error {
	c, err := rocketmq.NewPushConsumer(
		consumer.WithGroupName(groupName),
		consumer.WithNsResovler(primitive.NewPassthroughResolver(nameServers)))
	if err != nil {
		return err
	}

	m.consumer = c

	// topic: msg_push
	err = c.Subscribe(getPushMsgTopic(), consumer.MessageSelector{}, m.onMsgPush)
	if err != nil {
		return err
	}
	return c.Start()
}

func (m *MsgConsumer) Shutdown() error {
	if m.consumer != nil {
		close(m.pushMsgChan)
		err := m.consumer.Shutdown()
		m.consumer = nil
		m.pushMsgChan = nil
		return err
	}
	return nil
}

// get a read-only chan
func (m *MsgConsumer) Messages() <-chan *cim.CIMPushMsg {
	return m.pushMsgChan
}

func (m *MsgConsumer) onMsgPush(ctx context.Context, msgs ...*primitive.MessageExt) (result consumer.ConsumeResult, err error) {
	for i := range msgs {
		logger.Sugar.Infof("subscribe callback: %v", msgs[i])

		msg := &cim.CIMPushMsg{}
		err = proto.Unmarshal(msgs[i].Body, msg)
		if err != nil {
			logger.Sugar.Info(err)
		} else {
			m.pushMsgChan <- msg
		}
	}
	return consumer.ConsumeSuccess, nil
}
