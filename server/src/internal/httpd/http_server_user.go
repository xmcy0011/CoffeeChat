package httpd

import (
	"coffeechat/api/cim"
	"coffeechat/pkg/logger"
	"context"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
	"time"
)

const (
	// 用户名长度限制
	kMinUserNameLen = 5
	kMaxUserNameLen = 32
	// 密码
	kUserPwdLen = 32

	// 超时,s
	kGrpcTimeOut = 3
)

// 创建用户json
type RequestCreateUser struct {
	UserName     string `json:"userName"`
	UserNickName string `json:"userNickName"`
	UserPwd      string `json:"userPwd"`
}

// 查询用户json
type UserNickNameReq struct {
	UserId uint64 `json:"user_id"`
}

type UserNickNameRsp struct {
	ResponseBase
	NickName string `json:"nick_name"`
}

// 用户昵称随机生成
type GenerateNickRsp struct {
	ResponseBase
	NickName string `json:"nick_name"`
}

// 注册用户
// user/register
func userRegister(writer http.ResponseWriter, request *http.Request) {
	if err := checkPostHeader(request); err != nil {
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERROR_USER_INVALID_PARAMETER), err.Error())
		return
	}
	data, err := ioutil.ReadAll(request.Body)
	if err != nil {
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERROR_USER_INVALID_PARAMETER), "bad request")
		return
	}

	req := RequestCreateUser{}
	err = json.Unmarshal(data, &req)
	if err != nil {
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERROR_USER_INVALID_PARAMETER), "invalid parameters")
		return
	}
	if len(req.UserName) < kMinUserNameLen || len(req.UserName) > kMaxUserNameLen {
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERROR_USER_INVALID_PARAMETER), "invalid userName")
		return
	}
	if len(req.UserPwd) != kUserPwdLen { // 32位md5
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERROR_USER_INVALID_PARAMETER), "invalid userPwd")
		return
	}
	if strings.TrimSpace(req.UserNickName) == "" {
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERROR_USER_INVALID_PARAMETER), "invalid userNickName")
		return
	}

	con := GetConn()
	if con == nil {
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR), "server internal error")
		return
	}

	logger.Sugar.Infof("%s create,userName=%s,userPwd=%s", kRegisterUserUrl, req.UserName, req.UserPwd)

	ctx, _ := context.WithTimeout(context.Background(), time.Second*kGrpcTimeOut)
	createRsp, err := con.CreateUser(ctx, &cim.CreateUserAccountInfoReq{
		UserName:     strings.TrimSpace(req.UserName), // 去除前后空格
		UserPwd:      strings.TrimSpace(req.UserPwd),
		UserNickName: strings.TrimSpace(req.UserNickName),
	})
	if err != nil {
		logger.Sugar.Warnf("logic server error:%s", err.Error())
		writeError(kRegisterUserUrl, writer, int(cim.CIMErrorCode_kCIM_ERR_INTERNAL_ERROR), "server internal error")
	} else {
		if createRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERR_SUCCESS {
			rsp := ResponseBase{ErrorCode: int(cim.CIMErrorCode_kCIM_ERR_SUCCESS), ErrorMsg: "success"}
			data, _ := json.Marshal(rsp)
			_, _ = writer.Write(data)
			logger.Sugar.Infof("%s create success,userName=%s,userPwd=%s", kRegisterUserUrl,
				req.UserName, req.UserPwd)
		} else {
			rsp := ResponseBase{ErrorCode: int(createRsp.ErrorCode), ErrorMsg: "unknown error"}
			if createRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERROR_USER_ALREADY_EXIST {
				rsp.ErrorMsg = "user already exist"
			}
			data, _ := json.Marshal(rsp)
			_, _ = writer.Write(data)
			logger.Sugar.Infof("%s create failed:%s,userName=%s,userPwd=%s", kRegisterUserUrl,
				rsp.ErrorMsg, req.UserName, req.UserPwd)
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
		if queryRsp.ErrorCode == cim.CIMErrorCode_kCIM_ERR_SUCCESS {
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

func userGenerateNickName(writer http.ResponseWriter, request *http.Request) {
	v := request.URL.Query()
	version := v.Get("version")
	if version == "" {
		writeError(kGenerateNickNameUrl, writer, -1, "invalid parameters")
		return
	}

	if version == "1" {
		version = "V1"
	} else {
		writeError(kGenerateNickNameUrl, writer, -1, "invalid version")
		return
	}

	// rpc
	ctx, _ := context.WithTimeout(context.Background(), time.Second*3)
	conn := GetConn()
	req := &cim.GenerateNickNameReq{
		Version: version,
	}

	rsp, err := conn.GenerateNickName(ctx, req)
	if err != nil {
		logger.Sugar.Warnf("logic server error:%s", err.Error())
		writeError(kQueryNickNameUserUrl, writer, -1, "server internal error")
	} else {
		httpRsp := GenerateNickRsp{}
		httpRsp.ErrorMsg = "success"
		httpRsp.ErrorCode = int(cim.CIMErrorCode_kCIM_ERR_SUCCESS)
		httpRsp.NickName = rsp.LastName + rsp.FirstName

		data, _ := json.Marshal(httpRsp)
		_, _ = writer.Write(data)
		logger.Sugar.Infof("%s generate success,rand nick=%s", kQueryNickNameUserUrl, httpRsp.NickName)
	}
}
