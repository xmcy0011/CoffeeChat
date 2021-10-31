package rpcserver

import (
	"coffeechat/api/cim"
	"coffeechat/internal/logic/dao"
	"coffeechat/pkg/logger"
	"context"
	"math/rand"
)

const kGenerateVersion = "v1"

// 新增一个授权用户
func (s *LogicServer) CreateUser(ctx context.Context, req *cim.CreateUserAccountInfoReq) (*cim.CreateUserAccountInfoRsp, error) {
	rsp := &cim.CreateUserAccountInfoRsp{}
	u := dao.DefaultUser.GetByUserName(req.UserName)
	if u != nil {
		rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERROR_USER_ALREADY_EXIST
		logger.Sugar.Warnf("CreateUser failed:user already exist,userId=%d,userName=%s", u.UserId, req.UserName)
		return rsp, nil
	}

	userId, err := dao.DefaultUser.Add(req.UserName, req.UserNickName, req.UserPwd)
	if err != nil {
		return nil, err
	}

	// 1.create user
	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCESS
	logger.Sugar.Infof("CreateUser userName=%s,userNickName=%s,userId=%d", req.UserName, req.UserNickName, userId)

	// 2.create robot session
	AddRobotSession(uint64(userId))
	return rsp, nil
}

// 查询用户昵称
func (s *LogicServer) QueryUserNickName(ctx context.Context, in *cim.QueryUserNickNameReq) (*cim.QueryUserNickNameRsp, error) {
	rsp := &cim.QueryUserNickNameRsp{}
	u := dao.DefaultUser.Get(in.UserId)
	if u == nil {
		rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERROR_USER_NOT_EXIST
		logger.Sugar.Warnf("QueryUserNickName failed:user not exist,userId=%d", in.UserId)
		return rsp, nil
	}

	// success
	rsp.ErrorCode = cim.CIMErrorCode_kCIM_ERR_SUCCESS
	rsp.NickName = u.UserNickName
	logger.Sugar.Infof("QueryUserNickName userId=%d,nickName=%s", in.UserId, rsp.NickName)

	return rsp, nil
}

// 查询系统中已注册用户的列表（上限50）
func (s *LogicServer) QuerySystemUserRandomList(ctx context.Context, in *cim.CIMFriendQueryUserListReq) (*cim.CIMFriendQueryUserListRsp, error) {
	rsp := &cim.CIMFriendQueryUserListRsp{}
	users, err := dao.DefaultUser.ListRandom(in.UserId)
	if err != nil {
		logger.Sugar.Warnf("QuerySystemUserRandomList failed:%s,userId=%d", err.Error(), in.UserId)
		return nil, err
	}

	rsp.UserId = in.UserId
	rsp.UserInfoList = users
	logger.Sugar.Infof("QuerySystemUserRandomList userId=%d,userListLen=%d", in.UserId, len(rsp.UserInfoList))

	return rsp, nil
}

// 随机生成1个昵称
func (s *LogicServer) GenerateNickName(ctx context.Context, in *cim.GenerateNickNameReq) (*cim.GenerateNickNameRsp, error) {
	// 名
	firstCount := dao.DefaultNickGenerate.FirstNameCountV1.Load().(int)
	// 姓
	lastCount := dao.DefaultNickGenerate.LastNameCountV1.Load().(int)

	if firstCount == 0 || lastCount == 0 {
		err, count := dao.DefaultNickGenerate.QueryLastNameCount(kGenerateVersion)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return nil, err
		} else {
			dao.DefaultNickGenerate.LastNameCountV1.Store(count)
			lastCount = count
		}

		err, count = dao.DefaultNickGenerate.QueryFirstNameCount(kGenerateVersion)
		if err != nil {
			logger.Sugar.Warn(err.Error())
			return nil, err
		} else {
			dao.DefaultNickGenerate.FirstNameCountV1.Store(count)
			firstCount = count
		}

		logger.Sugar.Infof("load %d lastName, %d firstName",
			dao.DefaultNickGenerate.LastNameCountV1.Load(),
			dao.DefaultNickGenerate.FirstNameCountV1.Load())
	}

	// FIXME: 算法不严谨，依赖数据库自增ID，请注意
	lastId := rand.Int() % lastCount // 先姓氏，再姓名，直接ID偏移
	firstId := lastCount + (rand.Int() % firstCount)

	err, info1 := dao.DefaultNickGenerate.Get(firstId)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return nil, err
	}

	err, info2 := dao.DefaultNickGenerate.Get(lastId)
	if err != nil {
		logger.Sugar.Warn(err.Error())
		return nil, err
	}

	rsp := &cim.GenerateNickNameRsp{}
	rsp.FirstName = info1.GenValue
	rsp.LastName = info2.GenValue
	rsp.Version = kGenerateVersion

	logger.Sugar.Infof("GenerateNickName firstName=%s,lastName=%s", rsp.FirstName, rsp.LastName)
	return rsp, nil
}
