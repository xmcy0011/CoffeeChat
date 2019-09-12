// Code generated by protoc-gen-go. DO NOT EDIT.
// source: CIM.Def.proto

package grpc

import (
	fmt "fmt"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

// 外部消息：客户端 <-> 服务器消息定义
type CIMCmdID int32

const (
	CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_REQ            CIMCmdID = 257
	CIMCmdID_kCIM_CID_LOGIN_AUTH_TOKEN_RSP            CIMCmdID = 258
	CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_REQ           CIMCmdID = 259
	CIMCmdID_kCIM_CID_LOGIN_AUTH_LOGOUT_RSP           CIMCmdID = 260
	CIMCmdID_kCIM_CID_LOGIN_HEARTBEAT                 CIMCmdID = 261
	CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ CIMCmdID = 513
	CIMCmdID_kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP CIMCmdID = 514
	// kCIM_CID_LIST_UNREAD_CNT_REQ = 0x0203; // 未读消息计数列表请求
	// kCIM_CID_LIST_UNREAD_CNT_RSP = 0x0204;
	CIMCmdID_kCIM_CID_LIST_MSG_REQ              CIMCmdID = 517
	CIMCmdID_kCIM_CID_LIST_MSG_RSP              CIMCmdID = 518
	CIMCmdID_kCIM_CID_MSG_DATA                  CIMCmdID = 769
	CIMCmdID_kCIM_CID_MSG_DATA_ACK              CIMCmdID = 770
	CIMCmdID_kCIM_CID_MSG_READ_ACK              CIMCmdID = 771
	CIMCmdID_kCIM_CID_MSG_READ_NOTIFY           CIMCmdID = 772
	CIMCmdID_kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ CIMCmdID = 773
	CIMCmdID_kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP CIMCmdID = 774
	CIMCmdID_kCIM_CID_MSG_GET_BY_MSG_ID_REQ     CIMCmdID = 775
	CIMCmdID_kCIM_CID_MSG_GET_BY_MSG_ID_RSP     CIMCmdID = 776
)

var CIMCmdID_name = map[int32]string{
	257: "kCIM_CID_LOGIN_AUTH_TOKEN_REQ",
	258: "kCIM_CID_LOGIN_AUTH_TOKEN_RSP",
	259: "kCIM_CID_LOGIN_AUTH_LOGOUT_REQ",
	260: "kCIM_CID_LOGIN_AUTH_LOGOUT_RSP",
	261: "kCIM_CID_LOGIN_HEARTBEAT",
	513: "kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ",
	514: "kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP",
	517: "kCIM_CID_LIST_MSG_REQ",
	518: "kCIM_CID_LIST_MSG_RSP",
	769: "kCIM_CID_MSG_DATA",
	770: "kCIM_CID_MSG_DATA_ACK",
	771: "kCIM_CID_MSG_READ_ACK",
	772: "kCIM_CID_MSG_READ_NOTIFY",
	773: "kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ",
	774: "kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP",
	775: "kCIM_CID_MSG_GET_BY_MSG_ID_REQ",
	776: "kCIM_CID_MSG_GET_BY_MSG_ID_RSP",
}

var CIMCmdID_value = map[string]int32{
	"kCIM_CID_LOGIN_AUTH_TOKEN_REQ":            257,
	"kCIM_CID_LOGIN_AUTH_TOKEN_RSP":            258,
	"kCIM_CID_LOGIN_AUTH_LOGOUT_REQ":           259,
	"kCIM_CID_LOGIN_AUTH_LOGOUT_RSP":           260,
	"kCIM_CID_LOGIN_HEARTBEAT":                 261,
	"kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ": 513,
	"kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP": 514,
	"kCIM_CID_LIST_MSG_REQ":                    517,
	"kCIM_CID_LIST_MSG_RSP":                    518,
	"kCIM_CID_MSG_DATA":                        769,
	"kCIM_CID_MSG_DATA_ACK":                    770,
	"kCIM_CID_MSG_READ_ACK":                    771,
	"kCIM_CID_MSG_READ_NOTIFY":                 772,
	"kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ":       773,
	"kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP":       774,
	"kCIM_CID_MSG_GET_BY_MSG_ID_REQ":           775,
	"kCIM_CID_MSG_GET_BY_MSG_ID_RSP":           776,
}

func (x CIMCmdID) Enum() *CIMCmdID {
	p := new(CIMCmdID)
	*p = x
	return p
}

func (x CIMCmdID) String() string {
	return proto.EnumName(CIMCmdID_name, int32(x))
}

func (x *CIMCmdID) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMCmdID_value, data, "CIMCmdID")
	if err != nil {
		return err
	}
	*x = CIMCmdID(value)
	return nil
}

func (CIMCmdID) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{0}
}

// 内部消息：服务器 <-> 服务器消息定义
type CIMIntenralCmdID int32

const (
	CIMIntenralCmdID_kCIM_SID_DB_VALIDATE_REQ CIMIntenralCmdID = 1793
	CIMIntenralCmdID_kCIM_SID_DB_VALIDATE_RSP CIMIntenralCmdID = 1794
)

var CIMIntenralCmdID_name = map[int32]string{
	1793: "kCIM_SID_DB_VALIDATE_REQ",
	1794: "kCIM_SID_DB_VALIDATE_RSP",
}

var CIMIntenralCmdID_value = map[string]int32{
	"kCIM_SID_DB_VALIDATE_REQ": 1793,
	"kCIM_SID_DB_VALIDATE_RSP": 1794,
}

func (x CIMIntenralCmdID) Enum() *CIMIntenralCmdID {
	p := new(CIMIntenralCmdID)
	*p = x
	return p
}

func (x CIMIntenralCmdID) String() string {
	return proto.EnumName(CIMIntenralCmdID_name, int32(x))
}

func (x *CIMIntenralCmdID) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMIntenralCmdID_value, data, "CIMIntenralCmdID")
	if err != nil {
		return err
	}
	*x = CIMIntenralCmdID(value)
	return nil
}

func (CIMIntenralCmdID) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{1}
}

type CIMErrorCode int32

const (
	// 通用错误码
	CIMErrorCode_kCIM_ERR_SUCCSSE CIMErrorCode = 0
	// 账号错误码
	CIMErrorCode_kCIM_ERR_LOGIN_DB_VALIDATE_FAILED CIMErrorCode = 1
	CIMErrorCode_kCIM_ERR_LOGIN_VERSION_TOO_OLD    CIMErrorCode = 2
	CIMErrorCode_kCIM_ERR_LOGIN_INVALID_USER_TOKEN CIMErrorCode = 3
)

var CIMErrorCode_name = map[int32]string{
	0: "kCIM_ERR_SUCCSSE",
	1: "kCIM_ERR_LOGIN_DB_VALIDATE_FAILED",
	2: "kCIM_ERR_LOGIN_VERSION_TOO_OLD",
	3: "kCIM_ERR_LOGIN_INVALID_USER_TOKEN",
}

var CIMErrorCode_value = map[string]int32{
	"kCIM_ERR_SUCCSSE":                  0,
	"kCIM_ERR_LOGIN_DB_VALIDATE_FAILED": 1,
	"kCIM_ERR_LOGIN_VERSION_TOO_OLD":    2,
	"kCIM_ERR_LOGIN_INVALID_USER_TOKEN": 3,
}

func (x CIMErrorCode) Enum() *CIMErrorCode {
	p := new(CIMErrorCode)
	*p = x
	return p
}

func (x CIMErrorCode) String() string {
	return proto.EnumName(CIMErrorCode_name, int32(x))
}

func (x *CIMErrorCode) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMErrorCode_value, data, "CIMErrorCode")
	if err != nil {
		return err
	}
	*x = CIMErrorCode(value)
	return nil
}

func (CIMErrorCode) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{2}
}

// 客户端类型
type CIMClientType int32

const (
	CIMClientType_kCIM_CLIENT_TYPE_DEFAULT CIMClientType = 0
	CIMClientType_kCIM_CLIENT_TYPE_ANDROID CIMClientType = 1
	CIMClientType_kCIM_CLIENT_TYPE_IOS     CIMClientType = 2
	CIMClientType_kCIM_CLIENT_TYPE_WEB     CIMClientType = 3
)

var CIMClientType_name = map[int32]string{
	0: "kCIM_CLIENT_TYPE_DEFAULT",
	1: "kCIM_CLIENT_TYPE_ANDROID",
	2: "kCIM_CLIENT_TYPE_IOS",
	3: "kCIM_CLIENT_TYPE_WEB",
}

var CIMClientType_value = map[string]int32{
	"kCIM_CLIENT_TYPE_DEFAULT": 0,
	"kCIM_CLIENT_TYPE_ANDROID": 1,
	"kCIM_CLIENT_TYPE_IOS":     2,
	"kCIM_CLIENT_TYPE_WEB":     3,
}

func (x CIMClientType) Enum() *CIMClientType {
	p := new(CIMClientType)
	*p = x
	return p
}

func (x CIMClientType) String() string {
	return proto.EnumName(CIMClientType_name, int32(x))
}

func (x *CIMClientType) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMClientType_value, data, "CIMClientType")
	if err != nil {
		return err
	}
	*x = CIMClientType(value)
	return nil
}

func (CIMClientType) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{3}
}

// 会话类型
type CIMSessionType int32

const (
	// kCIM_SESSION_TYPE_Invalid = 0;   // 无效会话
	CIMSessionType_kCIM_SESSION_TYPE_SINGLE CIMSessionType = 1
	CIMSessionType_kCIM_SESSION_TYPE_GROUP  CIMSessionType = 2
)

var CIMSessionType_name = map[int32]string{
	1: "kCIM_SESSION_TYPE_SINGLE",
	2: "kCIM_SESSION_TYPE_GROUP",
}

var CIMSessionType_value = map[string]int32{
	"kCIM_SESSION_TYPE_SINGLE": 1,
	"kCIM_SESSION_TYPE_GROUP":  2,
}

func (x CIMSessionType) Enum() *CIMSessionType {
	p := new(CIMSessionType)
	*p = x
	return p
}

func (x CIMSessionType) String() string {
	return proto.EnumName(CIMSessionType_name, int32(x))
}

func (x *CIMSessionType) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMSessionType_value, data, "CIMSessionType")
	if err != nil {
		return err
	}
	*x = CIMSessionType(value)
	return nil
}

func (CIMSessionType) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{4}
}

// 消息类型
type CIMMsgType int32

const (
	CIMMsgType_kCIM_MSG_TYPE_TEXT  CIMMsgType = 1
	CIMMsgType_kCIM_MSG_TYPE_IMAGE CIMMsgType = 2
	CIMMsgType_kCIM_MSG_TYPE_Audio CIMMsgType = 3
	// kCIM_MSG_TYPE_VIDEO = 4;        // 视频
	// kCIM_MSG_TYPE_LOCATION = 5;     // 位置
	// kCIM_MSG_TYPE_NOTIFACATION = 6; // 系统通知（包括入群出群通知等）
	// kCIM_MSG_TYPE_FILE = 7;         // 文件
	CIMMsgType_kCIM_MSG_TYPE_TIPS  CIMMsgType = 8
	CIMMsgType_kCIM_MSG_TYPE_Robot CIMMsgType = 9
)

var CIMMsgType_name = map[int32]string{
	1: "kCIM_MSG_TYPE_TEXT",
	2: "kCIM_MSG_TYPE_IMAGE",
	3: "kCIM_MSG_TYPE_Audio",
	8: "kCIM_MSG_TYPE_TIPS",
	9: "kCIM_MSG_TYPE_Robot",
}

var CIMMsgType_value = map[string]int32{
	"kCIM_MSG_TYPE_TEXT":  1,
	"kCIM_MSG_TYPE_IMAGE": 2,
	"kCIM_MSG_TYPE_Audio": 3,
	"kCIM_MSG_TYPE_TIPS":  8,
	"kCIM_MSG_TYPE_Robot": 9,
}

func (x CIMMsgType) Enum() *CIMMsgType {
	p := new(CIMMsgType)
	*p = x
	return p
}

func (x CIMMsgType) String() string {
	return proto.EnumName(CIMMsgType_name, int32(x))
}

func (x *CIMMsgType) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMMsgType_value, data, "CIMMsgType")
	if err != nil {
		return err
	}
	*x = CIMMsgType(value)
	return nil
}

func (CIMMsgType) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{5}
}

// 消息状态
type CIMMessageStatus int32

const (
	CIMMessageStatus_kCIM_MESSAGE_STATUS_NONE    CIMMessageStatus = 0
	CIMMessageStatus_kCIM_MESSAGE_STATUS_UNREAD  CIMMessageStatus = 1
	CIMMessageStatus_kCIM_MESSAGE_STATUS_READ    CIMMessageStatus = 2
	CIMMessageStatus_kCIM_MESSAGE_STATUS_DELETED CIMMessageStatus = 3
	// kCIM_MESSAGE_STATUS_SENDING = 4;   // 发送中
	CIMMessageStatus_kCIM_MESSAGE_STATUS_SENT CIMMessageStatus = 5
)

var CIMMessageStatus_name = map[int32]string{
	0: "kCIM_MESSAGE_STATUS_NONE",
	1: "kCIM_MESSAGE_STATUS_UNREAD",
	2: "kCIM_MESSAGE_STATUS_READ",
	3: "kCIM_MESSAGE_STATUS_DELETED",
	5: "kCIM_MESSAGE_STATUS_SENT",
}

var CIMMessageStatus_value = map[string]int32{
	"kCIM_MESSAGE_STATUS_NONE":    0,
	"kCIM_MESSAGE_STATUS_UNREAD":  1,
	"kCIM_MESSAGE_STATUS_READ":    2,
	"kCIM_MESSAGE_STATUS_DELETED": 3,
	"kCIM_MESSAGE_STATUS_SENT":    5,
}

func (x CIMMessageStatus) Enum() *CIMMessageStatus {
	p := new(CIMMessageStatus)
	*p = x
	return p
}

func (x CIMMessageStatus) String() string {
	return proto.EnumName(CIMMessageStatus_name, int32(x))
}

func (x *CIMMessageStatus) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMMessageStatus_value, data, "CIMMessageStatus")
	if err != nil {
		return err
	}
	*x = CIMMessageStatus(value)
	return nil
}

func (CIMMessageStatus) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{6}
}

// 会话状态
type CIMSessionStatusType int32

const (
	CIMSessionStatusType_kCIM_SESSION_STATUS_OK CIMSessionStatusType = 0
)

var CIMSessionStatusType_name = map[int32]string{
	0: "kCIM_SESSION_STATUS_OK",
}

var CIMSessionStatusType_value = map[string]int32{
	"kCIM_SESSION_STATUS_OK": 0,
}

func (x CIMSessionStatusType) Enum() *CIMSessionStatusType {
	p := new(CIMSessionStatusType)
	*p = x
	return p
}

func (x CIMSessionStatusType) String() string {
	return proto.EnumName(CIMSessionStatusType_name, int32(x))
}

func (x *CIMSessionStatusType) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMSessionStatusType_value, data, "CIMSessionStatusType")
	if err != nil {
		return err
	}
	*x = CIMSessionStatusType(value)
	return nil
}

func (CIMSessionStatusType) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{7}
}

// 消息属性
type CIMMessageFeature int32

const (
	CIMMessageFeature_kCIM_MESSAGE_FEATURE_DEFAULT CIMMessageFeature = 0
	// kCIM_MESSAGE_FEATURE_LEAVE_MSG = 1;      // 离线消息(和漫游消息有何区别)
	CIMMessageFeature_kCIM_MESSAGE_FEATURE_ROAM_MSG CIMMessageFeature = 2
)

var CIMMessageFeature_name = map[int32]string{
	0: "kCIM_MESSAGE_FEATURE_DEFAULT",
	2: "kCIM_MESSAGE_FEATURE_ROAM_MSG",
}

var CIMMessageFeature_value = map[string]int32{
	"kCIM_MESSAGE_FEATURE_DEFAULT":  0,
	"kCIM_MESSAGE_FEATURE_ROAM_MSG": 2,
}

func (x CIMMessageFeature) Enum() *CIMMessageFeature {
	p := new(CIMMessageFeature)
	*p = x
	return p
}

func (x CIMMessageFeature) String() string {
	return proto.EnumName(CIMMessageFeature_name, int32(x))
}

func (x *CIMMessageFeature) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMMessageFeature_value, data, "CIMMessageFeature")
	if err != nil {
		return err
	}
	*x = CIMMessageFeature(value)
	return nil
}

func (CIMMessageFeature) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{8}
}

// 消息错误码
type CIMResCode int32

const (
	CIMResCode_kCIM_RES_CODE_OK CIMResCode = 0
)

var CIMResCode_name = map[int32]string{
	0: "kCIM_RES_CODE_OK",
}

var CIMResCode_value = map[string]int32{
	"kCIM_RES_CODE_OK": 0,
}

func (x CIMResCode) Enum() *CIMResCode {
	p := new(CIMResCode)
	*p = x
	return p
}

func (x CIMResCode) String() string {
	return proto.EnumName(CIMResCode_name, int32(x))
}

func (x *CIMResCode) UnmarshalJSON(data []byte) error {
	value, err := proto.UnmarshalJSONEnum(CIMResCode_value, data, "CIMResCode")
	if err != nil {
		return err
	}
	*x = CIMResCode(value)
	return nil
}

func (CIMResCode) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{9}
}

// 用户信息
type CIMUserInfo struct {
	UserId               *uint64  `protobuf:"varint,1,req,name=user_id,json=userId" json:"user_id,omitempty"`
	NickName             *string  `protobuf:"bytes,2,req,name=nick_name,json=nickName" json:"nick_name,omitempty"`
	AttachInfo           *string  `protobuf:"bytes,11,opt,name=attach_info,json=attachInfo" json:"attach_info,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *CIMUserInfo) Reset()         { *m = CIMUserInfo{} }
func (m *CIMUserInfo) String() string { return proto.CompactTextString(m) }
func (*CIMUserInfo) ProtoMessage()    {}
func (*CIMUserInfo) Descriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{0}
}

func (m *CIMUserInfo) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_CIMUserInfo.Unmarshal(m, b)
}
func (m *CIMUserInfo) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_CIMUserInfo.Marshal(b, m, deterministic)
}
func (m *CIMUserInfo) XXX_Merge(src proto.Message) {
	xxx_messageInfo_CIMUserInfo.Merge(m, src)
}
func (m *CIMUserInfo) XXX_Size() int {
	return xxx_messageInfo_CIMUserInfo.Size(m)
}
func (m *CIMUserInfo) XXX_DiscardUnknown() {
	xxx_messageInfo_CIMUserInfo.DiscardUnknown(m)
}

var xxx_messageInfo_CIMUserInfo proto.InternalMessageInfo

func (m *CIMUserInfo) GetUserId() uint64 {
	if m != nil && m.UserId != nil {
		return *m.UserId
	}
	return 0
}

func (m *CIMUserInfo) GetNickName() string {
	if m != nil && m.NickName != nil {
		return *m.NickName
	}
	return ""
}

func (m *CIMUserInfo) GetAttachInfo() string {
	if m != nil && m.AttachInfo != nil {
		return *m.AttachInfo
	}
	return ""
}

// 会话信息
type CIMContactSessionInfo struct {
	SessionId            *uint64               `protobuf:"varint,1,req,name=session_id,json=sessionId" json:"session_id,omitempty"`
	SessionType          *CIMSessionType       `protobuf:"varint,2,req,name=session_type,json=sessionType,enum=CIM.Def.CIMSessionType" json:"session_type,omitempty"`
	SessionStatus        *CIMSessionStatusType `protobuf:"varint,3,req,name=session_status,json=sessionStatus,enum=CIM.Def.CIMSessionStatusType" json:"session_status,omitempty"`
	UnreadCnt            *uint32               `protobuf:"varint,4,req,name=unread_cnt,json=unreadCnt" json:"unread_cnt,omitempty"`
	UpdatedTime          *uint32               `protobuf:"varint,5,req,name=updated_time,json=updatedTime" json:"updated_time,omitempty"`
	MsgId                *string               `protobuf:"bytes,6,req,name=msg_id,json=msgId" json:"msg_id,omitempty"`
	MsgTimeStamp         *uint64               `protobuf:"varint,7,req,name=msg_time_stamp,json=msgTimeStamp" json:"msg_time_stamp,omitempty"`
	MsgData              []byte                `protobuf:"bytes,8,req,name=msg_data,json=msgData" json:"msg_data,omitempty"`
	MsgType              *CIMMsgType           `protobuf:"varint,9,req,name=msg_type,json=msgType,enum=CIM.Def.CIMMsgType" json:"msg_type,omitempty"`
	MsgFromUserId        *uint64               `protobuf:"varint,10,req,name=msg_from_user_id,json=msgFromUserId" json:"msg_from_user_id,omitempty"`
	MsgStatus            *CIMMessageStatus     `protobuf:"varint,11,req,name=msg_status,json=msgStatus,enum=CIM.Def.CIMMessageStatus" json:"msg_status,omitempty"`
	MsgAttach            *string               `protobuf:"bytes,12,opt,name=msg_attach,json=msgAttach" json:"msg_attach,omitempty"`
	ExtendData           *string               `protobuf:"bytes,13,opt,name=extend_data,json=extendData" json:"extend_data,omitempty"`
	IsRobotSession       *bool                 `protobuf:"varint,14,opt,name=is_robot_session,json=isRobotSession,def=0" json:"is_robot_session,omitempty"`
	XXX_NoUnkeyedLiteral struct{}              `json:"-"`
	XXX_unrecognized     []byte                `json:"-"`
	XXX_sizecache        int32                 `json:"-"`
}

func (m *CIMContactSessionInfo) Reset()         { *m = CIMContactSessionInfo{} }
func (m *CIMContactSessionInfo) String() string { return proto.CompactTextString(m) }
func (*CIMContactSessionInfo) ProtoMessage()    {}
func (*CIMContactSessionInfo) Descriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{1}
}

func (m *CIMContactSessionInfo) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_CIMContactSessionInfo.Unmarshal(m, b)
}
func (m *CIMContactSessionInfo) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_CIMContactSessionInfo.Marshal(b, m, deterministic)
}
func (m *CIMContactSessionInfo) XXX_Merge(src proto.Message) {
	xxx_messageInfo_CIMContactSessionInfo.Merge(m, src)
}
func (m *CIMContactSessionInfo) XXX_Size() int {
	return xxx_messageInfo_CIMContactSessionInfo.Size(m)
}
func (m *CIMContactSessionInfo) XXX_DiscardUnknown() {
	xxx_messageInfo_CIMContactSessionInfo.DiscardUnknown(m)
}

var xxx_messageInfo_CIMContactSessionInfo proto.InternalMessageInfo

const Default_CIMContactSessionInfo_IsRobotSession bool = false

func (m *CIMContactSessionInfo) GetSessionId() uint64 {
	if m != nil && m.SessionId != nil {
		return *m.SessionId
	}
	return 0
}

func (m *CIMContactSessionInfo) GetSessionType() CIMSessionType {
	if m != nil && m.SessionType != nil {
		return *m.SessionType
	}
	return CIMSessionType_kCIM_SESSION_TYPE_SINGLE
}

func (m *CIMContactSessionInfo) GetSessionStatus() CIMSessionStatusType {
	if m != nil && m.SessionStatus != nil {
		return *m.SessionStatus
	}
	return CIMSessionStatusType_kCIM_SESSION_STATUS_OK
}

func (m *CIMContactSessionInfo) GetUnreadCnt() uint32 {
	if m != nil && m.UnreadCnt != nil {
		return *m.UnreadCnt
	}
	return 0
}

func (m *CIMContactSessionInfo) GetUpdatedTime() uint32 {
	if m != nil && m.UpdatedTime != nil {
		return *m.UpdatedTime
	}
	return 0
}

func (m *CIMContactSessionInfo) GetMsgId() string {
	if m != nil && m.MsgId != nil {
		return *m.MsgId
	}
	return ""
}

func (m *CIMContactSessionInfo) GetMsgTimeStamp() uint64 {
	if m != nil && m.MsgTimeStamp != nil {
		return *m.MsgTimeStamp
	}
	return 0
}

func (m *CIMContactSessionInfo) GetMsgData() []byte {
	if m != nil {
		return m.MsgData
	}
	return nil
}

func (m *CIMContactSessionInfo) GetMsgType() CIMMsgType {
	if m != nil && m.MsgType != nil {
		return *m.MsgType
	}
	return CIMMsgType_kCIM_MSG_TYPE_TEXT
}

func (m *CIMContactSessionInfo) GetMsgFromUserId() uint64 {
	if m != nil && m.MsgFromUserId != nil {
		return *m.MsgFromUserId
	}
	return 0
}

func (m *CIMContactSessionInfo) GetMsgStatus() CIMMessageStatus {
	if m != nil && m.MsgStatus != nil {
		return *m.MsgStatus
	}
	return CIMMessageStatus_kCIM_MESSAGE_STATUS_NONE
}

func (m *CIMContactSessionInfo) GetMsgAttach() string {
	if m != nil && m.MsgAttach != nil {
		return *m.MsgAttach
	}
	return ""
}

func (m *CIMContactSessionInfo) GetExtendData() string {
	if m != nil && m.ExtendData != nil {
		return *m.ExtendData
	}
	return ""
}

func (m *CIMContactSessionInfo) GetIsRobotSession() bool {
	if m != nil && m.IsRobotSession != nil {
		return *m.IsRobotSession
	}
	return Default_CIMContactSessionInfo_IsRobotSession
}

// 消息信息
type CIMMsgInfo struct {
	ClientMsgId          *string            `protobuf:"bytes,1,req,name=client_msg_id,json=clientMsgId" json:"client_msg_id,omitempty"`
	ServerMsgId          *uint64            `protobuf:"varint,2,req,name=server_msg_id,json=serverMsgId" json:"server_msg_id,omitempty"`
	MsgResCode           *CIMResCode        `protobuf:"varint,3,req,name=msg_res_code,json=msgResCode,enum=CIM.Def.CIMResCode" json:"msg_res_code,omitempty"`
	MsgFeature           *CIMMessageFeature `protobuf:"varint,4,req,name=msg_feature,json=msgFeature,enum=CIM.Def.CIMMessageFeature" json:"msg_feature,omitempty"`
	SessionType          *CIMSessionType    `protobuf:"varint,5,req,name=session_type,json=sessionType,enum=CIM.Def.CIMSessionType" json:"session_type,omitempty"`
	FromUserId           *uint64            `protobuf:"varint,6,req,name=from_user_id,json=fromUserId" json:"from_user_id,omitempty"`
	ToSessionId          *uint64            `protobuf:"varint,7,req,name=to_session_id,json=toSessionId" json:"to_session_id,omitempty"`
	CreateTime           *uint64            `protobuf:"varint,8,req,name=create_time,json=createTime" json:"create_time,omitempty"`
	MsgType              *CIMMsgType        `protobuf:"varint,9,req,name=msg_type,json=msgType,enum=CIM.Def.CIMMsgType" json:"msg_type,omitempty"`
	MsgStatus            *CIMMessageStatus  `protobuf:"varint,10,req,name=msg_status,json=msgStatus,enum=CIM.Def.CIMMessageStatus" json:"msg_status,omitempty"`
	MsgData              []byte             `protobuf:"bytes,11,req,name=msg_data,json=msgData" json:"msg_data,omitempty"`
	Attach               *string            `protobuf:"bytes,12,opt,name=attach" json:"attach,omitempty"`
	SenderClientType     *CIMClientType     `protobuf:"varint,13,req,name=sender_client_type,json=senderClientType,enum=CIM.Def.CIMClientType" json:"sender_client_type,omitempty"`
	XXX_NoUnkeyedLiteral struct{}           `json:"-"`
	XXX_unrecognized     []byte             `json:"-"`
	XXX_sizecache        int32              `json:"-"`
}

func (m *CIMMsgInfo) Reset()         { *m = CIMMsgInfo{} }
func (m *CIMMsgInfo) String() string { return proto.CompactTextString(m) }
func (*CIMMsgInfo) ProtoMessage()    {}
func (*CIMMsgInfo) Descriptor() ([]byte, []int) {
	return fileDescriptor_59f2b4dd9a8c1a4e, []int{2}
}

func (m *CIMMsgInfo) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_CIMMsgInfo.Unmarshal(m, b)
}
func (m *CIMMsgInfo) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_CIMMsgInfo.Marshal(b, m, deterministic)
}
func (m *CIMMsgInfo) XXX_Merge(src proto.Message) {
	xxx_messageInfo_CIMMsgInfo.Merge(m, src)
}
func (m *CIMMsgInfo) XXX_Size() int {
	return xxx_messageInfo_CIMMsgInfo.Size(m)
}
func (m *CIMMsgInfo) XXX_DiscardUnknown() {
	xxx_messageInfo_CIMMsgInfo.DiscardUnknown(m)
}

var xxx_messageInfo_CIMMsgInfo proto.InternalMessageInfo

func (m *CIMMsgInfo) GetClientMsgId() string {
	if m != nil && m.ClientMsgId != nil {
		return *m.ClientMsgId
	}
	return ""
}

func (m *CIMMsgInfo) GetServerMsgId() uint64 {
	if m != nil && m.ServerMsgId != nil {
		return *m.ServerMsgId
	}
	return 0
}

func (m *CIMMsgInfo) GetMsgResCode() CIMResCode {
	if m != nil && m.MsgResCode != nil {
		return *m.MsgResCode
	}
	return CIMResCode_kCIM_RES_CODE_OK
}

func (m *CIMMsgInfo) GetMsgFeature() CIMMessageFeature {
	if m != nil && m.MsgFeature != nil {
		return *m.MsgFeature
	}
	return CIMMessageFeature_kCIM_MESSAGE_FEATURE_DEFAULT
}

func (m *CIMMsgInfo) GetSessionType() CIMSessionType {
	if m != nil && m.SessionType != nil {
		return *m.SessionType
	}
	return CIMSessionType_kCIM_SESSION_TYPE_SINGLE
}

func (m *CIMMsgInfo) GetFromUserId() uint64 {
	if m != nil && m.FromUserId != nil {
		return *m.FromUserId
	}
	return 0
}

func (m *CIMMsgInfo) GetToSessionId() uint64 {
	if m != nil && m.ToSessionId != nil {
		return *m.ToSessionId
	}
	return 0
}

func (m *CIMMsgInfo) GetCreateTime() uint64 {
	if m != nil && m.CreateTime != nil {
		return *m.CreateTime
	}
	return 0
}

func (m *CIMMsgInfo) GetMsgType() CIMMsgType {
	if m != nil && m.MsgType != nil {
		return *m.MsgType
	}
	return CIMMsgType_kCIM_MSG_TYPE_TEXT
}

func (m *CIMMsgInfo) GetMsgStatus() CIMMessageStatus {
	if m != nil && m.MsgStatus != nil {
		return *m.MsgStatus
	}
	return CIMMessageStatus_kCIM_MESSAGE_STATUS_NONE
}

func (m *CIMMsgInfo) GetMsgData() []byte {
	if m != nil {
		return m.MsgData
	}
	return nil
}

func (m *CIMMsgInfo) GetAttach() string {
	if m != nil && m.Attach != nil {
		return *m.Attach
	}
	return ""
}

func (m *CIMMsgInfo) GetSenderClientType() CIMClientType {
	if m != nil && m.SenderClientType != nil {
		return *m.SenderClientType
	}
	return CIMClientType_kCIM_CLIENT_TYPE_DEFAULT
}

func init() {
	proto.RegisterEnum("CIM.Def.CIMCmdID", CIMCmdID_name, CIMCmdID_value)
	proto.RegisterEnum("CIM.Def.CIMIntenralCmdID", CIMIntenralCmdID_name, CIMIntenralCmdID_value)
	proto.RegisterEnum("CIM.Def.CIMErrorCode", CIMErrorCode_name, CIMErrorCode_value)
	proto.RegisterEnum("CIM.Def.CIMClientType", CIMClientType_name, CIMClientType_value)
	proto.RegisterEnum("CIM.Def.CIMSessionType", CIMSessionType_name, CIMSessionType_value)
	proto.RegisterEnum("CIM.Def.CIMMsgType", CIMMsgType_name, CIMMsgType_value)
	proto.RegisterEnum("CIM.Def.CIMMessageStatus", CIMMessageStatus_name, CIMMessageStatus_value)
	proto.RegisterEnum("CIM.Def.CIMSessionStatusType", CIMSessionStatusType_name, CIMSessionStatusType_value)
	proto.RegisterEnum("CIM.Def.CIMMessageFeature", CIMMessageFeature_name, CIMMessageFeature_value)
	proto.RegisterEnum("CIM.Def.CIMResCode", CIMResCode_name, CIMResCode_value)
	proto.RegisterType((*CIMUserInfo)(nil), "CIM.Def.CIMUserInfo")
	proto.RegisterType((*CIMContactSessionInfo)(nil), "CIM.Def.CIMContactSessionInfo")
	proto.RegisterType((*CIMMsgInfo)(nil), "CIM.Def.CIMMsgInfo")
}

func init() { proto.RegisterFile("CIM.Def.proto", fileDescriptor_59f2b4dd9a8c1a4e) }

var fileDescriptor_59f2b4dd9a8c1a4e = []byte{
	// 1259 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0x94, 0x56, 0xcd, 0x6e, 0xdb, 0xc6,
	0x16, 0x8e, 0x68, 0x59, 0x96, 0x8e, 0x7e, 0x30, 0x99, 0x24, 0xb6, 0xe2, 0xc4, 0x89, 0xac, 0x7b,
	0x2f, 0x22, 0x08, 0xb8, 0x2e, 0x10, 0xa0, 0x40, 0x91, 0xae, 0x68, 0x72, 0xac, 0x0c, 0x2c, 0x89,
	0x2a, 0x49, 0xa5, 0x49, 0x37, 0x03, 0x46, 0x1c, 0x29, 0x42, 0x42, 0xd2, 0x20, 0xa9, 0xa2, 0x59,
	0x15, 0xf9, 0x6b, 0xfa, 0x04, 0x7d, 0x8b, 0xbe, 0x4a, 0x97, 0x5d, 0xf5, 0x61, 0x8a, 0x99, 0xa1,
	0x2c, 0x31, 0x92, 0x91, 0x64, 0xc7, 0xf9, 0xbe, 0xef, 0x9c, 0x99, 0x73, 0xce, 0x37, 0x24, 0xa1,
	0x6e, 0xd0, 0xc1, 0x89, 0xc9, 0xa7, 0x27, 0x17, 0x71, 0x94, 0x46, 0x78, 0x2f, 0x5b, 0xb6, 0x7d,
	0xa8, 0x1a, 0x74, 0x30, 0x4e, 0x78, 0x4c, 0xc3, 0x69, 0x84, 0x0f, 0x60, 0x6f, 0x91, 0xf0, 0x98,
	0xcd, 0xfd, 0x66, 0xa1, 0xa5, 0x75, 0x8a, 0x76, 0x49, 0x2c, 0xa9, 0x8f, 0xef, 0x40, 0x25, 0x9c,
	0x4f, 0x5e, 0xb2, 0xd0, 0x0b, 0x78, 0x53, 0x6b, 0x69, 0x9d, 0x8a, 0x5d, 0x16, 0xc0, 0xd0, 0x0b,
	0x38, 0xbe, 0x0f, 0x55, 0x2f, 0x4d, 0xbd, 0xc9, 0x0b, 0x36, 0x0f, 0xa7, 0x51, 0xb3, 0xda, 0x2a,
	0x74, 0x2a, 0x36, 0x28, 0x48, 0xa4, 0x6d, 0xff, 0x5d, 0x84, 0x5b, 0x06, 0x1d, 0x18, 0x51, 0x98,
	0x7a, 0x93, 0xd4, 0xe1, 0x49, 0x32, 0x8f, 0x42, 0xb9, 0xe1, 0x11, 0x40, 0xa2, 0x96, 0xab, 0x3d,
	0x2b, 0x19, 0x42, 0x7d, 0xfc, 0x08, 0x6a, 0x4b, 0x3a, 0x7d, 0x7d, 0xa1, 0x76, 0x6e, 0x3c, 0x3c,
	0x38, 0x59, 0x56, 0x63, 0xd0, 0x41, 0x96, 0xcd, 0x7d, 0x7d, 0xc1, 0xed, 0x6a, 0xb2, 0x5a, 0x60,
	0x13, 0x1a, 0xcb, 0xd8, 0x24, 0xf5, 0xd2, 0x45, 0xd2, 0xdc, 0x91, 0xd1, 0x47, 0x5b, 0xa2, 0x1d,
	0x29, 0x90, 0x39, 0xea, 0xc9, 0x3a, 0x24, 0x0e, 0xb8, 0x08, 0x63, 0xee, 0xf9, 0x6c, 0x12, 0xa6,
	0xcd, 0x62, 0x4b, 0xeb, 0xd4, 0xed, 0x8a, 0x42, 0x8c, 0x30, 0xc5, 0xc7, 0x50, 0x5b, 0x5c, 0xf8,
	0x5e, 0xca, 0x7d, 0x96, 0xce, 0x03, 0xde, 0xdc, 0x95, 0x82, 0x6a, 0x86, 0xb9, 0xf3, 0x80, 0xe3,
	0x5b, 0x50, 0x0a, 0x92, 0x99, 0x28, 0xaf, 0x24, 0xfb, 0xb6, 0x1b, 0x24, 0x33, 0xea, 0xe3, 0xff,
	0x42, 0x43, 0xc0, 0x22, 0x4a, 0x9c, 0x2f, 0xb8, 0x68, 0xee, 0xc9, 0xea, 0x6b, 0x41, 0x32, 0x13,
	0x71, 0x8e, 0xc0, 0xf0, 0x6d, 0x28, 0x0b, 0x95, 0xef, 0xa5, 0x5e, 0xb3, 0xdc, 0xd2, 0x3a, 0x35,
	0x7b, 0x2f, 0x48, 0x66, 0xa6, 0x97, 0x7a, 0xf8, 0x44, 0x51, 0xb2, 0x2f, 0x15, 0x59, 0xd9, 0x8d,
	0xf5, 0xca, 0x06, 0xc9, 0x4c, 0xd6, 0x23, 0xf4, 0xb2, 0x1f, 0x0f, 0x00, 0x09, 0xfd, 0x34, 0x8e,
	0x02, 0xb6, 0x1c, 0x32, 0xc8, 0x2d, 0xeb, 0x41, 0x32, 0x3b, 0x8b, 0xa3, 0x60, 0xac, 0x66, 0xfd,
	0x1d, 0x80, 0x10, 0x66, 0x4d, 0xab, 0xca, 0xd4, 0xb7, 0x73, 0xa9, 0x79, 0x92, 0x78, 0x33, 0xae,
	0x3a, 0x64, 0x57, 0x82, 0x64, 0xb6, 0x6a, 0x96, 0x88, 0x54, 0x93, 0x6f, 0xd6, 0xa4, 0x0f, 0x04,
	0xad, 0x4b, 0x40, 0xf8, 0x84, 0xff, 0x92, 0xf2, 0xd0, 0x57, 0xf5, 0xd4, 0x95, 0x4f, 0x14, 0x24,
	0x4b, 0xfa, 0x06, 0xd0, 0x3c, 0x61, 0x71, 0xf4, 0x3c, 0x4a, 0x59, 0x36, 0x86, 0x66, 0xa3, 0x55,
	0xe8, 0x94, 0x1f, 0xed, 0x4e, 0xbd, 0x57, 0x09, 0xb7, 0x1b, 0xf3, 0xc4, 0x16, 0x6c, 0x36, 0xb6,
	0xf6, 0x5f, 0x45, 0x00, 0x55, 0xab, 0x74, 0x53, 0x1b, 0xea, 0x93, 0x57, 0x73, 0x1e, 0xa6, 0x2c,
	0xeb, 0x78, 0x41, 0x76, 0xbc, 0xaa, 0xc0, 0x81, 0xec, 0x7b, 0x1b, 0xea, 0x09, 0x8f, 0x7f, 0xe6,
	0xf1, 0x52, 0xa3, 0xc9, 0x1e, 0x54, 0x15, 0xa8, 0x34, 0xdf, 0x82, 0x98, 0x02, 0x8b, 0x79, 0xc2,
	0x26, 0x91, 0xcf, 0x33, 0xe3, 0xe4, 0xda, 0x6b, 0xf3, 0xc4, 0x88, 0x7c, 0x6e, 0x8b, 0x82, 0xb3,
	0x67, 0xfc, 0x3d, 0x54, 0x65, 0x87, 0xb9, 0x97, 0x2e, 0x62, 0x2e, 0xcd, 0xd2, 0x78, 0x78, 0xb8,
	0xa5, 0x73, 0x67, 0x4a, 0x21, 0x83, 0xb3, 0xe7, 0x0d, 0xab, 0xef, 0x7e, 0x85, 0xd5, 0x5b, 0x50,
	0xcb, 0x8d, 0xb5, 0x24, 0x4b, 0x82, 0xe9, 0x6a, 0xa6, 0x6d, 0xa8, 0xa7, 0x11, 0x5b, 0xbb, 0x6a,
	0xca, 0x6c, 0xd5, 0x34, 0x72, 0x2e, 0x2f, 0xdb, 0x7d, 0xa8, 0x4e, 0x62, 0xee, 0xa5, 0x5c, 0x59,
	0xb9, 0xac, 0x92, 0x28, 0x48, 0x3a, 0xf9, 0x6b, 0x1d, 0x97, 0x37, 0x12, 0x7c, 0x85, 0x91, 0xd6,
	0x6d, 0x5f, 0xcd, 0xdb, 0x7e, 0x1f, 0x4a, 0x39, 0x7f, 0x65, 0x2b, 0x6c, 0x02, 0x4e, 0x78, 0xe8,
	0xf3, 0x98, 0x65, 0x16, 0x90, 0xc7, 0xac, 0xcb, 0x4d, 0xf7, 0xd7, 0x37, 0x35, 0x24, 0x2d, 0x4f,
	0x8a, 0x54, 0xc4, 0x0a, 0xe9, 0xfe, 0x53, 0x84, 0xb2, 0xd0, 0x04, 0x3e, 0x35, 0x71, 0x1b, 0x8e,
	0x5e, 0x1a, 0x74, 0xc0, 0x0c, 0x6a, 0xb2, 0xbe, 0xd5, 0xa3, 0x43, 0xa6, 0x8f, 0xdd, 0xc7, 0xcc,
	0xb5, 0xce, 0xc9, 0x90, 0xd9, 0xe4, 0x07, 0xf4, 0x46, 0xfb, 0x8c, 0xc6, 0x19, 0xa1, 0xb7, 0x1a,
	0xfe, 0x0f, 0xdc, 0xdb, 0xa6, 0xe9, 0x5b, 0x3d, 0x6b, 0xec, 0xca, 0x44, 0xef, 0x3e, 0x2b, 0x72,
	0x46, 0xe8, 0xbd, 0x86, 0x8f, 0xa0, 0xf9, 0x89, 0xe8, 0x31, 0xd1, 0x6d, 0xf7, 0x94, 0xe8, 0x2e,
	0xfa, 0xa0, 0xe1, 0xff, 0x43, 0x67, 0x45, 0x53, 0x47, 0xe4, 0x36, 0xc8, 0xd0, 0x65, 0x86, 0x35,
	0x74, 0x75, 0xc3, 0x65, 0x0e, 0x71, 0x1c, 0x6a, 0x65, 0x67, 0x2f, 0x7e, 0xb9, 0x5c, 0x94, 0x51,
	0xc4, 0x87, 0x70, 0x2b, 0x2f, 0x1f, 0x38, 0x3d, 0x99, 0xea, 0xc3, 0x55, 0x9c, 0x33, 0x42, 0xbf,
	0x15, 0xf1, 0x3e, 0x5c, 0xbf, 0xe4, 0x04, 0x6c, 0xea, 0xae, 0x8e, 0xde, 0x94, 0x72, 0x31, 0x4b,
	0x9c, 0xe9, 0xc6, 0x39, 0x7a, 0xbb, 0xc9, 0xd9, 0x44, 0x37, 0x25, 0xf7, 0xae, 0x94, 0x6b, 0xc2,
	0x25, 0x37, 0xb4, 0x5c, 0x7a, 0xf6, 0x0c, 0xbd, 0x2f, 0xe1, 0x07, 0xd0, 0xce, 0xd1, 0x3d, 0xe2,
	0xb2, 0xbe, 0xee, 0x92, 0xec, 0x50, 0xd4, 0x54, 0x67, 0xfe, 0x22, 0xa1, 0x28, 0xa0, 0x94, 0x1b,
	0xcd, 0x52, 0x78, 0xfa, 0x6c, 0x3d, 0xdb, 0xc7, 0xcf, 0x8a, 0x9c, 0x11, 0xfa, 0xbd, 0xd4, 0x1d,
	0x01, 0x32, 0xe8, 0x80, 0x86, 0x29, 0x0f, 0x63, 0xef, 0x95, 0x72, 0xd9, 0xb2, 0x1c, 0x87, 0x9a,
	0xcc, 0x3c, 0x65, 0x4f, 0xf4, 0x3e, 0x35, 0x75, 0x97, 0xa8, 0x21, 0x35, 0xae, 0xa6, 0xc5, 0x50,
	0x1a, 0xdd, 0x3f, 0x0a, 0x50, 0x33, 0xe8, 0x80, 0xc4, 0x71, 0x14, 0xcb, 0x97, 0xd0, 0x4d, 0x40,
	0x52, 0x4f, 0x6c, 0x9b, 0x39, 0x63, 0xc3, 0x70, 0x1c, 0x82, 0xae, 0xe1, 0xff, 0xc1, 0xf1, 0x25,
	0xaa, 0x8c, 0xb3, 0x9e, 0xeb, 0x4c, 0xa7, 0x7d, 0x62, 0xa2, 0x02, 0x6e, 0x67, 0x45, 0xac, 0x64,
	0x4f, 0x88, 0x2d, 0x3d, 0xe0, 0x5a, 0x16, 0xb3, 0xfa, 0x26, 0xd2, 0xb6, 0xa4, 0xa2, 0x43, 0x99,
	0x89, 0x8d, 0x1d, 0x62, 0x2b, 0xe7, 0xa3, 0x9d, 0xee, 0xaf, 0xf2, 0x9f, 0x63, 0x75, 0xb5, 0xf0,
	0xdd, 0xe5, 0xd8, 0xfa, 0x54, 0x98, 0xcc, 0x7d, 0x36, 0x22, 0xcc, 0x24, 0x67, 0xfa, 0xb8, 0xef,
	0xa2, 0x6b, 0x5b, 0x59, 0x7d, 0x68, 0xda, 0x16, 0x15, 0xe7, 0x6a, 0xc2, 0xcd, 0x0d, 0x96, 0x5a,
	0x0e, 0xd2, 0xb6, 0x32, 0x3f, 0x92, 0x53, 0xb4, 0xd3, 0x3d, 0x87, 0x46, 0xfe, 0x9d, 0x79, 0xb9,
	0xc7, 0xd2, 0xd7, 0x52, 0xec, 0xd0, 0x61, 0xaf, 0x4f, 0x50, 0x01, 0xdf, 0x81, 0x83, 0x4d, 0xb6,
	0x67, 0x5b, 0xe3, 0x11, 0xd2, 0xba, 0x1f, 0x0b, 0xcb, 0x0f, 0x8d, 0xcc, 0xb4, 0x0f, 0x58, 0x6a,
	0xc5, 0x74, 0xa5, 0xce, 0x25, 0x4f, 0x5d, 0x54, 0xc0, 0x07, 0x70, 0x23, 0x8f, 0xd3, 0x81, 0xde,
	0x23, 0x48, 0xdb, 0x24, 0xf4, 0x85, 0x3f, 0x8f, 0xd0, 0xce, 0x96, 0x4c, 0x74, 0xe4, 0xa0, 0xf2,
	0x66, 0x80, 0xfc, 0xee, 0xa1, 0x4a, 0xf7, 0xcf, 0x82, 0xf4, 0x50, 0xee, 0xd5, 0x79, 0x59, 0xd9,
	0x80, 0x38, 0x8e, 0xde, 0x23, 0xcc, 0x71, 0x75, 0x77, 0xec, 0xb0, 0xa1, 0x35, 0x14, 0xc3, 0xbf,
	0x07, 0x87, 0xdb, 0xd8, 0xf1, 0x50, 0xdc, 0x1c, 0x54, 0xb8, 0x2a, 0x5a, 0xb2, 0x1a, 0xbe, 0x0f,
	0x77, 0xb6, 0xb1, 0x26, 0xe9, 0x13, 0x97, 0x98, 0x68, 0xe7, 0xaa, 0x70, 0x87, 0x0c, 0x5d, 0xb4,
	0xdb, 0x7d, 0x08, 0x37, 0xb7, 0xfd, 0x67, 0xe1, 0x43, 0xd8, 0xcf, 0xb5, 0x3b, 0x8b, 0xb2, 0xce,
	0xd1, 0xb5, 0xee, 0x53, 0xb8, 0xbe, 0xf1, 0xb1, 0xc4, 0x2d, 0xb8, 0x9b, 0xdb, 0xe6, 0x8c, 0xe8,
	0xee, 0xd8, 0x5e, 0xf7, 0xd0, 0x71, 0xf6, 0x2e, 0xfe, 0x54, 0x61, 0x5b, 0xba, 0x6c, 0x24, 0xd2,
	0xba, 0x6d, 0x39, 0xc6, 0xe5, 0x07, 0x7b, 0x79, 0x57, 0x6c, 0xe2, 0x30, 0xc3, 0x32, 0x89, 0xdc,
	0xfd, 0xf4, 0x18, 0x0e, 0x26, 0x51, 0x70, 0x32, 0x89, 0xa6, 0x53, 0xce, 0x27, 0x2f, 0xbc, 0x54,
	0xfd, 0x34, 0x3f, 0x5f, 0x4c, 0x1f, 0xef, 0xfc, 0x54, 0x9c, 0xc5, 0x17, 0x93, 0x7f, 0x03, 0x00,
	0x00, 0xff, 0xff, 0x81, 0x29, 0x3a, 0x4d, 0x4f, 0x0b, 0x00, 0x00,
}