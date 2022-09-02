package biz

import "message/internal/message/data/ent"

type Message struct {
	client *ent.Client
}

func NewMessage(client *ent.Client) *Message {
	return &Message{client: client}
}

func (m *Message) DD() {

}
