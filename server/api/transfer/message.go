/** @file message.go
 * @brief json到对象的转化，可用于消息队列、http等
 * @author CoffeeChat
 * @date 2019/9/18
 */
package transfer

// 消息信息转化成json
type CIMMsgInfo struct {
	ClientMsgId string `json:"client_msg_id"`
	ServerMsgId uint64 `json:"server_msg_id"`
	MsgResCode  int    `json:"msg_res_code"`
	MsgFeature  int    `json:"msg_feature"`
	SessionType int    `json:"session_type"`
	FromUserId  uint64 `json:"from_user_id"`
	ToSessionId uint64 `json:"to_session_id"`
	CreateTime  uint64 `json:"create_time"`
	MsgType     int    `json:"msg_type"`
	MsgStatus   int    `json:"msg_status"`
	MsgData     []byte `json:"msg_data"`
	//optional
	Attach           string `json:"attach"`
	SenderClientType int    `json:"sender_client_type"`
}
