package biz

import (
	"CoffeeChat/jwt"
	"context"
	"user/internal/conf"
)

type AuthUseCase struct {
	authRepo AuthTokenRepo
	jwt      *jwt.TokenGenerate
}

type AuthTokenRepo interface {
	CreateAuth(ctx context.Context, userid int64, details jwt.TokenDetails) error
	DeleteAuth(ctx context.Context, givenUuid string) (userId int64, err error)
	FetchAuth(ctx context.Context, tokenUuid string) (userId int64, err error)
}

func NewAuthUseCase(jwtConf *conf.Server_JWT, repo AuthTokenRepo) *AuthUseCase {
	return &AuthUseCase{
		jwt:      jwt.NewTokenGenerate(jwtConf.AccessSecret, jwtConf.RefreshSecret),
		authRepo: repo,
	}
}

func (a *AuthUseCase) CreateToken(ctx context.Context, info jwt.ClientInfo, needPersistence bool) (*jwt.TokenDetails, error) {
	details, err := a.jwt.CreateToken(info)
	if err == nil && needPersistence {
		// persistence to redis
		if err = a.authRepo.CreateAuth(ctx, info.UserId, *details); err != nil {
			return nil, err
		}
	}
	return details, err
}

func (a *AuthUseCase) VerifyToken(ctx context.Context, token string) (*jwt.ClientInfo, error) {
	clientInfo, details, err := a.jwt.ParseToken(token, false)
	if err != nil {
		return nil, err
	}
	// check token exist in redis
	if _, err = a.authRepo.FetchAuth(ctx, details.AccessUuid); err != nil {
		return nil, err
	}
	return clientInfo, nil
}

func (a *AuthUseCase) GetClientInfo(token string) (*jwt.ClientInfo, error) {
	clientInfo, _, err := a.jwt.ParseToken(token, false)
	if err != nil {
		return nil, err
	}
	return clientInfo, nil
}

func (a *AuthUseCase) RefreshToken(ctx context.Context, refreshToken string) error {
	clientInfo, details, err := a.jwt.ParseToken(refreshToken, true)
	if err != nil {
		return err
	}
	//Delete the previous Refresh Token
	if _, err = a.authRepo.DeleteAuth(ctx, details.RefreshUuid); err != nil {
		return err
	}
	token, err := a.jwt.CreateToken(*clientInfo)
	if err != nil {
		return err
	}
	return a.authRepo.CreateAuth(ctx, clientInfo.UserId, *token)
}

func (a *AuthUseCase) DeleteToken(ctx context.Context, accessToken string) error {
	_, details, err := a.jwt.ParseToken(accessToken, false)
	if err != nil {
		return err
	}
	_, err = a.authRepo.DeleteAuth(ctx, details.AccessUuid)
	return err
}
