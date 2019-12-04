/** @file user.go
 * @brief 用户类，一个用户多个连接，以实现多端同步
 * @author CoffeeChat
 * @date 2019-09-16
 */
package tcpserver

import (
	"container/list"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"math"
)

type User struct {
	conn *list.List // list<CImConn interface>

	ackMsgMap map[string]*cim.CIMMsgData // 客户端待确认收到消息列表

	UserId     uint64            // 用户id
	NickName   string            // 昵称
	ClientType cim.CIMClientType // 客户端类型
}

func NewUser() *User {
	u := &User{
		conn:      list.New(),
		ackMsgMap: make(map[string]*cim.CIMMsgData),
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

func (u *User) BroadcastMessage(data *cim.CIMMsgData) {
	// FIXED ME
	// 按照每个客户端类型统计ack列表更好
	u.ackMsgMap[data.MsgId] = data

	// update counter
	downMsgTotalCount.Inc()
	downMissMsgCount.Inc()

	for item := u.conn.Front(); item != nil; item = item.Next() {
		conn := item.Value.(CImConn)
		_, err := conn.Send(0, uint16(cim.CIMCmdID_kCIM_CID_MSG_DATA), data)
		if err != nil {
			logger.Sugar.Error("BroadcastMessage error:", err.Error())
		} else {
		}
	}
}

func (u *User) BroadcastReadMessage(data *cim.CIMMsgDataReadNotify) {
	for item := u.conn.Front(); item != nil; item = item.Next() {
		conn := item.Value.(CImConn)
		_, err := conn.Send(0, uint16(cim.CIMCmdID_kCIM_CID_MSG_READ_NOTIFY), data)
		if err != nil {
			logger.Sugar.Error("BroadcastReadMessage error:", err.Error())
		}
	}
}

func (u *User) OnCheckAckMessageTimerOut(tick int64) {
	for i := range u.ackMsgMap {
		if math.Abs(float64(int32(tick)-u.ackMsgMap[i].CreateTime)) > kAckMsgTimeOut {
			item := u.ackMsgMap[i]
			logger.Sugar.Errorf("ack msg time out,from_id:%d,to_id:%d,"+
				"session_type=%d,msg_id=%s,msg_type=%d,create_time=%d,tick=%d",
				item.FromUserId, item.ToSessionId, item.SessionType, item.MsgId, item.MsgType, item.CreateTime, tick)
			delete(u.ackMsgMap, i)
		}
	}
}

func (u *User) AckMessage(data *cim.CIMMsgDataAck) {
	delete(u.ackMsgMap, data.MsgId)
	downMissMsgCount.Dec()
}
