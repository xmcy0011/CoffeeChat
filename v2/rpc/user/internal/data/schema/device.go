package schema

import (
	"CoffeeChat/ent/mixin"
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
)

// Device holds the schema definition for the Device entity.
type Device struct {
	ent.Schema
}

// Fields of the Device.
func (Device) Fields() []ent.Field {
	return []ent.Field{
		field.Int32("id").Unique(),
		field.String("device_id"),
		field.Int32("app_version"),
		field.String("os_version"),
	}
}

// Edges of the Device.
func (Device) Edges() []ent.Edge {
	return nil
}

func (Device) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.TimeMixin{},
	}
}
