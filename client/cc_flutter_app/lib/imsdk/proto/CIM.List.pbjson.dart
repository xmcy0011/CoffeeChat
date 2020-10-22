///
//  Generated code. Do not modify.
//  source: CIM.List.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CIMRecentContactSessionReq$json = const {
  '1': 'CIMRecentContactSessionReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'latest_update_time', '3': 2, '4': 1, '5': 13, '10': 'latestUpdateTime'},
  ],
};

const CIMRecentContactSessionRsp$json = const {
  '1': 'CIMRecentContactSessionRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'unread_counts', '3': 2, '4': 1, '5': 13, '10': 'unreadCounts'},
    const {'1': 'contact_session_list', '3': 3, '4': 3, '5': 11, '6': '.CIM.Def.CIMContactSessionInfo', '10': 'contactSessionList'},
  ],
};

const CIMGetMsgListReq$json = const {
  '1': 'CIMGetMsgListReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'end_msg_id', '3': 4, '4': 1, '5': 4, '10': 'endMsgId'},
    const {'1': 'limit_count', '3': 6, '4': 1, '5': 13, '10': 'limitCount'},
  ],
};

const CIMGetMsgListRsp$json = const {
  '1': 'CIMGetMsgListRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'session_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMSessionType', '10': 'sessionType'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 4, '10': 'sessionId'},
    const {'1': 'end_msg_id', '3': 4, '4': 1, '5': 4, '10': 'endMsgId'},
    const {'1': 'msg_list', '3': 6, '4': 3, '5': 11, '6': '.CIM.Def.CIMMsgInfo', '10': 'msgList'},
  ],
};

