package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"container/list"
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

	// 如果seq设置为0，则内部自增使用全局序号
	Send(seq uint16, cmdId uint16, body proto.Message) (int, error)

	GetClientType() cim.CIMClientType // 获取该连接的客户端类型
	GetClientVersion() string         // 获取该连接的客户端版本
	SetUserId(userId uint64)          // 设置连接对应的用户id
	GetUserId() uint64
	GetSeq() uint16 // 获取该连接唯一的序列号
}

var DefaultConnManager = new(Manager)

type Manager struct {
	connList *list.List // CImConn
}

func init() {
	c := time.NewTicker(time.Duration(1 * time.Second))
	DefaultConnManager.connList = list.New()

	// 心跳检测routine
	go func() {
		for {
			select {
			case tick := <-c.C:
				for i := DefaultConnManager.connList.Front(); i != nil; i = i.Next() {
					conn := i.Value.(CImConn)
					conn.OnTimer(tick.Unix())
				}
			default:
				time.Sleep(time.Millisecond * 10)
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
		if ele == nil || ele != conn {
			logger.Sugar.Errorf("manager.connList removed conn failed,user_id=%d,client_type=%s", conn.GetUserId(),
				conn.GetClientType())
		}
	}
}
