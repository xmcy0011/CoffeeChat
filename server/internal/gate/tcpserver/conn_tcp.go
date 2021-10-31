package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"container/list"
	"context"
	"encoding/json"
	"github.com/golang/protobuf/proto"
	uuid "github.com/satori/go.uuid"
	"go.uber.org/atomic"
	"net"
	"sync"
	"time"
)

const kLoginTimeOut = 15     // 登录超时时间(s)
const kBusinessTimeOut = 3   // 常规业务超时时间(s)
const kHeartBeatTimeOut = 60 // 心跳超时时间
const kAckMsgTimeOut = 15    // 等待确认收到消息响应超时时间

var upMsgTotalCount = atomic.NewUint64(0)   // 上行消息总数
var upMissMsgCount = atomic.NewUint64(0)    // 上行消息丢失
var downMsgTotalCount = atomic.NewUint64(0) // 下行消息总数
var downMissMsgCount = atomic.NewUint64(0)  // 下行消息丢失

type TcpConn struct {
	Conn          *net.TCPConn      // 客户端的连接
	clientType    cim.CIMClientType // 客户端连接类型
	clientVersion string            // 客户端版本
	userId        uint64            // 客户端id
	nickName      string            // 昵称
	conMutex      sync.Mutex        // 互斥锁

	seq *atomic.Uint32 // 给客户端返回的seq号

	connectedTime     int64 // 连接时间
	loginTime         int64 // 登录时间
	isLogin           bool  // 是否已认证
	lastHeartBeatTime int64 // 上次心跳时间

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
		seq:                    atomic.NewUint32(0),
	}
	return conn
}

//OnConnect implements the CImConn OnConnect method.
func (tcp *TcpConn) OnConnect(conn *net.TCPConn) {
	tcp.Conn = conn
	tcp.connectedTime = time.Now().Unix()
	tcp.lastHeartBeatTime = tcp.connectedTime
	tcp.loginTime = 0

	// save conn
	tcp.connManagerListElement = DefaultConnManager.Add(tcp)
	// when user auth success, then save to user.connList
	//tcp.connUserListElement = user.DefaultUserManager.FindUser(tcp.userId).AddConn(tcp)

	logger.Sugar.Debug("new connect come in, address:", conn.RemoteAddr().String())
}

//OnClose implements the CImConn OnClose method.
func (tcp *TcpConn) OnClose() {
	tcp.conMutex.Lock()
	defer tcp.conMutex.Unlock()

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

	logger.Sugar.Info("connection be closed,address=", tcp.Conn.RemoteAddr().String())
}

//OnRead implements the CImConn OnRead method.
func (tcp *TcpConn) OnRead(header *cim.ImHeader, buff []byte) {
	//logger.Sugar.Debug("recv data:", string(buff))

	if !tcp.isLogin && header.CommandId != uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_REQ) &&
		header.CommandId != uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_REQ) {
		logger.Sugar.Error("need login,close connect,address=", tcp.Conn.RemoteAddr().String())
		tcp.OnClose()
		return
	}

	switch header.CommandId {
	case uint16(cim.CIMCmdID_kCIM_CID_LOGIN_HEARTBEAT):
		//logger.Sugar.Info("heartbeat", header.CommandId)
		tcp.lastHeartBeatTime = time.Now().Unix()
		_, _ = tcp.Send(0, uint16(cim.CIMCmdID_kCIM_CID_LOGIN_HEARTBEAT), &cim.CIMHeartBeat{})
	case uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_REQ):
		tcp.onHandleAuthReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_REQ):
		tcp.onHandleAuthTokenReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ):
		tcp.onHandleRecentContactSessionReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_LIST_MSG_REQ):
		tcp.onHandleGetMsgListReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA):
		tcp.onHandleMsgData(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA_ACK):
		tcp.onHandleMsgAck(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_MSG_READ_ACK):
		tcp.onHandleSetReadMessaged(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REQ):
		tcp.onHandleVOIPInviteReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_VOIP_HEARTBEAT):
		tcp.onHandleVOIPHeartbeat(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY):
		tcp.onHandleVOIPInviteReply(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_VOIP_INVITE_REPLY_ACK):
		tcp.onHandleVOIPInviteReplyAck(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_VOIP_BYE_REQ):
		tcp.onHandleVOIPByeReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_CREATE_DEFAULT_REQ):
		tcp.onHandleCreateGroupReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_DISBINGDING_REQ):
		tcp.onHandleDisbandingGroupReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_EXIT_REQ):
		tcp.onHandleGroupExitReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_LIST_REQ):
		tcp.onHandleGroupListReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_INFO_REQ):
		tcp.onHandleGroupInfoReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_INVITE_MEMBER_REQ):
		tcp.onHandleGroupInviteMemberReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_KICK_OUT_MEMBER_REQ):
		tcp.onHandleGroupKickOutMemberReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_FRIEND_QUERY_USER_LIST_REQ):
		tcp.onHandleFriendQueryUserListReq(header, buff)
	case uint16(cim.CIMCmdID_kCIM_CID_GROUP_LIST_MEMBER_REQ):
		tcp.onHandleGroupMemberListReq(header, buff)
	default:
		logger.Sugar.Errorf("unknown command_id=%d", header.CommandId)
		break
	}
}

func (tcp *TcpConn) Send(seq uint16, cmdId uint16, body proto.Message) (int, error) {
	header := cim.ImHeader{}
	header.CommandId = cmdId
	if seq == 0 {
		header.SeqNum = tcp.GetSeq() // 全局自增
	} else {
		header.SeqNum = seq
	}
	header.SetPduMsg(body)

	var data = header.GetBuffer()
	//logger.Sugar.Debugf("send len=%d,user_id=%d", len(data), tcp.userId)
	return tcp.Conn.Write(data)
}

//OnTimer implements the CImConn OnTimer method.
func (tcp *TcpConn) OnTimer(tick int64) {
	if tcp.loginTime == 0 && (tick-tcp.connectedTime) > kLoginTimeOut {
		logger.Sugar.Info("login time out, close connect, address=", tcp.Conn.RemoteAddr().String())
		tcp.OnClose()
	} else if (tick - tcp.lastHeartBeatTime) > kHeartBeatTimeOut {
		logger.Sugar.Errorf("heartbeat time out, close connect, address=%s,userId=%d,ClientType:%d",
			tcp.Conn.RemoteAddr().String(), tcp.userId, tcp.clientType)
		tcp.OnClose()
	} else {
		user := DefaultUserManager.FindUser(tcp.userId)
		if user != nil {
			user.OnCheckAckMessageTimerOut(tick)
		}
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

//GetSeq implements the CImConn GetUserId method.
func (tcp *TcpConn) GetSeq() uint16 {
	tcp.seq.Inc()

	// 溢出
	if tcp.seq.Load() >= uint32(cim.UINT16_MAX) {
		tcp.seq.Store(1)
		return 1
	}
	return uint16(tcp.seq.Load())
}

// 认证授权
func (tcp *TcpConn) onHandleAuthReq(header *cim.ImHeader, buff []byte) {
	if tcp.isLogin {
		logger.Sugar.Errorf("duplication login,address:%s,user_id=%d", tcp.Conn.RemoteAddr().String(), tcp.userId)
	} else {
		req := &cim.CIMAuthReq{}
		err := proto.Unmarshal(buff, req)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return
		}

		// call logic gRPC to validate
		conn := GetLoginConn()
		ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
		defer cancelFun()
		rsp, err := conn.Auth(ctx, req)

		if err != nil {
			logger.Sugar.Warnf("err:%s", err.Error())
			rsp = &cim.CIMAuthRsp{
				ResultCode:   cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR,
				ResultString: "服务器内部错误",
			}
		} else {
			if rsp.ResultCode == cim.CIMErrorCode_kCIM_ERR_SUCCESS {
				tcp.isLogin = true
				tcp.userId = rsp.UserInfo.UserId
				tcp.nickName = rsp.UserInfo.NickName
				tcp.clientType = req.ClientType
				tcp.clientVersion = req.ClientVersion
				tcp.loginTime = time.Now().Unix()
				tcp.lastHeartBeatTime = tcp.loginTime

				// save to UserManager
				userInfo := DefaultUserManager.FindUser(tcp.userId)
				if userInfo == nil {
					userInfo = NewUser()
					userInfo.UserId = tcp.userId
					userInfo.NickName = tcp.nickName
					userInfo.ClientType = tcp.clientType
					DefaultUserManager.AddUser(userInfo.UserId, userInfo)
				}
				// save to user.connList
				tcp.connUserListElement = userInfo.AddConn(tcp)
			}
		}

		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_RSP), rsp)

		logger.Sugar.Infof("onHandleAuthReq result_code=%d,result_string=%s,user_name=%s,client_version=%s,client_type=%d",
			rsp.ResultCode, rsp.ResultString, req.UserName, req.ClientVersion, req.ClientType)
	}
}

// 认证授权（废弃）
func (tcp *TcpConn) onHandleAuthTokenReq(header *cim.ImHeader, buff []byte) {
	if tcp.isLogin {
		logger.Sugar.Errorf("duplication login,address:%s,user_id=%d", tcp.Conn.RemoteAddr().String(), tcp.userId)
	} else {
		req := &cim.CIMAuthTokenReq{}
		err := proto.Unmarshal(buff, req)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return
		}

		// call logic gRPC to validate
		conn := GetLoginConn()
		ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
		defer cancelFun()
		rsp, err := conn.AuthToken(ctx, req)

		if err != nil {
			logger.Sugar.Warnf("err:%s", err.Error())
			rsp = &cim.CIMAuthTokenRsp{
				ResultCode:   cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR,
				ResultString: "服务器内部错误",
			}
		} else {
			if rsp.ResultCode == cim.CIMErrorCode_kCIM_ERR_SUCCESS {
				tcp.isLogin = true
				tcp.userId = req.UserId
				tcp.nickName = req.NickName
				tcp.clientType = req.ClientType
				tcp.clientVersion = req.ClientVersion
				tcp.loginTime = time.Now().Unix()
				tcp.lastHeartBeatTime = tcp.loginTime

				// save to UserManager
				userInfo := DefaultUserManager.FindUser(tcp.userId)
				if userInfo == nil {
					userInfo = NewUser()
					userInfo.UserId = tcp.userId
					userInfo.NickName = req.NickName
					userInfo.ClientType = tcp.clientType
					DefaultUserManager.AddUser(userInfo.UserId, userInfo)
				}
				// save to user.connList
				tcp.connUserListElement = userInfo.AddConn(tcp)
			}
		}

		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_RSP), rsp)

		logger.Sugar.Infof("onHandleAuthTokenReq result_code=%d,result_string=%s,user_id=%d,client_version=%s,client_type=%d",
			rsp.ResultCode, rsp.ResultString, req.UserId, req.ClientVersion, req.ClientType)
	}
}

// 查询会话列表请求
func (tcp *TcpConn) onHandleRecentContactSessionReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMRecentContactSessionReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return
	}

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()
	rsp, err := conn.RecentContactSession(ctx, req)

	if err != nil {
		logger.Sugar.Warnf("err:%s", err.Error())
		return
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP), rsp)
	}

	logger.Sugar.Infof("onHandleRecentContactSessionReq user_id:%d,latest_update_time:%d,"+
		"total_unread_count=%d,total_session_cnt=%d,unread_cnt=%d",
		req.UserId, req.LatestUpdateTime, rsp.UnreadCounts, len(rsp.ContactSessionList), rsp.UnreadCounts)
}

// 拉取历史消息
func (tcp *TcpConn) onHandleGetMsgListReq(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMGetMsgListReq{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return
	}
	logger.Sugar.Infof("onHandleGetMsgListReq user_id:%d,session_id:%d,"+
		"session_type=%d,end_msg_id=%d,limit_count=%d",
		req.UserId, req.SessionId, req.SessionType, req.EndMsgId, req.LimitCount)

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.GetMsgList(ctx, req)
	if err != nil {
		logger.Sugar.Error("err:", err.Error())
		return
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_LIST_MSG_RSP), rsp)
	}

	logger.Sugar.Infof("onHandleGetMsgListReq GetMsgList(gRPC) res,user_id:%d,session_id:%d,"+
		"session_type=%d,end_msg_id=%d,limit_count=%d,count=%d",
		req.UserId, req.SessionId, req.SessionType, req.EndMsgId, req.LimitCount,
		len(rsp.MsgList))
}

// 发送消息
func (tcp *TcpConn) onHandleMsgData(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMMsgData{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return
	}

	if req.FromUserId == req.ToSessionId {
		logger.Sugar.Warnf("onHandleMsgData from_id:%d is equals to_id:%d,"+
			"session_type=%d,msg_id=%s,msg_type=%d",
			req.FromUserId, req.ToSessionId, req.SessionType, req.ClientMsgId, req.MsgType)
		return
	}

	req.CreateTime = int32(time.Now().Unix())
	logger.Sugar.Infof("onHandleMsgData from_id:%d,to_id:%d,"+
		"session_type=%d,msg_id=%s,msg_type=%d,create_time=%d",
		req.FromUserId, req.ToSessionId, req.SessionType, req.ClientMsgId, req.MsgType, req.CreateTime)
	upMsgTotalCount.Inc()

	// 消息存储
	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	rsp, err := conn.SendMsgData(ctx, req)
	if err != nil {
		// 上行消息丢失计数+1
		upMissMsgCount.Inc()
		logger.Sugar.Warn("err:", err.Error())
		return
	} else {
		_, err = tcp.Send(header.SeqNum, uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA_ACK), rsp)
	}

	logger.Sugar.Infof("onHandleMsgData SendMsgData(gRPC) res,from_id:%d,to_id:%d,"+
		"session_type=%d,msg_id=%s,server_msg_id=%d,create_time=%d,res_code=%d",
		rsp.FromUserId, rsp.ToSessionId, rsp.SessionType, rsp.ClientMsgId, rsp.ServerMsgId, rsp.CreateTime, rsp.ResCode)

	// 更新消息的服务端消息序号
	req.ServerMsgId = rsp.ServerMsgId

	// send to peer
	if req.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		tcp._onHandleSingleMsgData(req, rsp)
	} else if req.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
		tcp._onHandleGroupMsgData(req, rsp)
	}
}

// 处理单聊消息返回
func (tcp *TcpConn) _onHandleSingleMsgData(req *cim.CIMMsgData, rsp *cim.CIMMsgDataAck) {
	user := DefaultUserManager.FindUser(rsp.ToSessionId)
	if user != nil {
		user.BroadcastMessage(req)
	}

	if !def.IsRobot(req.ToSessionId) {
		return
	}

	// 机器人消息，转发到第三方机器人平台，获取回复
	// 这里为了简化，牺牲性能，直接调用了
	// http超时3秒，1个TCP连接，2个协程。请注意
	logger.Sugar.Debugf("robot msg ,msgData:%s,from_id:%d,to_id:%d", string(req.MsgData), rsp.FromUserId, rsp.ToSessionId)
	question, err := DefaultRobotClient.ResolveQuestion(req)
	if err != nil {
		return
	}
	go func() {
		answer, err := DefaultRobotClient.GetAnswer(req.FromUserId, req.ToSessionId, question)
		if err != nil {
			logger.Sugar.Warnf("get robot answer error:%s,userId=%d", err.Error(), req.FromUserId)
			if answer.Content.Content != "" {
				answer.Content.Content = "机器人出错啦！"
			}
		}

		toUserId := req.FromUserId
		req.FromUserId = req.ToSessionId
		req.FromNickName = DefaultRobotClient.Name
		req.ToSessionId = toUserId // change
		req.ClientMsgId = uuid.NewV4().String()
		req.CreateTime = int32(time.Now().Unix())
		req.MsgType = cim.CIMMsgType_kCIM_MSG_TYPE_ROBOT

		data, _ := json.Marshal(answer)
		req.MsgData = data

		//转发到logic存储
		conn := GetMessageConn()
		ctx, _ := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
		_, err = conn.SendMsgData(ctx, req)
		if err != nil {
			// 上行消息丢失计数+1
			upMissMsgCount.Inc()
			logger.Sugar.Warnf("err:", err.Error())
		} else {
			// 广播机器人回复的消息
			user := DefaultUserManager.FindUser(toUserId)
			if user != nil {
				user.BroadcastMessage(req)
			}
		}
	}()
}

// 处理群聊消息返回
func (tcp *TcpConn) _onHandleGroupMsgData(msg *cim.CIMMsgData, rsp *cim.CIMMsgDataAck) {
	// FIXME: rpc阻塞了，会导致客户端消息被阻塞，消息发不出去。后续要优化
	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	in := &cim.CIMGroupMemberListReq{
		UserId:  tcp.userId,
		GroupId: rsp.ToSessionId,
	}
	rsp2, err := conn.QueryGroupMemberList(ctx, in)
	if err != nil {
		logger.Sugar.Warn("err:", err.Error())
	} else {
		count := 0

		// 广播给所有在线的用户
		for _, v := range rsp2.MemberIdList {
			if v != msg.FromUserId {
				user := DefaultUserManager.FindUser(v)
				if user != nil {
					user.BroadcastMessage(msg)
					count++
				}
			}
		}

		logger.Sugar.Infof("onHandleMsgData broadcast group msg,memberIdListLen:%d,onlineUserCount:%d,group_id:%d",
			len(rsp2.MemberIdList), count, msg.ToSessionId)
	}
}

// 消息收到确认
func (tcp *TcpConn) onHandleMsgAck(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMMsgDataAck{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleMsgAck error:%s", err.Error())
		return
	}

	logger.Sugar.Infof("onHandleMsgAck from_id:%d,to_id:%d,"+
		"session_type=%d,msg_id=%s,server_msg_id=%d,create_time=%d,res_code=%d",
		req.FromUserId, req.ToSessionId, req.SessionType, req.ClientMsgId, req.ServerMsgId, req.CreateTime, req.ResCode)

	user := DefaultUserManager.FindUser(req.FromUserId)
	if user != nil {
		user.AckMessage(req)
	}
}

// 设置会话消息已读
func (tcp *TcpConn) onHandleSetReadMessaged(header *cim.ImHeader, buff []byte) {
	req := &cim.CIMMsgDataReadAck{}
	err := proto.Unmarshal(buff, req)
	if err != nil {
		logger.Sugar.Warnf("onHandleSetReadMessaged error:%s", err.Error())
		return
	}

	// 目前没用，注释掉
	//if req.MsgId == 0 {
	//	logger.Sugar.Warn("onHandleSetReadMessaged invalid msgId=0")
	//	return
	//}

	logger.Sugar.Infof("onHandleSetReadMessaged user_id:%d,session_id:%d,msg_id=%d,session_type=%d",
		req.UserId, req.SessionId, req.MsgId, req.SessionType)

	conn := GetMessageConn()
	ctx, cancelFun := context.WithTimeout(context.Background(), time.Second*kBusinessTimeOut)
	defer cancelFun()

	_, err = conn.ReadAckMsgData(ctx, req)
	if err != nil {
		logger.Sugar.Infof("onHandleSetReadMessaged ReadAckMsgData(Grpc) user_id:%d,session_id:%d,msg_id=%d,"+
			"session_type=%d,error=%s", req.UserId, req.SessionId, req.MsgId, req.SessionType, err.Error())
	} else {
		logger.Sugar.Infof("onHandleMsgAck ReadAckMsgData(Grpc) user_id:%d,session_id:%d,msg_id=%d,"+
			"session_type=%d", req.UserId, req.SessionId, req.MsgId, req.SessionType)
	}

	// 给对方发送已读通知
	user := DefaultUserManager.FindUser(req.SessionId)
	if user != nil {
		notify := &cim.CIMMsgDataReadNotify{
			UserId:      req.UserId,
			SessionId:   req.SessionId,
			MsgId:       req.MsgId,
			SessionType: req.SessionType,
		}
		user.BroadcastReadMessage(notify)
	}
}
