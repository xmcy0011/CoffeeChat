package data

import (
	"CoffeeChat/internal/chat/conf"
	"github.com/go-kratos/kratos/v2/log"
)

// ProviderSet is data providers.
//var ProviderSet = wire.NewSet(NewData)

// Data .
type Data struct {
	// TODO wrapped database client
}

// NewData .
func NewData(c *conf.Data, logger log.Logger) (*Data, func(), error) {
	cleanup := func() {
		log.NewHelper(logger).Info("closing the data resources")
	}
	return &Data{}, cleanup, nil
}
