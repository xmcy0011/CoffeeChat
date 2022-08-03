package data

import (
	"CoffeeChat/log"
	"context"
	"user/internal/data/ent"
	"user/internal/data/ent/user"
)

type UserRepo interface {
	Save(context.Context, *ent.User) (*ent.User, error)
	Update(context.Context, *ent.User) error
	FindByID(context.Context, int32) (*ent.User, error)
	FindByPhone(ctx context.Context, phone string) (*ent.User, error)
	ListAll(context.Context) ([]*ent.User, error)
}

type userRepo struct {
	data *Data
	log  *log.Logger
}

func NewUserRepo(data *Data, logger *log.Logger) UserRepo {
	return &userRepo{
		data: data,
		log:  logger,
	}
}

func (u *userRepo) Save(ctx context.Context, user *ent.User) (*ent.User, error) {
	return u.data.User.Create().
		SetNickName(user.NickName).
		SetEmail(user.Email).
		SetPhone(user.Phone).
		SetSex(user.Sex).
		SetExtra(user.Extra).Save(ctx)
}
func (u *userRepo) Update(ctx context.Context, newUser *ent.User) error {
	_, err := u.data.User.UpdateOneID(newUser.ID).
		SetNickName(newUser.NickName).
		SetSex(newUser.Sex).
		SetPhone(newUser.Phone).
		SetEmail(newUser.Email).
		Save(ctx)
	return err
}
func (u *userRepo) FindByID(ctx context.Context, id int32) (*ent.User, error) {
	return u.data.User.Query().Where(user.ID(id)).Only(ctx)
}
func (u *userRepo) FindByPhone(ctx context.Context, phone string) (*ent.User, error) {
	return u.data.User.Query().Where(user.Phone(phone)).Only(ctx)
}
func (u *userRepo) ListAll(ctx context.Context) ([]*ent.User, error) {
	return u.data.User.Query().All(ctx)
}
