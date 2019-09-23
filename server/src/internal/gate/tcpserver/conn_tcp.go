package tcpserver

import (
	"container/list"
	"context"
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
	case uint16(cim.CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ):
		break
	case uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA):
		break
	case uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA_ACK):
		break
	}
}

func (tcp *TcpConn) Send(cmdId uint16, body proto.Message) (int, error) {
	header := cim.ImHeader{}
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

// 认证授权
func (tcp *TcpConn) onHandleAuthReq(header *cim.ImHeader, buff []byte) {
	if tcp.isLogin {
		logger.Sugar.Errorf("duplication login,address:%s,user_id=%d", tcp.Conn.RemoteAddr().String(), tcp.userId)
	} else {
		req := &cim.CIMAuthTokenReq{}
		err := proto.Unmarshal(buff, req)
		if err != nil {
			logger.Sugar.Error(err.Error())
			return
		}

		// call logic gRPC to validate
		conn := GetLoginConn()
		ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
		defer cancelFun()
		rsp, err := conn.AuthToken(ctx, req)

		if err != nil {
			logger.Sugar.Error("err:", err.Error())
			rsp = &cim.CIMAuthTokenRsp{
				ResultCode:   cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR,
				ResultString: "服务器内部错误",
			}
		} else {
			if rsp.ResultCode == cim.CIMErrorCode_kCIM_ERR_SUCCSSE {
				tcp.isLogin = true
				tcp.userId = req.UserId
				tcp.clientType = req.ClientType
				tcp.clientVersion = req.ClientVersion
				tcp.loginTime = time.Now().Unix()

				// save to UserManager
				userInfo := DefaultUserManager.FindUser(tcp.userId)
				if userInfo == nil {
					userInfo = NewUser()
					userInfo.UserId = tcp.userId
					userInfo.NickName = req.NickName
					DefaultUserManager.AddUser(userInfo.UserId, userInfo)
				}
				// save to user.connList
				tcp.connUserListElement = userInfo.AddConn(tcp)
			}
		}

		_, err = tcp.Send(uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_RSP), rsp)

		logger.Sugar.Infof("onHandleAuthReq result_code=%d,result_string=%s,user_id=%d,client_version=%s,client_type=%d",
			rsp.ResultCode, rsp.ResultString, req.UserId, req.ClientVersion, req.ClientType)
	}
}

// 查询会话列表请求
func (tcp *TcpConn) onHandleRecentContactSession(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMRecentContactSessionReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Error(err.Error())
		return
	}

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()
	rsp, err := conn.RecentContactSession(ctx, req)

	if err != nil {
		logger.Sugar.Error("err:", err.Error())
	} else {
		_, err = tcp.Send(uint16(cim.CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP), rsp)
	}
}

// 发送消息
func (tcp *TcpConn) onHandleMsgData(header *cim.ImHeader, buff []byte) {

}

// 消息收到确认
func (tcp *TcpConn) onHandleMsgAck(header *cim.ImHeader, buff []byte) {

}
