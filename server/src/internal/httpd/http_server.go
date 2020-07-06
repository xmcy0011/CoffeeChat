package httpd

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"encoding/json"
	"errors"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
	"time"
)

var (
	kRegisterUserUrl      = "/user/register"
	kQueryNickNameUserUrl = "/user/nickname/query"
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

// 创建用户json
type RequestCreateUser struct {
	UserId       int    `json:"user_id"`
	UserNickName string `json:"user_nick_name"`
	UserToken    string `json:"user_token"`
}

type ResponseBase struct {
	ErrorCode int    `json:"error_code"`
	ErrorMsg  string `json:"error_msg"`
}

// 查询用户json
type UserNickNameReq struct {
	UserId uint64 `json:"user_id"`
}

type UserNickNameRsp struct {
	ResponseBase
	NickName string `json:"nick_name"`
}

func writeError(url string, writer http.ResponseWriter, errorCode int, errorMsg string) {
	rsp := ResponseBase{ErrorCode: errorCode, ErrorMsg: errorMsg}
	data, _ := json.Marshal(rsp)
	_, _ = writer.Write(data)
	logger.Sugar.Warnf("%s %s", url, rsp.ErrorMsg)
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

// 注册用户
// user/register
func userRegister(writer http.ResponseWriter, request *http.Request) {
	if err := checkPostHeader(request); err != nil {
		writeError(kRegisterUserUrl, writer, -1, err.Error())
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

// 查询用户昵称
// user/nickname/query
func userNickNameQuery(writer http.ResponseWriter, request *http.Request) {
	err := request.ParseForm()
	if err != nil {
		writeError(kQueryNickNameUserUrl, writer, -1, "invalid parameters")
		return
	}

	userId := request.FormValue("user_id")
	if userId == "" {
		writeError(kQueryNickNameUserUrl, writer, -1, "miss user_id filed")
		return
	}

	iUserId, err := strconv.Atoi(userId)
	if err != nil {
		writeError(kQueryNickNameUserUrl, writer, -1, "invalid user_id")
		return
	}

	logger.Sugar.Infof("%s query user_nick_name,user_id=%d", kQueryNickNameUserUrl, iUserId)

	// rpc
	ctx, _ := context.WithTimeout(context.Background(), time.Second*3)
	conn := GetConn()

	req := &cim.QueryUserNickNameReq{
		UserId: uint64(iUserId),
	}
	queryRsp, err := conn.QueryUserNickName(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("logic server error:%s", err.Error())
		writeError(kQueryNickNameUserUrl, writer, -1, "server internal error")
	} else {
		if queryRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERR_SUCCSSE {
			rsp := UserNickNameRsp{NickName: ""}
			rsp.ErrorMsg = "success"
			rsp.ErrorCode = 0
			rsp.NickName = queryRsp.NickName

			data, _ := json.Marshal(rsp)
			_, _ = writer.Write(data)
			logger.Sugar.Infof("%s query success,user_id=%d,nick_name=%s", kQueryNickNameUserUrl,
				req.UserId, queryRsp.NickName)
		} else {
			rsp := UserNickNameRsp{NickName: ""}
			rsp.ErrorMsg = "unknown error"
			rsp.ErrorCode = int(queryRsp.ErrorCode)

			//if createRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERROR_USER_ALREADY_EXIST {
			//	rsp.ErrorMsg = "user already exist"
			//}
			data, _ := json.Marshal(rsp)
			_, _ = writer.Write(data)
			logger.Sugar.Infof("%s create failed:%s,user_id=%d", kQueryNickNameUserUrl, rsp.ErrorMsg, req.UserId)
		}
	}
}

// 启动HTTP服务
func StartHttpServer(config Config) {
	StartGrpcClient(config.Logic)

	// Content-Type:application/json; charset=utf-8
	http.HandleFunc(kRegisterUserUrl, userRegister)
	http.HandleFunc(kQueryNickNameUserUrl, userNickNameQuery)

	// 启动Http监听端口
	// PS：为了安全起见，一般线上需要改成HTTPS， 证书可以使用阿里云等免费的SSL证书
	host := config.ListenIp + ":" + strconv.Itoa(config.ListenPort)
	logger.Sugar.Infof("start http server,listen on %s", host)
	logger.Sugar.Fatal(http.ListenAndServe(host, nil))
}
