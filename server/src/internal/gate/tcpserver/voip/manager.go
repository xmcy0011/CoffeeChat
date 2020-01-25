package voip

import (
	"container/list"
	"strconv"
)

type Manager struct {
	channelList *list.List
}

var DefaultVOIPManager = &Manager{}

func init() {
	DefaultVOIPManager.channelList = list.New()
}

// get channel name(p2p)
func GetChannelName(toSessionId uint64) (name, token string, error error) {
	// 021-sessionId：single
	// 031-sessionId: group
	name = "021-" + strconv.Itoa(int(toSessionId))
	return name, token, nil
}

func (m *Manager) Get(userId uint64) *ChannelInfo {
	return nil
}
