package rpcserver

import (
	"context"
	"github.com/CoffeeChat/server/src/api/cim"
)

// 查询会话列表
func (s *LogicServer) RecentContactSession(ctx context.Context, in *cim.CIMRecentContactSessionReq) (*cim.CIMRecentContactSessionRsp, error) {
	return nil, nil
}

// 查询历史消息列表
func (s *LogicServer) GetMsgList(ctx context.Context, in *cim.CIMGetMsgListReq) (*cim.CIMGetMsgListRsp, error) {
	return nil, nil
}
