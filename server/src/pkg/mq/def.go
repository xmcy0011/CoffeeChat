package mq

const (
	TopicPrefix = "cim_"
	PushTopic   = "msg_push"
)

func getPushMsgTopic() string {
	return TopicPrefix + PushTopic
}
