package data

import (
	"CoffeeChat/log"
	"chat/internal/data/ent"
	"chat/internal/data/ent/message"
	"context"
	"time"
)

type Message struct {
	ID           int64
	Created      time.Time
	Updated      time.Time
	From         int64
	To           string
	SessionType  int
	ClientMsgID  string
	ServerMsgSeq int64
	MsgType      int
	MsgData      string
	MsgResCode   int
	MsgFeature   int
	MsgStatus    int
	CreateTime   int32
}

type MessageRepo interface {
	Create(context.Context, *Message) (*Message, error)
	FindByClientMsgId(ctx context.Context, clientMsgId string) (*Message, error)
}

type messageRepo struct {
	log    *log.Logger
	client *ent.Client
}

func NewMessageRepo(data *Data, logger *log.Logger) MessageRepo {
	return &messageRepo{
		client: data.entClient,
		log:    logger,
	}
}

func (m *messageRepo) Create(ctx context.Context, msg *Message) (*Message, error) {
	result, err := m.client.Message.Create().SetFrom(msg.From).
		SetTo(msg.To).SetSessionType(int8(msg.SessionType)).SetClientMsgID(msg.ClientMsgID).
		SetServerMsgSeq(msg.ServerMsgSeq).SetMsgType(int8(msg.MsgType)).SetMsgData(msg.MsgData).
		SetMsgResCode(int8(msg.MsgResCode)).SetMsgStatus(int8(msg.MsgStatus)).
		SetCreateTime(msg.CreateTime).Save(ctx)
	if err != nil {
		return nil, err
	}
	msg.ID = result.ID
	return msg, nil
}

func (m *messageRepo) ent2model(old *ent.Message, err error) (*Message, error) {
	if err != nil {
		return nil, err
	}
	return &Message{
		ID:           old.ID,
		Created:      old.Created,
		Updated:      old.Updated,
		From:         old.From,
		To:           old.To,
		SessionType:  int(old.SessionType),
		ClientMsgID:  old.ClientMsgID,
		ServerMsgSeq: old.ServerMsgSeq,
		MsgType:      int(old.MsgType),
		MsgData:      old.MsgData,
		MsgResCode:   int(old.MsgResCode),
		MsgFeature:   int(old.MsgFeature),
		MsgStatus:    int(old.MsgStatus),
		CreateTime:   old.CreateTime,
	}, nil
}

func (m *messageRepo) FindByClientMsgId(ctx context.Context, clientMsgId string) (*Message, error) {
	return m.ent2model(m.client.Message.Query().Where(message.ClientMsgID(clientMsgId)).Only(ctx))
}
