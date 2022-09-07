package schema

import (
	"CoffeeChat/ent/mixin"
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
)

// Message holds the schema definition for the User entity.
type Message struct {
	ent.Schema
}

// Fields of the Message
func (Message) Fields() []ent.Field {
	return []ent.Field{
		field.Int64("id").Unique(),
		field.String("sessionKey").MaxLen(32),
		field.Int64("from"),
		field.String("to").MaxLen(32),
		field.Int8("session_type"),

		field.String("client_msg_id").MaxLen(32),
		field.Int64("server_msg_seq"),

		field.Int8("msg_type"),
		field.String("msg_data").MaxLen(4096),

		field.Int8("msg_res_code"),
		field.Int8("msg_feature"),
		field.Int8("msg_status"),

		field.Int64("create_time"),
	}
}

func (Message) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.TimeMixin{},
	}
}

// Edges of the Message
func (Message) Edges() []ent.Edge {
	return nil
}
