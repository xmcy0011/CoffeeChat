package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
	"entgo.io/ent/schema/mixin"
)

// MessageMixin 消息存储共用schema定义
type MessageMixin struct {
	mixin.Schema
}

func (MessageMixin) Fields() []ent.Field {
	return []ent.Field{
		field.Int("id").Unique(),
		field.Int64("msg_id"),         // 服务端消息ID，严格递增
		field.String("client_msg_id"), // 客户端消息ID-UUID
		field.Int64("from_id"),        // 来源id
		field.Int64("to_id"),          // 目标id
		field.Int64("group_id"),       // 群消息时，群id
		field.Int("msg_type"),         // 消息类型
		field.String("msg_content"),   // 消息内容
		field.Int16("msg_res_code"),   // 消息错误码 0：一切正常
		field.Int16("msg_feature"),    // 消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息
		field.Int16("msg_status"),     // 消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中
	}
}

func (MessageMixin) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("group_id"),
		index.Fields("from_id", "to_id", "msg_status"),
	}
}
