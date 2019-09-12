package gate

type ServerConfig struct {
	ListenIp            string
	ListenPort          int // tcp监听端口
	ListenPortWebSocket int // websocket监听端口
}
