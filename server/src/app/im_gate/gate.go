package main

import (
	"flag"
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/internal/gate/conf"
	"github.com/CoffeeChat/server/src/internal/gate/tcpserver"
	"github.com/CoffeeChat/server/src/pkg/helper"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"os"
	"os/signal"
	"syscall"
)

var (
	configFile  string
	pidFileName = "server.pid"
)

func waitExit(c chan os.Signal) {
	for i := range c {
		switch i {
		case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			logger.Sugar.Info("receive exit signal ", i.String(), ",exit...")
			os.Exit(0)
		}
	}
}

func init() {
	flag.String("conf", "gate-example.toml", configFile)
}

func main() {
	flag.Parse()

	logger.InitLogger("log/log.log", "debug")
	defer logger.Logger.Sync() // flushes buffer, if any

	// resolve gate.conf
	_, err := toml.DecodeFile(configFile, conf.DefaultConfig)
	if err != nil {
		_, err := toml.DecodeFile("gate-example.toml", conf.DefaultConfig)
		if err != nil {
			logger.Sugar.Error("load config error:", err.Error(), ",exit...")
			return
		}
	}

	// 记录进程id
	if err := helper.WritePid(pidFileName); err != nil {
		logger.Sugar.Error("write pid file error:", err.Error(), ",exit...")
		return
	}

	go tcpserver.StartServer()

	// before exit, cleanup something ...
	c := make(chan os.Signal)
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	waitExit(c)
}
