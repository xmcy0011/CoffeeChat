package main

import (
	"bufio"
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"errors"
	"fmt"
	"github.com/golang/protobuf/proto"
	uuid "github.com/satori/go.uuid"
	"net"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"
)

var tcpConn *net.TCPConn
var tcpBuffer = make([]byte, 10*1024)
var heartBeatTicker *time.Ticker
var seq uint16 = 0
var seqMutex sync.Mutex

const KUserId = 1992
const KUserToken = "12345"
const KNickName = "三生三世十里桃花"

func main() {
	logger.InitLogger("log/log.log", "debug")
	defer logger.Logger.Sync()

	addr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:8000")
	if err != nil {
		logger.Sugar.Fatal("ip adress err:", err.Error())
		return
	}

	tcpConn, err = net.DialTCP("tcp", nil, addr)
	if err != nil {
		logger.Sugar.Fatal("connect failed,please check ip address is correct,", err.Error())
		return
	}

	// login
	err = login()
	if err != nil {
		logger.Sugar.Fatal("login error:", err.Error())
	} else {
		logger.Sugar.Infof("login success,userId=%d,nickName=%s", KUserId, KNickName)

		heartBeatTicker = time.NewTicker(30 * time.Second)
		go heartBeat()
		go read()
	}

	for {
		logger.Sugar.Info("please select:")
		logger.Sugar.Info("0:exit")
		logger.Sugar.Info("1:show session list")
		logger.Sugar.Info("2:Send message to user")

		scanner := bufio.NewScanner(os.Stdin)
		if scanner.Scan() {
			text := scanner.Text()
			switch text {
			case "1":
				reqRecentSessionList()
				break
			case "2":
				logger.Sugar.Info("please input msg, example 1008:hello")
				reader := bufio.NewReader(os.Stdin)
				data, _, err := reader.ReadLine()
				if err != nil {
					logger.Sugar.Info("unknown format,please try again...")
					break
				}
				text := string(data)
				textArr := strings.Split(text, ":")
				if len(textArr) != 2 {
					logger.Sugar.Info("unknown format,please try again...")
					break
				} else {
					userId, err := strconv.ParseInt(textArr[0], 10, 64)
					if err != nil {
						logger.Sugar.Info("invalid userId:", textArr[0])
						break
					}
					sendMessage(uint64(userId), textArr[1])
				}
			default:
				logger.Sugar.Info("unknown command,please try again...")
				break
			}
		} else {
			logger.Sugar.Info("exit...")
			break
		}
	}

	_ = tcpConn.Close()
}

func login() error {
	//_ = tcpConn.SetReadDeadline(time.Now().Add(time.Duration(10 * time.Second)))

	// auth req
	req := &cim.CIMAuthTokenReq{
		UserId:        KUserId,
		UserToken:     KUserToken,
		ClientVersion: "demo/0.1",
		ClientType:    cim.CIMClientType_kCIM_CLIENT_TYPE_WEB,
		NickName:      KNickName,
	}
	_ = send(uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_REQ), req)

	res := &cim.CIMAuthTokenRsp{}

	buffLen, err := tcpConn.Read(tcpBuffer)
	if err != nil {
		return err
	}

	dataBuff := tcpBuffer[cim.IMHeaderLen:buffLen] // body=len-headLen

	err = proto.Unmarshal(dataBuff, res)
	if err != nil {
		return err
	}

	if res.ResultCode != cim.CIMErrorCode_kCIM_ERR_SUCCESS {
		return errors.New("auth err:" + res.ResultString)
	}

	//_ = tcpConn.SetReadDeadline(time.Unix(0, 0))
	return nil
}

func send(cimId uint16, message proto.Message) error {
	header := &cim.ImHeader{}
	header.CommandId = cimId
	header.SeqNum = getSeq()
	header.SetPduMsg(message)

	_, err := tcpConn.Write(header.GetBuffer())
	if err != nil {
		return err
	}
	return nil
}

func heartBeat() {
	for {
		<-heartBeatTicker.C
		_ = send(uint16(cim.CIMCmdID_kCIM_CID_LOGIN_HEARTBEAT), &cim.CIMHeartBeat{})
	}
}

func read() {
	for {
		buffLen, err := tcpConn.Read(tcpBuffer)
		if err != nil {
			logger.Sugar.Error("peer closed connection or network is unavailable", err.Error())
			return
		}
		header := &cim.ImHeader{}
		header.ReadHeader(tcpBuffer, buffLen)

		if header.CommandId == uint16(cim.CIMCmdID_kCIM_CID_LOGIN_HEARTBEAT) {
			continue
		}

		dataBuff := tcpBuffer[cim.IMHeaderLen:header.Length] // body=len-headLen
		switch header.CommandId {
		case uint16(cim.CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP):
			onHandleRecentSessionList(dataBuff)
		case uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA_ACK):
			onHandleMsgDataAck(dataBuff)
		case uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA):
			onHandleMsgData(dataBuff)
		default:
			logger.Sugar.Errorf("unknown command:%d", header.CommandId)
		}
	}
}

func getSeq() uint16 {
	seqMutex.Lock()
	defer seqMutex.Unlock()
	seq++
	return seq
}

func reqRecentSessionList() {
	req := &cim.CIMRecentContactSessionReq{
		UserId:           KUserId,
		LatestUpdateTime: 0,
	}
	err := send(uint16(cim.CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ), req)
	if err != nil {
		logger.Sugar.Error(err.Error())
		return
	}
}

func sendMessage(toId uint64, text string) {
	data := &cim.CIMMsgData{
		FromUserId:  KUserId,
		ToSessionId: toId,
		ClientMsgId: uuid.NewV4().String(),
		CreateTime:  int32(time.Now().Unix()),
		MsgType:     cim.CIMMsgType_kCIM_MSG_TYPE_TEXT,
		SessionType: cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
		MsgData:     []byte(text),
	}
	logger.Sugar.Infof("msgId:{%s} sending ...", data.ClientMsgId)
	_ = send(uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA), data)
}

func onHandleRecentSessionList(dataBuff []byte) {
	rsp := &cim.CIMRecentContactSessionRsp{}
	if err := proto.Unmarshal(dataBuff, rsp); err != nil {
		logger.Sugar.Error(err.Error())
		return
	} else {
		logger.Sugar.Infof("unread_cnt:%d", rsp.UnreadCounts)
		for i := range rsp.ContactSessionList {
			item := rsp.ContactSessionList[i]

			sessionText := ""
			if item.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
				sessionText = fmt.Sprintf("%d", item.SessionId)
			} else {
				sessionText = "未知会话类型"
			}
			tm := time.Unix(int64(item.MsgTimeStamp), 0)
			logger.Sugar.Infof("[%s][%d:%s][%s]", sessionText, item.MsgFromUserId, string(item.MsgData), tm.Format("2006-01-01 15:04:05 PM"))
		}
	}
}

func onHandleMsgDataAck(dataBuff []byte) {
	ack := &cim.CIMMsgDataAck{}
	err := proto.Unmarshal(dataBuff, ack)
	if err != nil {
		logger.Sugar.Error("onHandleMsgDataAck,", err.Error())
		return
	}

	logger.Sugar.Errorf("send msgId:{%s} success", ack.ClientMsgId)
}

func onHandleMsgData(dataBuff []byte) {
	msg := &cim.CIMMsgData{}
	err := proto.Unmarshal(dataBuff, msg)
	if err != nil {
		logger.Sugar.Error("onHandleMsgDataAck,", err.Error())
		return
	}

	// ack
	ack := &cim.CIMMsgDataAck{
		FromUserId: KUserId,
		//ToSessionId: msg.FromUserId,
		ClientMsgId: msg.ClientMsgId,
		ServerMsgId: 0,
		ResCode:     cim.CIMResCode_kCIM_RES_CODE_OK,
		SessionType: msg.SessionType,
		CreateTime:  int32(time.Now().Unix()),
	}
	if msg.SessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		ack.ToSessionId = msg.FromUserId
	} else {
		ack.ToSessionId = msg.ToSessionId
	}
	_ = send(uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA_ACK), ack)

	logger.Sugar.Errorf("recv [%d]->[%d] [sessionType:%d] [msgType:%d] %s", msg.FromUserId, msg.ToSessionId,
		msg.SessionType, msg.MsgType, string(msg.MsgData))
}
