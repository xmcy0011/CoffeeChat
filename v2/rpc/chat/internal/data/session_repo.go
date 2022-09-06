package data

import (
	"CoffeeChat/ent/utils"
	"CoffeeChat/log"
	pb "chat/api/chat"
	"chat/internal/data/ent"
	"chat/internal/data/ent/session"
	"context"
	"time"
)

type Session struct {
	Id            int32
	Created       time.Time
	Updated       time.Time
	UserId        string                 // 用户ID
	PeerId        string                 // 对方ID
	SessionType   pb.IMSessionType       // 会话类型，0：未知，1：用户，2：群组
	SessionStatus pb.IMSessionStatusType // 会话状态，0：正常，1：被删除
}

type SessionRepo interface {
	Create(ctx context.Context, session *Session) error
	FindOne(ctx context.Context, userId, peerId string, sessionType pb.IMSessionType) (*Session, error)
	FindSingleSession(ctx context.Context, userId, peerId string, sessionType pb.IMSessionType) ([]*Session, error)
	UpdateStatus(ctx context.Context, sessionId int32, sessionStatus pb.IMSessionStatusType) (int, error)
}

type sessionRepo struct {
	client *ent.Client
	log    *log.Logger
}

func NewSessionRepo(data *Data, logger *log.Logger) SessionRepo {
	return &sessionRepo{client: data.entClient, log: logger}
}

func (s *sessionRepo) Create(ctx context.Context, session *Session) error {
	if session.SessionType == pb.IMSessionType_kCIM_SESSION_TYPE_SINGLE {
		tx, err := s.client.Tx(ctx)
		if err != nil {
			return err
		}

		return utils.EntWithTx(tx, s.log, ctx, func(ctx context.Context) error {
			// 创建双向会话
			r, err := tx.Session.Create().SetSessionType(int8(session.SessionType)).
				SetSessionStatus(int8(session.SessionStatus)).
				SetUserID(session.UserId).SetPeerID(session.PeerId).Save(ctx)
			if err != nil {
				return err
			}
			session.Id = r.ID

			_, err = tx.Session.Create().SetSessionType(int8(session.SessionType)).
				SetSessionStatus(int8(session.SessionStatus)).
				SetUserID(session.PeerId).SetPeerID(session.UserId).Save(ctx)
			if err != nil {
				return err
			}
			return nil
		})
	}

	// 创建双向会话
	r, err := s.client.Session.Create().SetSessionType(int8(session.SessionType)).
		SetSessionStatus(int8(session.SessionStatus)).
		SetUserID(session.UserId).SetPeerID(session.PeerId).Save(ctx)
	if err != nil {
		session.Id = r.ID
	}
	return err
}

func (s *sessionRepo) ent2Model(session *ent.Session) *Session {
	return &Session{
		Id:            session.ID,
		Created:       session.Created,
		Updated:       session.Updated,
		UserId:        session.UserID,
		PeerId:        session.PeerID,
		SessionType:   pb.IMSessionType(session.SessionType),
		SessionStatus: pb.IMSessionStatusType(session.SessionStatus),
	}
}

func (s *sessionRepo) FindOne(ctx context.Context, userId, peerId string, sessionType pb.IMSessionType) (*Session, error) {
	r, err := s.client.Session.Query().
		Where(session.UserID(userId), session.PeerID(peerId), session.SessionType(int8(sessionType))).
		Only(ctx)
	if err != nil {
		return nil, err
	}
	return s.ent2Model(r), nil
}

func (s *sessionRepo) FindSingleSession(ctx context.Context, userId, peerId string, sessionType pb.IMSessionType) ([]*Session, error) {
	r, err := s.client.Session.Query().
		Where(
			session.Or(session.UserID(userId), session.PeerID(peerId), session.SessionType(int8(sessionType))),
			session.Or(session.UserID(peerId), session.PeerID(userId), session.SessionType(int8(sessionType))),
		).All(ctx)
	if err != nil {
		return nil, err
	}

	sessions := make([]*Session, len(r))
	for k, v := range r {
		sessions[k] = s.ent2Model(v)
	}
	return sessions, nil
}

func (s *sessionRepo) UpdateStatus(ctx context.Context, sessionId int32, sessionStatus pb.IMSessionStatusType) (int, error) {
	return s.client.Session.Update().Where(session.ID(sessionId)).SetSessionStatus(int8(sessionStatus)).Save(ctx)
}
