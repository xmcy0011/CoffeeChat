package schema

import (
	"CoffeeChat/ent/mixin"
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"user/internal/data/pojo"
)

// User holds the schema definition for the User entity.
type User struct {
	ent.Schema
}

// Fields of the User.
func (User) Fields() []ent.Field {
	return []ent.Field{
		field.Int64("id").Unique(),
		field.String("nick_name").MaxLen(64),
		field.Int8("sex"),
		field.String("phone").MaxLen(32).Optional(),
		field.String("email").MaxLen(128).Optional(),
		field.JSON("extra", pojo.UserExtra{}).Optional(),
	}
}

func (User) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.TimeMixin{},
	}
}

// Edges of the User.
func (User) Edges() []ent.Edge {
	return nil
}
