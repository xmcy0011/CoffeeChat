package voip

import "coffeechat/api/cim"

type AVState int32

const (
	AVState_Default   AVState = 0
	AVState_Tring     AVState = 1
	AVState_Ringing   AVState = 2
	AVState_Establish AVState = 3
	AVState_Hangup    AVState = 4
)

// 成员信息
//type ChannelMemberInfo struct {
//	UserId uint64               // 用户ID
//	Status cim.CIMInviteRspCode // 状态
//}

// 频道信息
type ChannelInfo struct {
	Name  string // 频道名
	Token string // 频道令牌

	State    AVState               // 通话状态
	CallType cim.CIMVoipInviteType // 通话类型

	Creator    uint64 // 发起者
	PeerUserId uint64 // 被呼叫者
	//Members *list.List // 成员,ChannelMemberInfo
}
