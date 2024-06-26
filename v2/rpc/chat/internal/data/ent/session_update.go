// Code generated by ent, DO NOT EDIT.

package ent

import (
	"chat/internal/data/ent/predicate"
	"chat/internal/data/ent/session"
	"context"
	"errors"
	"fmt"
	"time"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
)

// SessionUpdate is the builder for updating Session entities.
type SessionUpdate struct {
	config
	hooks    []Hook
	mutation *SessionMutation
}

// Where appends a list predicates to the SessionUpdate builder.
func (su *SessionUpdate) Where(ps ...predicate.Session) *SessionUpdate {
	su.mutation.Where(ps...)
	return su
}

// SetUpdated sets the "updated" field.
func (su *SessionUpdate) SetUpdated(t time.Time) *SessionUpdate {
	su.mutation.SetUpdated(t)
	return su
}

// SetUserID sets the "user_id" field.
func (su *SessionUpdate) SetUserID(s string) *SessionUpdate {
	su.mutation.SetUserID(s)
	return su
}

// SetPeerID sets the "peer_id" field.
func (su *SessionUpdate) SetPeerID(s string) *SessionUpdate {
	su.mutation.SetPeerID(s)
	return su
}

// SetSessionType sets the "session_type" field.
func (su *SessionUpdate) SetSessionType(i int8) *SessionUpdate {
	su.mutation.ResetSessionType()
	su.mutation.SetSessionType(i)
	return su
}

// AddSessionType adds i to the "session_type" field.
func (su *SessionUpdate) AddSessionType(i int8) *SessionUpdate {
	su.mutation.AddSessionType(i)
	return su
}

// SetSessionStatus sets the "session_status" field.
func (su *SessionUpdate) SetSessionStatus(i int8) *SessionUpdate {
	su.mutation.ResetSessionStatus()
	su.mutation.SetSessionStatus(i)
	return su
}

// AddSessionStatus adds i to the "session_status" field.
func (su *SessionUpdate) AddSessionStatus(i int8) *SessionUpdate {
	su.mutation.AddSessionStatus(i)
	return su
}

// Mutation returns the SessionMutation object of the builder.
func (su *SessionUpdate) Mutation() *SessionMutation {
	return su.mutation
}

// Save executes the query and returns the number of nodes affected by the update operation.
func (su *SessionUpdate) Save(ctx context.Context) (int, error) {
	var (
		err      error
		affected int
	)
	su.defaults()
	if len(su.hooks) == 0 {
		if err = su.check(); err != nil {
			return 0, err
		}
		affected, err = su.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*SessionMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = su.check(); err != nil {
				return 0, err
			}
			su.mutation = mutation
			affected, err = su.sqlSave(ctx)
			mutation.done = true
			return affected, err
		})
		for i := len(su.hooks) - 1; i >= 0; i-- {
			if su.hooks[i] == nil {
				return 0, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = su.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, su.mutation); err != nil {
			return 0, err
		}
	}
	return affected, err
}

// SaveX is like Save, but panics if an error occurs.
func (su *SessionUpdate) SaveX(ctx context.Context) int {
	affected, err := su.Save(ctx)
	if err != nil {
		panic(err)
	}
	return affected
}

// Exec executes the query.
func (su *SessionUpdate) Exec(ctx context.Context) error {
	_, err := su.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (su *SessionUpdate) ExecX(ctx context.Context) {
	if err := su.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (su *SessionUpdate) defaults() {
	if _, ok := su.mutation.Updated(); !ok {
		v := session.UpdateDefaultUpdated()
		su.mutation.SetUpdated(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (su *SessionUpdate) check() error {
	if v, ok := su.mutation.UserID(); ok {
		if err := session.UserIDValidator(v); err != nil {
			return &ValidationError{Name: "user_id", err: fmt.Errorf(`ent: validator failed for field "Session.user_id": %w`, err)}
		}
	}
	if v, ok := su.mutation.PeerID(); ok {
		if err := session.PeerIDValidator(v); err != nil {
			return &ValidationError{Name: "peer_id", err: fmt.Errorf(`ent: validator failed for field "Session.peer_id": %w`, err)}
		}
	}
	return nil
}

func (su *SessionUpdate) sqlSave(ctx context.Context) (n int, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   session.Table,
			Columns: session.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt32,
				Column: session.FieldID,
			},
		},
	}
	if ps := su.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := su.mutation.Updated(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: session.FieldUpdated,
		})
	}
	if value, ok := su.mutation.UserID(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: session.FieldUserID,
		})
	}
	if value, ok := su.mutation.PeerID(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: session.FieldPeerID,
		})
	}
	if value, ok := su.mutation.SessionType(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionType,
		})
	}
	if value, ok := su.mutation.AddedSessionType(); ok {
		_spec.Fields.Add = append(_spec.Fields.Add, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionType,
		})
	}
	if value, ok := su.mutation.SessionStatus(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionStatus,
		})
	}
	if value, ok := su.mutation.AddedSessionStatus(); ok {
		_spec.Fields.Add = append(_spec.Fields.Add, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionStatus,
		})
	}
	if n, err = sqlgraph.UpdateNodes(ctx, su.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{session.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{msg: err.Error(), wrap: err}
		}
		return 0, err
	}
	return n, nil
}

// SessionUpdateOne is the builder for updating a single Session entity.
type SessionUpdateOne struct {
	config
	fields   []string
	hooks    []Hook
	mutation *SessionMutation
}

// SetUpdated sets the "updated" field.
func (suo *SessionUpdateOne) SetUpdated(t time.Time) *SessionUpdateOne {
	suo.mutation.SetUpdated(t)
	return suo
}

// SetUserID sets the "user_id" field.
func (suo *SessionUpdateOne) SetUserID(s string) *SessionUpdateOne {
	suo.mutation.SetUserID(s)
	return suo
}

// SetPeerID sets the "peer_id" field.
func (suo *SessionUpdateOne) SetPeerID(s string) *SessionUpdateOne {
	suo.mutation.SetPeerID(s)
	return suo
}

// SetSessionType sets the "session_type" field.
func (suo *SessionUpdateOne) SetSessionType(i int8) *SessionUpdateOne {
	suo.mutation.ResetSessionType()
	suo.mutation.SetSessionType(i)
	return suo
}

// AddSessionType adds i to the "session_type" field.
func (suo *SessionUpdateOne) AddSessionType(i int8) *SessionUpdateOne {
	suo.mutation.AddSessionType(i)
	return suo
}

// SetSessionStatus sets the "session_status" field.
func (suo *SessionUpdateOne) SetSessionStatus(i int8) *SessionUpdateOne {
	suo.mutation.ResetSessionStatus()
	suo.mutation.SetSessionStatus(i)
	return suo
}

// AddSessionStatus adds i to the "session_status" field.
func (suo *SessionUpdateOne) AddSessionStatus(i int8) *SessionUpdateOne {
	suo.mutation.AddSessionStatus(i)
	return suo
}

// Mutation returns the SessionMutation object of the builder.
func (suo *SessionUpdateOne) Mutation() *SessionMutation {
	return suo.mutation
}

// Select allows selecting one or more fields (columns) of the returned entity.
// The default is selecting all fields defined in the entity schema.
func (suo *SessionUpdateOne) Select(field string, fields ...string) *SessionUpdateOne {
	suo.fields = append([]string{field}, fields...)
	return suo
}

// Save executes the query and returns the updated Session entity.
func (suo *SessionUpdateOne) Save(ctx context.Context) (*Session, error) {
	var (
		err  error
		node *Session
	)
	suo.defaults()
	if len(suo.hooks) == 0 {
		if err = suo.check(); err != nil {
			return nil, err
		}
		node, err = suo.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*SessionMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = suo.check(); err != nil {
				return nil, err
			}
			suo.mutation = mutation
			node, err = suo.sqlSave(ctx)
			mutation.done = true
			return node, err
		})
		for i := len(suo.hooks) - 1; i >= 0; i-- {
			if suo.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = suo.hooks[i](mut)
		}
		v, err := mut.Mutate(ctx, suo.mutation)
		if err != nil {
			return nil, err
		}
		nv, ok := v.(*Session)
		if !ok {
			return nil, fmt.Errorf("unexpected node type %T returned from SessionMutation", v)
		}
		node = nv
	}
	return node, err
}

// SaveX is like Save, but panics if an error occurs.
func (suo *SessionUpdateOne) SaveX(ctx context.Context) *Session {
	node, err := suo.Save(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// Exec executes the query on the entity.
func (suo *SessionUpdateOne) Exec(ctx context.Context) error {
	_, err := suo.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (suo *SessionUpdateOne) ExecX(ctx context.Context) {
	if err := suo.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (suo *SessionUpdateOne) defaults() {
	if _, ok := suo.mutation.Updated(); !ok {
		v := session.UpdateDefaultUpdated()
		suo.mutation.SetUpdated(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (suo *SessionUpdateOne) check() error {
	if v, ok := suo.mutation.UserID(); ok {
		if err := session.UserIDValidator(v); err != nil {
			return &ValidationError{Name: "user_id", err: fmt.Errorf(`ent: validator failed for field "Session.user_id": %w`, err)}
		}
	}
	if v, ok := suo.mutation.PeerID(); ok {
		if err := session.PeerIDValidator(v); err != nil {
			return &ValidationError{Name: "peer_id", err: fmt.Errorf(`ent: validator failed for field "Session.peer_id": %w`, err)}
		}
	}
	return nil
}

func (suo *SessionUpdateOne) sqlSave(ctx context.Context) (_node *Session, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   session.Table,
			Columns: session.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt32,
				Column: session.FieldID,
			},
		},
	}
	id, ok := suo.mutation.ID()
	if !ok {
		return nil, &ValidationError{Name: "id", err: errors.New(`ent: missing "Session.id" for update`)}
	}
	_spec.Node.ID.Value = id
	if fields := suo.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, session.FieldID)
		for _, f := range fields {
			if !session.ValidColumn(f) {
				return nil, &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
			}
			if f != session.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, f)
			}
		}
	}
	if ps := suo.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := suo.mutation.Updated(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: session.FieldUpdated,
		})
	}
	if value, ok := suo.mutation.UserID(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: session.FieldUserID,
		})
	}
	if value, ok := suo.mutation.PeerID(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: session.FieldPeerID,
		})
	}
	if value, ok := suo.mutation.SessionType(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionType,
		})
	}
	if value, ok := suo.mutation.AddedSessionType(); ok {
		_spec.Fields.Add = append(_spec.Fields.Add, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionType,
		})
	}
	if value, ok := suo.mutation.SessionStatus(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionStatus,
		})
	}
	if value, ok := suo.mutation.AddedSessionStatus(); ok {
		_spec.Fields.Add = append(_spec.Fields.Add, &sqlgraph.FieldSpec{
			Type:   field.TypeInt8,
			Value:  value,
			Column: session.FieldSessionStatus,
		})
	}
	_node = &Session{config: suo.config}
	_spec.Assign = _node.assignValues
	_spec.ScanValues = _node.scanValues
	if err = sqlgraph.UpdateNode(ctx, suo.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{session.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{msg: err.Error(), wrap: err}
		}
		return nil, err
	}
	return _node, nil
}
