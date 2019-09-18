package rpcserver

import (
	"context"
	"github.com/CoffeeChat/server/src/api/cim"
)

// 发消息
func (s *LogicServer) SendMsgData(ctx context.Context, in *cim.CIMMsgData) (*cim.CIMMsgDataAck, error) {
	return nil, nil
}

// 消息收到ACK
func (s *LogicServer) AckMsgData(ctx context.Context, in *cim.CIMMsgDataAck) (*cim.Empty, error) {
	return nil, nil
}
