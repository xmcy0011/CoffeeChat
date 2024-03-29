// Code generated by Wire. DO NOT EDIT.

//go:generate go run github.com/google/wire/cmd/wire
//go:build !wireinject
// +build !wireinject

package main

import (
	log2 "CoffeeChat/log"
	"chat/internal/biz"
	"chat/internal/conf"
	"chat/internal/data"
	"chat/internal/data/cache"
	"chat/internal/server"
	"chat/internal/service"
	"github.com/go-kratos/kratos/v2"
	"github.com/go-kratos/kratos/v2/log"
)

// Injectors from wire.go:

// wireApp init kratos application.
func wireApp(confServer *conf.Server, confData *conf.Data, logger log.Logger, logLogger *log2.Logger) (*kratos.App, func(), error) {
	client, err := data.NewEntClient(confData)
	if err != nil {
		return nil, nil, err
	}
	redisClient, err := data.NewRedis(confData, logLogger)
	if err != nil {
		return nil, nil, err
	}
	dataData, cleanup, err := data.NewData(logLogger, client, redisClient)
	if err != nil {
		return nil, nil, err
	}
	messageRepo := data.NewMessageRepo(dataData, logLogger)
	msgSeq := cache.NewMsgSeq(redisClient)
	sessionRepo := data.NewSessionRepo(dataData, logLogger)
	messageUseCase := biz.NewMessageUseCase(messageRepo, msgSeq, sessionRepo)
	chatService := service.NewChatService(messageUseCase)
	grpcServer := server.NewGRPCServer(confServer, chatService, logger)
	app := newApp(logger, grpcServer)
	return app, func() {
		cleanup()
	}, nil
}
