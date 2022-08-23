package data

import (
	"CoffeeChat/log"
	"context"
	"entgo.io/ent/dialect"
	"entgo.io/ent/dialect/sql"
	"fmt"
	"github.com/go-redis/redis/v8"
	"github.com/google/wire"
	"go.uber.org/zap"
	"runtime"
	"time"
	"user/internal/conf"
	"user/internal/data/cache"
	"user/internal/data/ent"

	// init mysql driver
	_ "github.com/go-sql-driver/mysql"
)

// ProviderSet is data providers.
var ProviderSet = wire.NewSet(NewData, NewRedis, NewUserRepo, NewDeviceRepo, cache.NewAuthTokenRepo)

// Data ent client
type Data struct {
	*ent.Client
}

// NewData create ent client
func NewData(c *conf.Data, logger *log.Logger) (*Data, func(), error) {
	drv, err := sql.Open(c.Database.Driver, c.Database.Source)
	if err != nil {
		return nil, nil, err
	}
	sqlDrv := dialect.DebugWithContext(drv, func(ctx context.Context, i ...interface{}) {
		log.Trace(ctx).Info("sql" + fmt.Sprintf("%v", i...))

		// trace
		//tracer := otel.Tracer("ent.")
		//kind := trace.SpanKindServer
		//_, span := tracer.Start(ctx,
		//	"Query",
		//	trace.WithAttributes(
		//		attribute.String("sql", fmt.Sprint(i...)),
		//	),
		//	trace.WithSpanKind(kind),
		//)
		//span.End()
	})
	client := ent.NewClient(ent.Driver(sqlDrv))

	if err := client.Schema.Create(context.Background()); err != nil {
		return nil, nil, err
	}

	cleanup := func() {
		logger.Info("closing the data resources")
		if err = client.Close(); err != nil {
			logger.Error("close sql client error", zap.Error(err))
		}
	}
	return &Data{Client: client}, cleanup, nil
}

func NewRedis(c *conf.Data_Redis, logger *log.Logger) (*redis.Client, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     c.Addr,
		Password: c.Password,
		DB:       int(c.Db),

		DialTimeout:  c.DialTimeout.AsDuration(),
		ReadTimeout:  c.ReadTimeout.AsDuration(),
		WriteTimeout: c.WriteTimeout.AsDuration(),

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
	logger.Info("ping redis success", zap.String("addr", fmt.Sprintf("%s/%d", c.Addr, c.Db)))
	return client, nil
}
