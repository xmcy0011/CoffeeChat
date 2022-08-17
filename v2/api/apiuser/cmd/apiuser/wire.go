//go:build wireinject
// +build wireinject

// The build tag makes sure the stub is not built in the final build.

package main

import (
	"CoffeeChat/log"
	"apiuser/internal/conf"
	"apiuser/internal/server"
	"apiuser/internal/service"
	"github.com/go-kratos/kratos/v2"
	klog "github.com/go-kratos/kratos/v2/log"
	"github.com/google/wire"
	"user/api/user"
)

// wireApp init kratos application.
func wireApp(*conf.Server, *conf.Data, klog.Logger, *log.Logger, user.AuthClient) (*kratos.App, func(), error) {
	panic(wire.Build(server.ProviderSet, service.ProviderSet, newApp))
}
