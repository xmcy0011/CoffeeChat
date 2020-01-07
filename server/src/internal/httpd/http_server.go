package httpd

import (
	"context"
	"encoding/json"
	"github.com/CoffeeChat/server/src/api/cim"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
	"time"
)

var (
	kRegisterUserUrl = "/user/register"
)

type Config struct {
	ListenIp   string
	ListenPort int // tcp监听端口

	Logic []GrpcConfig // logic服务器地址
}

type GrpcConfig struct {
	Ip   string
	Port int
	//MaxConnCnt int // 最大连接数
}

type RequestCreateUser struct {
	UserId       int    `json:"user_id"`
	UserNickName string `json:"user_nick_name"`
	UserToken    string `json:"user_token"`
}

type ResponseBase struct {
	ErrorCode int    `json:"error_code"`
	ErrorMsg  string `json:"error_msg"`
}

func writeError(url string, writer http.ResponseWriter, errorCode int, errorMsg string) {
	rsp := ResponseBase{ErrorCode: errorCode, ErrorMsg: errorMsg}
	data, _ := json.Marshal(rsp)
	_, _ = writer.Write(data)
	logger.Sugar.Warnf("%s %s", url, rsp.ErrorMsg)
}

// 注册用户
// user/register
func userRegister(writer http.ResponseWriter, request *http.Request) {
	v, ok := request.Header["Content-Type"]

	if request.Method != "POST" {
		writeError(kRegisterUserUrl, writer, -1, "method must be post")
		return
	}
	if !ok || len(v) <= 0 || v[0] != "application/json" {
		writeError(kRegisterUserUrl, writer, -1, "Content-Type must be application/json")
		return
	}

	data, err := ioutil.ReadAll(request.Body)
	if err != nil {
		writeError(kRegisterUserUrl, writer, -1, "bad request")
		return
	}

	req := RequestCreateUser{}
	err = json.Unmarshal(data, &req)
	if err != nil {
		writeError(kRegisterUserUrl, writer, -1, "invalid parameters")
		return
	}
	if req.UserId == 0 {
		writeError(kRegisterUserUrl, writer, -1, "invalid user_id")
		return
	}
	if strings.TrimSpace(req.UserNickName) == "" {
		writeError(kRegisterUserUrl, writer, -1, "invalid user_nick_name")
		return
	}
	if len(req.UserToken) < 5 || len(req.UserToken) > 16 {
		writeError(kRegisterUserUrl, writer, -1, "invalid user_token,min 5,max 16")
		return
	}

	con := GetConn()
	if con == nil {
		writeError(kRegisterUserUrl, writer, -1, "server internal error")
		return
	}

	logger.Sugar.Infof("%s create,user_id=%d,user_nick_name=%s,user_token=%s", kRegisterUserUrl, req.UserId,
		req.UserNickName, req.UserToken)

	ctx, _ := context.WithTimeout(context.Background(), time.Second)
	createRsp, err := con.CreateUser(ctx, &cim.CreateUserAccountInfoReq{
		UserId:       uint64(req.UserId),
		UserNickName: req.UserNickName,
		UserToken:    req.UserToken,
	})
	if err != nil {
		logger.Sugar.Warnf("logic server error:%s", err.Error())
		writeError(kRegisterUserUrl, writer, -1, "server internal error")
	} else {
		if createRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERR_SUCCSSE {
			rsp := ResponseBase{ErrorCode: 0, ErrorMsg: "success"}
			data, _ := json.Marshal(rsp)
			_, _ = writer.Write(data)
			logger.Sugar.Infof("%s create success,user_id=%d,user_nick_name=%s,user_token=%s", kRegisterUserUrl,
				req.UserId, req.UserNickName, req.UserToken)
		} else {
			rsp := ResponseBase{ErrorCode: int(createRsp.ErrorCode), ErrorMsg: "unknown error"}
			if createRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERROR_USER_ALREADY_EXIST {
				rsp.ErrorMsg = "user already exist"
			}
			data, _ := json.Marshal(rsp)
			_, _ = writer.Write(data)
			logger.Sugar.Infof("%s create failed:%s,user_id=%d,user_nick_name=%s,user_token=%s", kRegisterUserUrl,
				rsp.ErrorMsg, req.UserId, req.UserNickName, req.UserToken)
		}
	}
}

// 启动HTTP服务
func StartHttpServer(config Config) {
	StartGrpcClient(config.Logic)

	// content-type:x-www-form-urlencoded
	http.HandleFunc(kRegisterUserUrl, userRegister)

	// 启动Http监听端口
	// PS：为了安全起见，一般线上需要改成HTTPS， 证书可以使用阿里云等免费的SSL证书
	logger.Sugar.Infof("start http server")
	logger.Sugar.Fatal(http.ListenAndServe(config.ListenIp+":"+strconv.Itoa(config.ListenPort), nil))
}
