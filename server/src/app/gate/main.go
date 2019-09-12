package main

import (
	"flag"
	"github.com/CoffeeChat/server/src/internal/gate"
	"github.com/Unknwon/goconfig"
	"github.com/golang/glog"
	"os"
	"os/signal"
	"syscall"
)

const configFile = "gate.conf"

func loadConfig(filename string) (*gate.ServerConfig, error) {
	config := &gate.ServerConfig{}
	conf, err := goconfig.LoadConfigFile(filename)
	if err != nil {
		glog.Error("load config failed:", err.Error())
		return nil, nil
	}

	ip, err := conf.GetValue("gate", "listenIp")
	if err != nil {
		glog.Error("config miss listenIp,err:", err.Error())
		return nil, err
	}
	config.ListenIp = ip

	port, err := conf.Int("gate", "listenPort")
	if err != nil {
		glog.Error("config miss listenPort,err:", err.Error())
		return nil, err
	}
	config.ListenPort = port

	portWs, err := conf.Int("gate", "listenPortWS")
	if err != nil {
		glog.Error("config miss listenPortWS,err:", err.Error())
		return nil, err
	}
	config.ListenPortWebSocket = portWs

	return config, nil
}

func waitExit(c chan os.Signal) {
	for i := range c {
		switch i {
		case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			glog.Info("receive exit signal ", i.String(), ",exit...")
			os.Exit(0)
		}
	}
}

func main() {
	flag.Parse() // need by glog, start with: -log_dir=log -alsologtostderr=true
	defer glog.Flush()
	glog.MaxSize = 50 * 1024 * 1024 // 50MB log max size

	// resolve gate.conf
	config, err := loadConfig(configFile)
	if err != nil {
		glog.Error("load config error, exit...")
		return
	}

	go gate.StartServer(*config)

	// before exit, cleanup something ...
	c := make(chan os.Signal)
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	waitExit(c)
}