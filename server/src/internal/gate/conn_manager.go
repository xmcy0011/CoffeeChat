package gate

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/grpc"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"net"
	"time"
)

/**
来自于客户端的连接
*/
type CImConn interface {
	OnConnect(conn *net.TCPConn)
	OnClose()
	OnRead(header *grpc.ImHeader, buff []byte)

	OnTimer(tick int64) // 定时器回调，间隔1秒

	GetClientType() grpc.CIMClientType // 获取该连接的客户端类型

	SetConnListElement(e *list.Element) // ConnManager
	GetConnListElement() *list.Element

	SetUserId(userId uint64) // 设置连接对应的用户id
	GetUserId() uint64
}

var ConnManager = new(Manager)

type Manager struct {
	connList *list.List // CImConn
}

func init() {
	c := time.NewTicker(time.Duration(1 * time.Second))
	ConnManager.connList = list.New()

	// 心跳检测routine
	go func() {
		for {
			select {
			case tick := <-c.C:
				for i := ConnManager.connList.Front(); i != nil; i = i.Next() {
					conn := i.Value.(CImConn)
					conn.OnTimer(tick.Unix())
				}
			default:
			}
		}
	}()
}

func (c *Manager) Add(conn CImConn) {
	e := c.connList.PushBack(conn)
	conn.SetConnListElement(e)
}

func (c *Manager) Remove(conn CImConn) {
	e := conn.GetConnListElement()
	if e != nil {
		c.connList.Remove(e)
	} else {
		logger.Sugar.Error("element is nil")
	}
}
