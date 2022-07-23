// +build wireinject

// The build tag makes sure the stub is not built in the final build.

package main

import (
	"github.com/xmcy0011/CoffeeChat/internal/biz"
	"github.com/xmcy0011/CoffeeChat/internal/conf"
	"github.com/xmcy0011/CoffeeChat/internal/data"
	"github.com/xmcy0011/CoffeeChat/internal/server"
	"github.com/xmcy0011/CoffeeChat/internal/service"
	"github.com/go-kratos/kratos/v2"
	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/wire"
)

// wireApp init kratos application.
func wireApp(*conf.Server, *conf.Data, log.Logger) (*kratos.App, func(), error) {
	panic(wire.Build(server.ProviderSet, data.ProviderSet, biz.ProviderSet, service.ProviderSet, newApp))
}
