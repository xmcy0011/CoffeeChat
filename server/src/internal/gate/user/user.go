package user

import "container/list"

type User struct {
	Conn list.List // CImConn list

	UserId   uint64 // 用户id
	NickName string // 昵称
}
