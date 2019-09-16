package gate

import (
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/gate/conf"
	"github.com/CoffeeChat/server/src/internal/gate/tcpserver"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"net"
	"os"
	"strconv"
)

func StartServer(config conf.Config) {
	tcpserver.StartGrpcClient(config.Logic)

	startTcpServer(config.ListenIp, config.ListenPort)
}

func startTcpServer(ip string, port int) {
	logger.Sugar.Info("server listen on ", ip+":"+strconv.Itoa(port))

	addr, err := net.ResolveTCPAddr("tcp", ip+":"+strconv.Itoa(port))
	if err != nil {
		logger.Sugar.Error("ResolveTCPAddr error:", err.Error(), ",ip=", ip, ",port=", port)
		os.Exit(-1)
	}

	listenerTcp, err := net.ListenTCP("tcp", addr)
	if err != nil {
		logger.Sugar.Error("listen on ", ip, ":", port, " error:", err.Error())
		os.Exit(-1)
	}

	for {
		// FIXED ME
		// use cpu num accept routine
		conn, err := listenerTcp.AcceptTCP()
		if err != nil {
			logger.Sugar.Error("accept conn error:", err.Error())
		} else {
			tcpConn := tcpserver.NewTcpConn()
			tcpConn.OnConnect(conn)
			tcpserver.ConnManager.Add(tcpConn)

			// FIXED ME
			// 一个连接一个read routine？
			go tcpConnRead(tcpConn)
		}
	}
}

func tcpConnRead(tcpConn *tcpserver.TcpConn) {
	// FIXED ME
	// use ROUND buffer instead
	// 10KB,if 500,000 user online,need memory 10KB*500,000/1024/1024=4.76GB
	const kBufferMaxLen = 10 * 1024 * 1024
	var buffer = make([]byte, kBufferMaxLen)
	var writeOffset = 0
	for {
		buffLen, err := tcpConn.Conn.Read(buffer[writeOffset:])
		if err != nil || buffLen < 0 {
			break
		}
		writeOffset += buffLen

		for {
			if !cim.IsPduAvailable(buffer, writeOffset) {
				break
			}

			// 解析出头部
			header := &cim.ImHeader{}
			header.ReadHeader(buffer, writeOffset)

			// 有效数据=len-HeaderLen，但是这里需要偏移HeaderLen刚好抵消
			dataLen := header.Length
			data := buffer[cim.IMHeaderLen:dataLen]

			// 回调处理
			tcpConn.OnRead(header, data)

			// 处理粘包问题，把余下的数据拷贝到数组起始位置
			resetBuf := buffer[dataLen:writeOffset]
			copy(buffer, resetBuf)
			writeOffset -= int(dataLen)
		}

		// safe
		if writeOffset >= kBufferMaxLen {
			writeOffset = 0
		}
	}
	// close the connect
	tcpConn.OnClose()
	tcpserver.ConnManager.Remove(tcpConn)
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
//			logger.Sugar.Error("accept conn error:", err.Error())
//		} else {
//
//		}
//	}
//}()
//}
