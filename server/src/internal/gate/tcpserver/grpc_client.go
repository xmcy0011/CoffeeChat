package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/gate/conf"
	"coffeechat/pkg/logger"
	"context"
	"errors"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/connectivity"
)

// all grpc client connections
var logicClientMap map[int]*LogicGrpcClient = nil
var kMaxLogicClientConnect = 0

const kMaxCheckInterval = 32 // s

type LogicGrpcClient struct {
	instance cim.LogicClient
	conn     *grpc.ClientConn
	config   conf.LogicConfig
	index    int
}

func init() {
	logicClientMap = make(map[int]*LogicGrpcClient)
}

func StartGrpcClient(config []conf.LogicConfig) error {
	logger.Sugar.Info("start grpc client")

	if len(config) < 2 {
		logger.Sugar.Fatal("at least 2 logic connections are required")
		return errors.New("at least 2 logic connections are required")
	}

	for i := range config {
		logger.Sugar.Infof("logic rpc server ip=%s,port=%d,maxConnCnt=%d", config[i].Ip, config[i].Port, config[i].MaxConnCnt)

		address := fmt.Sprintf("%s:%d", config[i].Ip, config[i].Port)
		//maxConnCnt := config[i].MaxConnCnt

		conn, err := grpc.Dial(address, grpc.WithInsecure())
		if err != nil {
			logger.Sugar.Error("connect grpc server=%s,error:", address, err.Error())
		} else {
			client := cim.NewLogicClient(conn)
			// save
			logicClientMap[kMaxLogicClientConnect] = &LogicGrpcClient{
				instance: client,
				conn:     conn,
				config:   config[i],
				index:    i,
			}
			// ping
			err := ping(client)
			if err != nil {
				// if failed, the routine will try again
				return err
			}
		}
		kMaxLogicClientConnect++
	}
	return nil
}

func ping(conn cim.LogicClient) error {
	heart := &cim.CIMHeartBeat{}
	_, err := conn.Ping(context.Background(), heart)
	return err
}

// 获取登录验证的业务连接 0-0
func GetLoginConn() cim.LogicClient {
	if logicClientMap[0].conn.GetState() == connectivity.Ready {
		return logicClientMap[0].instance
	}
	return GetMessageConn()
}

// 获取处理消息的业务连接 1-1
func GetMessageConn() cim.LogicClient {
	return logicClientMap[1].instance
}

// 获取处理列表的连接 0-0
func GetlistConn() cim.LogicClient {
	return logicClientMap[0].instance
}
