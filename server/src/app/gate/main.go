package main

import (
	"github.com/CoffeeChat/server/src/internal/gate"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/Unknwon/goconfig"
	"os"
	"os/signal"
	"syscall"
)

const configFile = "gate-example.conf"

//const configFile = "gate.conf"

func loadConfig(filename string) (*gate.ServerConfig, error) {
	config := &gate.ServerConfig{}
	conf, err := goconfig.LoadConfigFile(filename)
	if err != nil {
		logger.Sugar.Error("load config failed:", err.Error())
		return nil, err
	}

	ip, err := conf.GetValue("gate", "listenIp")
	if err != nil {
		logger.Sugar.Error("config miss listenIp,err:", err.Error())
		return nil, err
	}
	config.ListenIp = ip

	port, err := conf.Int("gate", "listenPort")
	if err != nil {
		logger.Sugar.Error("config miss listenPort,err:", err.Error())
		return nil, err
	}
	config.ListenPort = port

	portWs, err := conf.Int("gate", "listenPortWS")
	if err != nil {
		logger.Sugar.Error("config miss listenPortWS,err:", err.Error())
		return nil, err
	}
	config.ListenPortWebSocket = portWs

	return config, nil
}

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
	config, err := loadConfig(configFile)
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
