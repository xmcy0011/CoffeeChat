package data

import (
	"CoffeeChat/log"
	"context"
	"entgo.io/ent/dialect"
	"entgo.io/ent/dialect/sql"
	"fmt"
	"github.com/google/wire"
	"go.uber.org/zap"
	"user/internal/conf"
	"user/internal/data/ent"

	// init mysql driver
	_ "github.com/go-sql-driver/mysql"
)

// ProviderSet is data providers.
var ProviderSet = wire.NewSet(NewData, NewUserRepo, NewDeviceRepo)

// Data .
type Data struct {
	*ent.Client
}

// NewData .
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
