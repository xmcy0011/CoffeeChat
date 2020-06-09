package tcpserver

import (
	"coffeechat/pkg/logger"
	"net"
	"testing"
	"time"
)

func TestTcpConn_OnTimer(t *testing.T) {
	logger.InitLogger("log/log.log", "debug")

	go startTcpServer("127.0.0.1", 8000)

	time.Sleep(time.Duration(3 * time.Second))

	addr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:8000")
	conn, err := net.DialTCP("tcp", nil, addr)
	if err != nil {
		t.Error(err)
	}

	//time.Sleep(time.Duration(20 * time.Second))

	_, err = conn.Write([]byte("hello go"))

	time.Sleep(time.Duration(3 * time.Second))
	tempBuff := make([]byte, 1024)
	recvLen, err := conn.Read(tempBuff)

	if err == nil || recvLen > 0 {
		t.Error("more than 15s but the server don't close connect")
	}
}
