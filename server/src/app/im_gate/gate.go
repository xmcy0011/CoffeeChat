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
	"runtime/pprof"
	"syscall"
)

var (
	configFile  = flag.String("conf", "gate-example.toml", "the config path")
	profFlag    = flag.Int("prof", 0, "write cpu profile, to used be p-prof tool")
	pidFileName = "server.pid"
	f           *os.File
)

func waitExit(c chan os.Signal) {
	for i := range c {
		switch i {
		case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			logger.Sugar.Info("receive exit signal ", i.String(), ",exit...")

			// CPU 性能分析
			if *profFlag == 1 {
				_ = f.Close()
				pprof.StopCPUProfile()
			}

			os.Exit(0)
		}
	}
}

func main() {
	flag.Parse()

	logger.InitLogger("log/log.log", "debug")
	defer logger.Logger.Sync() // flushes buffer, if any

	// 崩溃时，打印错误
	defer func() {
		err := recover()
		logger.Sugar.Error(err)
	}()

	//启用CPU 性能分析
	if *profFlag == 1 {
		f, err := os.OpenFile("cpu.prof", os.O_RDWR|os.O_CREATE, 0644)
		if err != nil {
			logger.Sugar.Fatal(err)
			return
		}
		pprof.StartCPUProfile(f)
	}

	// resolve gate.conf
	_, err := toml.DecodeFile(*configFile, conf.DefaultConfig)
	if err != nil {
		logger.Sugar.Errorf("load config error:%s,try again", err.Error())
		_, err := toml.DecodeFile("im_gate.toml", conf.DefaultConfig)
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
