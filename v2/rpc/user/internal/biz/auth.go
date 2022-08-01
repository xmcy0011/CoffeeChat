package biz

import (
	"context"
	"user/internal/data"
)

type Auth struct {
	user data.UserRepo
}

func NewAuth(userRepo data.UserRepo) *Auth {
	return &Auth{user: userRepo}
}

func (a *Auth) Register(ctx context.Context) {

}

func (a *Auth) Auth(ctx context.Context) {

}
