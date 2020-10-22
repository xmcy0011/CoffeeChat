///
//  Generated code. Do not modify.
//  source: CIM.Voip.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CIMVoipInviteReq$json = const {
  '1': 'CIMVoipInviteReq',
  '2': const [
    const {'1': 'creator_user_id', '3': 1, '4': 1, '5': 4, '10': 'creatorUserId'},
    const {'1': 'invite_user_list', '3': 2, '4': 3, '5': 4, '10': 'inviteUserList'},
    const {'1': 'invite_type', '3': 3, '4': 1, '5': 14, '6': '.CIM.Def.CIMVoipInviteType', '10': 'inviteType'},
    const {'1': 'channel_info', '3': 4, '4': 1, '5': 11, '6': '.CIM.Def.CIMChannelInfo', '10': 'channelInfo'},
  ],
};

const CIMVoipInviteReply$json = const {
  '1': 'CIMVoipInviteReply',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'rsp_code', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMInviteRspCode', '10': 'rspCode'},
    const {'1': 'channel_info', '3': 3, '4': 1, '5': 11, '6': '.CIM.Def.CIMChannelInfo', '10': 'channelInfo'},
  ],
};

const CIMVoipInviteReplyAck$json = const {
  '1': 'CIMVoipInviteReplyAck',
  '2': const [
    const {'1': 'channel_info', '3': 1, '4': 1, '5': 11, '6': '.CIM.Def.CIMChannelInfo', '10': 'channelInfo'},
  ],
};

const CIMVoipHeartbeat$json = const {
  '1': 'CIMVoipHeartbeat',
};

const CIMVoipByeReq$json = const {
  '1': 'CIMVoipByeReq',
  '2': const [
    const {'1': 'local_call_time_len', '3': 1, '4': 1, '5': 4, '10': 'localCallTimeLen'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'channel_info', '3': 3, '4': 1, '5': 11, '6': '.CIM.Def.CIMChannelInfo', '10': 'channelInfo'},
    const {'1': 'bye_reason', '3': 4, '4': 1, '5': 14, '6': '.CIM.Def.CIMVoipByeReason', '10': 'byeReason'},
  ],
};

const CIMVoipByeRsp$json = const {
  '1': 'CIMVoipByeRsp',
  '2': const [
    const {'1': 'error_code', '3': 1, '4': 1, '5': 14, '6': '.CIM.Def.CIMErrorCode', '10': 'errorCode'},
  ],
};

const CIMVoipByeNotify$json = const {
  '1': 'CIMVoipByeNotify',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'channel_info', '3': 2, '4': 1, '5': 11, '6': '.CIM.Def.CIMChannelInfo', '10': 'channelInfo'},
    const {'1': 'byeReason', '3': 3, '4': 1, '5': 14, '6': '.CIM.Def.CIMVoipByeReason', '10': 'byeReason'},
  ],
};

