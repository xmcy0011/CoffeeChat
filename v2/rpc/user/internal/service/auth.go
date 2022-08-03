package service

import (
	"context"
	"user/internal/biz"

	pb "user/api/auth"
)

type AuthService struct {
	pb.UnimplementedAuthServer

	dc *biz.DeviceUseCase
}

func NewAuthService(dc *biz.DeviceUseCase) *AuthService {
	return &AuthService{dc: dc}
}

func (s *AuthService) Register(ctx context.Context, req *pb.RegisterRequest) (*pb.RegisterReply, error) {
	device, err := s.dc.Register(ctx, &biz.Device{
		DeviceID:   req.DeviceId,
		AppVersion: req.AppVersion,
		OsVersion:  req.OsVersion,
	})
	if err != nil {
		return nil, err
	}
	return &pb.RegisterReply{Id: device.ID}, nil
}

func (s *AuthService) Auth(ctx context.Context, req *pb.AuthRequest) (*pb.AuthReply, error) {
	return &pb.AuthReply{}, nil
}
