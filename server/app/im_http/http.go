package main

import (
	"coffeechat/internal/httpd"
	"coffeechat/pkg/helper"
	"coffeechat/pkg/logger"
	"errors"
	"flag"
	"fmt"
	"github.com/BurntSushi/toml"
	"math/rand"
	"net"
	"strings"
	"time"
)

var (
	configFile = flag.String("conf", "http-example.toml", "the config path")
	//configFile  = flag.String("conf", "app/im_http/http-example.toml", "the config path")
	pidFileName = "server.pid"
)

func main() {
	flag.Parse()

	logger.InitLoggerEx("log/log.log", "log/log.warn.log", "debug")
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

	// docker bridge模式下，通过本地DNS访问内部服务
	for i, value := range config.Logic {
		if strings.Index(value.Ip, ".") == -1 {
			addrs, err := net.LookupHost(value.Ip)
			if err != nil {
				logger.Sugar.Error(err)
				return
			} else {
				if len(addrs) != 1 {
					logger.Sugar.Warn(errors.New(fmt.Sprintf("LookupHost return %d ip,dns:%s", len(addrs), value.Ip)))
				}
				config.Logic[i].Ip = addrs[0]
				logger.Sugar.Infof("LookupHost success, ip: %s, dns: %s", addrs[0], value.Ip)
			}
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
