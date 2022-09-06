package cache

import (
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
	"strconv"
)

const (
	kMsgSeqPrefix = "msgSeq"
)

// MsgSeq 利用redis生成分布式连续递增且唯一的消息ID（会话级别）
type MsgSeq interface {
	IncrSingle(ctx context.Context, from string, to string) (int64, error)
	IncrGroup(ctx context.Context, group string) (int64, error)
	GetSingleLatestSeq(ctx context.Context, from string, to string) (int64, error)
	GetGroupLatestSeq(ctx context.Context, group string) (int64, error)
}

type msgSeq struct {
	client *redis.Client
}

func NewMsgSeq(client *redis.Client) MsgSeq {
	return &msgSeq{
		client: client,
	}
}

func (m *msgSeq) IncrSingle(ctx context.Context, from string, to string) (int64, error) {
	return m.client.Incr(ctx, m.buildSingleKey(from, to)).Result()
}
func (m *msgSeq) IncrGroup(ctx context.Context, group string) (int64, error) {
	return m.client.Incr(ctx, m.buildGroupKey(group)).Result()
}
func (m *msgSeq) GetSingleLatestSeq(ctx context.Context, from string, to string) (int64, error) {
	key := m.buildSingleKey(from, to)
	r, err := m.client.Get(ctx, key).Result()
	if err != nil {
		return 0, err
	}
	return strconv.ParseInt(r, 10, 64)
}
func (m *msgSeq) GetGroupLatestSeq(ctx context.Context, group string) (int64, error) {
	key := m.buildGroupKey(group)
	r, err := m.client.Get(ctx, key).Result()
	if err != nil {
		return 0, err
	}
	return strconv.ParseInt(r, 10, 64)
}

func (m msgSeq) buildSingleKey(from string, to string) string {
	if from < to {
		return fmt.Sprintf("%s:%s:%s", kMsgSeqPrefix, from, to)
	}
	return fmt.Sprintf("%s:%s:%s", kMsgSeqPrefix, to, from)
}
func (m msgSeq) buildGroupKey(group string) string {
	return fmt.Sprintf("%s:group:%s", kMsgSeqPrefix, group)
}
