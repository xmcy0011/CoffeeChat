package main

import (
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/internal/gate/conf"
	"github.com/CoffeeChat/server/src/internal/gate/tcpserver"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"os"
	"os/signal"
	"syscall"
)

//const configFile = "app/gate/gate-example.toml"

const configFile = "gate-example.toml"

func waitExit(c chan os.Signal) {
	for i := range c {
		switch i {
		case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			logger.Sugar.Info("receive exit signal ", i.String(), ",exit...")
			os.Exit(0)
		}
	}
}

func main() {
	//flag.Parse()

	logger.InitLogger("log/log.log", "debug")
	defer logger.Logger.Sync() // flushes buffer, if any

	// resolve gate.conf
	_, err := toml.DecodeFile(configFile, conf.DefaultConfig)
	if err != nil {
		logger.Sugar.Error("load config error:", err.Error(), "exit...")
		return
	}

	go tcpserver.StartServer()

	// before exit, cleanup something ...
	c := make(chan os.Signal)
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	waitExit(c)
}
