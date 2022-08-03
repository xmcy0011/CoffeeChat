package data

import (
	"CoffeeChat/log"
	"context"
	"github.com/stretchr/testify/require"
	"os"
	"testing"
	"user/internal/conf"
	"user/internal/data/ent"
	"user/internal/data/pojo"
)

var (
	dataSource = os.Getenv("GoMicroIMDb")
)

func setupUserRepo(t *testing.T) UserRepo {
	data, _, err := NewData(&conf.Data{
		Database: &conf.Data_Database{
			Driver: "mysql",
			Source: dataSource,
		},
		Redis: nil,
	}, log.L)
	if err != nil {
		t.Fatal(err)
	}
	return NewUserRepo(data, log.L)
}

func TestUserRepo_Save(t *testing.T) {
	repo := setupUserRepo(t)
	u, err := repo.Save(context.Background(), &ent.User{
		NickName: "xmcy0011",
		Sex:      1,
		Phone:    "17300000000",
		Email:    "xmcy0011@sina.com",
		Extra:    pojo.UserExtra{},
	})

	require.Equal(t, err, nil)
	t.Log("save success,user:", u)
}

func TestUserRepo_Update(t *testing.T) {
	repo := setupUserRepo(t)
	err := repo.Update(context.Background(), &ent.User{ID: 2, NickName: "xmcy0011-New"})
	require.Equal(t, err, nil)
}

func TestUserRepo_ListAll(t *testing.T) {
	repo := setupUserRepo(t)
	arr, err := repo.ListAll(context.Background())
	require.Equal(t, err, nil)
	t.Log(arr)
}

func TestUserRepo_FindByPhone(t *testing.T) {
	repo := setupUserRepo(t)
	arr, err := repo.FindByPhone(context.Background(), "333")
	if ent.IsNotFound(err) {
		t.Log("not found")
		return
	}
	require.Equal(t, err, nil)
	t.Log(arr)
}
