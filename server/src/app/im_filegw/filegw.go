package main

import (
	"coffeechat/internal/filegw"
	"coffeechat/internal/filegw/conf"
	"coffeechat/pkg/helper"
	"coffeechat/pkg/logger"
	"flag"
	"github.com/BurntSushi/toml"
	"math/rand"
	"time"
)

var (
	configFile = flag.String("conf", "filegw-example.toml", "the config path")
)

const (
	PID_FILE_NAME = "server.pid"
)

func main() {
	flag.Parse()

	logger.InitLoggerEx("log.log", "log/log.warn.log", "debug")
	rand.Seed(time.Now().Unix())

	// resolve filegw.toml
	_, err := toml.DecodeFile(*configFile, conf.DefaultConfig)
	if err != nil {
		logger.Sugar.Errorf("load config error:%s,try again", err.Error())
		_, err := toml.DecodeFile("im-filegw.toml", conf.DefaultConfig)
		if err != nil {
			logger.Sugar.Error("load config error:", err.Error(), ",exit...")
			return
		}
	}

	// 记录进程id
	if err := helper.WritePid(PID_FILE_NAME); err != nil {
		logger.Sugar.Error("write pid file error:", err.Error(), ",exit...")
		return
	}

	err = filegw.StartHttpFileServer()
	if err != nil {
		logger.Sugar.Fatal(err)
	}
}
