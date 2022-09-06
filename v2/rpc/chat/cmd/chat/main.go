package main

import (
	"CoffeeChat/log"
	"flag"
	"os"

	"chat/internal/conf"
	"github.com/go-kratos/kratos/v2"
	kratoslog "github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/transport/grpc"
)

// go build -ldflags "-X main.Version=x.y.z"
var (
	Name     string
	Version  string
	flagConf string

	id, _ = os.Hostname()
)

func init() {
	flag.StringVar(&flagConf, "conf", "../../configs/config.yaml", "config path, eg: -conf config.yaml")
}

func newApp(logger kratoslog.Logger, gs *grpc.Server) *kratos.App {
	return kratos.New(
		kratos.ID(id),
		kratos.Name(Name),
		kratos.Version(Version),
		kratos.Metadata(map[string]string{}),
		kratos.Logger(logger),
		kratos.Server(
			gs,
		),
	)
}

func main() {
	flag.Parse()
	kratoslog.SetLogger(log.MustNewLogger(id, Name, Version, true, 2))
	logger := log.MustNewLogger(id, Name, Version, true, 0)
	log.SetGlobalLogger(logger)

	bc := conf.MustLoad(flagConf)
	app, cleanup, err := wireApp(bc.Server, bc.Data, logger, logger)
	if err != nil {
		panic(err)
	}
	defer cleanup()

	// start and wait for stop signal
	if err := app.Run(); err != nil {
		panic(err)
	}
}
