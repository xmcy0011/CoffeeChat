package mq

type MsgPush struct {
	CommandId uint16
	ServiceId uint16
	Data      []byte
}