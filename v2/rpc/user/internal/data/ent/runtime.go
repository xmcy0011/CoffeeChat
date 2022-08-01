// Code generated by ent, DO NOT EDIT.

package ent

import (
	"time"
	"user/internal/data/ent/device"
	"user/internal/data/ent/user"
	"user/internal/data/schema"
)

// The init function reads all schema descriptors with runtime code
// (default values, validators, hooks and policies) and stitches it
// to their package variables.
func init() {
	deviceMixin := schema.Device{}.Mixin()
	deviceMixinFields0 := deviceMixin[0].Fields()
	_ = deviceMixinFields0
	deviceFields := schema.Device{}.Fields()
	_ = deviceFields
	// deviceDescCreated is the schema descriptor for created field.
	deviceDescCreated := deviceMixinFields0[0].Descriptor()
	// device.DefaultCreated holds the default value on creation for the created field.
	device.DefaultCreated = deviceDescCreated.Default.(time.Time)
	// deviceDescUpdated is the schema descriptor for updated field.
	deviceDescUpdated := deviceMixinFields0[1].Descriptor()
	// device.DefaultUpdated holds the default value on creation for the updated field.
	device.DefaultUpdated = deviceDescUpdated.Default.(time.Time)
	// device.UpdateDefaultUpdated holds the default value on update for the updated field.
	device.UpdateDefaultUpdated = deviceDescUpdated.UpdateDefault.(func() time.Time)
	userMixin := schema.User{}.Mixin()
	userMixinFields0 := userMixin[0].Fields()
	_ = userMixinFields0
	userFields := schema.User{}.Fields()
	_ = userFields
	// userDescCreated is the schema descriptor for created field.
	userDescCreated := userMixinFields0[0].Descriptor()
	// user.DefaultCreated holds the default value on creation for the created field.
	user.DefaultCreated = userDescCreated.Default.(time.Time)
	// userDescUpdated is the schema descriptor for updated field.
	userDescUpdated := userMixinFields0[1].Descriptor()
	// user.DefaultUpdated holds the default value on creation for the updated field.
	user.DefaultUpdated = userDescUpdated.Default.(time.Time)
	// user.UpdateDefaultUpdated holds the default value on update for the updated field.
	user.UpdateDefaultUpdated = userDescUpdated.UpdateDefault.(func() time.Time)
	// userDescNickName is the schema descriptor for nick_name field.
	userDescNickName := userFields[1].Descriptor()
	// user.NickNameValidator is a validator for the "nick_name" field. It is called by the builders before save.
	user.NickNameValidator = userDescNickName.Validators[0].(func(string) error)
	// userDescPhone is the schema descriptor for phone field.
	userDescPhone := userFields[3].Descriptor()
	// user.PhoneValidator is a validator for the "phone" field. It is called by the builders before save.
	user.PhoneValidator = userDescPhone.Validators[0].(func(string) error)
	// userDescEmail is the schema descriptor for email field.
	userDescEmail := userFields[4].Descriptor()
	// user.EmailValidator is a validator for the "email" field. It is called by the builders before save.
	user.EmailValidator = userDescEmail.Validators[0].(func(string) error)
}
