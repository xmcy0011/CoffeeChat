package voip

import (
	"coffeechat/pkg/logger"
	"strconv"
)

type Manager struct {
	channelMap map[uint64]*ChannelInfo // 频道列表，creator_user_id
}

var DefaultVOIPManager = &Manager{}

func init() {
	DefaultVOIPManager.channelMap = make(map[uint64]*ChannelInfo, 0)
}

// get channel name(p2p)
func GetChannelName(toSessionId uint64) (name, token string, error error) {
	// 021-sessionId：single
	// 031-sessionId: group
	name = "021-" + strconv.Itoa(int(toSessionId))
	return name, token, nil
}

func (m *Manager) Get(creatorUserId uint64) *ChannelInfo {
	if v, ok := m.channelMap[creatorUserId]; ok {
		return v
	}
	return nil
}

// insert channel
func (m *Manager) InsertOrUpdate(creatorUserId uint64, info *ChannelInfo) {
	if _, ok := m.channelMap[creatorUserId]; ok {
		logger.Sugar.Debugf("exist key,creator_user_id=%s,update it", creatorUserId)
		m.channelMap[creatorUserId] = info
	}

	// insert
	m.channelMap[creatorUserId] = info
}

// update avState
func (m *Manager) UpdateAvState(creatorUserId uint64, state AVState) {
	c := m.Get(creatorUserId)
	if c != nil {
		c.State = state
	}
}

// delete
func (m *Manager) Delete(creatorUserId uint64) {
	if _, ok := m.channelMap[creatorUserId]; ok {
		delete(m.channelMap, creatorUserId)
	} else {
		logger.Sugar.Debugf("not exist key=%s,delete from channelMap failed", creatorUserId)
	}
}
