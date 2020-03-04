package conf

type Config struct {
	ListenIp   string
	ListenPort int // tcp监听端口

	MinIo     MinIoConfig // logic服务器地址
	UrlAesKey string
}

type MinIoConfig struct {
	Ip   string // minio服务器地址
	Port int    // minio端口

	AccessKeyID     string // default minioadmin
	SecretAccessKey string // default minioadmin
	UseSSL          bool   // default true,use false to test and develop
	Location        string // "us-east-1" // default,see more:https://docs.min.io/docs/golang-client-api-reference#MakeBucket
}

var DefaultConfig = &Config{}
