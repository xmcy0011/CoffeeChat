package service

import (
	"context"
	"user/api/user"

	pb "apiuser/api/user/v1"
)

type ApiUserService struct {
	pb.UnimplementedApiUserServer
}

func NewApiUserService() *ApiUserService {
	return &ApiUserService{}
}

func (s *ApiUserService) Register(ctx context.Context, req *user.RegisterRequest) (*user.RegisterReply, error) {
	return &user.RegisterReply{}, nil
}

func (s *ApiUserService) Auth(ctx context.Context, req *user.AuthRequest) (*user.AuthReply, error) {
	return &user.AuthReply{}, nil
}
