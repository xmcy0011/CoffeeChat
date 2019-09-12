package gate

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/grpc"
	"net"
)

type TcpConn struct {
	conn       net.Conn           // 客户端的连接
	clientType grpc.CIMClientType // 客户端连接类型
	userId     uint64             // 客户端id

	connManagerListElement *list.Element // 该连接在ConnManager.connList中的元素
}

func NewTcpConn() *TcpConn {
	conn := &TcpConn{
		clientType:             grpc.CIMClientType_kCIM_CLIENT_TYPE_DEFAULT,
		userId:                 0,
		connManagerListElement: nil,
	}
	return conn
}

//OnConnect implements the CImConn OnConnect method.
func (tcp *TcpConn) OnConnect(conn net.Conn) {
	tcp.conn = conn
}

//OnClose implements the CImConn OnClose method.
func (tcp *TcpConn) OnClose() {

}

//OnRead implements the CImConn OnRead method.
func (tcp *TcpConn) OnRead(buff []byte) {

}

//OnTimer implements the CImConn OnTimer method.
func (tcp *TcpConn) OnTimer(tick int64) {

}

//GetClientType implements the CImConn GetClientType method.
func (tcp *TcpConn) GetClientType() grpc.CIMClientType {
	return tcp.clientType
}

//SetConnListElement implements the CImConn SetConnListElement method.
func (tcp *TcpConn) SetConnListElement(e *list.Element) {
	tcp.connManagerListElement = e
}

//GetConnListElement implements the CImConn GetConnListElement method.
func (tcp *TcpConn) GetConnListElement() *list.Element {
	return tcp.connManagerListElement
}

//SetUserId implements the CImConn SetUserId method.
func (tcp *TcpConn) SetUserId(userId uint64) {
	tcp.userId = userId
}

//GetUserId implements the CImConn GetUserId method.
func (tcp *TcpConn) GetUserId() uint64 {
	return tcp.userId
}
