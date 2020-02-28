///
//  Generated code. Do not modify.
//  source: CIM.Login.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMAuthTokenReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMAuthTokenReq', package: const $pb.PackageName('CIM.Login'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'nickName')
    ..aOS(3, 'userToken')
    ..e<$0.CIMClientType>(4, 'clientType', $pb.PbFieldType.OE, $0.CIMClientType.kCIM_CLIENT_TYPE_DEFAULT, $0.CIMClientType.valueOf, $0.CIMClientType.values)
    ..aOS(5, 'clientVersion')
    ..hasRequiredFields = false
  ;

  CIMAuthTokenReq() : super();
  CIMAuthTokenReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMAuthTokenReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMAuthTokenReq clone() => CIMAuthTokenReq()..mergeFromMessage(this);
  CIMAuthTokenReq copyWith(void Function(CIMAuthTokenReq) updates) => super.copyWith((message) => updates(message as CIMAuthTokenReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMAuthTokenReq create() => CIMAuthTokenReq();
  CIMAuthTokenReq createEmptyInstance() => create();
  static $pb.PbList<CIMAuthTokenReq> createRepeated() => $pb.PbList<CIMAuthTokenReq>();
  static CIMAuthTokenReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMAuthTokenReq _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $core.String get nickName => $_getS(1, '');
  set nickName($core.String v) { $_setString(1, v); }
  $core.bool hasNickName() => $_has(1);
  void clearNickName() => clearField(2);

  $core.String get userToken => $_getS(2, '');
  set userToken($core.String v) { $_setString(2, v); }
  $core.bool hasUserToken() => $_has(2);
  void clearUserToken() => clearField(3);

  $0.CIMClientType get clientType => $_getN(3);
  set clientType($0.CIMClientType v) { setField(4, v); }
  $core.bool hasClientType() => $_has(3);
  void clearClientType() => clearField(4);

  $core.String get clientVersion => $_getS(4, '');
  set clientVersion($core.String v) { $_setString(4, v); }
  $core.bool hasClientVersion() => $_has(4);
  void clearClientVersion() => clearField(5);
}

class CIMAuthTokenRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMAuthTokenRsp', package: const $pb.PackageName('CIM.Login'))
    ..a<$core.int>(1, 'serverTime', $pb.PbFieldType.OU3)
    ..e<$0.CIMErrorCode>(2, 'resultCode', $pb.PbFieldType.OE, $0.CIMErrorCode.kCIM_ERR_UNKNOWN, $0.CIMErrorCode.valueOf, $0.CIMErrorCode.values)
    ..aOS(3, 'resultString')
    ..a<$0.CIMUserInfo>(4, 'userInfo', $pb.PbFieldType.OM, $0.CIMUserInfo.getDefault, $0.CIMUserInfo.create)
    ..hasRequiredFields = false
  ;

  CIMAuthTokenRsp() : super();
  CIMAuthTokenRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMAuthTokenRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMAuthTokenRsp clone() => CIMAuthTokenRsp()..mergeFromMessage(this);
  CIMAuthTokenRsp copyWith(void Function(CIMAuthTokenRsp) updates) => super.copyWith((message) => updates(message as CIMAuthTokenRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMAuthTokenRsp create() => CIMAuthTokenRsp();
  CIMAuthTokenRsp createEmptyInstance() => create();
  static $pb.PbList<CIMAuthTokenRsp> createRepeated() => $pb.PbList<CIMAuthTokenRsp>();
  static CIMAuthTokenRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMAuthTokenRsp _defaultInstance;

  $core.int get serverTime => $_get(0, 0);
  set serverTime($core.int v) { $_setUnsignedInt32(0, v); }
  $core.bool hasServerTime() => $_has(0);
  void clearServerTime() => clearField(1);

  $0.CIMErrorCode get resultCode => $_getN(1);
  set resultCode($0.CIMErrorCode v) { setField(2, v); }
  $core.bool hasResultCode() => $_has(1);
  void clearResultCode() => clearField(2);

  $core.String get resultString => $_getS(2, '');
  set resultString($core.String v) { $_setString(2, v); }
  $core.bool hasResultString() => $_has(2);
  void clearResultString() => clearField(3);

  $0.CIMUserInfo get userInfo => $_getN(3);
  set userInfo($0.CIMUserInfo v) { setField(4, v); }
  $core.bool hasUserInfo() => $_has(3);
  void clearUserInfo() => clearField(4);
}

class CIMLogoutReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMLogoutReq', package: const $pb.PackageName('CIM.Login'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMClientType>(2, 'clientType', $pb.PbFieldType.OE, $0.CIMClientType.kCIM_CLIENT_TYPE_DEFAULT, $0.CIMClientType.valueOf, $0.CIMClientType.values)
    ..hasRequiredFields = false
  ;

  CIMLogoutReq() : super();
  CIMLogoutReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMLogoutReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMLogoutReq clone() => CIMLogoutReq()..mergeFromMessage(this);
  CIMLogoutReq copyWith(void Function(CIMLogoutReq) updates) => super.copyWith((message) => updates(message as CIMLogoutReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMLogoutReq create() => CIMLogoutReq();
  CIMLogoutReq createEmptyInstance() => create();
  static $pb.PbList<CIMLogoutReq> createRepeated() => $pb.PbList<CIMLogoutReq>();
  static CIMLogoutReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMLogoutReq _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $0.CIMClientType get clientType => $_getN(1);
  set clientType($0.CIMClientType v) { setField(2, v); }
  $core.bool hasClientType() => $_has(1);
  void clearClientType() => clearField(2);
}

class CIMLogoutRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMLogoutRsp', package: const $pb.PackageName('CIM.Login'))
    ..a<$core.int>(1, 'resultCode', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMLogoutRsp() : super();
  CIMLogoutRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMLogoutRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMLogoutRsp clone() => CIMLogoutRsp()..mergeFromMessage(this);
  CIMLogoutRsp copyWith(void Function(CIMLogoutRsp) updates) => super.copyWith((message) => updates(message as CIMLogoutRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMLogoutRsp create() => CIMLogoutRsp();
  CIMLogoutRsp createEmptyInstance() => create();
  static $pb.PbList<CIMLogoutRsp> createRepeated() => $pb.PbList<CIMLogoutRsp>();
  static CIMLogoutRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMLogoutRsp _defaultInstance;

  $core.int get resultCode => $_get(0, 0);
  set resultCode($core.int v) { $_setUnsignedInt32(0, v); }
  $core.bool hasResultCode() => $_has(0);
  void clearResultCode() => clearField(1);
}

class CIMHeartBeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMHeartBeat', package: const $pb.PackageName('CIM.Login'))
    ..hasRequiredFields = false
  ;

  CIMHeartBeat() : super();
  CIMHeartBeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMHeartBeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMHeartBeat clone() => CIMHeartBeat()..mergeFromMessage(this);
  CIMHeartBeat copyWith(void Function(CIMHeartBeat) updates) => super.copyWith((message) => updates(message as CIMHeartBeat));
  $pb.BuilderInfo get info_ => _i;
  static CIMHeartBeat create() => CIMHeartBeat();
  CIMHeartBeat createEmptyInstance() => create();
  static $pb.PbList<CIMHeartBeat> createRepeated() => $pb.PbList<CIMHeartBeat>();
  static CIMHeartBeat getDefault() => _defaultInstance ??= create()..freeze();
  static CIMHeartBeat _defaultInstance;
}

