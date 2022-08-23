package biz

import (
	"CoffeeChat/log"
	"context"
	"time"
	"user/internal/data/ent"
	"user/internal/data/pojo"
)

type User struct {
	ID       int64          `json:"id,omitempty"`
	Created  time.Time      `json:"created,omitempty"`
	Updated  time.Time      `json:"updated,omitempty"`
	NickName string         `json:"nick_name,omitempty"`
	Sex      int8           `json:"sex,omitempty"`
	Phone    string         `json:"phone,omitempty"`
	Email    string         `json:"email,omitempty"`
	Extra    pojo.UserExtra `json:"extra,omitempty"`
}

type UserRepo interface {
	Save(context.Context, *User) (*User, error)
	Update(context.Context, *User) error
	FindByID(context.Context, int64) (*User, error)
	FindByPhone(ctx context.Context, phone string) (*User, error)
	ListAll(context.Context) ([]*User, error)
}

type UserUseCase struct {
	repo UserRepo
	log  *log.Logger
}

func NewUserUseCase(repo UserRepo, logger *log.Logger) *UserUseCase {
	return &UserUseCase{
		repo: repo,
		log:  logger,
	}
}

func (u *UserUseCase) RegisterByPhone(ctx context.Context, phone string) (*User, error) {
	user, err := u.repo.FindByPhone(ctx, phone)
	if err != nil {
		if ent.IsNotFound(err) {
			user = &User{
				NickName: phone,
				Phone:    phone,
			}
			return u.repo.Save(ctx, user)
		}
		return nil, err
	}
	return user, nil
}
