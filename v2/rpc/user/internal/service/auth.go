package service

import (
	"context"

	pb "user/api/auth"
)

type AuthService struct {
	pb.UnimplementedAuthServer
}

func NewAuthService() *AuthService {
	return &AuthService{}
}

func (s *AuthService) Register(ctx context.Context, req *pb.RegisterRequest) (*pb.RegisterReply, error) {
	return &pb.RegisterReply{}, nil
}
func (s *AuthService) Auth(ctx context.Context, req *pb.AuthRequest) (*pb.AuthReply, error) {
	return &pb.AuthReply{}, nil
}
