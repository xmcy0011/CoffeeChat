package schema

import (
	"CoffeeChat/ent/mixin"
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
)

type Session struct {
	ent.Schema
}

// Fields of the Session
func (Session) Fields() []ent.Field {
	return []ent.Field{
		field.Int32("id").Unique(),
		field.String("user_id").MaxLen(32),
		field.String("peer_id").MaxLen(32),
		field.Int8("session_type"),
		field.Int8("session_status"),
	}
}

func (Session) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.TimeMixin{},
	}
}

// Edges of the Session
func (Session) Edges() []ent.Edge {
	return nil
}
