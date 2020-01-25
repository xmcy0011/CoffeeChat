package tcpserver

import (
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/gate/tcpserver/voip"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
)

// 音视频通话呼叫邀请
func (tcp *TcpConn) onHandleVOIPInviteReq(header *cim.ImHeader, buff []byte) {
	req := cim.CIMVoipInviteReq{}
	err := proto.Unmarshal(buff, &req)
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}
	if len(req.InviteUserList) > 1 {
		logger.Sugar.Warnf("onHandleVOIPInviteReq not support group voice/video call,user_id:%d", tcp.userId)
		return
	} else if len(req.InviteUserList) <= 0 {
		logger.Sugar.Warnf("onHandleVOIPInviteReq need less 1 user to voice/video call,user_id:%d", tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleVOIPInviteReq user_id_len=%d,invite_type=%d", len(req.InviteUserList), req.InviteType)

	// check if user have another channel
	if voip.DefaultVOIPManager.Get(tcp.userId) != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq user have another channel,user_id=%d,invite_type=%d", tcp.userId, req.InviteType)
		return
	}

	// allocate channel name
	name, token, err := voip.GetChannelName(req.InviteUserList[0])
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq create channel error:%s,to_session_id=%d,invite_type=%d", err.Error(), tcp.userId, req.InviteType)
		return
	}
	req.ChannelInfo = &cim.CIMChannelInfo{
		ChannelName:  name,
		ChannelToken: token,
	}

	// 100 trying
	rsp := &cim.CIMVoipInviteReply{}
	rsp.UserId = 0
	rsp.RspCode = cim.CIMInviteRspCode_kCIM_VOIP_INVITE_CODE_TRYING
	rsp.ChannelInfo = &cim.CIMChannelInfo{
		ChannelName:  name,
		ChannelToken: token,
	}
	_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY), rsp)
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq send error:%s", err.Error())
	}

	// 转发Invite
	for i := range req.InviteUserList {
		u := DefaultUserManager.FindUser(req.InviteUserList[i])
		if u != nil {
			u.Broadcast(uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REQ), &req)
		}
	}
}

// 呼叫应答
func (tcp *TcpConn) onHandleVOIPInviteReply(header *cim.ImHeader, buff []byte) {
	reply := cim.CIMVoipInviteReply{}
	err := proto.Unmarshal(buff, &reply)
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReply error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleVOIPInviteReply user_id:%d,res_code:%d", reply.UserId, reply.RspCode.String())

	// 转发180 Ringing

}

// 呼叫成功，通话建立
func (tcp *TcpConn) onHandleVOIPInviteReplyAck(header *cim.ImHeader, buff []byte) {

}

// 通话心跳，30秒超时
func (tcp *TcpConn) onHandleVOIPHeartbeat(header *cim.ImHeader, buff []byte) {

}

// 通话结束
func (tcp *TcpConn) onHandleVOIPByeReq(header *cim.ImHeader, buff []byte) {

}
