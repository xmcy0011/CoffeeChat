package main

import (
	"CoffeeChat/log"
	"flag"
	"os"

	"apiuser/internal/conf"
	"github.com/go-kratos/kratos/v2"
	"github.com/go-kratos/kratos/v2/config"
	"github.com/go-kratos/kratos/v2/config/file"
	kratoslog "github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/transport/http"
)

var (
	Name     string
	Version  string
	flagConf string

	id, _ = os.Hostname()
)

func init() {
	flag.StringVar(&flagConf, "conf", "../../configs/config.yaml", "config path, eg: -conf config.yaml")
}

func newApp(logger *log.Logger, hs *http.Server) *kratos.App {
	return kratos.New(
		kratos.ID(id),
		kratos.Name(Name),
		kratos.Version(Version),
		kratos.Metadata(map[string]string{}),
		kratos.Logger(logger),
		kratos.Server(
			hs,
		),
	)
}

func main() {
	flag.Parse()
	kratoslog.SetLogger(log.MustNewLogger(id, Name, Version, true, 2))
	log.SetGlobalLogger(log.MustNewLogger(id, Name, Version, true, 0))

	c := config.New(
		config.WithSource(
			file.NewSource(flagConf),
		),
	)
	defer c.Close()

	if err := c.Load(); err != nil {
		panic(err)
	}

	var bc conf.Bootstrap
	if err := c.Scan(&bc); err != nil {
		panic(err)
	}

	app, cleanup, err := wireApp(bc.Server, bc.Data,
		log.MustNewLogger(id, Name, Version, true, 4),
		log.L)
	if err != nil {
		panic(err)
	}
	defer cleanup()

	// start and wait for stop signal
	if err := app.Run(); err != nil {
		panic(err)
	}
}
