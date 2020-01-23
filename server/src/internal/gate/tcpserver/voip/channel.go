package voip

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/cim"
)

// 成员信息
type ChannelMemberInfo struct {
	UserId uint64               // 用户ID
	Status cim.CIMInviteRspCode // 状态
}

// 频道信息
type ChannelInfo struct {
	Name    string            // 频道名
	Creator ChannelMemberInfo // 发起者
	Members *list.List        // 成员
}
