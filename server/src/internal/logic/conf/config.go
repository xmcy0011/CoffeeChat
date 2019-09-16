package conf

import "github.com/CoffeeChat/server/src/pkg/db"

type Config struct {
	ListenIp   string
	ListenPort int

	Db []db.DatabaseConfig // db config
}
