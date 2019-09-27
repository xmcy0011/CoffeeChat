package main

import (
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/internal/logic/conf"
	"github.com/CoffeeChat/server/src/internal/logic/rpcserver"
	"github.com/CoffeeChat/server/src/pkg/db"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"os"
	"os/signal"
	"syscall"
)

//const kDefaultConf = "app/logic/logic-example.toml"
const kDefaultConf = "logic-example.toml"

func waitExit(c chan os.Signal) {
	for i := range c {
		switch i {
		case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			logger.Sugar.Info("receive exit signal ", i.String(), ",exit...")

			logger.Sugar.Infof("close db connect")
			db.DefaultManager.UnInt()

			os.Exit(0)
		}
	}
}

func main() {

	logger.InitLogger("log/log.log", "debug")
	defer logger.Sugar.Sync()

	_, err := toml.DecodeFile(kDefaultConf, conf.DefaultLogicConfig)
	if err != nil {
		logger.Sugar.Fatal("load conf file err:", err.Error())
	}

	// init db
	err = db.DefaultManager.Init(conf.DefaultLogicConfig.Db)
	if err != nil {
		logger.Sugar.Fatal("db init failed:", err.Error())
		return
	}

	// init cache
	redis := conf.DefaultLogicConfig.Redis
	err = db.InitCache(redis.Ip, redis.Port, redis.Password, redis.KeyPrefix, redis.Pool)
	if err != nil {
		logger.Sugar.Fatal("redis cache init failed:", err.Error())
		return
	}

	// start rpc server
	go rpcserver.StartRpcServer(conf.DefaultLogicConfig.ListenIp, conf.DefaultLogicConfig.ListenPort)

	// before exit, cleanup something ...
	c := make(chan os.Signal)
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	waitExit(c)
}
