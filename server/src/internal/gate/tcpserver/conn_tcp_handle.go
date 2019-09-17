/** @file conn_tcp_handle.go
  * @brief tcp客户端消息处理实现
  * @author CoffeeChat
  * @date 2019-09-16
  */
package tcpserver

import (
	"context"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
	"time"
)

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
		ctx, cancelFun := context.WithTimeout(context.Background(), time.Duration(time.Second*kBusinessTimeOut))
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
