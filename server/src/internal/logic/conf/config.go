package conf

import "coffeechat/pkg/db"

type Config struct {
	ListenIp   string
	ListenPort int

	Db []db.DatabaseConfig // db config

	RocketMq *RocketMq // mq
	Redis    *Redis    // redis config
}

var DefaultLogicConfig = &Config{}

// rocketmq config
type RocketMq struct {
	Enable      bool     // 是否启用rocketmq，集群模式下需要启用，单机情况下不需要启用
	NameServers []string // namesrv
}

type Redis struct {
	Name     string
	Password string // redis密码，不允许为空

	Ip        string
	Port      int
	KeyPrefix string // redis中key的统一前缀

	Pool []*db.RedisPoolConfig
}
