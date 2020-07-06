package rpcserver

import "coffeechat/api/cim"

type LogicServer struct {
}

var DefaultLogicRpcServer = &LogicServer{}
var gateRpcClientMap map[string]cim.GateClient

func init() {
	gateRpcClientMap = make(map[string]cim.GateClient)
}