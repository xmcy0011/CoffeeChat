///
//  Generated code. Do not modify.
//  source: CIM.Message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMMsgData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgData', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'fromUserId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, 'fromNickName')
    ..a<$fixnum.Int64>(3, 'toSessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, 'clientMsgId')
    ..a<$fixnum.Int64>(5, 'serverMsgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(6, 'createTime', $pb.PbFieldType.O3)
    ..e<$0.CIMMsgType>(7, 'msgType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMMsgType.kCIM_MSG_TYPE_UNKNOWN, valueOf: $0.CIMMsgType.valueOf, enumValues: $0.CIMMsgType.values)
    ..e<$0.CIMSessionType>(8, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$core.List<$core.int>>(9, 'msgData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMMsgData._() : super();
  factory CIMMsgData() => create();
  factory CIMMsgData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMMsgData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMMsgData clone() => CIMMsgData()..mergeFromMessage(this);
  CIMMsgData copyWith(void Function(CIMMsgData) updates) => super.copyWith((message) => updates(message as CIMMsgData));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMMsgData create() => CIMMsgData._();
  CIMMsgData createEmptyInstance() => create();
  static $pb.PbList<CIMMsgData> createRepeated() => $pb.PbList<CIMMsgData>();
  @$core.pragma('dart2js:noInline')
  static CIMMsgData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMMsgData>(create);
  static CIMMsgData _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fromUserId => $_getI64(0);
  @$pb.TagNumber(1)
  set fromUserId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromNickName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromNickName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromNickName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromNickName() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get toSessionId => $_getI64(2);
  @$pb.TagNumber(3)
  set toSessionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get clientMsgId => $_getSZ(3);
  @$pb.TagNumber(4)
  set clientMsgId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasClientMsgId() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientMsgId() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get serverMsgId => $_getI64(4);
  @$pb.TagNumber(5)
  set serverMsgId($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasServerMsgId() => $_has(4);
  @$pb.TagNumber(5)
  void clearServerMsgId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get createTime => $_getIZ(5);
  @$pb.TagNumber(6)
  set createTime($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreateTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreateTime() => clearField(6);

  @$pb.TagNumber(7)
  $0.CIMMsgType get msgType => $_getN(6);
  @$pb.TagNumber(7)
  set msgType($0.CIMMsgType v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMsgType() => $_has(6);
  @$pb.TagNumber(7)
  void clearMsgType() => clearField(7);

  @$pb.TagNumber(8)
  $0.CIMSessionType get sessionType => $_getN(7);
  @$pb.TagNumber(8)
  set sessionType($0.CIMSessionType v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasSessionType() => $_has(7);
  @$pb.TagNumber(8)
  void clearSessionType() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get msgData => $_getN(8);
  @$pb.TagNumber(9)
  set msgData($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMsgData() => $_has(8);
  @$pb.TagNumber(9)
  void clearMsgData() => clearField(9);
}

class CIMMsgDataAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgDataAck', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'fromUserId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'toSessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, 'clientMsgId')
    ..a<$fixnum.Int64>(4, 'serverMsgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMResCode>(5, 'resCode', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMResCode.kCIM_RES_CODE_UNKNOWN, valueOf: $0.CIMResCode.valueOf, enumValues: $0.CIMResCode.values)
    ..e<$0.CIMSessionType>(6, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$core.int>(7, 'createTime', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CIMMsgDataAck._() : super();
  factory CIMMsgDataAck() => create();
  factory CIMMsgDataAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMMsgDataAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMMsgDataAck clone() => CIMMsgDataAck()..mergeFromMessage(this);
  CIMMsgDataAck copyWith(void Function(CIMMsgDataAck) updates) => super.copyWith((message) => updates(message as CIMMsgDataAck));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMMsgDataAck create() => CIMMsgDataAck._();
  CIMMsgDataAck createEmptyInstance() => create();
  static $pb.PbList<CIMMsgDataAck> createRepeated() => $pb.PbList<CIMMsgDataAck>();
  @$core.pragma('dart2js:noInline')
  static CIMMsgDataAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMMsgDataAck>(create);
  static CIMMsgDataAck _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fromUserId => $_getI64(0);
  @$pb.TagNumber(1)
  set fromUserId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get toSessionId => $_getI64(1);
  @$pb.TagNumber(2)
  set toSessionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get clientMsgId => $_getSZ(2);
  @$pb.TagNumber(3)
  set clientMsgId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasClientMsgId() => $_has(2);
  @$pb.TagNumber(3)
  void clearClientMsgId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get serverMsgId => $_getI64(3);
  @$pb.TagNumber(4)
  set serverMsgId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasServerMsgId() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerMsgId() => clearField(4);

  @$pb.TagNumber(5)
  $0.CIMResCode get resCode => $_getN(4);
  @$pb.TagNumber(5)
  set resCode($0.CIMResCode v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasResCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearResCode() => clearField(5);

  @$pb.TagNumber(6)
  $0.CIMSessionType get sessionType => $_getN(5);
  @$pb.TagNumber(6)
  set sessionType($0.CIMSessionType v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSessionType() => $_has(5);
  @$pb.TagNumber(6)
  void clearSessionType() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get createTime => $_getIZ(6);
  @$pb.TagNumber(7)
  set createTime($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreateTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreateTime() => clearField(7);
}

class CIMMsgDataReadAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgDataReadAck', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, 'msgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(4, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..hasRequiredFields = false
  ;

  CIMMsgDataReadAck._() : super();
  factory CIMMsgDataReadAck() => create();
  factory CIMMsgDataReadAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMMsgDataReadAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMMsgDataReadAck clone() => CIMMsgDataReadAck()..mergeFromMessage(this);
  CIMMsgDataReadAck copyWith(void Function(CIMMsgDataReadAck) updates) => super.copyWith((message) => updates(message as CIMMsgDataReadAck));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMMsgDataReadAck create() => CIMMsgDataReadAck._();
  CIMMsgDataReadAck createEmptyInstance() => create();
  static $pb.PbList<CIMMsgDataReadAck> createRepeated() => $pb.PbList<CIMMsgDataReadAck>();
  @$core.pragma('dart2js:noInline')
  static CIMMsgDataReadAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMMsgDataReadAck>(create);
  static CIMMsgDataReadAck _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sessionId => $_getI64(1);
  @$pb.TagNumber(2)
  set sessionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get msgId => $_getI64(2);
  @$pb.TagNumber(3)
  set msgId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMsgId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsgId() => clearField(3);

  @$pb.TagNumber(4)
  $0.CIMSessionType get sessionType => $_getN(3);
  @$pb.TagNumber(4)
  set sessionType($0.CIMSessionType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionType() => clearField(4);
}

class CIMMsgDataReadNotify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgDataReadNotify', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, 'msgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(4, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..hasRequiredFields = false
  ;

  CIMMsgDataReadNotify._() : super();
  factory CIMMsgDataReadNotify() => create();
  factory CIMMsgDataReadNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMMsgDataReadNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMMsgDataReadNotify clone() => CIMMsgDataReadNotify()..mergeFromMessage(this);
  CIMMsgDataReadNotify copyWith(void Function(CIMMsgDataReadNotify) updates) => super.copyWith((message) => updates(message as CIMMsgDataReadNotify));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMMsgDataReadNotify create() => CIMMsgDataReadNotify._();
  CIMMsgDataReadNotify createEmptyInstance() => create();
  static $pb.PbList<CIMMsgDataReadNotify> createRepeated() => $pb.PbList<CIMMsgDataReadNotify>();
  @$core.pragma('dart2js:noInline')
  static CIMMsgDataReadNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMMsgDataReadNotify>(create);
  static CIMMsgDataReadNotify _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sessionId => $_getI64(1);
  @$pb.TagNumber(2)
  set sessionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get msgId => $_getI64(2);
  @$pb.TagNumber(3)
  set msgId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMsgId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsgId() => clearField(3);

  @$pb.TagNumber(4)
  $0.CIMSessionType get sessionType => $_getN(3);
  @$pb.TagNumber(4)
  set sessionType($0.CIMSessionType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionType() => clearField(4);
}

class CIMGetLatestMsgIdReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetLatestMsgIdReq', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$fixnum.Int64>(3, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMGetLatestMsgIdReq._() : super();
  factory CIMGetLatestMsgIdReq() => create();
  factory CIMGetLatestMsgIdReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGetLatestMsgIdReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGetLatestMsgIdReq clone() => CIMGetLatestMsgIdReq()..mergeFromMessage(this);
  CIMGetLatestMsgIdReq copyWith(void Function(CIMGetLatestMsgIdReq) updates) => super.copyWith((message) => updates(message as CIMGetLatestMsgIdReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGetLatestMsgIdReq create() => CIMGetLatestMsgIdReq._();
  CIMGetLatestMsgIdReq createEmptyInstance() => create();
  static $pb.PbList<CIMGetLatestMsgIdReq> createRepeated() => $pb.PbList<CIMGetLatestMsgIdReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGetLatestMsgIdReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGetLatestMsgIdReq>(create);
  static CIMGetLatestMsgIdReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMSessionType get sessionType => $_getN(1);
  @$pb.TagNumber(2)
  set sessionType($0.CIMSessionType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sessionId => $_getI64(2);
  @$pb.TagNumber(3)
  set sessionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);
}

class CIMGetLatestMsgIdRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetLatestMsgIdRsp', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$fixnum.Int64>(3, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, 'latestMsgId')
    ..hasRequiredFields = false
  ;

  CIMGetLatestMsgIdRsp._() : super();
  factory CIMGetLatestMsgIdRsp() => create();
  factory CIMGetLatestMsgIdRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGetLatestMsgIdRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGetLatestMsgIdRsp clone() => CIMGetLatestMsgIdRsp()..mergeFromMessage(this);
  CIMGetLatestMsgIdRsp copyWith(void Function(CIMGetLatestMsgIdRsp) updates) => super.copyWith((message) => updates(message as CIMGetLatestMsgIdRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGetLatestMsgIdRsp create() => CIMGetLatestMsgIdRsp._();
  CIMGetLatestMsgIdRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGetLatestMsgIdRsp> createRepeated() => $pb.PbList<CIMGetLatestMsgIdRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGetLatestMsgIdRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGetLatestMsgIdRsp>(create);
  static CIMGetLatestMsgIdRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMSessionType get sessionType => $_getN(1);
  @$pb.TagNumber(2)
  set sessionType($0.CIMSessionType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sessionId => $_getI64(2);
  @$pb.TagNumber(3)
  set sessionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get latestMsgId => $_getSZ(3);
  @$pb.TagNumber(4)
  set latestMsgId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLatestMsgId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatestMsgId() => clearField(4);
}

class CIMGetMsgByIdReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgByIdReq', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$fixnum.Int64>(3, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(4, 'msgIdList')
    ..hasRequiredFields = false
  ;

  CIMGetMsgByIdReq._() : super();
  factory CIMGetMsgByIdReq() => create();
  factory CIMGetMsgByIdReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGetMsgByIdReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGetMsgByIdReq clone() => CIMGetMsgByIdReq()..mergeFromMessage(this);
  CIMGetMsgByIdReq copyWith(void Function(CIMGetMsgByIdReq) updates) => super.copyWith((message) => updates(message as CIMGetMsgByIdReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgByIdReq create() => CIMGetMsgByIdReq._();
  CIMGetMsgByIdReq createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgByIdReq> createRepeated() => $pb.PbList<CIMGetMsgByIdReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgByIdReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGetMsgByIdReq>(create);
  static CIMGetMsgByIdReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMSessionType get sessionType => $_getN(1);
  @$pb.TagNumber(2)
  set sessionType($0.CIMSessionType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sessionId => $_getI64(2);
  @$pb.TagNumber(3)
  set sessionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.String> get msgIdList => $_getList(3);
}

class CIMGetMsgByIdRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgByIdRsp', package: const $pb.PackageName('CIM.Message'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$fixnum.Int64>(3, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$0.CIMMsgInfo>(4, 'msgList', $pb.PbFieldType.PM, subBuilder: $0.CIMMsgInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGetMsgByIdRsp._() : super();
  factory CIMGetMsgByIdRsp() => create();
  factory CIMGetMsgByIdRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGetMsgByIdRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGetMsgByIdRsp clone() => CIMGetMsgByIdRsp()..mergeFromMessage(this);
  CIMGetMsgByIdRsp copyWith(void Function(CIMGetMsgByIdRsp) updates) => super.copyWith((message) => updates(message as CIMGetMsgByIdRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgByIdRsp create() => CIMGetMsgByIdRsp._();
  CIMGetMsgByIdRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgByIdRsp> createRepeated() => $pb.PbList<CIMGetMsgByIdRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgByIdRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGetMsgByIdRsp>(create);
  static CIMGetMsgByIdRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMSessionType get sessionType => $_getN(1);
  @$pb.TagNumber(2)
  set sessionType($0.CIMSessionType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sessionId => $_getI64(2);
  @$pb.TagNumber(3)
  set sessionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$0.CIMMsgInfo> get msgList => $_getList(3);
}

