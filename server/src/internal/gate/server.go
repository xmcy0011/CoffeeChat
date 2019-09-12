package gate

import (
	"github.com/golang/glog"
	"net"
	"strconv"
)

func StartServer(config ServerConfig) {
	startTcpServer(config.ListenIp, config.ListenPort)
}

func startTcpServer(ip string, port int) {
	listenerTcp, err := net.ListenTCP("tcp", ip+":"+strconv.Itoa(port))
	if err != nil {
		glog.Fatal("listen on ", ip, ":", port, " error:", err.Error())
		return
	}

	for {
		conn, err := listenerTcp.Accept()
		if err != nil {
			glog.Error("accept conn error:", err.Error())
		} else {
			tcpConn := NewTcpConn()
			tcpConn.OnConnect(conn)

			// 一个连接
			go func() {
				ConnManager.Add(tcpConn)
				for {
					len, err := tcpConn.conn.Read()
					if err != nil {
						break
					}
				}
				ConnManager.Remove(tcpConn)
			}()
		}
	}
}

//func startWebSocketServer(ip string, port int) {
//listenerWss, err := net.Listen("tcp", config.listenIp+":"+strconv.Itoa(config.listenPortWebSocket))
//if err != nil {
//	return err
//}

//go func() {
//	for{
//		conn, err := listenerWss.Accept()
//		if err != nil {
//			glog.Error("accept conn error:", err.Error())
//		} else {
//
//		}
//	}
//}()
//}
