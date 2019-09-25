package main

import (
	"bufio"
	"errors"
	"fmt"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
	"net"
	"os"
	"time"
)

var tcpConn *net.TCPConn
var tcpBuffer = make([]byte, 10*1024)
var heartBeatTicker *time.Ticker

const KUserId = 1008
const KUserToken = "12345"
const KNickName = "demo"

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
		logger.Sugar.Info("login success")

		heartBeatTicker = time.NewTicker(30 * time.Second)
		go heartBeat()
		go read()
	}

	for {
		logger.Sugar.Info("please select:")
		logger.Sugar.Info("0:exit")
		logger.Sugar.Info("1:show session list")

		scanner := bufio.NewScanner(os.Stdin)
		if scanner.Scan() {
			text := scanner.Text()
			switch text {
			case "1":
				reqRecentSessionList()
				break
			default:
				logger.Sugar.Info("unknown command,please try again...")
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
	_ = send(uint16(cim.CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ), req)

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

	if res.ResultCode != cim.CIMErrorCode_kCIM_ERR_SUCCSSE {
		return errors.New("auth err:" + res.ResultString)
	}

	//_ = tcpConn.SetReadDeadline(time.Unix(0, 0))
	return nil
}

func send(cimId uint16, message proto.Message) error {
	header := &cim.ImHeader{}
	header.CommandId = cimId
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
			break
		default:
			logger.Sugar.Error("unknown command:%d", header.CommandId)
			break
		}
	}
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
