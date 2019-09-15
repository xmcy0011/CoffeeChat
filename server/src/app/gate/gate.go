package main

import (
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/internal/gate"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"os"
	"os/signal"
	"syscall"
)

const configFile = "gate-example.toml"

//const configFile = "gate.toml"

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
	config := &gate.ServerConfig{}
	_, err := toml.DecodeFile(configFile, config)
	if err != nil {
		logger.Sugar.Error("load config error, exit...")
		return
	}

	go gate.StartServer(*config)

	// before exit, cleanup something ...
	c := make(chan os.Signal)
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	waitExit(c)
}
