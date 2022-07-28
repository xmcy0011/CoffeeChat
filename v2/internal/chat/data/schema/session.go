package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
	"entgo.io/ent/schema/mixin"
)

// Session holds the schema definition for the Session entity.
type Session struct {
	ent.Schema
}

// Fields of the Session.
func (Session) Fields() []ent.Field {
	return []ent.Field{
		field.Int("id").Unique(),
		field.Int64("user_id"),      // 用户ID
		field.Int64("peer_id"),      // 对方id，单聊代表用户，群聊代表群组
		field.Int("session_type"),   // 会话类型，1：单聊，2：群聊，3：机器人
		field.Int("session_status"), // 会话修改命令（预留）
	}
}

func (Session) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}

// Edges of the Session.
func (Session) Edges() []ent.Edge {
	return nil
}

func (Session) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("user_id", "peer_id").Unique(),
	}
}
