package conf

import "github.com/CoffeeChat/server/src/pkg/db"

type Config struct {
	Db map[string]db.DatabaseConfig // db config
}
