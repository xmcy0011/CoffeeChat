package model

type MessageModel struct {
	Id    int32  `json:"id"` // 自增长id
	MsgId uint64 `json:"msg_id"`

	// 客户端消息ID-UUID
	ClientMsgId string `json:"client_msg_id"`
	FromId      uint64 `json:"from_id"`
	ToId        uint64 `json:"to_id"`

	GroupId    uint64 `json:"group_id"`
	MsgType    int32  `json:"msg_type"`
	MsgContent string `json:"msg_content"`

	// cim.CIMResCode
	// 消息错误码 0：一切正常
	MsgResCode int32 `json:"msg_res_code"`
	// cim.CIMMessageFeature
	// 消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息
	MsgFeature int32 `json:"msg_feature"`

	// cim.CIMMsgStatus
	// 消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送
	// 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中
	MsgStatus int32  `json:"msg_status"`
	Created   uint32 `json:"created"`
	Updated   uint32 `json:"updated"`
}
