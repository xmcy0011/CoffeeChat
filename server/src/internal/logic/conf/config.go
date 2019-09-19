package conf

import "github.com/CoffeeChat/server/src/pkg/db"

type Config struct {
	ListenIp   string
	ListenPort int

	Db []db.DatabaseConfig // db config

	Kafka *Kafka // mq
	Redis *Redis // redis config
}

var DefaultLogicConfig = &Config{}

// kafka config
type Kafka struct {
	TopicPrefix string // Topic由前缀+cmdID组成，如msg_data消息id为301，则Topic=CoffeeChat_301
	Brokers     []string
}

type Redis struct {
	Name     string
	Password string // redis密码，不允许为空

	Ip        string
	Port      int
	KeyPrefix string // redis中key的统一前缀

	Pool []RedisPool
}

type RedisPool struct {
	Name       string // 名称
	DbNum      int    // 在redis中数据库的位置
	MaxConnect int    // 最大连接数
}
