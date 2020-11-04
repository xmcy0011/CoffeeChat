///
//  Generated code. Do not modify.
//  source: CIM.Def.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CIMCmdID$json = const {
  '1': 'CIMCmdID',
  '2': const [
    const {'1': 'kCIM_CID_UNKNOWN', '2': 0},
    const {'1': 'kCIM_CID_LOGIN_AUTH_TOKEN_REQ', '2': 257},
    const {'1': 'kCIM_CID_LOGIN_AUTH_TOKEN_RSP', '2': 258},
    const {'1': 'kCIM_CID_LOGIN_AUTH_LOGOUT_REQ', '2': 259},
    const {'1': 'kCIM_CID_LOGIN_AUTH_LOGOUT_RSP', '2': 260},
    const {'1': 'kCIM_CID_LOGIN_HEARTBEAT', '2': 261},
    const {'1': 'kCIM_CID_LIST_RECENT_CONTACT_SESSION_REQ', '2': 513},
    const {'1': 'kCIM_CID_LIST_RECENT_CONTACT_SESSION_RSP', '2': 514},
    const {'1': 'kCIM_CID_LIST_MSG_REQ', '2': 517},
    const {'1': 'kCIM_CID_LIST_MSG_RSP', '2': 518},
    const {'1': 'kCIM_CID_MSG_DATA', '2': 769},
    const {'1': 'kCIM_CID_MSG_DATA_ACK', '2': 770},
    const {'1': 'kCIM_CID_MSG_READ_ACK', '2': 771},
    const {'1': 'kCIM_CID_MSG_READ_NOTIFY', '2': 772},
    const {'1': 'kCIM_CID_MSG_GET_LATEST_MSG_ID_REQ', '2': 773},
    const {'1': 'kCIM_CID_MSG_GET_LATEST_MSG_ID_RSP', '2': 774},
    const {'1': 'kCIM_CID_MSG_GET_BY_MSG_ID_REQ', '2': 775},
    const {'1': 'kCIM_CID_MSG_GET_BY_MSG_ID_RSP', '2': 776},
    const {'1': 'kCIM_CID_VOIP_INVITE_REQ', '2': 1025},
    const {'1': 'kCIM_CID_VOIP_INVITE_REPLY', '2': 1026},
    const {'1': 'kCIM_CID_VOIP_INVITE_REPLY_ACK', '2': 1027},
    const {'1': 'kCIM_CID_VOIP_HEARTBEAT', '2': 1028},
    const {'1': 'kCIM_CID_VOIP_BYE_REQ', '2': 1029},
    const {'1': 'kCIM_CID_VOIP_BYE_RSP', '2': 1030},
    const {'1': 'kCIM_CID_VOIP_BYE_NOTIFY', '2': 1031},
    const {'1': 'kCIM_CID_GROUP_CREATE_DEFAULT_REQ', '2': 1281},
    const {'1': 'kCIM_CID_GROUP_CREATE_DEFAULT_RSP', '2': 1282},
    const {'1': 'kCIM_CID_GROUP_DISBINGDING_REQ', '2': 1283},
    const {'1': 'kCIM_CID_GROUP_DISBINGDING_RSP', '2': 1284},
    const {'1': 'kCIM_CID_GROUP_EXIT_REQ', '2': 1285},
    const {'1': 'kCIM_CID_GROUP_EXIT_RSP', '2': 1286},
    const {'1': 'kCIM_CID_GROUP_LIST_REQ', '2': 1287},
    const {'1': 'kCIM_CID_GROUP_LIST_RSP', '2': 1288},
    const {'1': 'kCIM_CID_GROUP_INFO_REQ', '2': 1289},
    const {'1': 'kCIM_CID_GROUP_INFO_RSP', '2': 1296},
    const {'1': 'kCIM_CID_GROUP_INVITE_MEMBER_REQ', '2': 1297},
    const {'1': 'kCIM_CID_GROUP_INVITE_MEMBER_RSP', '2': 1298},
    const {'1': 'kCIM_CID_GROUP_KICK_OUT_MEMBER_REQ', '2': 1299},
    const {'1': 'kCIM_CID_GROUP_KICK_OUT_MEMBER_RSP', '2': 1300},
    const {'1': 'kCIM_CID_GROUP_MEMBER_CHANGED_NOTIFY', '2': 1301},
    const {'1': 'kCIM_CID_GROUP_LIST_MEMBER_REQ', '2': 1302},
    const {'1': 'kCIM_CID_GROUP_LIST_MEMBER_RSP', '2': 1303},
    const {'1': 'kCIM_CID_FRIEND_QUERY_USER_LIST_REQ', '2': 1537},
    const {'1': 'kCIM_CID_FRIEND_QUERY_USER_LIST_RSP', '2': 1538},
  ],
};

const CIMIntenralCmdID$json = const {
  '1': 'CIMIntenralCmdID',
  '2': const [
    const {'1': 'kCIM_SID_UNKNOWN', '2': 0},
    const {'1': 'kCIM_SID_DB_VALIDATE_REQ', '2': 1793},
    const {'1': 'kCIM_SID_DB_VALIDATE_RSP', '2': 1794},
  ],
};

const CIMErrorCode$json = const {
  '1': 'CIMErrorCode',
  '2': const [
    const {'1': 'kCIM_ERR_UNKNOWN', '2': 0},
    const {'1': 'kCIM_ERR_SUCCSSE', '2': 200},
    const {'1': 'kCIM_ERR_INTERNAL_ERROR', '2': 201},
    const {'1': 'kCIM_ERR_LOGIN_DB_VALIDATE_FAILED', '2': 2000},
    const {'1': 'kCIM_ERR_LOGIN_VERSION_TOO_OLD', '2': 2001},
    const {'1': 'kCIM_ERR_LOGIN_INVALID_USER_TOKEN', '2': 2002},
    const {'1': 'kCIM_ERR_LOGIN_INVALID_USER_OR_PWD', '2': 2003},
    const {'1': 'kCIM_ERROR_USER_ALREADY_EXIST', '2': 9000},
    const {'1': 'kCIM_ERROR_USER_INVALID_PARAMETER', '2': 9001},
    const {'1': 'kCIM_ERROR_USER_NOT_EXIST', '2': 9002},
  ],
};

const CIMClientType$json = const {
  '1': 'CIMClientType',
  '2': const [
    const {'1': 'kCIM_CLIENT_TYPE_DEFAULT', '2': 0},
    const {'1': 'kCIM_CLIENT_TYPE_ANDROID', '2': 1},
    const {'1': 'kCIM_CLIENT_TYPE_IOS', '2': 2},
    const {'1': 'kCIM_CLIENT_TYPE_WEB', '2': 3},
  ],
};

const CIMSessionType$json = const {
  '1': 'CIMSessionType',
  '2': const [
    const {'1': 'kCIM_SESSION_TYPE_Invalid', '2': 0},
    const {'1': 'kCIM_SESSION_TYPE_SINGLE', '2': 1},
    const {'1': 'kCIM_SESSION_TYPE_GROUP', '2': 2},
  ],
};

const CIMMsgType$json = const {
  '1': 'CIMMsgType',
  '2': const [
    const {'1': 'kCIM_MSG_TYPE_UNKNOWN', '2': 0},
    const {'1': 'kCIM_MSG_TYPE_TEXT', '2': 1},
    const {'1': 'kCIM_MSG_TYPE_FILE', '2': 2},
    const {'1': 'kCIM_MSG_TYPE_IMAGE', '2': 3},
    const {'1': 'kCIM_MSG_TYPE_AUDIO', '2': 4},
    const {'1': 'kCIM_MSG_TYPE_VIDEO', '2': 5},
    const {'1': 'kCIM_MSG_TYPE_LOCATION', '2': 6},
    const {'1': 'kCIM_MSG_TYPE_ROBOT', '2': 7},
    const {'1': 'kCIM_MSG_TYPE_TIPS', '2': 8},
    const {'1': 'kCIM_MSG_TYPE_NOTIFACATION', '2': 9},
    const {'1': 'kCIM_MSG_TYPE_AVCHAT', '2': 10},
  ],
};

const CIMMsgStatus$json = const {
  '1': 'CIMMsgStatus',
  '2': const [
    const {'1': 'kCIM_MSG_STATUS_NONE', '2': 0},
    const {'1': 'kCIM_MSG_STATUS_UNREAD', '2': 1},
    const {'1': 'kCIM_MSG_STATUS_READ', '2': 2},
    const {'1': 'kCIM_MSG_STATUS_DELETED', '2': 3},
    const {'1': 'kCIM_MSG_STATUS_SENDING', '2': 4},
    const {'1': 'kCIM_MSG_STATUS_SENT', '2': 5},
    const {'1': 'kCIM_MSG_STATUS_RECEIPT', '2': 6},
    const {'1': 'kCIM_MSG_STATUS_DRAFT', '2': 7},
    const {'1': 'kCIM_MSG_STATUS_SendCacel', '2': 8},
    const {'1': 'kCIM_MSG_STATUS_REFUSED', '2': 9},
    const {'1': 'kCIM_MSG_STATUS_FAILED', '2': 10},
  ],
};

const CIMMsgNotificationType$json = const {
  '1': 'CIMMsgNotificationType',
  '2': const [
    const {'1': 'kCIM_MSG_NOTIFICATION_UNKNOWN', '2': 0},
    const {'1': 'kCIM_MSG_NOTIFICATION_GROUP_CREATE', '2': 1},
    const {'1': 'kCIM_MSG_NOTIFICATION_GROUP_BE_INVITE', '2': 2},
    const {'1': 'kCIM_MSG_NOTIFICATION_GROUP_KICK', '2': 3},
    const {'1': 'kCIM_MSG_NOTIFICATION_GROUP_LEAVE', '2': 4},
    const {'1': 'kCIM_MSG_NOTIFICATION_GROUP_UPDATE', '2': 5},
    const {'1': 'kCIM_MSG_NOTIFICATION_GROUP_DISMISS', '2': 6},
  ],
};

const CIMSessionStatusType$json = const {
  '1': 'CIMSessionStatusType',
  '2': const [
    const {'1': 'kCIM_SESSION_STATUS_UNKNOWN', '2': 0},
    const {'1': 'kCIM_SESSION_STATUS_OK', '2': 1},
    const {'1': 'kCIM_SESSION_STATUS_DELETE', '2': 2},
  ],
};

const CIMMsgFeature$json = const {
  '1': 'CIMMsgFeature',
  '2': const [
    const {'1': 'kCIM_MSG_FEATURE_DEFAULT', '2': 0},
    const {'1': 'kCIM_MSG_FEATURE_ROAM_MSG', '2': 2},
  ],
};

const CIMVoipInviteType$json = const {
  '1': 'CIMVoipInviteType',
  '2': const [
    const {'1': 'kCIM_VOIP_INVITE_TYPE_UNKNOWN', '2': 0},
    const {'1': 'kCIM_VOIP_INVITE_TYPE_VOICE_CALL', '2': 1},
    const {'1': 'kCIM_VOIP_INVITE_TYPE_VIDEO_CALL', '2': 2},
  ],
};

const CIMInviteRspCode$json = const {
  '1': 'CIMInviteRspCode',
  '2': const [
    const {'1': 'kCIM_VOIP_INVITE_CODE_UNKNOWN', '2': 0},
    const {'1': 'kCIM_VOIP_INVITE_CODE_TRYING', '2': 100},
    const {'1': 'kCIM_VOIP_INVITE_CODE_RINGING', '2': 180},
    const {'1': 'KCIM_VOIP_INVITE_CODE_OK', '2': 200},
  ],
};

const CIMVoipByeReason$json = const {
  '1': 'CIMVoipByeReason',
  '2': const [
    const {'1': 'kCIM_VOIP_BYE_REASON_UNKNOWN', '2': 0},
    const {'1': 'kCIM_VOIP_BYE_REASON_CANCEL', '2': 1},
    const {'1': 'kCIM_VOIP_BYE_REASON_REJECT', '2': 2},
    const {'1': 'kCIM_VOIP_BYE_REASON_END', '2': 3},
    const {'1': 'kCIM_VOIP_BYE_REASON_BUSY', '2': 4},
    const {'1': 'kCIM_VOIP_BYE_REASON_ONLINE_CLIENT_REJECT', '2': 5},
  ],
};

const CIMResCode$json = const {
  '1': 'CIMResCode',
  '2': const [
    const {'1': 'kCIM_RES_CODE_UNKNOWN', '2': 0},
    const {'1': 'kCIM_RES_CODE_OK', '2': 1},
  ],
};

const CIMUserInfo$json = const {
  '1': 'CIMUserInfo',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'nick_name', '3': 2, '4': 1, '5': 9, '10': 'nickName'},
    const {'1': 'nick_name_spell', '3': 3, '4': 1, '5': 9, '10': 'nickNameSpell'},
    const {'1': 'phone', '3': 9, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'avatar_url', '3': 10, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'attach_info', '3': 11, '4': 1, '5': 9, '10': 'attachInfo'},
  ],
};

const CIMContactSessionInfo$json = const {
  '1': 'CIMContactSessionInfo',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_status', '3': 3, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionStatusType', '10': 'sessionStatus'},
    const {'1': 'unread_cnt', '3': 4, '4': 1, '5': 13, '10': 'unreadCnt'},
    const {'1': 'updated_time', '3': 5, '4': 1, '5': 13, '10': 'updatedTime'},
    const {'1': 'msg_id', '3': 6, '4': 1, '5': 9, '10': 'msgId'},
    const {'1': 'server_msg_id', '3': 7, '4': 1, '5': 4, '10': 'serverMsgId'},
    const {'1': 'msg_time_stamp', '3': 8, '4': 1, '5': 13, '10': 'msgTimeStamp'},
    const {'1': 'msg_data', '3': 9, '4': 1, '5': 12, '10': 'msgData'},
    const {'1': 'msg_type', '3': 10, '4': 1, '5': 14, '6': '.CIM.Def.CIMMsgType', '10': 'msgType'},
    const {'1': 'msg_from_user_id', '3': 11, '4': 1, '5': 4, '10': 'msgFromUserId'},
    const {'1': 'msg_status', '3': 12, '4': 1, '5': 14, '6': '.CIM.Def.CIMMsgStatus', '10': 'msgStatus'},
    const {'1': 'msg_attach', '3': 13, '4': 1, '5': 9, '10': 'msgAttach'},
    const {'1': 'extend_data', '3': 14, '4': 1, '5': 9, '10': 'extendData'},
    const {'1': 'is_robot_session', '3': 15, '4': 1, '5': 8, '10': 'isRobotSession'},
  ],
};

const CIMMsgInfo$json = const {
  '1': 'CIMMsgInfo',
  '2': const [
    const {'1': 'client_msg_id', '3': 1, '4': 1, '5': 9, '10': 'clientMsgId'},
    const {'1': 'server_msg_id', '3': 2, '4': 1, '5': 4, '10': 'serverMsgId'},
    const {'1': 'msg_res_code', '3': 3, '4': 1, '5': 14, '6': '.CIM.Def.CIMResCode', '10': 'msgResCode'},
    const {'1': 'msg_feature', '3': 4, '4': 1, '5': 14, '6': '.CIM.Def.CIMMsgFeature', '10': 'msgFeature'},
    const {'1': 'session_type', '3': 5, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'from_user_id', '3': 6, '4': 1, '5': 4, '10': 'fromUserId'},
    const {'1': 'to_session_id', '3': 7, '4': 1, '5': 4, '10': 'toSessionId'},
    const {'1': 'create_time', '3': 8, '4': 1, '5': 13, '10': 'createTime'},
    const {'1': 'msg_type', '3': 9, '4': 1, '5': 14, '6': '.CIM.Def.CIMMsgType', '10': 'msgType'},
    const {'1': 'msg_status', '3': 10, '4': 1, '5': 14, '6': '.CIM.Def.CIMMsgStatus', '10': 'msgStatus'},
    const {'1': 'msg_data', '3': 11, '4': 1, '5': 12, '10': 'msgData'},
    const {'1': 'attach', '3': 12, '4': 1, '5': 9, '10': 'attach'},
    const {'1': 'sender_client_type', '3': 13, '4': 1, '5': 14, '6': '.CIM.Def.CIMClientType', '10': 'senderClientType'},
  ],
};

const CIMChannelInfo$json = const {
  '1': 'CIMChannelInfo',
  '2': const [
    const {'1': 'channel_name', '3': 1, '4': 1, '5': 9, '10': 'channelName'},
    const {'1': 'channel_token', '3': 2, '4': 1, '5': 9, '10': 'channelToken'},
    const {'1': 'creator_id', '3': 3, '4': 1, '5': 4, '10': 'creatorId'},
  ],
};

