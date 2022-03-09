package mq

import (
	"coffeechat/pkg/logger"
	"github.com/Shopify/sarama"
	"math/rand"
	"time"
)

type SyncProducer struct {
	producer sarama.SyncProducer
}

// NewSyncProducer 同步生产者
func NewSyncProducer(addr []string) *SyncProducer {
	// producer
	config := sarama.NewConfig()
	config.Producer.RequiredAcks = sarama.WaitForAll // 所有kafka从节点返回后才认为成功
	config.Producer.Retry.Max = 10                   // Retry up to 10 times to produce the message
	config.Producer.Return.Successes = true
	config.Producer.Partitioner = sarama.NewHashPartitioner // 针对Key进行Hash，只要Key一样，始终落到1个分区，1个分区内消息有序

	producer, err := sarama.NewSyncProducer(addr, config)
	if err != nil {
		panic(err.Error())
	}
	return &SyncProducer{
		producer: producer,
	}
}

// SendMessage 同步发送消息，使用同步模式+WaitForAll等待所有从节点ack确认，保证消息不丢，缺点是性能没有异步的高效
func (s *SyncProducer) SendMessage(topic string, value, key string) (partition int32, offset int64, err error) {
	rand.Seed(int64(time.Now().Nanosecond()))
	msg := &sarama.ProducerMessage{
		Topic: topic,
		Value: sarama.StringEncoder(value),
		Key:   sarama.StringEncoder(key),
	}

	t1 := time.Now().Nanosecond()
	partition, offset, err = s.producer.SendMessage(msg)
	t2 := time.Now().Nanosecond()
	if err == nil {
		logger.Sugar.Infof("produce success, partition:%d, offset:%d, cost:%d ms",
			partition, offset, (t2-t1)/(1000*1000))
	}
	return
}

// Close close the SyncProducer
func (s *SyncProducer) Close() error {
	return s.producer.Close()
}
