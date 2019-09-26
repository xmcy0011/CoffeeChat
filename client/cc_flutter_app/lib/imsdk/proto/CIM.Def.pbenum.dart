///
//  Generated code. Do not modify.
//  source: CIM.Def.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class CIMCmdID extends $pb.ProtobufEnum {
  static const CIMCmdID kCIM_CID_UNKNOWN = CIMCmdID._(0, 'kCIM_CID_UNKNOWN');
  static const CIMCmdID kCIM_CID_LOGIN_AUTH_TOKEN_REQ = CIMCmdID._(257, 'kCIM_CID_LOGIN_AUTH_TOKEN_REQ');
  static const CIMCmdID kCIM_CID_LOGIN_AUTH_TOKEN_RSP = CIMCmdID._(258, 'kCIM_CID_LOGIN_AUTH_TOKEN_RSP');
  static const CIMCmdID kCIM_CID_LOGIN_AUTH_LOGOUT_REQ = CIMCmdID._(259, 'kCIM_CID_LOGIN_AUTH_LOGOUT_REQ');
  static const CIMCmdID kCIM_CID_LOGIN_AUTH_LOGOUT_RSP = CIMCmdID._(260, 'kCIM_CID_LOGIN_AUTH_LOGOUT_RSP');
  static const CIMCmdID kCIM_CID_LOGIN_HEARTBEAT = CIMCmdID._(261, 'kCIM_CID_LOGIN_HEARTBEAT');
  static const CIMCmdID kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ = CIMCmdID._(513, 'kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ');
  static const CIMCmdID kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP = CIMCmdID._(514, 'kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP');
  static const CIMCmdID kCIM_CID_LIST_MSG_REQ = CIMCmdID._(517, 'kCIM_CID_LIST_MSG_REQ');
  static const CIMCmdID kCIM_CID_LIST_MSG_RSP = CIMCmdID._(518, 'kCIM_CID_LIST_MSG_RSP');
  static const CIMCmdID kCIM_CID_MSG_DATA = CIMCmdID._(769, 'kCIM_CID_MSG_DATA');
  static const CIMCmdID kCIM_CID_MSG_DATA_ACK = CIMCmdID._(770, 'kCIM_CID_MSG_DATA_ACK');
  static const CIMCmdID kCIM_CID_MSG_READ_ACK = CIMCmdID._(771, 'kCIM_CID_MSG_READ_ACK');
  static const CIMCmdID kCIM_CID_MSG_READ_NOTIFY = CIMCmdID._(772, 'kCIM_CID_MSG_READ_NOTIFY');
  static const CIMCmdID kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ = CIMCmdID._(773, 'kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ');
  static const CIMCmdID kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP = CIMCmdID._(774, 'kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP');
  static const CIMCmdID kCIM_CID_MSG_GET_BY_MSG_ID_REQ = CIMCmdID._(775, 'kCIM_CID_MSG_GET_BY_MSG_ID_REQ');
  static const CIMCmdID kCIM_CID_MSG_GET_BY_MSG_ID_RSP = CIMCmdID._(776, 'kCIM_CID_MSG_GET_BY_MSG_ID_RSP');

  static const $core.List<CIMCmdID> values = <CIMCmdID> [
    kCIM_CID_UNKNOWN,
    kCIM_CID_LOGIN_AUTH_TOKEN_REQ,
    kCIM_CID_LOGIN_AUTH_TOKEN_RSP,
    kCIM_CID_LOGIN_AUTH_LOGOUT_REQ,
    kCIM_CID_LOGIN_AUTH_LOGOUT_RSP,
    kCIM_CID_LOGIN_HEARTBEAT,
    kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ,
    kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP,
    kCIM_CID_LIST_MSG_REQ,
    kCIM_CID_LIST_MSG_RSP,
    kCIM_CID_MSG_DATA,
    kCIM_CID_MSG_DATA_ACK,
    kCIM_CID_MSG_READ_ACK,
    kCIM_CID_MSG_READ_NOTIFY,
    kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ,
    kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP,
    kCIM_CID_MSG_GET_BY_MSG_ID_REQ,
    kCIM_CID_MSG_GET_BY_MSG_ID_RSP,
  ];

  static final $core.Map<$core.int, CIMCmdID> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMCmdID valueOf($core.int value) => _byValue[value];

  const CIMCmdID._($core.int v, $core.String n) : super(v, n);
}

class CIMIntenralCmdID extends $pb.ProtobufEnum {
  static const CIMIntenralCmdID kCIM_SID_UNKNOWN = CIMIntenralCmdID._(0, 'kCIM_SID_UNKNOWN');
  static const CIMIntenralCmdID kCIM_SID_DB_VALIDATE_REQ = CIMIntenralCmdID._(1793, 'kCIM_SID_DB_VALIDATE_REQ');
  static const CIMIntenralCmdID kCIM_SID_DB_VALIDATE_RSP = CIMIntenralCmdID._(1794, 'kCIM_SID_DB_VALIDATE_RSP');

  static const $core.List<CIMIntenralCmdID> values = <CIMIntenralCmdID> [
    kCIM_SID_UNKNOWN,
    kCIM_SID_DB_VALIDATE_REQ,
    kCIM_SID_DB_VALIDATE_RSP,
  ];

  static final $core.Map<$core.int, CIMIntenralCmdID> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMIntenralCmdID valueOf($core.int value) => _byValue[value];

  const CIMIntenralCmdID._($core.int v, $core.String n) : super(v, n);
}

class CIMErrorCode extends $pb.ProtobufEnum {
  static const CIMErrorCode kCIM_ERR_SUCCSSE = CIMErrorCode._(0, 'kCIM_ERR_SUCCSSE');
  static const CIMErrorCode kCIM_ERR_INTERNAL_ERROR = CIMErrorCode._(1, 'kCIM_ERR_INTERNAL_ERROR');
  static const CIMErrorCode kCIM_ERR_LOGIN_DB_VALIDATE_FAILED = CIMErrorCode._(200, 'kCIM_ERR_LOGIN_DB_VALIDATE_FAILED');
  static const CIMErrorCode kCIM_ERR_LOGIN_VERSION_TOO_OLD = CIMErrorCode._(201, 'kCIM_ERR_LOGIN_VERSION_TOO_OLD');
  static const CIMErrorCode kCIM_ERR_LOGIN_INVALID_USER_TOKEN = CIMErrorCode._(202, 'kCIM_ERR_LOGIN_INVALID_USER_TOKEN');

  static const $core.List<CIMErrorCode> values = <CIMErrorCode> [
    kCIM_ERR_SUCCSSE,
    kCIM_ERR_INTERNAL_ERROR,
    kCIM_ERR_LOGIN_DB_VALIDATE_FAILED,
    kCIM_ERR_LOGIN_VERSION_TOO_OLD,
    kCIM_ERR_LOGIN_INVALID_USER_TOKEN,
  ];

  static final $core.Map<$core.int, CIMErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMErrorCode valueOf($core.int value) => _byValue[value];

  const CIMErrorCode._($core.int v, $core.String n) : super(v, n);
}

class CIMClientType extends $pb.ProtobufEnum {
  static const CIMClientType kCIM_CLIENT_TYPE_DEFAULT = CIMClientType._(0, 'kCIM_CLIENT_TYPE_DEFAULT');
  static const CIMClientType kCIM_CLIENT_TYPE_ANDROID = CIMClientType._(1, 'kCIM_CLIENT_TYPE_ANDROID');
  static const CIMClientType kCIM_CLIENT_TYPE_IOS = CIMClientType._(2, 'kCIM_CLIENT_TYPE_IOS');
  static const CIMClientType kCIM_CLIENT_TYPE_WEB = CIMClientType._(3, 'kCIM_CLIENT_TYPE_WEB');

  static const $core.List<CIMClientType> values = <CIMClientType> [
    kCIM_CLIENT_TYPE_DEFAULT,
    kCIM_CLIENT_TYPE_ANDROID,
    kCIM_CLIENT_TYPE_IOS,
    kCIM_CLIENT_TYPE_WEB,
  ];

  static final $core.Map<$core.int, CIMClientType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMClientType valueOf($core.int value) => _byValue[value];

  const CIMClientType._($core.int v, $core.String n) : super(v, n);
}

class CIMSessionType extends $pb.ProtobufEnum {
  static const CIMSessionType kCIM_SESSION_TYPE_Invalid = CIMSessionType._(0, 'kCIM_SESSION_TYPE_Invalid');
  static const CIMSessionType kCIM_SESSION_TYPE_SINGLE = CIMSessionType._(1, 'kCIM_SESSION_TYPE_SINGLE');
  static const CIMSessionType kCIM_SESSION_TYPE_GROUP = CIMSessionType._(2, 'kCIM_SESSION_TYPE_GROUP');

  static const $core.List<CIMSessionType> values = <CIMSessionType> [
    kCIM_SESSION_TYPE_Invalid,
    kCIM_SESSION_TYPE_SINGLE,
    kCIM_SESSION_TYPE_GROUP,
  ];

  static final $core.Map<$core.int, CIMSessionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMSessionType valueOf($core.int value) => _byValue[value];

  const CIMSessionType._($core.int v, $core.String n) : super(v, n);
}

class CIMMsgType extends $pb.ProtobufEnum {
  static const CIMMsgType kCIM_MSG_TYPE_UNKNOWN = CIMMsgType._(0, 'kCIM_MSG_TYPE_UNKNOWN');
  static const CIMMsgType kCIM_MSG_TYPE_TEXT = CIMMsgType._(1, 'kCIM_MSG_TYPE_TEXT');
  static const CIMMsgType kCIM_MSG_TYPE_IMAGE = CIMMsgType._(2, 'kCIM_MSG_TYPE_IMAGE');
  static const CIMMsgType kCIM_MSG_TYPE_Audio = CIMMsgType._(3, 'kCIM_MSG_TYPE_Audio');
  static const CIMMsgType kCIM_MSG_TYPE_TIPS = CIMMsgType._(8, 'kCIM_MSG_TYPE_TIPS');
  static const CIMMsgType kCIM_MSG_TYPE_Robot = CIMMsgType._(9, 'kCIM_MSG_TYPE_Robot');

  static const $core.List<CIMMsgType> values = <CIMMsgType> [
    kCIM_MSG_TYPE_UNKNOWN,
    kCIM_MSG_TYPE_TEXT,
    kCIM_MSG_TYPE_IMAGE,
    kCIM_MSG_TYPE_Audio,
    kCIM_MSG_TYPE_TIPS,
    kCIM_MSG_TYPE_Robot,
  ];

  static final $core.Map<$core.int, CIMMsgType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMMsgType valueOf($core.int value) => _byValue[value];

  const CIMMsgType._($core.int v, $core.String n) : super(v, n);
}

class CIMMsgStatus extends $pb.ProtobufEnum {
  static const CIMMsgStatus kCIM_MSG_STATUS_NONE = CIMMsgStatus._(0, 'kCIM_MSG_STATUS_NONE');
  static const CIMMsgStatus kCIM_MSG_STATUS_UNREAD = CIMMsgStatus._(1, 'kCIM_MSG_STATUS_UNREAD');
  static const CIMMsgStatus kCIM_MSG_STATUS_READ = CIMMsgStatus._(2, 'kCIM_MSG_STATUS_READ');
  static const CIMMsgStatus kCIM_MSG_STATUS_DELETED = CIMMsgStatus._(3, 'kCIM_MSG_STATUS_DELETED');
  static const CIMMsgStatus kCIM_MSG_STATUS_SENDING = CIMMsgStatus._(4, 'kCIM_MSG_STATUS_SENDING');
  static const CIMMsgStatus kCIM_MSG_STATUS_SENT = CIMMsgStatus._(5, 'kCIM_MSG_STATUS_SENT');
  static const CIMMsgStatus kCIM_MSG_STATUS_RECEIPT = CIMMsgStatus._(6, 'kCIM_MSG_STATUS_RECEIPT');
  static const CIMMsgStatus kCIM_MSG_STATUS_DRAFT = CIMMsgStatus._(7, 'kCIM_MSG_STATUS_DRAFT');
  static const CIMMsgStatus kCIM_MSG_STATUS_SendCacel = CIMMsgStatus._(8, 'kCIM_MSG_STATUS_SendCacel');
  static const CIMMsgStatus kCIM_MSG_STATUS_REFUSED = CIMMsgStatus._(9, 'kCIM_MSG_STATUS_REFUSED');
  static const CIMMsgStatus kCIM_MSG_STATUS_FAILED = CIMMsgStatus._(10, 'kCIM_MSG_STATUS_FAILED');

  static const $core.List<CIMMsgStatus> values = <CIMMsgStatus> [
    kCIM_MSG_STATUS_NONE,
    kCIM_MSG_STATUS_UNREAD,
    kCIM_MSG_STATUS_READ,
    kCIM_MSG_STATUS_DELETED,
    kCIM_MSG_STATUS_SENDING,
    kCIM_MSG_STATUS_SENT,
    kCIM_MSG_STATUS_RECEIPT,
    kCIM_MSG_STATUS_DRAFT,
    kCIM_MSG_STATUS_SendCacel,
    kCIM_MSG_STATUS_REFUSED,
    kCIM_MSG_STATUS_FAILED,
  ];

  static final $core.Map<$core.int, CIMMsgStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMMsgStatus valueOf($core.int value) => _byValue[value];

  const CIMMsgStatus._($core.int v, $core.String n) : super(v, n);
}

class CIMSessionStatusType extends $pb.ProtobufEnum {
  static const CIMSessionStatusType kCIM_SESSION_STATUS_OK = CIMSessionStatusType._(0, 'kCIM_SESSION_STATUS_OK');

  static const $core.List<CIMSessionStatusType> values = <CIMSessionStatusType> [
    kCIM_SESSION_STATUS_OK,
  ];

  static final $core.Map<$core.int, CIMSessionStatusType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMSessionStatusType valueOf($core.int value) => _byValue[value];

  const CIMSessionStatusType._($core.int v, $core.String n) : super(v, n);
}

class CIMMsgFeature extends $pb.ProtobufEnum {
  static const CIMMsgFeature kCIM_MSG_FEATURE_DEFAULT = CIMMsgFeature._(0, 'kCIM_MSG_FEATURE_DEFAULT');
  static const CIMMsgFeature kCIM_MSG_FEATURE_ROAM_MSG = CIMMsgFeature._(2, 'kCIM_MSG_FEATURE_ROAM_MSG');

  static const $core.List<CIMMsgFeature> values = <CIMMsgFeature> [
    kCIM_MSG_FEATURE_DEFAULT,
    kCIM_MSG_FEATURE_ROAM_MSG,
  ];

  static final $core.Map<$core.int, CIMMsgFeature> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMMsgFeature valueOf($core.int value) => _byValue[value];

  const CIMMsgFeature._($core.int v, $core.String n) : super(v, n);
}

class CIMResCode extends $pb.ProtobufEnum {
  static const CIMResCode kCIM_RES_CODE_OK = CIMResCode._(0, 'kCIM_RES_CODE_OK');

  static const $core.List<CIMResCode> values = <CIMResCode> [
    kCIM_RES_CODE_OK,
  ];

  static final $core.Map<$core.int, CIMResCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMResCode valueOf($core.int value) => _byValue[value];

  const CIMResCode._($core.int v, $core.String n) : super(v, n);
}

