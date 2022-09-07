package data

import (
	"CoffeeChat/log"
	pb "chat/api/chat"
	"chat/internal/data/ent"
	"chat/internal/data/ent/message"
	"context"
	"errors"
	"fmt"
	"strconv"
	"time"
)

type Message struct {
	ID           int64     // 自增ID
	Created      time.Time // 创建时间
	Updated      time.Time // 更新时间
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
	CreateTime   int64
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
	// 根据 from&to 生产一个唯一key，以方便查询私聊消息，群直接根据groupId查即可
	sessionKey := ""
	if msg.SessionType == int(pb.IMSessionType_kCIM_SESSION_TYPE_GROUP) {
		sessionKey = msg.To
	} else if msg.SessionType == int(pb.IMSessionType_kCIM_SESSION_TYPE_SINGLE) {
		sessionKey = m.getSingleSessionId(strconv.FormatInt(msg.From, 10), msg.To)
	} else {
		return nil, errors.New("not support sessionType")
	}

	result, err := m.client.Message.Create().
		SetSessionKey(sessionKey).SetFrom(msg.From).SetTo(msg.To).SetSessionType(int8(msg.SessionType)).
		SetClientMsgID(msg.ClientMsgID).SetServerMsgSeq(msg.ServerMsgSeq).
		SetMsgType(int8(msg.MsgType)).SetMsgData(msg.MsgData).
		SetMsgResCode(int8(msg.MsgResCode)).SetMsgStatus(int8(msg.MsgStatus)).SetMsgFeature(int8(msg.MsgFeature)).
		SetCreateTime(msg.CreateTime).Save(ctx)
	if err != nil {
		return nil, err
	}
	msg.ID = result.ID
	msg.Created = result.Created
	msg.Updated = result.Updated
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

func (m messageRepo) getSingleSessionId(from string, to string) string {
	small, big := from, to
	if from > to {
		small, big = to, from
	}
	return fmt.Sprintf("single:%s:%s", small, big)
}
