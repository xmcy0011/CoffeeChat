/** @file user.go
  * @brief 用户类，一个用户多个连接，以实现多端同步
  * @author CoffeeChat
  * @date 2019-09-16
  */
package tcpserver

import (
	"container/list"
	"github.com/CoffeeChat/server/src/pkg/logger"
)

type User struct {
	conn *list.List // list<CImConn interface>

	UserId   uint64 // 用户id
	NickName string // 昵称
}

func NewUser() *User {
	u := &User{
		conn: list.New(),
	}
	return u
}

func (u *User) AddConn(conn CImConn) *list.Element {
	return u.conn.PushBack(conn)
}

func (u *User) RemoveConn(e *list.Element, conn CImConn) {
	removedConn := u.conn.Remove(e)
	if removedConn == nil || removedConn != conn {
		logger.Sugar.Errorf("user.connList removed conn failed, user_id=%d, client_type=%s", u.UserId,
			conn.GetClientType())
	}
}

func (u *User) GetConnCount() int {
	return u.conn.Len()
}
