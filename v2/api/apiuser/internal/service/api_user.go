package service

import (
	"context"
	"user/api/user"

	pb "apiuser/api/user/v1"
)

type ApiUserService struct {
	pb.UnimplementedApiUserServer

	client user.AuthClient
}

func NewApiUserService(client user.AuthClient) *ApiUserService {
	return &ApiUserService{client: client}
}

func (s *ApiUserService) Register(ctx context.Context, req *user.RegisterRequest) (*user.RegisterReply, error) {
	return s.client.Register(ctx, req)
}

func (s *ApiUserService) Auth(ctx context.Context, req *user.AuthRequest) (*user.AuthReply, error) {
	return s.client.Auth(ctx, req)
}
