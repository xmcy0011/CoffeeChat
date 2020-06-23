package mq

import (
	"github.com/apache/rocketmq-client-go/v2/primitive"
	"sync"
)

type MsgProducer struct {
}

var DefaultMsgProducer = &MsgProducer{}

func (m *MsgProducer) StartProducer(nameSrv []string) {
	//p, err := rocketmq.NewTransactionProducer()
}

type MsgListener struct {
	localTrans    *sync.Map // 本地事物存储
	transactionId uint64    // 事物ID，幂等处理
}

//  When send transactional prepare(half) message succeed, this method will be invoked to execute local transaction.
func (m *MsgListener) ExecuteLocalTransaction(msg *primitive.Message) primitive.LocalTransactionState {
	return primitive.UnknowState
}

// When no response to prepare(half) message. broker will send check message to check the transaction status, and this
// method will be invoked to get local transaction status.
func (m *MsgListener) CheckLocalTransaction(msg *primitive.MessageExt) primitive.LocalTransactionState {
	return primitive.UnknowState
}
