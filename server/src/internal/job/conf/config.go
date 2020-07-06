package conf

type Config struct {
	ListenIp   string `toml:"ListenIp"`
	ListenPort int    `toml:"ListenPort"`

	RocketMq RocketMq `toml:"RocketMq"`
	Gate     []Gate   `toml:"Gate"`
}

type RocketMq struct {
	ConsumeGroup string   `toml:"ConsumeGroup"`
	NameServers  []string `toml:"NameServers"`
}

type Gate struct {
	Ip         string `toml:"Ip"`
	Port       int    `toml:"Port"`
	MaxConnCnt int    `toml:"MaxConnCnt"`
}

var DefaultConfig = &Config{}
