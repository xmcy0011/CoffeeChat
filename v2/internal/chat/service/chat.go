package service

import (
	pb "CoffeeChat/api/chat"
	"context"
)

type ChatService struct {
	pb.UnimplementedChatServer
}

func NewChatService() *ChatService {
	return &ChatService{}
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
