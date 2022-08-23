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

func (s *ApiUserService) Register(ctx context.Context, req *user.RegisterRequest) (*user.RegisterReply, error) {
	return s.client.Register(ctx, req)
}

func (s *ApiUserService) Auth(ctx context.Context, req *pb.AuthRequestV1) (*user.AuthReply, error) {
	httpCtx := ctx.(http.Context)
	token, err := extractToken(httpCtx)
	if err != nil {
		return nil, err
	}

	return s.client.Auth(ctx, &user.AuthRequest{
		LoginType:   req.LoginType,
		ByMobile:    req.ByMobile,
		AccessToken: token,
		ClientType:  req.ClientType,
	})
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
