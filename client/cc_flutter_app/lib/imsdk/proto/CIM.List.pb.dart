///
//  Generated code. Do not modify.
//  source: CIM.List.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMRecentContactSessionReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMRecentContactSessionReq', package: const $pb.PackageName('CIM.List'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'latestUpdateTime', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMRecentContactSessionReq._() : super();
  factory CIMRecentContactSessionReq() => create();
  factory CIMRecentContactSessionReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMRecentContactSessionReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMRecentContactSessionReq clone() => CIMRecentContactSessionReq()..mergeFromMessage(this);
  CIMRecentContactSessionReq copyWith(void Function(CIMRecentContactSessionReq) updates) => super.copyWith((message) => updates(message as CIMRecentContactSessionReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMRecentContactSessionReq create() => CIMRecentContactSessionReq._();
  CIMRecentContactSessionReq createEmptyInstance() => create();
  static $pb.PbList<CIMRecentContactSessionReq> createRepeated() => $pb.PbList<CIMRecentContactSessionReq>();
  @$core.pragma('dart2js:noInline')
  static CIMRecentContactSessionReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMRecentContactSessionReq>(create);
  static CIMRecentContactSessionReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get latestUpdateTime => $_getIZ(1);
  @$pb.TagNumber(2)
  set latestUpdateTime($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatestUpdateTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatestUpdateTime() => clearField(2);
}

class CIMRecentContactSessionRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMRecentContactSessionRsp', package: const $pb.PackageName('CIM.List'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'unreadCounts', $pb.PbFieldType.OU3)
    ..pc<$0.CIMContactSessionInfo>(3, 'contactSessionList', $pb.PbFieldType.PM, subBuilder: $0.CIMContactSessionInfo.create)
    ..hasRequiredFields = false
  ;

  CIMRecentContactSessionRsp._() : super();
  factory CIMRecentContactSessionRsp() => create();
  factory CIMRecentContactSessionRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMRecentContactSessionRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMRecentContactSessionRsp clone() => CIMRecentContactSessionRsp()..mergeFromMessage(this);
  CIMRecentContactSessionRsp copyWith(void Function(CIMRecentContactSessionRsp) updates) => super.copyWith((message) => updates(message as CIMRecentContactSessionRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMRecentContactSessionRsp create() => CIMRecentContactSessionRsp._();
  CIMRecentContactSessionRsp createEmptyInstance() => create();
  static $pb.PbList<CIMRecentContactSessionRsp> createRepeated() => $pb.PbList<CIMRecentContactSessionRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMRecentContactSessionRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMRecentContactSessionRsp>(create);
  static CIMRecentContactSessionRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get unreadCounts => $_getIZ(1);
  @$pb.TagNumber(2)
  set unreadCounts($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUnreadCounts() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnreadCounts() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$0.CIMContactSessionInfo> get contactSessionList => $_getList(2);
}

class CIMGetMsgListReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgListReq', package: const $pb.PackageName('CIM.List'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$fixnum.Int64>(3, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, 'endMsgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(6, 'limitCount', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMGetMsgListReq._() : super();
  factory CIMGetMsgListReq() => create();
  factory CIMGetMsgListReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGetMsgListReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGetMsgListReq clone() => CIMGetMsgListReq()..mergeFromMessage(this);
  CIMGetMsgListReq copyWith(void Function(CIMGetMsgListReq) updates) => super.copyWith((message) => updates(message as CIMGetMsgListReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgListReq create() => CIMGetMsgListReq._();
  CIMGetMsgListReq createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgListReq> createRepeated() => $pb.PbList<CIMGetMsgListReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgListReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGetMsgListReq>(create);
  static CIMGetMsgListReq _defaultInstance;

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
  $fixnum.Int64 get endMsgId => $_getI64(3);
  @$pb.TagNumber(4)
  set endMsgId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasEndMsgId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndMsgId() => clearField(4);

  @$pb.TagNumber(6)
  $core.int get limitCount => $_getIZ(4);
  @$pb.TagNumber(6)
  set limitCount($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasLimitCount() => $_has(4);
  @$pb.TagNumber(6)
  void clearLimitCount() => clearField(6);
}

class CIMGetMsgListRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgListRsp', package: const $pb.PackageName('CIM.List'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: $0.CIMSessionType.valueOf, enumValues: $0.CIMSessionType.values)
    ..a<$fixnum.Int64>(3, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, 'endMsgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$0.CIMMsgInfo>(6, 'msgList', $pb.PbFieldType.PM, subBuilder: $0.CIMMsgInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGetMsgListRsp._() : super();
  factory CIMGetMsgListRsp() => create();
  factory CIMGetMsgListRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGetMsgListRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGetMsgListRsp clone() => CIMGetMsgListRsp()..mergeFromMessage(this);
  CIMGetMsgListRsp copyWith(void Function(CIMGetMsgListRsp) updates) => super.copyWith((message) => updates(message as CIMGetMsgListRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgListRsp create() => CIMGetMsgListRsp._();
  CIMGetMsgListRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgListRsp> createRepeated() => $pb.PbList<CIMGetMsgListRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGetMsgListRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGetMsgListRsp>(create);
  static CIMGetMsgListRsp _defaultInstance;

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
  $fixnum.Int64 get endMsgId => $_getI64(3);
  @$pb.TagNumber(4)
  set endMsgId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasEndMsgId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndMsgId() => clearField(4);

  @$pb.TagNumber(6)
  $core.List<$0.CIMMsgInfo> get msgList => $_getList(4);
}

