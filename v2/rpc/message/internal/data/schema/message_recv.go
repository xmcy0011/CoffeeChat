package schema

import (
	"CoffeeChat/ent/mixin"
	"entgo.io/ent"
)

// MessageRecv holds the schema definition for the MessageRecv entity.
type MessageRecv struct {
	ent.Schema
}

func (MessageRecv) Mixin() []ent.Mixin {
	return []ent.Mixin{
		MessageMixin{},
		mixin.TimeMixin{},
	}
}

// Edges of the MessageRecv.
func (MessageRecv) Edges() []ent.Edge {
	return nil
}
