package mq

import (
	"github.com/apache/rocketmq-client-go/v2"
	"github.com/apache/rocketmq-client-go/v2/primitive"
	"github.com/apache/rocketmq-client-go/v2/producer"
)

type MsgProducer struct {
	producer rocketmq.Producer
}

var DefaultMsgProducer = &MsgProducer{}

// nameSrv，example: 127.0.0.1:9876
func (m *MsgProducer) StartProducer(nameSrv []string) error {
	p, err := rocketmq.NewProducer(
		producer.WithNsResovler(primitive.NewPassthroughResolver(nameSrv)),
		producer.WithRetry(2),
	)
	if err != nil {
		return err
	}
	DefaultMsgProducer.producer = p

	return p.Start()
}

func (m *MsgProducer) Stop() error {
	if DefaultMsgProducer.producer != nil {
		return DefaultMsgProducer.producer.Shutdown()
	}
	return nil
}

