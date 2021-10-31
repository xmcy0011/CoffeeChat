package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/gate/tcpserver/voip"
	"coffeechat/pkg/logger"
	"context"
	"encoding/json"
	"github.com/golang/protobuf/proto"
	uuid "github.com/satori/go.uuid"
	"time"
)

type AVChatMsgInfo struct {
	HangupUserId uint64                `json:"hangup_user_id"` // 挂断用户ID
	HangupReason cim.CIMVoipByeReason  `json:"hangup_reason"`  // 挂断原因
	TimeLen      int                   `json:"time_len"`       // 通话时长（秒）
	CallType     cim.CIMVoipInviteType `json:"call_type"`      // 0:unknown, 1:voice, 2:video
}

// 音视频通话呼叫邀请
func (tcp *TcpConn) onHandleVOIPInviteReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMVoipInviteReq{}
	err := proto.Unmarshal(buff, req)
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
	if req.CreatorUserId == 0 {
		logger.Sugar.Warnf("onHandleVOIPInviteReq invalid creator_user_id:%d", req.CreatorUserId)
		return
	}

	logger.Sugar.Infof("onHandleVOIPInviteReq creator_id=%d,peer_id=%d,invite_type=%d", req.CreatorUserId, req.InviteUserList[0], req.InviteType)

	// allocate channel name
	name, token, err := voip.GetChannelName(req.InviteUserList[0])
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq create channel error:%s,to_session_id=%d,invite_type=%d", err.Error(), tcp.userId, req.InviteType)
		return
	}
	req.ChannelInfo = &cim.CIMChannelInfo{
		CreatorId:    req.CreatorUserId,
		ChannelName:  name,
		ChannelToken: token,
	}

	// check if user have another channel
	if voip.DefaultVOIPManager.Get(req.CreatorUserId) != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq user have another channel,user_id=%d,invite_type=%d", tcp.userId, req.InviteType)
		return
	}

	// save channel info
	voip.DefaultVOIPManager.InsertOrUpdate(req.CreatorUserId, &voip.ChannelInfo{
		Name:       name,
		Token:      token,
		State:      voip.AVState_Tring,
		CallType:   req.InviteType,
		Creator:    req.CreatorUserId,
		PeerUserId: req.InviteUserList[0],
	})

	// 100 trying
	rsp := &cim.CIMVoipInviteReply{}
	rsp.UserId = 0
	rsp.RspCode = cim.CIMInviteRspCode_kCIM_VOIP_INVITE_CODE_TRYING
	rsp.ChannelInfo = &cim.CIMChannelInfo{
		CreatorId:    req.CreatorUserId,
		ChannelName:  name,
		ChannelToken: token,
	}
	_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY), rsp)
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReq send error:%s", err.Error())
	} else {
		logger.Sugar.Debugf("onHandleVOIPInviteReq 100 trying,user_id=%d", tcp.userId)
	}

	// 转发Invite
	for i := range req.InviteUserList {
		u := DefaultUserManager.FindUser(req.InviteUserList[i])
		if u != nil {
			u.Broadcast(uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REQ), req)
			logger.Sugar.Debugf("onHandleVOIPInviteReq transmit to user_id=%d", req.InviteUserList[i])
		} else {
			logger.Sugar.Warnf("onHandleVOIPInviteReq peer=%d not online", req.InviteUserList[i])
		}
	}
}

// 呼叫应答
func (tcp *TcpConn) onHandleVOIPInviteReply(header *cim.ImHeader, buff []byte) {
	reply := &cim.CIMVoipInviteReply{}
	err := proto.Unmarshal(buff, reply)
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPInviteReply error:%s,user_id:%d", err.Error(), tcp.userId)
		return
	}

	logger.Sugar.Infof("onHandleVOIPInviteReply user_id:%d,res_code:%s", reply.UserId, reply.RspCode.String())

	if reply.RspCode == cim.CIMInviteRspCode_kCIM_VOIP_INVITE_CODE_RINGING {
		// 180 Ringing, 转发
		c := voip.DefaultVOIPManager.Get(reply.ChannelInfo.CreatorId)
		if c == nil {
			logger.Sugar.Warnf("onHandleVOIPInviteReply channel not exist,name=%s,creator_id=%d",
				reply.ChannelInfo.ChannelName, reply.ChannelInfo.CreatorId)
			return
		}
		logger.Sugar.Infof("onHandleVOIPInviteReply 180 ringing,user_id=%d", reply.UserId)

		useId := c.PeerUserId
		if c.PeerUserId == tcp.userId {
			useId = c.Creator
		}
		u := DefaultUserManager.FindUser(useId)
		if u != nil {
			// update channel avState
			voip.DefaultVOIPManager.UpdateAvState(reply.ChannelInfo.CreatorId, voip.AVState_Ringing)
			// 转发180 Ringing
			u.Broadcast(uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY), reply)
			logger.Sugar.Debugf("onHandleVOIPInviteReply transmit to user_id=%d", useId)
		} else {
			logger.Sugar.Warnf("onHandleVOIPInviteReply user not find,user_id=%d", useId)
		}
	} else if reply.RspCode == cim.CIMInviteRspCode_KCIM_VOIP_INVITE_CODE_OK {
		// 200 OK, 回复replyAck
		var ack = &cim.CIMVoipInviteReplyAck{
			ChannelInfo: &cim.CIMChannelInfo{
				ChannelName:  reply.ChannelInfo.ChannelName,
				ChannelToken: reply.ChannelInfo.ChannelToken,
			},
		}
		_, _ = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY_ACK), ack)

		logger.Sugar.Infof("onHandleVOIPInviteReply 200 ok,user_id=%d", reply.UserId)
		// update avState
		voip.DefaultVOIPManager.UpdateAvState(reply.ChannelInfo.CreatorId, voip.AVState_Establish)

		// 转发200 OK给对方
		c := voip.DefaultVOIPManager.Get(reply.ChannelInfo.CreatorId)
		if c == nil {
			logger.Sugar.Warnf("onHandleVOIPInviteReply transmit 200 ok,but channel not exist,name=%s,creator_id=%d",
				reply.ChannelInfo.ChannelName, reply.ChannelInfo.CreatorId)
			return
		}
		useId := c.PeerUserId
		if c.PeerUserId == tcp.userId {
			useId = c.Creator
		}
		u := DefaultUserManager.FindUser(useId)
		if u != nil {
			u.Broadcast(uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY), reply)
		}
	} else {
		logger.Sugar.Warnf("onHandleVOIPInviteReply user_id:%d,error res_code:%d", reply.UserId, reply.RspCode.String())
	}
}

// 呼叫成功，通话建立
func (tcp *TcpConn) onHandleVOIPInviteReplyAck(header *cim.ImHeader, buff []byte) {
	var req = &cim.CIMVoipInviteReplyAck{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return
	}
	if req.ChannelInfo == nil {
		logger.Sugar.Warn("onHandleVOIPInviteReplyAck ChannelInfo is null")
		return
	}

	c := voip.DefaultVOIPManager.Get(req.ChannelInfo.CreatorId)
	if c != nil {
		// update avState
		voip.DefaultVOIPManager.UpdateAvState(req.ChannelInfo.CreatorId, voip.AVState_Establish)
		logger.Sugar.Infof("onHandleVOIPInviteReplyAck creator_user_id:%d,peer_user_id:%d,channel_name:%s",
			c.Creator, c.PeerUserId, c.Name)
	} else {
		logger.Sugar.Infof("onHandleVOIPInviteReplyAck channel_name:%s not find,user_id:%d", req.ChannelInfo.ChannelName, tcp.userId)
	}
}

// 通话心跳，30秒超时
func (tcp *TcpConn) onHandleVOIPHeartbeat(header *cim.ImHeader, buff []byte) {

}

// 通话结束
func (tcp *TcpConn) onHandleVOIPByeReq(header *cim.ImHeader, buff []byte) {
	var req = &cim.CIMVoipByeReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleVOIPByeReq %s", err.Error())
		return
	}

	logger.Sugar.Infof("onHandleVOIPByeReq user_id:%d,channel_name:%s", req.UserId, req.ChannelInfo.ChannelName)

	// rsp
	var rsp = &cim.CIMVoipByeRsp{}
	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCESS
	_, _ = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_VOIP_BYE_RSP), rsp)

	// check
	c := voip.DefaultVOIPManager.Get(req.ChannelInfo.CreatorId)
	if c == nil {
		logger.Sugar.Warnf("onHandleVOIPByeReq receive CIMCmdID_kCIM_CID_VOIP_BYE_REQ but creator_user_id=%d not exist", req.ChannelInfo.CreatorId)
		return
	}
	voip.DefaultVOIPManager.Delete(req.ChannelInfo.CreatorId)

	// broadCast to peer
	var notify = &cim.CIMVoipByeNotify{
		UserId:    tcp.userId,
		ByeReason: req.ByeReason,
	}

	// 注意双方都可以发送挂断信令
	userId := c.PeerUserId
	if c.PeerUserId == tcp.userId {
		userId = c.Creator
	}
	peerUser := DefaultUserManager.FindUser(userId)
	if peerUser != nil {
		peerUser.Broadcast(uint16(cim.CIMCmdID_kCIM_CID_VOIP_BYE_NOTIFY), notify)
		logger.Sugar.Debugf("onHandleVOIPByeReq broadcast to user_id:%d", userId)
	}

	// send msg
	msgContent := &AVChatMsgInfo{
		HangupUserId: tcp.userId,
		HangupReason: req.ByeReason,
		TimeLen:      int(req.LocalCallTimeLen),
		CallType:     c.CallType,
	}
	msgData, _ := json.Marshal(msgContent)
	data := &cim.CIMMsgData{
		FromUserId:   tcp.userId,
		FromNickName: tcp.nickName,
		ToSessionId:  userId,
		ClientMsgId:        uuid.NewV4().String(),
		CreateTime:   int32(time.Now().Unix()),
		MsgType:      cim.CIMMsgType_kCIM_MSG_TYPE_AVCHAT,
		SessionType:  cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
		MsgData:      msgData,
	}

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	// save to db
	_, err = conn.SendMsgData(ctx, data)
	if err != nil {
		// 上行消息丢失计数+1
		upMissMsgCount.Inc()
		logger.Sugar.Warnf("err:", err.Error())
	} else {
		// broadcast peer user
		if peerUser != nil {
			peerUser.BroadcastMessage(data)
		}

		// broadcast send user
		user := DefaultUserManager.FindUser(tcp.userId)
		if user != nil {
			user.BroadcastMessage(data)
		}
	}
}
