package data

import (
	"CoffeeChat/log"
	"chat/internal/chat/conf"
	"chat/internal/chat/data/ent"
	_ "github.com/go-sql-driver/mysql"
	"github.com/google/wire"
)

// ProviderSet is data providers.
var ProviderSet = wire.NewSet(NewData)

// Data ent wrapper
type Data struct {
	*ent.Client
}

// NewData New ent.Client
func NewData(c *conf.Data, logger *log.Logger) (*Data, func(), error) {
	cleanup := func() {
		logger.Info("closing the data resources")
	}
	client, err := ent.Open(c.Database.Driver, c.Database.Source)
	if err != nil {
		return nil, nil, err
	}

	return &Data{Client: client}, cleanup, nil
}
