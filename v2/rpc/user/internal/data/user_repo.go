package data

import (
	"CoffeeChat/log"
	"context"
	"user/internal/biz"
	"user/internal/data/ent"
	"user/internal/data/ent/user"
)

type userRepo struct {
	data *Data
	log  *log.Logger
}

func NewUserRepo(data *Data, logger *log.Logger) biz.UserRepo {
	return &userRepo{
		data: data,
		log:  logger,
	}
}

func (u *userRepo) ent2Model(user *ent.User, err error) (*biz.User, error) {
	if err != nil {
		return nil, err
	}
	return &biz.User{
		ID:       user.ID,
		Created:  user.Created,
		Updated:  user.Updated,
		NickName: user.NickName,
		Sex:      user.Sex,
		Phone:    user.Phone,
		Email:    user.Email,
		Extra:    user.Extra,
	}, nil
}

func (u *userRepo) Save(ctx context.Context, user *biz.User) (*biz.User, error) {
	return u.ent2Model(u.data.User.Create().
		SetNickName(user.NickName).
		SetEmail(user.Email).
		SetPhone(user.Phone).
		SetSex(user.Sex).
		SetExtra(user.Extra).Save(ctx))
}
func (u *userRepo) Update(ctx context.Context, newUser *biz.User) error {
	_, err := u.data.User.UpdateOneID(newUser.ID).
		SetNickName(newUser.NickName).
		SetSex(newUser.Sex).
		SetPhone(newUser.Phone).
		SetEmail(newUser.Email).
		Save(ctx)
	return err
}
func (u *userRepo) FindByID(ctx context.Context, id int64) (*biz.User, error) {
	return u.ent2Model(u.data.User.Query().Where(user.ID(id)).Only(ctx))
}
func (u *userRepo) FindByPhone(ctx context.Context, phone string) (*biz.User, error) {
	return u.ent2Model(u.data.User.Query().Where(user.Phone(phone)).Only(ctx))
}
func (u *userRepo) ListAll(ctx context.Context) ([]*biz.User, error) {
	entUsers, err := u.data.User.Query().All(ctx)
	if err != nil {
		return nil, err
	}
	users := make([]*biz.User, len(entUsers))
	for k, v := range entUsers {
		item, _ := u.ent2Model(v, nil)
		users[k] = item
	}
	return users, nil
}
