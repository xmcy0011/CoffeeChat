package tcpserver

import (
	"github.com/BurntSushi/toml"
	"coffeechat/internal/gate/conf"
	"coffeechat/pkg/logger"
	"testing"
)

func TestRobotClient_GetJwtToken(t *testing.T) {
	key := "vpIfV7aof4QP40EreXNAVygwy4Bx534JldY1inOETBY"
	userId := "xjlsj33lasfaf"
	q := "我想和你聊天"
	response, err := DefaultRobotClient.getJwtToken(key, userId, q)
	if err != nil {
		t.Failed()
	}
	t.Logf("webToken=%s", response)
}

func TestRobotClient_GetWeChatAnswer(t *testing.T) {
	logger.InitLogger("log.log", "debug")

	_, err := toml.DecodeFile("../../../app/im_gate/gate-example.toml", conf.DefaultConfig)
	if err != nil{
		t.Failed()
		return
	}

	res, err := DefaultRobotClient.getWeChatAnswer(123, "下雨天不下雨")
	if err != nil {
		t.Failed()
	}
	t.Logf("成功,微信机器人回复：%s", res.Content.Content)
}
