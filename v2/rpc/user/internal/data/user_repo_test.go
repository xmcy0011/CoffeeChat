package data

import (
	"CoffeeChat/log"
	"context"
	"github.com/stretchr/testify/require"
	"os"
	"testing"
	"time"
	"user/internal/conf"
	"user/internal/data/ent"
	"user/internal/data/pojo"
)

var (
	dataSource = os.Getenv("GoMicroIMDb")
)

func setup(t *testing.T) *Data {
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
	return data
}

func TestUserRepo_Save(t *testing.T) {
	client := setup(t)
	repo := NewUserRepo(client, log.L)
	u, err := repo.Save(context.Background(), &ent.User{
		ID:       0,
		Created:  time.Time{},
		Updated:  time.Time{},
		NickName: "",
		Sex:      0,
		Phone:    "",
		Email:    "",
		Extra:    pojo.UserExtra{},
	})

	require.Equal(t, err, nil)
	t.Log("save success,user:", u)
}
