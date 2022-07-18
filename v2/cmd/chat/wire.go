//go:build wireinject
// +build wireinject

// The build tag makes sure the stub is not built in the final build.

package main

import (
	"github.com/go-kratos/kratos/v2"
	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/wire"
	"github.com/xmcy0011/CoffeeChat/internal/chat/biz"
	"github.com/xmcy0011/CoffeeChat/internal/chat/conf"
	"github.com/xmcy0011/CoffeeChat/internal/chat/data"
	"github.com/xmcy0011/CoffeeChat/internal/chat/server"
	"github.com/xmcy0011/CoffeeChat/internal/chat/service"
)

// wireApp init kratos application.
func wireApp(*conf.Server, *conf.Data, log.Logger) (*kratos.App, func(), error) {
	panic(wire.Build(server.ProviderSet, data.ProviderSet, biz.ProviderSet, service.ProviderSet, newApp))
}
