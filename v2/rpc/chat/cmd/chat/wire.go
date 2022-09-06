//go:build wireinject
// +build wireinject

// The build tag makes sure the stub is not built in the final build.

package main

import (
	"CoffeeChat/log"
	"chat/internal/biz"
	"chat/internal/conf"
	"chat/internal/data"
	"chat/internal/server"
	"chat/internal/service"
	"github.com/go-kratos/kratos/v2"
	kratosLogs "github.com/go-kratos/kratos/v2/log"
	"github.com/google/wire"
)

// wireApp init kratos application.
func wireApp(*conf.Server, *conf.Data, kratosLogs.Logger, *log.Logger) (*kratos.App, func(), error) {
	panic(wire.Build(server.ProviderSet, data.ProviderSet, biz.ProviderSet, service.ProviderSet, newApp))
}
