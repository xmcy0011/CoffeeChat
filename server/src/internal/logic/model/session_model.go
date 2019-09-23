package model

type SessionModel struct {
	Id          uint64 `json:"id"`
	UserId      uint64 `json:"user_id"`
	PeerId      uint64 `json:"peer_id"`
	SessionType int    `json:"session_type"`

	SessionStatus  int `json:"session_status"`
	IsRobotSession int `json:"is_robot_session"`

	Created int `json:"created"`
	Updated int `json:"updated"`
}
