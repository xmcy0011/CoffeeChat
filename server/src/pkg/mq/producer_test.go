package mq

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"github.com/golang/protobuf/proto"
	"testing"
	"time"
)

func TestMsgProducer_PushMsg(t *testing.T) {
	logger.InitLogger("log.log", "info")

	client := MsgProducer{}
	err := client.StartProducer([]string{"10.0.107.218:9876"})
	if err != nil {
		t.Failed()
		return
	}

	msg := cim.CIMMsgData{
		FromUserId:   2020,
		FromNickName: "wx_2020",
		ToSessionId:  2019,
		MsgId:        "16757bf1-c9e5-4705-ba04-3b2bca925f27",
		CreateTime:   int32(time.Now().Unix()),
		MsgType:      cim.CIMMsgType_kCIM_MSG_TYPE_TEXT,
		SessionType:  cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE,
		MsgData:      []byte("hello mq"),
	}
	data, _ := proto.Marshal(&msg)

	err = client.PushMsg(1, "10.0.107.117:8000", uint32(cim.CIMCmdID_kCIM_CID_MSG_DATA), 0, data)
	if err != nil {
		t.Failed()
	}
}

func TestMsgProducer_BroadcastMsg(t *testing.T) {

}

func TestMsgProducer_PushRoomMsg(t *testing.T) {

}
