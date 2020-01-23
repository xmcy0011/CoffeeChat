package voip

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/cim"
	"strconv"
)

type Manager struct {
	channelList *list.List
}

var DefaultVOIPManager = &Manager{}

func init() {
	DefaultVOIPManager.channelList = list.New()
}

// get channel name
func GetChannelName(toSessionId uint64, sessionType cim.CIMSessionType) (name, token string, error error) {
	// 021-sessionId：single
	// 031-sessionId: group
	if sessionType == cim.CIMSessionType_kCIM_SESSION_TYPE_SINGLE {
		name = "021-" + strconv.Itoa(int(toSessionId))
	} else {
		name = "031-" + strconv.Itoa(int(toSessionId))
	}
	return name, token, nil
}

func (m *Manager) Get(userId uint64) *ChannelInfo {
	return nil
}
