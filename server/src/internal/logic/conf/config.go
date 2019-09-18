package conf

import "github.com/CoffeeChat/server/src/pkg/db"

type Config struct {
	ListenIp   string
	ListenPort int

	Db []db.DatabaseConfig // db config

	Kafka *Kafka // mq
}

// kafka config
type Kafka struct {
	TopicPrefix string // Topic由前缀+cmdID组成，如msg_data消息id为301，则Topic=CoffeeChat_301
	Brokers     []string
}
