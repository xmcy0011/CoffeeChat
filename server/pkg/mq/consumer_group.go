package mq

import (
	"coffeechat/pkg/logger"
	"context"
	"github.com/Shopify/sarama"
	"log"
)

type MsgConsumerGroup struct {
	consumerGroup sarama.ConsumerGroup
}

/*
func (msgConsumerGroup) Setup(_ sarama.ConsumerGroupSession) error   { return nil }
func (msgConsumerGroup) Cleanup(_ sarama.ConsumerGroupSession) error { return nil }
func (h msgConsumerGroup) ConsumeClaim(sess sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
	for msg := range claim.Messages() {
		fmt.Printf("Message topic:%q partition:%d offset:%d  value:%s\n", msg.Topic, msg.Partition, msg.Offset, string(msg.Value))

		// insertToMysql()

		// 一定要调用，标记一条消息已被处理，sarama会自动进行提交，如果不调用，下次启动消费者将从头重新消费
		sess.MarkMessage(msg, "")

		//consumerCount++
		//if consumerCount%3 == 0 {
		//	// 手动提交，不能频繁调用，耗时9ms左右，macOS i7 16GB
		//	t1 := time.Now().Nanosecond()
		//	sess.Commit()
		//	t2 := time.Now().Nanosecond()
		//	fmt.Println("commit cost:", (t2-t1)/(1000*1000), "ms")
		//}
	}
	return nil
}
*/

// NewMsgConsumerGroup 启动一个新的消费组
// addr: 地址
// groupId：消费组ID
// offset：消费起始偏移 sarama.OffsetNewest or sarama.OffsetOldest
func NewMsgConsumerGroup(addr []string, groupId string, offset int64) *MsgConsumerGroup {
	// consumer
	consumerConfig := sarama.NewConfig()
	consumerConfig.Version = sarama.V2_2_0_0 // specify appropriate version
	consumerConfig.Consumer.Return.Errors = false
	//consumerConfig.Consumer.Offsets.AutoCommit.Enable = isAutoCommit      // 禁用自动提交，改为手动
	//consumerConfig.Consumer.Offsets.AutoCommit.Interval = time.Second * 1 // 测试3秒自动提交
	consumerConfig.Consumer.Offsets.Initial = offset

	// 拿到原始client，可以获取集群的一些信息
	newClient, err := sarama.NewClient(addr, consumerConfig)
	if err != nil {
		log.Fatal(err)
	}

	cGroup, err := sarama.NewConsumerGroupFromClient(groupId, newClient)
	if err != nil {
		panic(err)
	}

	return &MsgConsumerGroup{
		consumerGroup: cGroup,
	}
}

// Consume 启动消费组
// 下面是一个示例：一定是业务逻辑成功后在进行标记，否则会造成消息丢失
//func (h msgConsumerGroup) ConsumeClaim(sess sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
// 	for msg := range claim.Messages() {
//      // you code, must before MarkMessage(), example: insertToMysql()
//		// 一定要调用，标记一条消息已被处理，sarama会自动进行提交，如果不调用，下次启动消费者将从头重新消费
//		sess.MarkMessage(msg, "")
//}
func (m *MsgConsumerGroup) Consume(topics []string, handler sarama.ConsumerGroupHandler) {
	defer m.consumerGroup.Close()
	for {
		err := m.consumerGroup.Consume(context.Background(), topics, handler)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			break
		}
	}
}
