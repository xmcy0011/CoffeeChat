package service

import (
	"context"
	"github.com/go-kratos/kratos/v2/errors"
	"github.com/go-kratos/kratos/v2/transport/http"
	"strings"
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

func (s *ApiUserService) Register(ctx context.Context, req *pb.RegisterRequest) (*pb.RegisterReply, error) {
	result, err := s.client.Register(ctx, &user.RegisterRequest{
		DeviceId:   req.DeviceId,
		AppVersion: req.AppVersion,
		OsVersion:  req.OsVersion,
	})
	if err != nil {
		return nil, err
	}
	return &pb.RegisterReply{
		AccessToken: result.AccessToken,
		AtExpires:   result.AtExpires,
	}, nil
}

func (s *ApiUserService) Auth(ctx context.Context, req *pb.AuthRequest) (*pb.AuthReply, error) {
	httpCtx := ctx.(http.Context)
	token, err := extractToken(httpCtx)
	if err != nil {
		return nil, err
	}

	result, err := s.client.Auth(ctx, &user.AuthRequest{
		LoginType: user.AuthRequest_LoginType(req.LoginType),
		ByMobile: &user.AuthRequest_MobileAuth{
			Phone: req.ByMobile.Phone,
			Code:  req.ByMobile.Code,
		},
		AccessToken: token,
		ClientType:  user.AuthRequest_ClientType(req.ClientType),
	})
	if err != nil {
		return nil, err
	}

	return &pb.AuthReply{
		AccessToken:  result.AccessToken,
		RefreshToken: result.RefreshToken,
		AtExpires:    result.AtExpires,
		RtExpires:    result.RtExpires,
		UserId:       result.UserId,
	}, nil
}

func extractToken(ctx http.Context) (string, error) {
	token := ctx.Header().Get("Authorization")
	if token == "" {
		return "", errors.BadRequest(pb.ErrorReason_TOKEN_MISS.String(), "miss token")
	}

	arr := strings.Split(token, " ")
	if len(arr) != 2 {
		return "", errors.BadRequest(pb.ErrorReason_TOKEN_INVALID.String(), "miss token")
	} else {
		return arr[1], nil
	}
}
