///
//  Generated code. Do not modify.
//  source: CIM.List.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMRecentContactSessionReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMRecentContactSessionReq', package: const $pb.PackageName('CIM.List'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.int>(2, 'latestUpdateTime', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMRecentContactSessionReq() : super();
  CIMRecentContactSessionReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMRecentContactSessionReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMRecentContactSessionReq clone() => CIMRecentContactSessionReq()..mergeFromMessage(this);
  CIMRecentContactSessionReq copyWith(void Function(CIMRecentContactSessionReq) updates) => super.copyWith((message) => updates(message as CIMRecentContactSessionReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMRecentContactSessionReq create() => CIMRecentContactSessionReq();
  CIMRecentContactSessionReq createEmptyInstance() => create();
  static $pb.PbList<CIMRecentContactSessionReq> createRepeated() => $pb.PbList<CIMRecentContactSessionReq>();
  static CIMRecentContactSessionReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMRecentContactSessionReq _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $core.int get latestUpdateTime => $_get(1, 0);
  set latestUpdateTime($core.int v) { $_setUnsignedInt32(1, v); }
  $core.bool hasLatestUpdateTime() => $_has(1);
  void clearLatestUpdateTime() => clearField(2);
}

class CIMRecentContactSessionRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMRecentContactSessionRsp', package: const $pb.PackageName('CIM.List'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.int>(2, 'unreadCounts', $pb.PbFieldType.OU3)
    ..pc<$0.CIMContactSessionInfo>(3, 'contactSessionList', $pb.PbFieldType.PM,$0.CIMContactSessionInfo.create)
    ..hasRequiredFields = false
  ;

  CIMRecentContactSessionRsp() : super();
  CIMRecentContactSessionRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMRecentContactSessionRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMRecentContactSessionRsp clone() => CIMRecentContactSessionRsp()..mergeFromMessage(this);
  CIMRecentContactSessionRsp copyWith(void Function(CIMRecentContactSessionRsp) updates) => super.copyWith((message) => updates(message as CIMRecentContactSessionRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMRecentContactSessionRsp create() => CIMRecentContactSessionRsp();
  CIMRecentContactSessionRsp createEmptyInstance() => create();
  static $pb.PbList<CIMRecentContactSessionRsp> createRepeated() => $pb.PbList<CIMRecentContactSessionRsp>();
  static CIMRecentContactSessionRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMRecentContactSessionRsp _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $core.int get unreadCounts => $_get(1, 0);
  set unreadCounts($core.int v) { $_setUnsignedInt32(1, v); }
  $core.bool hasUnreadCounts() => $_has(1);
  void clearUnreadCounts() => clearField(2);

  $core.List<$0.CIMContactSessionInfo> get contactSessionList => $_getList(2);
}

class CIMGetMsgListReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgListReq', package: const $pb.PackageName('CIM.List'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<Int64>(3, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(4, 'endMsgId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.int>(6, 'limitCount', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMGetMsgListReq() : super();
  CIMGetMsgListReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMGetMsgListReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMGetMsgListReq clone() => CIMGetMsgListReq()..mergeFromMessage(this);
  CIMGetMsgListReq copyWith(void Function(CIMGetMsgListReq) updates) => super.copyWith((message) => updates(message as CIMGetMsgListReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMGetMsgListReq create() => CIMGetMsgListReq();
  CIMGetMsgListReq createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgListReq> createRepeated() => $pb.PbList<CIMGetMsgListReq>();
  static CIMGetMsgListReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMGetMsgListReq _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $0.CIMSessionType get sessionType => $_getN(1);
  set sessionType($0.CIMSessionType v) { setField(2, v); }
  $core.bool hasSessionType() => $_has(1);
  void clearSessionType() => clearField(2);

  Int64 get sessionId => $_getI64(2);
  set sessionId(Int64 v) { $_setInt64(2, v); }
  $core.bool hasSessionId() => $_has(2);
  void clearSessionId() => clearField(3);

  Int64 get endMsgId => $_getI64(3);
  set endMsgId(Int64 v) { $_setInt64(3, v); }
  $core.bool hasEndMsgId() => $_has(3);
  void clearEndMsgId() => clearField(4);

  $core.int get limitCount => $_get(4, 0);
  set limitCount($core.int v) { $_setUnsignedInt32(4, v); }
  $core.bool hasLimitCount() => $_has(4);
  void clearLimitCount() => clearField(6);
}

class CIMGetMsgListRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgListRsp', package: const $pb.PackageName('CIM.List'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<Int64>(3, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(4, 'endMsgId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..pc<$0.CIMMsgInfo>(6, 'msgList', $pb.PbFieldType.PM,$0.CIMMsgInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGetMsgListRsp() : super();
  CIMGetMsgListRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMGetMsgListRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMGetMsgListRsp clone() => CIMGetMsgListRsp()..mergeFromMessage(this);
  CIMGetMsgListRsp copyWith(void Function(CIMGetMsgListRsp) updates) => super.copyWith((message) => updates(message as CIMGetMsgListRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMGetMsgListRsp create() => CIMGetMsgListRsp();
  CIMGetMsgListRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgListRsp> createRepeated() => $pb.PbList<CIMGetMsgListRsp>();
  static CIMGetMsgListRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMGetMsgListRsp _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $0.CIMSessionType get sessionType => $_getN(1);
  set sessionType($0.CIMSessionType v) { setField(2, v); }
  $core.bool hasSessionType() => $_has(1);
  void clearSessionType() => clearField(2);

  Int64 get sessionId => $_getI64(2);
  set sessionId(Int64 v) { $_setInt64(2, v); }
  $core.bool hasSessionId() => $_has(2);
  void clearSessionId() => clearField(3);

  Int64 get endMsgId => $_getI64(3);
  set endMsgId(Int64 v) { $_setInt64(3, v); }
  $core.bool hasEndMsgId() => $_has(3);
  void clearEndMsgId() => clearField(4);

  $core.List<$0.CIMMsgInfo> get msgList => $_getList(4);
}

