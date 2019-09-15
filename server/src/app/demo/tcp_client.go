package main

import (
	"errors"
	"github.com/CoffeeChat/server/src/api/grpc"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/golang/protobuf/proto"
	"net"
	"time"
)

func main() {
	logger.InitLogger("log/log.log", "debug")
	defer logger.Logger.Sync()

	addr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:8000")
	if err != nil {
		logger.Sugar.Fatal("ip adress err:", err.Error())
	}

	conn, err := net.DialTCP("tcp", nil, addr)
	if err != nil {
		logger.Sugar.Fatal("connect failed,please check ip address is correct,", err.Error())
	}

	// login
	err = login(conn)
	if err != nil {
		logger.Sugar.Fatal("login error:", err.Error())
	} else {
		logger.Sugar.Info("login success")
	}

	logger.Sugar.Info("10s later exit...")
	time.Sleep(time.Duration(10 * time.Second))
	_ = conn.Close()
}

func login(conn *net.TCPConn) error {
	// auth req
	header := &grpc.ImHeader{}
	header.CommandId = uint16(grpc.CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ)

	req := &grpc.CIMAuthTokenReq{
		UserId:        80808080808123,
		UserToken:     "gsdgsadgwerwer",
		ClientVersion: "demo/0.1",
		ClientType:    grpc.CIMClientType_kCIM_CLIENT_TYPE_WEB,
		NickName:      "demo",
	}
	header.SetPduMsg(req)

	_, err := conn.Write(header.GetBuffer())
	if err != nil {
		return err
	}

	var buffer = make([]byte, 10*1024)
	_ = conn.SetReadDeadline(time.Now().Add(time.Duration(10 * time.Second)))
	buffLen, err := conn.Read(buffer)
	if err != nil {
		return err
	}

	// auth res
	header.ReadHeader(buffer, buffLen)

	res := &grpc.CIMAuthTokenRsp{}
	var dataBuff = buffer[grpc.IMHeaderLen:header.Length] // body=len-headLen
	err = proto.Unmarshal(dataBuff, res)
	if err != nil {
		return err
	}

	if res.ResultCode != grpc.CIMErrorCode_kCIM_ERR_SUCCSSE {
		return errors.New("auth err:" + res.ResultString)
	}

	return nil
}
