package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"github.com/golang/protobuf/proto"
	"time"
)

// 查询用户系统中的列表
func (tcp *TcpConn) onHandleFriendQueryUserListReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMFriendQueryUserListReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleFriendQueryUserListReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.QuerySystemUserRandomList(ctx, req)
	if err != nil {
		logger.Sugar.Warn("onHandleFriendQueryUserListReq QuerySystemUserRandomList(gRPC) err:", err.Error(), "user_id:", req.UserId)
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_FRIEND_QUERY_USER_LIST_RSP), rsp)
		logger.Sugar.Infof("onHandleFriendQueryUserListReq QuerySystemUserRandomList(gRPC) res,user_id:%d,list_len:%d",
			rsp.UserId, len(rsp.UserInfoList))
	}
}
