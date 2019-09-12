package gate

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/grpc"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
	"net"
	"time"
)

const kLoginTimeOut = 15 // 登录超时时间(s)

type TcpConn struct {
	conn       *net.TCPConn       // 客户端的连接
	clientType grpc.CIMClientType // 客户端连接类型
	userId     uint64             // 客户端id

	connectedTime int64 // 连接时间
	loginTime     int64 // 登录时间
	isLogin       bool  // 是否已认证

	connManagerListElement *list.Element // 该连接在ConnManager.connList中的元素
}

func NewTcpConn() *TcpConn {
	conn := &TcpConn{
		clientType:             grpc.CIMClientType_kCIM_CLIENT_TYPE_DEFAULT,
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
	tcp.conn = conn
	tcp.connectedTime = time.Now().Unix()
	tcp.loginTime = 0

	logger.Sugar.Debug("new connect come in, address:", conn.RemoteAddr().String())
}

//OnClose implements the CImConn OnClose method.
func (tcp *TcpConn) OnClose() {
	err := tcp.conn.Close()
	if err != nil {
		logger.Sugar.Error("close connect error,address=", tcp.conn.RemoteAddr().String())
	}
}

//OnRead implements the CImConn OnRead method.
func (tcp *TcpConn) OnRead(header *grpc.ImHeader, buff []byte) {
	logger.Sugar.Debug("recv data:", string(buff))

	if !tcp.isLogin && header.CommandId != uint16(grpc.CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ) {
		logger.Sugar.Error("need login,close connect,address=", tcp.conn.RemoteAddr().String())
		tcp.OnClose()
		return
	}

	switch header.CommandId {
	case uint16(grpc.CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ):
		tcp.onHandleAuthReq(header, buff)
		break
	}
}

//OnTimer implements the CImConn OnTimer method.
func (tcp *TcpConn) OnTimer(tick int64) {
	if tcp.loginTime == 0 && (tick-tcp.connectedTime) > kLoginTimeOut {
		logger.Sugar.Info("login time out, close connect, address=", tcp.conn.RemoteAddr().String())
		tcp.OnClose()
	}
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

func (tcp *TcpConn) onHandleAuthReq(header *grpc.ImHeader, buff []byte) {
	if tcp.isLogin {
		logger.Sugar.Errorf("duplication login,address:%s,user_id=%d", tcp.conn.RemoteAddr().String(), tcp.userId)
	} else {
		req := &grpc.CIMAuthTokenReq{}
		err := proto.Unmarshal(buff, req)
		if err != nil {
			logger.Sugar.Error(err.Error())
			return
		}

		logger.Sugar.Infof("onHandleAuthReq user_id=%d,client_version=%s,client_type=%d",
			*req.UserId, *req.ClientVersion, *req.ClientType)

		// to do
		// call logic gRPC to validate

		tcp.isLogin = true

		// response

		var code = grpc.CIMErrorCode_kCIM_ERR_SUCCSSE
		var str = "success"
		var serverTime = uint32(time.Now().Unix())
		var userInfo = &grpc.CIMUserInfo{
			UserId:     req.UserId,
			NickName:   req.NickName,
			AttachInfo: &str, // not used
		}

		rsp := &grpc.CIMAuthTokenRsp{}
		rsp.ResultCode = &code
		rsp.ResultString = &str
		rsp.ServerTime = &serverTime
		rsp.UserInfo = userInfo

		header.SetPduMsg(rsp)
		header.CommandId = uint16(grpc.CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_RSP)
		tcp.conn.Write(header.GetBuffer())

		temp := header.GetBuffer()
		err = proto.Unmarshal(temp[16:], rsp)
		if err != nil {
			logger.Sugar.Error(err)
		}
	}
}
