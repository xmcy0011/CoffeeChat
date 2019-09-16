package tcpserver

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
	"net"
	"time"
)

/**
来自于客户端的连接
*/
type CImConn interface {
	OnConnect(conn *net.TCPConn)
	OnClose()
	OnRead(header *cim.ImHeader, buff []byte)
	OnTimer(tick int64) // 定时器回调，间隔1秒

	Send(cmdId uint16, body proto.Message) (int, error)

	GetClientType() cim.CIMClientType // 获取该连接的客户端类型
	SetUserId(userId uint64)          // 设置连接对应的用户id
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

func (c *Manager) Add(conn CImConn) *list.Element {
	return c.connList.PushBack(conn)
}

func (c *Manager) Remove(e *list.Element, conn CImConn) {
	if e != nil {
		ele := c.connList.Remove(e)
		if ele == nil {
			logger.Sugar.Error("element is nil")
		}
	}
}
