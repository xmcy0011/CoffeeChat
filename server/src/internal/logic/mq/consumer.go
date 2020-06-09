package mq

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
