package service

import (
	"context"
	"github.com/go-kratos/kratos/v2/log"

	pb "CoffeeChat/api/chat"
)

type ChatService struct {
	pb.UnimplementedChatServer

	l log.Logger
}

func NewChatService(logger log.Logger) *ChatService {
	return &ChatService{l: logger}
}

func (s *ChatService) RecentContactSession(ctx context.Context, req *pb.CIMRecentContactSessionReq) (*pb.CIMRecentContactSessionRsp, error) {
	return &pb.CIMRecentContactSessionRsp{}, nil
}
func (s *ChatService) GetMsgList(ctx context.Context, req *pb.CIMGetMsgListReq) (*pb.CIMGetMsgListRsp, error) {
	return &pb.CIMGetMsgListRsp{}, nil
}
func (s *ChatService) Send(ctx context.Context, req *pb.CIMMsgData) (*pb.CIMMsgDataAck, error) {
	return &pb.CIMMsgDataAck{}, nil
}
func (s *ChatService) MsgReadAck(ctx context.Context, req *pb.CIMMsgDataReadReq) (*pb.CIMMsgDataReadRsp, error) {
	return &pb.CIMMsgDataReadRsp{}, nil
}
