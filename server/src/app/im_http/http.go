package main

import (
	"flag"
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/internal/httpd"
	"github.com/CoffeeChat/server/src/pkg/helper"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"math/rand"
	"time"
)

var (
	//configFile  = flag.String("conf", "http-example.toml", "the config path")
	configFile  = flag.String("conf", "app/im_http/http-example.toml", "the config path")
	pidFileName = "server.pid"
)

func main() {
	logger.InitLogger("log/log.log", "debug")
	defer logger.Logger.Sync() // flushes buffer, if any
	rand.Seed(time.Now().UnixNano())

	config := httpd.Config{}
	_, err := toml.DecodeFile(*configFile, &config)
	if err != nil {
		_, err := toml.DecodeFile("im_http.toml", &config)
		if err != nil {
			logger.Sugar.Error(err)
			return
		}
	}

	// 记录pid
	err = helper.WritePid(pidFileName)
	if err != nil {
		logger.Sugar.Fatalf("write pid file error:%s", err.Error())
		return
	}

	// 启动HTTP 服务
	httpd.StartHttpServer(config)
}
