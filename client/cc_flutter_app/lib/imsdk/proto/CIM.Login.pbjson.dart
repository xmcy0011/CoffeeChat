///
//  Generated code. Do not modify.
//  source: CIM.Login.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CIMAuthTokenReq$json = const {
  '1': 'CIMAuthTokenReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'nick_name', '3': 2, '4': 1, '5': 9, '10': 'nickName'},
    const {'1': 'user_token', '3': 3, '4': 1, '5': 9, '10': 'userToken'},
    const {'1': 'client_type', '3': 4, '4': 1, '5': 14, '6': '.CIM.Def.CIMClientType', '10': 'clientType'},
    const {'1': 'client_version', '3': 5, '4': 1, '5': 9, '10': 'clientVersion'},
  ],
};

const CIMAuthTokenRsp$json = const {
  '1': 'CIMAuthTokenRsp',
  '2': const [
    const {'1': 'server_time', '3': 1, '4': 1, '5': 13, '10': 'serverTime'},
    const {'1': 'result_code', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMErrorCode', '10': 'resultCode'},
    const {'1': 'result_string', '3': 3, '4': 1, '5': 9, '10': 'resultString'},
    const {'1': 'user_info', '3': 4, '4': 1, '5': 11, '6': '.CIM.Def.CIMUserInfo', '10': 'userInfo'},
  ],
};

const CIMLogoutReq$json = const {
  '1': 'CIMLogoutReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'client_type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Def.CIMClientType', '10': 'clientType'},
  ],
};

const CIMLogoutRsp$json = const {
  '1': 'CIMLogoutRsp',
  '2': const [
    const {'1': 'result_code', '3': 1, '4': 1, '5': 13, '10': 'resultCode'},
  ],
};

const CIMHeartBeat$json = const {
  '1': 'CIMHeartBeat',
};

