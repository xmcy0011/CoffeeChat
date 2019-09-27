package rpcserver

import (
	"context"
	"errors"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/internal/logic/dao"
	"github.com/CoffeeChat/server/src/pkg/logger"
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

	rsp := &cim.CIMRecentContactSessionRsp{}
	rsp.ContactSessionList = make([]*cim.CIMContactSessionInfo, 0, 5)
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
		msgId, err := dao.DefaultMessage.GetMsgIdSingle(e.UserId, e.PeerId)
		if err != nil {
			logger.Sugar.Errorf("can't find msgId,userId:%d,peerId:%d,error:%s", e.UserId, e.PeerId, err.Error())
			continue
		}

		// query msg detail
		msgInfo, err := dao.DefaultMessage.GetMessage(uint64(msgId), e.PeerId)
		if err != nil {
			// 如果是单聊，还需找1遍
			if e.SessionType == int(cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE) {
				msgInfo, err = dao.DefaultMessage.GetMessage(uint64(msgId), e.UserId)
				if err != nil {
					logger.Sugar.Errorf("query msg detail failed,userId:%d,peerId:%d,error:%s", e.UserId, e.PeerId, err.Error())
					continue
				}
			} else {
				logger.Sugar.Errorf("query msg detail failed,userId:%d,peerId:%d,error:%s", e.UserId, e.PeerId, err.Error())
				continue
			}
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
	// FIXED ME
	rsp.UnreadCounts = 0

	logger.Sugar.Infof("RecentContactSession userId=%d,LatestUpdateTime=%d,total_session_cnt=%d", in.UserId,
		in.LatestUpdateTime, len(rsp.ContactSessionList))

	return rsp, nil
}

// 查询历史消息列表
func (s *LogicServer) GetMsgList(ctx context.Context, in *cim.CIMGetMsgListReq) (*cim.CIMGetMsgListRsp, error) {
	if in.SessionType != cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		logger.Sugar.Errorf("GetMsgList not support sessionType:%d,userId:%d,sessionId:%d",
			in.SessionType, in.UserId, in.SessionId)
		return nil, errors.New("not support")
	}

	if in.LimitCount >= kMaxGetMessageListLimitCount {
		logger.Sugar.Errorf("GetMsgList limitCount:%d is invalid,userId:%d,sessionId:%d",
			in.LimitCount, in.UserId, in.SessionId)
		return nil, errors.New("limitCount is invalid")
	}

	msgList, err := dao.DefaultMessage.GetSingleMsgList(in.UserId, in.SessionId,
		in.SessionType, in.EndMsgId, in.LimitCount)
	if err != nil {
		logger.Sugar.Error("GetMsgList error:", err.Error())
		return nil, err
	}

	rsp := &cim.CIMGetMsgListRsp{
		UserId:      in.UserId,
		SessionType: in.SessionType,
		SessionId:   in.SessionId,
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
