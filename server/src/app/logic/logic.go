package main

import (
	"github.com/BurntSushi/toml"
	"github.com/CoffeeChat/server/src/internal/logic/conf"
	"github.com/CoffeeChat/server/src/pkg/logger"
)

const kDefaultConf = "logic-example.toml"

func main() {

	logger.InitLogger("log/log.log", "debug")
	defer logger.Sugar.Sync()

	conf := &conf.Config{}
	_, err := toml.DecodeFile(kDefaultConf, conf)
	if err != nil {
		logger.Sugar.Fatal("load conf file err:", err.Error())
	}


}
