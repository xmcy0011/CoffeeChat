package job

import (
	"coffeechat/api/cim"
	"coffeechat/internal/job/conf"
	"coffeechat/pkg/logger"
	"context"
	"fmt"
	"google.golang.org/grpc"
)

type GateClient struct {
	conn    *grpc.ClientConn
	rpcConn cim.GateClient
}

var clientMap map[string]*GateClient

func init() {
	clientMap = make(map[string]*GateClient)
}

func startRpcClient() error {
	for i := range conf.DefaultConfig.Gate {
		address := fmt.Sprintf("%s:%d", conf.DefaultConfig.Gate[i].Ip, conf.DefaultConfig.Gate[i].Port)
		conn, err := grpc.Dial(address, grpc.WithInsecure())
		if err != nil {
			logger.Sugar.Error(err.Error())
			return err
		}

		rpcConn := cim.NewGateClient(conn)
		client := &GateClient{conn: conn, rpcConn: rpcConn}

		// ping
		_, err = client.rpcConn.Ping(context.Background(), &cim.CIMHeartBeat{})
		if err != nil {
			logger.Sugar.Error(err.Error())
			return err
		}

		// save
		if _, ok := clientMap[address]; ok {
			_ = conn.Close()
			logger.Sugar.Warn("duplicate gate ip address:", address)
		} else {
			clientMap[address] = client
		}
	}

	return nil
}
