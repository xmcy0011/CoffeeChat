package schema

import (
	"CoffeeChat/ent/mixin"
	"entgo.io/ent"
)

// MessageSend holds the schema definition for the MessageSend entity.
type MessageSend struct {
	ent.Schema
}

// Edges of the MessageSend.
func (MessageSend) Edges() []ent.Edge {
	return nil
}

func (MessageSend) Mixin() []ent.Mixin {
	return []ent.Mixin{
		MessageMixin{},
		mixin.TimeMixin{},
	}
}
