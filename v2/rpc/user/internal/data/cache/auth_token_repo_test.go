package cache

import (
	"CoffeeChat/jwt"
	"context"
	"github.com/go-redis/redis/v8"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

func setupRedis(t *testing.T) *redis.Client {
	client := redis.NewClient(&redis.Options{
		Addr:     "127.0.0.1:6379",
		Password: "coffeechat",
		DB:       0,
	})
	if err := client.Ping(context.Background()).Err(); err != nil {
		t.Fatal(err)
	}
	return client
}

func TestAuthTokenRepo_CreateAuth(t *testing.T) {
	r := setupRedis(t)
	repo := NewAuthTokenRepo(r)

	token := jwt.TokenDetails{
		AccessToken:  "token1",
		RefreshToken: "token2",
		AccessUuid:   "fffff-1111-3333",
		RefreshUuid:  "ddddd-fff333-111",
		AtExpires:    time.Now().Add(time.Minute * 10).Unix(),
		RtExpires:    time.Now().Add(time.Hour * 24 * 7).Unix(),
	}

	// when user login
	ctx := context.Background()
	err := repo.CreateAuth(ctx, 333, token)
	assert.NoError(t, err)

	// http auth middleware
	userId, err := repo.FetchAuth(ctx, token)
	assert.NoError(t, err)
	t.Log("FetchAuth success,userId:", userId)

	// when user logout

	userId, err = repo.DeleteAuth(ctx, token.AccessUuid)
	assert.NoError(t, err)
	userId, err = repo.DeleteAuth(ctx, token.RefreshUuid)
	assert.NoError(t, err)
	_, err = repo.FetchAuth(ctx, token)
	if err == nil {
		t.Fatal("Delete Auth failed")
	} else {
		t.Log("user logout success")
	}
}
