package tcpserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/gate/conf"
	"coffeechat/pkg/def"
	"coffeechat/pkg/logger"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/golang-jwt/jwt"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
	"time"
)

type RobotClient struct {
	Name string
}

// 上行消息
type RobotQuestion struct {
	Body string `json:"body"`
}

// 下行消息
type RobotAnswer struct {
	Body    string             `json:"body"`
	Content RobotAnswerContent `json:"content"`
}

type RobotAnswerContent struct {
	Type    string `json:"type"`
	Content string `json:"content"`
}

// 思知返回json
type JsonResponseOwnThink struct {
	Message string `json:"message"`
	Data    struct {
		Type int `json:"type"`
		Info struct {
			Text string `json:"text"`
		}
	}
}

// 小微返回json
type JsonResponseWeChat struct {
	Response string `json:"response"`
}

type JwtPayloadQuestion struct {
	Q string `json:"q"`
}

var DefaultRobotClient = &RobotClient{Name: "思知机器人"}

func (r *RobotClient) IsRobotUser(toId uint64) {

}

// 解析机器人消息中的问题（上行）
func (r *RobotClient) ResolveQuestion(msg *cim.CIMMsgData) (string, error) {
	switch msg.MsgType {
	case cim.CIMMsgType_kCIM_MSG_TYPE_TEXT:
		return string(msg.MsgData), nil
	case cim.CIMMsgType_kCIM_MSG_TYPE_AUDIO:
		return "[语音]", nil
	case cim.CIMMsgType_kCIM_MSG_TYPE_VIDEO:
		return "[视频]", nil
	case cim.CIMMsgType_kCIM_MSG_TYPE_FILE:
		return "[文件]", nil
	case cim.CIMMsgType_kCIM_MSG_TYPE_LOCATION:
		return "[位置]", nil
	case cim.CIMMsgType_kCIM_MSG_TYPE_IMAGE:
		return "[图片]", nil
	default:
		return string(msg.MsgData), nil
	}
}

// 从思知机器人获取答案
func (r *RobotClient) getOwnThinkAnswer(userId uint64, question string) (RobotAnswer, error) {
	url := fmt.Sprintf("%s?appid=%s&userid=%d&spoken=%s", conf.DefaultConfig.OwnThinkRobotUrl, conf.DefaultConfig.OwnThinkRobotAppId, userId, question)
	client := http.Client{}
	// 思知机器人比较慢啊...
	client.Timeout = time.Second * 10

	answer := RobotAnswer{Body: question}
	answer.Content.Type = "text"

	res, err := client.Get(url)
	if err != nil {
		answer.Content.Content = "机器人思考时间太长啦，推荐问题：姚明，undefined，被子植物门，coffeechat"
		return answer, err
	}

	if res.StatusCode == 200 {
		data, err := ioutil.ReadAll(res.Body)
		if err != nil {
			return answer, err
		}

		logger.Sugar.Debugf("robot response:%s", string(data))
		//{
		//    "message": "success",               // 请求是否成功
		//    "data": {
		//        "type": 5000,                   // 答案类型，5000文本类型
		//        "info": {
		//            "text": "姚明的身高是226厘米"  // 机器人返回的答案
		//        }
		//    }
		//}

		info := JsonResponseOwnThink{}
		err = json.Unmarshal(data, &info)
		if err != nil {
			return answer, err
		}
		if info.Message != "success" {
			return answer, errors.New(info.Message)
		}
		if info.Data.Type != 5000 {
			return answer, errors.New("unknown type:" + strconv.Itoa(info.Data.Type))
		}

		answer.Content.Content = info.Data.Info.Text
		return answer, nil
	}
	return answer, errors.New(strconv.Itoa(res.StatusCode) + " status code")
}

// jwt calc WebToken
func (r *RobotClient) getJwtToken(signingKey, userId, question string) (string, error) {
	// Header
	// {
	// "typ": "JWT",
	// "alg": "HS256"
	//}
	token := jwt.New(jwt.SigningMethodHS256)
	claims := make(jwt.MapClaims)

	// Payload
	//{
	//	"uid": "xjlsj33lasfaf",
	//	"data": {
	//		"q": "我想和你聊天"
	//	}
	//}
	claims["uid"] = userId
	claims["data"] = JwtPayloadQuestion{Q: question}
	token.Claims = claims

	// Signing Key
	return token.SignedString([]byte(signingKey))
}

func (r *RobotClient) getWeChatAnswer(userId uint64, question string) (RobotAnswer, error) {
	url := fmt.Sprintf("%s/%s", conf.DefaultConfig.WeChatRobotUrl, conf.DefaultConfig.WeChatRobotToken)

	query, err := r.getJwtToken(conf.DefaultConfig.WeChatRobotEncodingAESKey, strconv.Itoa(int(userId)), question)
	if err != nil {
		logger.Sugar.Errorf("get webToken error %s", err.Error())
	}

	client := http.Client{}
	client.Timeout = time.Second * 3 // 小微的比较快

	answer := RobotAnswer{Body: question}
	answer.Content.Type = "text"

	res, err := client.Post(url, "application/x-www-form-urlencoded", strings.NewReader("query="+query))
	if err != nil {
		answer.Content.Content = "小微思考时间太长啦，请稍后重试哦😅"
		logger.Sugar.Warnf("weChat robot http error:%s", err.Error())
		return answer, err
	}

	data, err := ioutil.ReadAll(res.Body)
	if err != nil {
		answer.Content.Content = "小微异常啦，申请维修哦🧰"
		logger.Sugar.Warnf(err.Error())
		return answer, err
	}

	response := JsonResponseWeChat{}
	err = json.Unmarshal(data, &response)
	if err != nil {
		answer.Content.Content = "小微异常啦，申请维修哦🧰"
		logger.Sugar.Warnf(err.Error())
		return answer, err
	}
	answer.Content.Content = response.Response
	return answer, nil
}

// 获取答案
func (r *RobotClient) GetAnswer(userId, robotId uint64, question string) (RobotAnswer, error) {
	answer := RobotAnswer{Body: question}

	if robotId == def.OwnThinkRobotUserId {
		return r.getOwnThinkAnswer(userId, question)
	} else if robotId == def.WeChatRobotUserId {
		return r.getWeChatAnswer(userId, question)
	} else {
		logger.Sugar.Warnf("invalid robot_id=%d,user_id=%d", robotId, userId)
	}
	return answer, errors.New("invalid robot_id")
}
