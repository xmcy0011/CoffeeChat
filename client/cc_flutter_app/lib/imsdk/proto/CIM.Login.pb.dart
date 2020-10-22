///
//  Generated code. Do not modify.
//  source: CIM.Login.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMAuthTokenReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMAuthTokenReq', package: const $pb.PackageName('CIM.Login'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, 'nickName')
    ..aOS(3, 'userToken')
    ..e<$0.CIMClientType>(4, 'clientType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMClientType.kCIM_CLIENT_TYPE_DEFAULT, valueOf: $0.CIMClientType.valueOf, enumValues: $0.CIMClientType.values)
    ..aOS(5, 'clientVersion')
    ..hasRequiredFields = false
  ;

  CIMAuthTokenReq._() : super();
  factory CIMAuthTokenReq() => create();
  factory CIMAuthTokenReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMAuthTokenReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMAuthTokenReq clone() => CIMAuthTokenReq()..mergeFromMessage(this);
  CIMAuthTokenReq copyWith(void Function(CIMAuthTokenReq) updates) => super.copyWith((message) => updates(message as CIMAuthTokenReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMAuthTokenReq create() => CIMAuthTokenReq._();
  CIMAuthTokenReq createEmptyInstance() => create();
  static $pb.PbList<CIMAuthTokenReq> createRepeated() => $pb.PbList<CIMAuthTokenReq>();
  @$core.pragma('dart2js:noInline')
  static CIMAuthTokenReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMAuthTokenReq>(create);
  static CIMAuthTokenReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickName => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNickName() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set userToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserToken() => clearField(3);

  @$pb.TagNumber(4)
  $0.CIMClientType get clientType => $_getN(3);
  @$pb.TagNumber(4)
  set clientType($0.CIMClientType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasClientType() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get clientVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set clientVersion($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasClientVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearClientVersion() => clearField(5);
}

class CIMAuthTokenRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMAuthTokenRsp', package: const $pb.PackageName('CIM.Login'), createEmptyInstance: create)
    ..a<$core.int>(1, 'serverTime', $pb.PbFieldType.OU3)
    ..e<$0.CIMErrorCode>(2, 'resultCode', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMErrorCode.kCIM_ERR_UNKNOWN, valueOf: $0.CIMErrorCode.valueOf, enumValues: $0.CIMErrorCode.values)
    ..aOS(3, 'resultString')
    ..aOM<$0.CIMUserInfo>(4, 'userInfo', subBuilder: $0.CIMUserInfo.create)
    ..hasRequiredFields = false
  ;

  CIMAuthTokenRsp._() : super();
  factory CIMAuthTokenRsp() => create();
  factory CIMAuthTokenRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMAuthTokenRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMAuthTokenRsp clone() => CIMAuthTokenRsp()..mergeFromMessage(this);
  CIMAuthTokenRsp copyWith(void Function(CIMAuthTokenRsp) updates) => super.copyWith((message) => updates(message as CIMAuthTokenRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMAuthTokenRsp create() => CIMAuthTokenRsp._();
  CIMAuthTokenRsp createEmptyInstance() => create();
  static $pb.PbList<CIMAuthTokenRsp> createRepeated() => $pb.PbList<CIMAuthTokenRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMAuthTokenRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMAuthTokenRsp>(create);
  static CIMAuthTokenRsp _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get serverTime => $_getIZ(0);
  @$pb.TagNumber(1)
  set serverTime($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServerTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerTime() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMErrorCode get resultCode => $_getN(1);
  @$pb.TagNumber(2)
  set resultCode($0.CIMErrorCode v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasResultCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get resultString => $_getSZ(2);
  @$pb.TagNumber(3)
  set resultString($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResultString() => $_has(2);
  @$pb.TagNumber(3)
  void clearResultString() => clearField(3);

  @$pb.TagNumber(4)
  $0.CIMUserInfo get userInfo => $_getN(3);
  @$pb.TagNumber(4)
  set userInfo($0.CIMUserInfo v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUserInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserInfo() => clearField(4);
  @$pb.TagNumber(4)
  $0.CIMUserInfo ensureUserInfo() => $_ensure(3);
}

class CIMLogoutReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMLogoutReq', package: const $pb.PackageName('CIM.Login'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMClientType>(2, 'clientType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMClientType.kCIM_CLIENT_TYPE_DEFAULT, valueOf: $0.CIMClientType.valueOf, enumValues: $0.CIMClientType.values)
    ..hasRequiredFields = false
  ;

  CIMLogoutReq._() : super();
  factory CIMLogoutReq() => create();
  factory CIMLogoutReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMLogoutReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMLogoutReq clone() => CIMLogoutReq()..mergeFromMessage(this);
  CIMLogoutReq copyWith(void Function(CIMLogoutReq) updates) => super.copyWith((message) => updates(message as CIMLogoutReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMLogoutReq create() => CIMLogoutReq._();
  CIMLogoutReq createEmptyInstance() => create();
  static $pb.PbList<CIMLogoutReq> createRepeated() => $pb.PbList<CIMLogoutReq>();
  @$core.pragma('dart2js:noInline')
  static CIMLogoutReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMLogoutReq>(create);
  static CIMLogoutReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMClientType get clientType => $_getN(1);
  @$pb.TagNumber(2)
  set clientType($0.CIMClientType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientType() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientType() => clearField(2);
}

class CIMLogoutRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMLogoutRsp', package: const $pb.PackageName('CIM.Login'), createEmptyInstance: create)
    ..a<$core.int>(1, 'resultCode', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMLogoutRsp._() : super();
  factory CIMLogoutRsp() => create();
  factory CIMLogoutRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMLogoutRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMLogoutRsp clone() => CIMLogoutRsp()..mergeFromMessage(this);
  CIMLogoutRsp copyWith(void Function(CIMLogoutRsp) updates) => super.copyWith((message) => updates(message as CIMLogoutRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMLogoutRsp create() => CIMLogoutRsp._();
  CIMLogoutRsp createEmptyInstance() => create();
  static $pb.PbList<CIMLogoutRsp> createRepeated() => $pb.PbList<CIMLogoutRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMLogoutRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMLogoutRsp>(create);
  static CIMLogoutRsp _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get resultCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set resultCode($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResultCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearResultCode() => clearField(1);
}

class CIMHeartBeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMHeartBeat', package: const $pb.PackageName('CIM.Login'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  CIMHeartBeat._() : super();
  factory CIMHeartBeat() => create();
  factory CIMHeartBeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMHeartBeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMHeartBeat clone() => CIMHeartBeat()..mergeFromMessage(this);
  CIMHeartBeat copyWith(void Function(CIMHeartBeat) updates) => super.copyWith((message) => updates(message as CIMHeartBeat));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMHeartBeat create() => CIMHeartBeat._();
  CIMHeartBeat createEmptyInstance() => create();
  static $pb.PbList<CIMHeartBeat> createRepeated() => $pb.PbList<CIMHeartBeat>();
  @$core.pragma('dart2js:noInline')
  static CIMHeartBeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMHeartBeat>(create);
  static CIMHeartBeat _defaultInstance;
}

