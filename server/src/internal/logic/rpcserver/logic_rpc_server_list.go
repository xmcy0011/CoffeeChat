package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/internal/logic/model"
	"coffeechat/pkg/logger"
	"context"
	"errors"
	"strconv"
)

const kMaxGetMessageListLimitCount = 100 // 单次拉取聊天历史记录最大消息数

// 查询会话列表
func (s *LogicServer) RecentContactSession(ctx context.Context, in *cim.CIMRecentContactSessionReq) (*cim.CIMRecentContactSessionRsp, error) {
	// FIXED me
	// in.LatestUpdateTime

	// query all sessions
	// ps：简单起见，不支持分页
	sessionList, err := dao.DefaultSession.GetSessionList(in.UserId)
	if err != nil {
		logger.Sugar.Error("RecentContactSession error:", err.Error())
		return nil, err
	}

	// load user all unread
	unreadMap := dao.DefaultUnread.GetUnreadCount(in.UserId)

	rsp := &cim.CIMRecentContactSessionRsp{}
	rsp.ContactSessionList = make([]*cim.CIMContactSessionInfo, 0, 5)
	rsp.UnreadCounts = 0
	for i := range sessionList {
		e := sessionList[i]
		info := &cim.CIMContactSessionInfo{
			SessionId:      e.PeerId,
			SessionType:    cim.CIMSessionType(e.SessionType),
			SessionStatus:  cim.CIMSessionStatusType(e.SessionStatus),
			UnreadCnt:      0, // FIXED ME
			UpdatedTime:    uint32(e.Updated),
			IsRobotSession: e.IsRobotSession == 1,
		}

		// query latest msg
		msgId := int64(0)
		if info.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
			msgId, err = dao.DefaultMessage.GetMsgIdGroup(e.PeerId)
			if err != nil {
				logger.Sugar.Errorf("can't find groupMsgId,userId:%d,peerId:%d,error:%s", e.UserId, e.PeerId, err.Error())
				continue
			}
		} else if info.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
			msgId, err = dao.DefaultMessage.GetMsgIdSingle(e.UserId, e.PeerId)
			if err != nil {
				logger.Sugar.Errorf("can't find msgId,userId:%d,peerId:%d,error:%s", e.UserId, e.PeerId, err.Error())
				continue
			}
		} else {
			logger.Sugar.Errorf("invalid sessionType:%d,userId:%d,peerId:%d", info.SessionType, e.UserId, e.PeerId)
			continue
		}

		// query msg detail
		var msgInfo *model.MessageModel
		if info.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
			msgInfo, err = dao.DefaultMessage.GetMessageSingle(uint64(msgId), e.UserId, e.PeerId)
			if err != nil {
				// 如果是单聊，还需找1遍
				msgInfo, err = dao.DefaultMessage.GetMessageSingle(uint64(msgId), e.PeerId, e.UserId)
			}
		} else {
			msgInfo, err = dao.DefaultMessage.GetMessageGroup(uint64(msgId), e.PeerId)
		}
		if err != nil {
			logger.Sugar.Warnf("query msg detail failed,userId:%d,peerId:%d,error:%s", e.UserId, e.PeerId, err.Error())
			continue
		}

		// load unread count
		if unreadMap != nil {
			// peer_userId / group_userId
			var value string
			var ok bool
			if info.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
				value, ok = unreadMap["peer_"+strconv.FormatUint(info.SessionId, 10)]
			} else if info.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_GROUP {
				value, ok = unreadMap["group_"+strconv.FormatUint(info.SessionId, 10)]
			} else {
				ok = false
				logger.Sugar.Warn("not support")
			}
			if ok {
				count, err := strconv.Atoi(value)
				if err == nil {
					info.UnreadCnt = uint32(count)
				} else {
					info.UnreadCnt = 0
				}
			} else {
				info.UnreadCnt = 0
			}
			rsp.UnreadCounts += info.UnreadCnt
		}

		info.MsgId = msgInfo.ClientMsgId
		info.ServerMsgId = msgInfo.MsgId
		info.MsgTimeStamp = uint32(msgInfo.Created)
		info.MsgType = cim.CIMMsgType(msgInfo.MsgType)
		info.MsgData = []byte(msgInfo.MsgContent)
		info.MsgStatus = cim.CIMMsgStatus(msgInfo.MsgStatus)
		info.MsgFromUserId = msgInfo.FromId
		// FIXED ME
		// info.MsgAttach =
		// info.ExtendData =

		rsp.ContactSessionList = append(rsp.ContactSessionList, info)
	}
	rsp.UserId = in.UserId

	logger.Sugar.Infof("RecentContactSession userId=%d,LatestUpdateTime=%d,total_session_cnt=%d,unread_cnt=%d", in.UserId,
		in.LatestUpdateTime, len(rsp.ContactSessionList), rsp.UnreadCounts)

	return rsp, nil
}

// 查询历史消息列表
func (s *LogicServer) GetMsgList(ctx context.Context, in *cim.CIMGetMsgListReq) (*cim.CIMGetMsgListRsp, error) {
	if in.LimitCount >= kMaxGetMessageListLimitCount {
		logger.Sugar.Errorf("GetMsgList limitCount:%d is invalid,userId:%d,sessionId:%d",
			in.LimitCount, in.UserId, in.SessionId)
		return nil, errors.New("limitCount is invalid")
	}

	msgList, err := dao.DefaultMessage.GetMsgList(in.UserId, in.SessionId,
		in.SessionType, in.EndMsgId, in.LimitCount)
	if err != nil {
		logger.Sugar.Error("GetMsgList error:", err.Error())
		return nil, err
	}

	rsp := &cim.CIMGetMsgListRsp{
		UserId:      in.UserId,
		SessionType: in.SessionType,
		SessionId:   in.SessionId,
		EndMsgId:    in.EndMsgId,
	}
	rsp.MsgList = make([]*cim.CIMMsgInfo, 0)
	for i := range msgList {
		msgInfo := &cim.CIMMsgInfo{
			ClientMsgId:      msgList[i].ClientMsgId,
			ServerMsgId:      msgList[i].MsgId,
			MsgResCode:       cim.CIMResCode(msgList[i].MsgResCode),
			MsgFeature:       cim.CIMMsgFeature(msgList[i].MsgFeature),
			SessionType:      in.SessionType,
			FromUserId:       msgList[i].FromId,
			ToSessionId:      in.SessionId,
			CreateTime:       msgList[i].Created,
			MsgType:          cim.CIMMsgType(msgList[i].MsgType),
			MsgStatus:        cim.CIMMsgStatus(msgList[i].MsgStatus),
			MsgData:          []byte(msgList[i].MsgContent),
			Attach:           "",                                         // FIXED ME
			SenderClientType: cim.CIMClientType_kCIM_CLIENT_TYPE_DEFAULT, // FIXED ME
		}
		rsp.MsgList = append(rsp.MsgList, msgInfo)
	}

	logger.Sugar.Infof("GetMsgList userId=%d,sessionId=%d,sessionType=%d,endMsgId=%d,limitCount=%d,msgCount=%d",
		in.UserId, in.SessionId, in.SessionType, in.EndMsgId, in.LimitCount, len(rsp.MsgList))
	return rsp, nil
}
