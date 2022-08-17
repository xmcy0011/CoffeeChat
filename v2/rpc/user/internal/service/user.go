package service

import (
	"context"
	"user/api/user"
	"user/internal/biz"
)

type UserService struct {
	user.UnimplementedAuthServer

	dc *biz.DeviceUseCase
}

func NewAuthService(dc *biz.DeviceUseCase) *UserService {
	return &UserService{dc: dc}
}

func (s *UserService) Register(ctx context.Context, req *user.RegisterRequest) (*user.RegisterReply, error) {
	device, err := s.dc.Register(ctx, &biz.Device{
		DeviceID:   req.DeviceId,
		AppVersion: req.AppVersion,
		OsVersion:  req.OsVersion,
	})
	if err != nil {
		return nil, err
	}
	return &user.RegisterReply{Id: device.ID}, nil
}

func (s *UserService) Auth(ctx context.Context, req *user.AuthRequest) (*user.AuthReply, error) {
	return &user.AuthReply{}, nil
}
