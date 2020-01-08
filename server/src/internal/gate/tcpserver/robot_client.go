package tcpserver

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/CoffeeChat/server/src/internal/gate/conf"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"io/ioutil"
	"net/http"
	"strconv"
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

//type JsonResponseOwnThink struct {
//	Message string                   `json:"message"`
//	Data    JsonResponseOwnThinkData `json:"data"`
//}
//
//type JsonResponseOwnThinkData struct {
//	Type int                          `json:"type"`
//	Info JsonResponseOwnThinkDataInfo `json:"info"`
//}
//
//type JsonResponseOwnThinkDataInfo struct {
//	Text string `json:"text"`
//}

var DefaultRobotClient = &RobotClient{Name: "思知机器人"}

// 解析机器人消息中的问题（上行）
func (r *RobotClient) ResolveQuestion(msgData []byte) (string, error) {
	req := RobotQuestion{}

	err := json.Unmarshal(msgData, &req)
	if err != nil {
		return "", err
	}
	return req.Body, nil
}

// 获取答案
func (r *RobotClient) GetAnswer(userId uint64, question string) (RobotAnswer, error) {
	url := fmt.Sprintf("%s?appid=%s&userid=%d&spoken=%s", conf.DefaultConfig.RobotUrl, conf.DefaultConfig.RobotAppId, userId, question)
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
