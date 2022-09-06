package service

import (
	"chat/internal/biz"
	"context"

	pb "chat/api/chat"
)

type ChatService struct {
	pb.UnimplementedChatServer

	messageBiz *biz.MessageUseCase
}

func NewChatService(msgBiz *biz.MessageUseCase) *ChatService {
	return &ChatService{messageBiz: msgBiz}
}

func (s *ChatService) SendMsg(ctx context.Context, req *pb.SendMsgRequest) (*pb.SendMsgReply, error) {
	return &pb.SendMsgReply{}, nil
}
func (s *ChatService) GetSyncMessage(ctx context.Context, req *pb.SyncMessageRequest) (*pb.SyncMessageReply, error) {
	return &pb.SyncMessageReply{}, nil
}
func (s *ChatService) GetRecentContactSession(ctx context.Context, req *pb.GetRecentSessionRequest) (*pb.GetRecentSessionReply, error) {
	return &pb.GetRecentSessionReply{}, nil
}
func (s *ChatService) GetMsgList(ctx context.Context, req *pb.GetMsgListRequest) (*pb.GetMsgListReply, error) {
	return &pb.GetMsgListReply{}, nil
}
func (s *ChatService) MsgReadAck(ctx context.Context, req *pb.MsgReadAckRequest) (*pb.MsgReadAckReply, error) {
	return &pb.MsgReadAckReply{}, nil
}
