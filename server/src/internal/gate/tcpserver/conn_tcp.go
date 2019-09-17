package tcpserver

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
	"net"
	"time"
)

const kLoginTimeOut = 15   // 登录超时时间(s)
const kBusinessTimeOut = 5 // 常规业务超时时间(s)

type TcpConn struct {
	Conn          *net.TCPConn      // 客户端的连接
	clientType    cim.CIMClientType // 客户端连接类型
	clientVersion string            // 客户端版本
	userId        uint64            // 客户端id

	connectedTime int64 // 连接时间
	loginTime     int64 // 登录时间
	isLogin       bool  // 是否已认证

	connManagerListElement *list.Element // 该连接在ConnManager.connList中的位置
	connUserListElement    *list.Element // 该连接在User.connList中的位置
}

func NewTcpConn() *TcpConn {
	conn := &TcpConn{
		clientType:             cim.CIMClientType_kCIM_CLIENT_TYPE_DEFAULT,
		userId:                 0,
		connManagerListElement: nil,
		connectedTime:          0,
		loginTime:              0,
		isLogin:                false,
	}
	return conn
}

//OnConnect implements the CImConn OnConnect method.
func (tcp *TcpConn) OnConnect(conn *net.TCPConn) {
	tcp.Conn = conn
	tcp.connectedTime = time.Now().Unix()
	tcp.loginTime = 0

	// save conn
	tcp.connManagerListElement = DefaultConnManager.Add(tcp)
	// when user auth success, then save to user.connList
	//tcp.connUserListElement = user.DefaultUserManager.FindUser(tcp.userId).AddConn(tcp)

	logger.Sugar.Debug("new connect come in, address:", conn.RemoteAddr().String())
}

//OnClose implements the CImConn OnClose method.
func (tcp *TcpConn) OnClose() {
	err := tcp.Conn.Close()
	if err != nil {
		logger.Sugar.Error("close connect error,address=", tcp.Conn.RemoteAddr().String())
	}

	// remove conn from manager.connList
	DefaultConnManager.Remove(tcp.connManagerListElement, tcp)
	tcp.connManagerListElement = nil

	// remove conn from user.connList
	userInfo := DefaultUserManager.FindUser(tcp.userId)
	if userInfo != nil {
		userInfo.RemoveConn(tcp.connUserListElement, tcp)

		// if have't any conn, then remove user from UserManager
		if userInfo.GetConnCount() <= 0 {
			DefaultUserManager.RemoveUser(userInfo.UserId)
		}
	}

	tcp.isLogin = false
}

//OnRead implements the CImConn OnRead method.
func (tcp *TcpConn) OnRead(header *cim.ImHeader, buff []byte) {
	logger.Sugar.Debug("recv data:", string(buff))

	if !tcp.isLogin && header.CommandId != uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ) {
		logger.Sugar.Error("need login,close connect,address=", tcp.Conn.RemoteAddr().String())
		tcp.OnClose()
		return
	}

	switch header.CommandId {
	case uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ):
		tcp.onHandleAuthReq(header, buff)
		break
	}
}

func (tcp *TcpConn) Send(cmdId uint16, body proto.Message) (int, error) {
	header := &cim.ImHeader{}
	header.CommandId = cmdId
	header.SetPduMsg(body)

	return tcp.Conn.Write(header.GetBuffer())
}

//OnTimer implements the CImConn OnTimer method.
func (tcp *TcpConn) OnTimer(tick int64) {
	if tcp.loginTime == 0 && (tick-tcp.connectedTime) > kLoginTimeOut {
		logger.Sugar.Info("login time out, close connect, address=", tcp.Conn.RemoteAddr().String())
		tcp.OnClose()
	}
}

//GetClientType implements the CImConn GetClientType method.
func (tcp *TcpConn) GetClientType() cim.CIMClientType {
	return tcp.clientType
}

//GetClientVersion implements the CImConn GetClientVersion method.
func (tcp *TcpConn) GetClientVersion() string {
	return tcp.clientVersion
}

//SetUserId implements the CImConn SetUserId method.
func (tcp *TcpConn) SetUserId(userId uint64) {
	tcp.userId = userId
}

//GetUserId implements the CImConn GetUserId method.
func (tcp *TcpConn) GetUserId() uint64 {
	return tcp.userId
}
