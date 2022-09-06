package biz

import (
	"CoffeeChat/log"
	pb "chat/api/chat"
	"chat/internal/data"
	"chat/internal/data/cache"
	"chat/internal/data/ent"
	"context"
	"errors"
	"strconv"
)

type MessageUseCase struct {
	msgRepo     data.MessageRepo
	sessionRepo data.SessionRepo
	seqCache    cache.MsgSeq

	log *log.Logger
}

func NewMessageUseCase(repo data.MessageRepo, seq cache.MsgSeq, sessionRepo data.SessionRepo) *MessageUseCase {
	return &MessageUseCase{
		msgRepo:     repo,
		seqCache:    seq,
		sessionRepo: sessionRepo,
		log:         log.L,
	}
}

func (m *MessageUseCase) Send(ctx context.Context, from int64, to string, clientMsgID string,
	msgType int8, msgData string, createTime int64) (*data.Message, error) {

	// 幂等，如果由于网络等问题，ack客户端没有收到，则下次重发不必再插入数据库
	msg, err := m.msgRepo.FindByClientMsgId(ctx, clientMsgID)
	if err != nil && !ent.IsNotFound(err) {
		return msg, err
	}

	sessionType := pb.IMSessionType_kCIM_SESSION_TYPE_SINGLE

	// check session
	sessions, err := m.sessionRepo.FindSingleSession(ctx, strconv.FormatInt(from, 10), to, sessionType)
	if err != nil {
		return nil, err
	}
	if len(sessions) <= 0 {
		err = m.sessionRepo.Create(ctx, &data.Session{
			UserId:        strconv.FormatInt(from, 10),
			PeerId:        to,
			SessionType:   sessionType,
			SessionStatus: pb.IMSessionStatusType_kCIM_SESSION_STATUS_OK,
		})
		if err != nil {
			return nil, err
		}
	} else {
		if len(sessions) == 1 {
			m.log.Warn("single session miss row")
		}
		for _, v := range sessions {
			if v.SessionStatus == pb.IMSessionStatusType_kCIM_SESSION_STATUS_OK {
				continue
			}
			_, err = m.sessionRepo.UpdateStatus(ctx, v.Id, pb.IMSessionStatusType_kCIM_SESSION_STATUS_OK)
			if err != nil {
				return nil, err
			}
		}
	}

	return nil, nil
}

func (m *MessageUseCase) SendGroup(ctx context.Context, groupId int64, sessionType int,
	clientMsgID string, msgType int8, msgData string, createTime int32) (*data.Message, error) {
	return nil, errors.New("not implemented")
}
