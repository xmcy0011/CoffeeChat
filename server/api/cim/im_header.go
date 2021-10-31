package cim

import (
	"bytes"
	"coffeechat/pkg/logger"
	"encoding/binary"
	"github.com/golang/protobuf/proto"
	"sync"
)

const IMHeaderLen = 16
const IMHeaderVersion = 1
const UINT16_MAX = ^uint16(0)

var mutex sync.Mutex

type ImHeader struct {
	Length    uint32 // the whole pdu length
	Version   uint16 // pdu version number
	Flag      uint16 // not used
	ServiceId uint16 //
	CommandId uint16 //
	SeqNum    uint16 // 包序号
	Reversed  uint16 // 保留

	pbMessage proto.Message // 消息体
}

func (it *ImHeader) SetPduMsg(message proto.Message) {
	it.pbMessage = message
}

func (it *ImHeader) ReadHeader(data []byte, len int) {
	if len >= IMHeaderLen {
		buffer := bytes.NewBuffer(data)
		_ = binary.Read(buffer, binary.BigEndian, &it.Length)
		_ = binary.Read(buffer, binary.BigEndian, &it.Version)
		_ = binary.Read(buffer, binary.BigEndian, &it.Flag)
		_ = binary.Read(buffer, binary.BigEndian, &it.ServiceId)
		_ = binary.Read(buffer, binary.BigEndian, &it.CommandId)
		_ = binary.Read(buffer, binary.BigEndian, &it.SeqNum)
		_ = binary.Read(buffer, binary.BigEndian, &it.Reversed)
	}
}

func (it *ImHeader) getHeaderBuffer() []byte {
	tempSlice := make([]byte, 0)
	buffer := bytes.NewBuffer(tempSlice)
	_ = binary.Write(buffer, binary.BigEndian, it.Length)
	_ = binary.Write(buffer, binary.BigEndian, it.Version)
	_ = binary.Write(buffer, binary.BigEndian, it.Flag)
	_ = binary.Write(buffer, binary.BigEndian, it.ServiceId)
	_ = binary.Write(buffer, binary.BigEndian, it.CommandId)
	_ = binary.Write(buffer, binary.BigEndian, it.SeqNum)
	_ = binary.Write(buffer, binary.BigEndian, it.Reversed)

	return buffer.Bytes()
}

func IsPduAvailable(data []byte, len int) bool {
	if len < IMHeaderLen {
		return false
	}

	buffer := bytes.NewBuffer(data)
	var packetLen uint32 = 0
	_ = binary.Read(buffer, binary.BigEndian, &packetLen)

	if int(packetLen) > len {
		logger.Sugar.Warn("pdu len is invalid ", packetLen)
		return false
	}

	if packetLen == 0 {
		logger.Sugar.Warn("pdu len is 0")
		return false
	}

	return true
}

func (it *ImHeader) GetBuffer() []byte {
	// write header
	tempSlice := make([]byte, 0)
	buffer := bytes.NewBuffer(tempSlice)

	data, err := proto.Marshal(it.pbMessage)
	if err != nil {
		logger.Sugar.Error("parse cim error:", err.Error())
		return nil
	}

	// 设置头信息
	it.Length = uint32(len(data)) + IMHeaderLen
	it.Version = uint16(IMHeaderVersion)
	// 序号全局唯一
	//it.SeqNum = getSeq()

	headerData := it.getHeaderBuffer()

	_ = binary.Write(buffer, binary.BigEndian, headerData)
	_ = binary.Write(buffer, binary.BigEndian, data)

	return buffer.Bytes()
}

func (it *ImHeader) GetBodyBuffer() []byte {
	data, _ := proto.Marshal(it.pbMessage)
	return data
}
