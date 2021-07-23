package httpd

import (
	"coffeechat/pkg/logger"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
)

const (
	kRegisterUserUrl      = "/user/register"
	kQueryNickNameUserUrl = "/user/nickname/query"
	kGenerateNickNameUrl  = "/user/nickname/generate"
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

type ResponseBase struct {
	ErrorCode int    `json:"error_code"`
	ErrorMsg  string `json:"error_msg"`
}

func writeError(url string, writer http.ResponseWriter, errorCode int, errorMsg string) {
	rsp := ResponseBase{ErrorCode: errorCode, ErrorMsg: errorMsg}
	data, _ := json.Marshal(rsp)
	_, _ = writer.Write(data)
	logger.Sugar.Infof("%s %s", url, rsp.ErrorMsg)
}

func checkPostHeader(request *http.Request) error {
	v, ok := request.Header["Content-Type"]

	if request.Method != "POST" {
		return errors.New("method must be post")
	}
	if !ok || len(v) <= 0 || v[0] != "application/json; charset=utf-8" {
		return errors.New("Content-Type must be application/json; charset=utf-8")
	}
	return nil
}

// 启动HTTP服务
func StartHttpServer(config Config) {
	StartGrpcClient(config.Logic)

	// Content-Type:application/json; charset=utf-8
	http.HandleFunc(kRegisterUserUrl, userRegister)
	http.HandleFunc(kQueryNickNameUserUrl, userNickNameQuery)
	http.HandleFunc(kGenerateNickNameUrl, userGenerateNickName)

	// 启动Http监听端口
	// PS：为了安全起见，一般线上需要改成HTTPS， 证书可以使用阿里云等免费的SSL证书
	host := config.ListenIp + ":" + strconv.Itoa(config.ListenPort)
	logger.Sugar.Infof("start http server,listen on %s", host)
	logger.Sugar.Fatal(http.ListenAndServe(host, nil))
}
