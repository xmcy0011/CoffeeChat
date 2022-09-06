package data

import (
	"CoffeeChat/log"
	"chat/internal/conf"
	"chat/internal/data/cache"
	"chat/internal/data/ent"
	"context"
	"entgo.io/ent/dialect"
	"entgo.io/ent/dialect/sql"
	"fmt"
	"github.com/go-redis/redis/v8"
	"github.com/google/wire"
	"go.uber.org/zap"
	"runtime"
	"time"

	// init mysql driver
	_ "github.com/go-sql-driver/mysql"
)

// ProviderSet is data providers.
var ProviderSet = wire.NewSet(NewRedis, NewEntClient, NewData,
	NewMessageRepo, NewSessionRepo,
	cache.NewMsgSeq)

type Data struct {
	entClient   *ent.Client
	redisClient *redis.Client
}

// NewData .
func NewData(logger *log.Logger, entClient *ent.Client, redisClient *redis.Client) (*Data, func(), error) {
	cleanup := func() {
		logger.Info("closing the data resources")
		if err := entClient.Close(); err != nil {
			logger.Error("close sql client error", zap.Error(err))
		}
	}
	return &Data{
		entClient:   entClient,
		redisClient: redisClient,
	}, cleanup, nil
}

func NewEntClient(c *conf.Data) (*ent.Client, error) {
	// mysql driver
	drv, err := sql.Open(c.Database.Driver, c.Database.Source)
	if err != nil {
		return nil, err
	}
	sqlDrv := dialect.DebugWithContext(drv, func(ctx context.Context, i ...interface{}) {
		log.Trace(ctx).Info("sql" + fmt.Sprintf("%v", i...))
	})

	client := ent.NewClient(ent.Driver(sqlDrv))
	if err = client.Schema.Create(context.Background()); err != nil {
		return nil, err
	}
	return client, nil
}

func NewRedis(c *conf.Data, logger *log.Logger) (*redis.Client, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     c.Redis.Addr,
		Password: c.Redis.Password,
		DB:       int(c.Redis.Db),

		ReadTimeout:  c.Redis.ReadTimeout.AsDuration(),
		WriteTimeout: c.Redis.WriteTimeout.AsDuration(),

		// use go-redis default value
		PoolSize:           10 * runtime.NumCPU(),
		MinIdleConns:       runtime.NumCPU(),
		PoolTimeout:        time.Second * (3 + 1), // ReadTimeout + 1
		IdleTimeout:        time.Minute * 5,
		IdleCheckFrequency: time.Minute,
	})
	err := client.Ping(context.Background()).Err()
	if err != nil {
		return nil, err
	}
	logger.Info("ping redis success", zap.String("addr", fmt.Sprintf("%s/%d", c.Redis.Addr, c.Redis.Db)))
	return client, nil
}
