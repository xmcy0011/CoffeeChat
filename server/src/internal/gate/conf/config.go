package conf

type Config struct {
	ListenIp            string
	ListenPort          int // tcp监听端口
	ListenPortWebSocket int // websocket监听端口

	ListenIpGrpc   string // 监听Logic的grpc调用
	ListenPortGrpc int

	Logic []LogicConfig // logic服务器地址

	OwnThinkRobotUrl   string // 思知机器人URL
	OwnThinkRobotAppId string // AppID

	WeChatRobotUrl            string // 微信机器人
	WeChatRobotToken          string // TOKEN
	WeChatRobotEncodingAESKey string // WebToken的AesKey https://www.jsonwebtoken.io/
}

type LogicConfig struct {
	Ip         string // logic服务器地址
	Port       int    // grpc端口
	MaxConnCnt int    // 最大连接数
}

var DefaultConfig = &Config{}
