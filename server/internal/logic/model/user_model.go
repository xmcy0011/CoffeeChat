package model

type UserModel struct {
	UserId       uint64 `json:"id"`
	UserNickName string `json:"user_nick_name"`
	UserToken    string `json:"user_token"`
	UserAttach   string `json:"user_attach"`
	UserName     string `json:"user_name"`
	UserPwdSalt  string `json:"user_pwd_salt"`
	UserPwdHash  string `json:"user_pwd_hash"`
	Created      int    `json:"created"`
	Updated      int    `json:"updated"`
}
