///
//  Generated code. Do not modify.
//  source: CIM.Message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CIMMsgData$json = const {
  '1': 'CIMMsgData',
  '2': const [
    const {'1': 'from_user_id', '3': 1, '4': 1, '5': 4, '10': 'fromUserId'},
    const {'1': 'from_nick_name', '3': 2, '4': 1, '5': 9, '10': 'fromNickName'},
    const {'1': 'to_session_id', '3': 3, '4': 1, '5': 4, '10': 'toSessionId'},
    const {'1': 'client_msg_id', '3': 4, '4': 1, '5': 9, '10': 'clientMsgId'},
    const {'1': 'server_msg_id', '3': 5, '4': 1, '5': 4, '10': 'serverMsgId'},
    const {'1': 'create_time', '3': 6, '4': 1, '5': 5, '10': 'createTime'},
    const {'1': 'msg_type', '3': 7, '4': 1, '5': 14, '6': '.CIM.Def.CIMMsgType', '10': 'msgType'},
    const {'1': 'session_type', '3': 8, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'msg_data', '3': 9, '4': 1, '5': 12, '10': 'msgData'},
  ],
};

const CIMMsgDataAck$json = const {
  '1': 'CIMMsgDataAck',
  '2': const [
    const {'1': 'from_user_id', '3': 1, '4': 1, '5': 4, '10': 'fromUserId'},
    const {'1': 'to_session_id', '3': 2, '4': 1, '5': 4, '10': 'toSessionId'},
    const {'1': 'client_msg_id', '3': 3, '4': 1, '5': 9, '10': 'clientMsgId'},
    const {'1': 'server_msg_id', '3': 4, '4': 1, '5': 4, '10': 'serverMsgId'},
    const {'1': 'res_code', '3': 5, '4': 1, '5': 14, '6': '.CIM.Def.CIMResCode', '10': 'resCode'},
    const {'1': 'session_type', '3': 6, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'create_time', '3': 7, '4': 1, '5': 5, '10': 'createTime'},
  ],
};

const CIMMsgDataReadAck$json = const {
  '1': 'CIMMsgDataReadAck',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'msg_id', '3': 3, '4': 1, '5': 4, '10': 'msgId'},
    const {'1': 'session_type', '3': 4, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
  ],
};

const CIMMsgDataReadNotify$json = const {
  '1': 'CIMMsgDataReadNotify',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'msg_id', '3': 3, '4': 1, '5': 4, '10': 'msgId'},
    const {'1': 'session_type', '3': 4, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
  ],
};

const CIMGetLatestMsgIdReq$json = const {
  '1': 'CIMGetLatestMsgIdReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 4, '10': 'sessionId'},
  ],
};

const CIMGetLatestMsgIdRsp$json = const {
  '1': 'CIMGetLatestMsgIdRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'latest_msg_id', '3': 4, '4': 1, '5': 9, '10': 'latestMsgId'},
  ],
};

const CIMGetMsgByIdReq$json = const {
  '1': 'CIMGetMsgByIdReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'msg_id_list', '3': 4, '4': 3, '5': 9, '10': 'msgIdList'},
  ],
};

const CIMGetMsgByIdRsp$json = const {
  '1': 'CIMGetMsgByIdRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'msg_list', '3': 4, '4': 3, '5': 11, '6': '.CIM.Def.CIMMsgInfo', '10': 'msgList'},
  ],
};

