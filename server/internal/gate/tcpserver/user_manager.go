/** @file user_manager.go
 * @brief 用户管理类
 * @author CoffeeChat
 * @date 2019-09-16
 */
package tcpserver

import "sync"

type UserManager struct {
	users map[uint64]*User // 在线用户字典
}

var DefaultUserManager = &UserManager{}
var mutex = sync.Mutex{}

func init() {
	DefaultUserManager.users = make(map[uint64]*User)
}

// 查找用户
func (u *UserManager) FindUser(userId uint64) *User {
	if u, ok := u.users[userId]; ok {
		return u
	}
	return nil
}

// 添加一个用户
func (u *UserManager) AddUser(userId uint64, user *User) {
	mutex.Lock()
	u.users[userId] = user
	mutex.Unlock()
}

// 移除一个用户
func (u *UserManager) RemoveUser(userId uint64) {
	mutex.Lock()
	delete(u.users, userId)
	mutex.Unlock()
}
