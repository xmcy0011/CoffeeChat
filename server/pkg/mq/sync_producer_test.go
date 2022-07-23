package mq

import (
	"coffeechat/pkg/logger"
	"github.com/Shopify/sarama"
	"log"
	"strconv"
	"testing"
	"time"
)

var (
	kafkaAddr       = []string{"127.0.0.1:9092"}
	consumerGroupId = "wechat_work"
	topic           = "test"
)

type ConsumerGroup struct {
}

// Setup is run at the beginning of a new session, before ConsumeClaim.
func (c *ConsumerGroup) Setup(sarama.ConsumerGroupSession) error {
	return nil
}

// Cleanup is run at the end of a session, once all ConsumeClaim goroutines have exited
// but before the offsets are committed for the very last time.
func (c *ConsumerGroup) Cleanup(sarama.ConsumerGroupSession) error {
	return nil
}

// ConsumeClaim must start a consumer loop of ConsumerGroupClaim's Messages().
// Once the Messages() channel is closed, the Handler must finish its processing
// loop and exit.
func (c *ConsumerGroup) ConsumeClaim(session sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
	for msg := range claim.Messages() {
		log.Printf("recv msg:%s, key:%s, partition:%d, offset:%d, time:%d ",
			string(msg.Value), string(msg.Key), msg.Partition, msg.Offset, msg.Timestamp.Unix())

		lag := claim.HighWaterMarkOffset() - msg.Offset
		log.Println("lag:", lag)

		session.MarkMessage(msg, "consumed")
	}

	return nil
}

func TestSyncProducer_SendMessage(t *testing.T) {
	logger.InitLogger("log", "DEBUG")

	// start consumer group
	consumerGroup := NewMsgConsumerGroup(kafkaAddr, consumerGroupId, sarama.OffsetNewest)
	go func() {
		log.Println("success start consumer group")
		consumerGroup.Consume([]string{topic}, &ConsumerGroup{})
	}()

	// start producer
	producer := NewSyncProducer(kafkaAddr)

	for i := 0; i < 100; i++ {
		key := "recvId1"
		if i%2 == 0 {
			key = "recvId2"
		}
		msg := "hello" + strconv.Itoa(i)
		p, o, err := producer.SendMessage(topic, msg, key)
		if err != nil {
			t.Error(err)
			return
		} else {
			log.Printf("success produce, msg=%s, partition=%d, offset=%d,", msg, p, o)
		}
		time.Sleep(time.Second * 3)
	}

	t.Log("test pass")
}
