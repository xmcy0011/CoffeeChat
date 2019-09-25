///
//  Generated code. Do not modify.
//  source: CIM.Message.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMMsgData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgData', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'fromUserId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'toSessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(3, 'msgId')
    ..a<$core.int>(4, 'createTime', $pb.PbFieldType.O3)
    ..e<$0.CIMMsgType>(5, 'msgType', $pb.PbFieldType.OE, $0.CIMMsgType.kCIM_MSG_TYPE_UNKNOWN, $0.CIMMsgType.valueOf, $0.CIMMsgType.values)
    ..e<$0.CIMSessionType>(6, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<$core.List<$core.int>>(7, 'msgData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMMsgData() : super();
  CIMMsgData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMMsgData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMMsgData clone() => CIMMsgData()..mergeFromMessage(this);
  CIMMsgData copyWith(void Function(CIMMsgData) updates) => super.copyWith((message) => updates(message as CIMMsgData));
  $pb.BuilderInfo get info_ => _i;
  static CIMMsgData create() => CIMMsgData();
  CIMMsgData createEmptyInstance() => create();
  static $pb.PbList<CIMMsgData> createRepeated() => $pb.PbList<CIMMsgData>();
  static CIMMsgData getDefault() => _defaultInstance ??= create()..freeze();
  static CIMMsgData _defaultInstance;

  Int64 get fromUserId => $_getI64(0);
  set fromUserId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasFromUserId() => $_has(0);
  void clearFromUserId() => clearField(1);

  Int64 get toSessionId => $_getI64(1);
  set toSessionId(Int64 v) { $_setInt64(1, v); }
  $core.bool hasToSessionId() => $_has(1);
  void clearToSessionId() => clearField(2);

  $core.String get msgId => $_getS(2, '');
  set msgId($core.String v) { $_setString(2, v); }
  $core.bool hasMsgId() => $_has(2);
  void clearMsgId() => clearField(3);

  $core.int get createTime => $_get(3, 0);
  set createTime($core.int v) { $_setSignedInt32(3, v); }
  $core.bool hasCreateTime() => $_has(3);
  void clearCreateTime() => clearField(4);

  $0.CIMMsgType get msgType => $_getN(4);
  set msgType($0.CIMMsgType v) { setField(5, v); }
  $core.bool hasMsgType() => $_has(4);
  void clearMsgType() => clearField(5);

  $0.CIMSessionType get sessionType => $_getN(5);
  set sessionType($0.CIMSessionType v) { setField(6, v); }
  $core.bool hasSessionType() => $_has(5);
  void clearSessionType() => clearField(6);

  $core.List<$core.int> get msgData => $_getN(6);
  set msgData($core.List<$core.int> v) { $_setBytes(6, v); }
  $core.bool hasMsgData() => $_has(6);
  void clearMsgData() => clearField(7);
}

class CIMMsgDataAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgDataAck', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'fromUserId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'toSessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(3, 'serverMsgId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(4, 'msgId')
    ..e<$0.CIMResCode>(5, 'resCode', $pb.PbFieldType.OE, $0.CIMResCode.kCIM_RES_CODE_OK, $0.CIMResCode.valueOf, $0.CIMResCode.values)
    ..e<$0.CIMSessionType>(6, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<$core.int>(7, 'createTime', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CIMMsgDataAck() : super();
  CIMMsgDataAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMMsgDataAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMMsgDataAck clone() => CIMMsgDataAck()..mergeFromMessage(this);
  CIMMsgDataAck copyWith(void Function(CIMMsgDataAck) updates) => super.copyWith((message) => updates(message as CIMMsgDataAck));
  $pb.BuilderInfo get info_ => _i;
  static CIMMsgDataAck create() => CIMMsgDataAck();
  CIMMsgDataAck createEmptyInstance() => create();
  static $pb.PbList<CIMMsgDataAck> createRepeated() => $pb.PbList<CIMMsgDataAck>();
  static CIMMsgDataAck getDefault() => _defaultInstance ??= create()..freeze();
  static CIMMsgDataAck _defaultInstance;

  Int64 get fromUserId => $_getI64(0);
  set fromUserId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasFromUserId() => $_has(0);
  void clearFromUserId() => clearField(1);

  Int64 get toSessionId => $_getI64(1);
  set toSessionId(Int64 v) { $_setInt64(1, v); }
  $core.bool hasToSessionId() => $_has(1);
  void clearToSessionId() => clearField(2);

  Int64 get serverMsgId => $_getI64(2);
  set serverMsgId(Int64 v) { $_setInt64(2, v); }
  $core.bool hasServerMsgId() => $_has(2);
  void clearServerMsgId() => clearField(3);

  $core.String get msgId => $_getS(3, '');
  set msgId($core.String v) { $_setString(3, v); }
  $core.bool hasMsgId() => $_has(3);
  void clearMsgId() => clearField(4);

  $0.CIMResCode get resCode => $_getN(4);
  set resCode($0.CIMResCode v) { setField(5, v); }
  $core.bool hasResCode() => $_has(4);
  void clearResCode() => clearField(5);

  $0.CIMSessionType get sessionType => $_getN(5);
  set sessionType($0.CIMSessionType v) { setField(6, v); }
  $core.bool hasSessionType() => $_has(5);
  void clearSessionType() => clearField(6);

  $core.int get createTime => $_get(6, 0);
  set createTime($core.int v) { $_setSignedInt32(6, v); }
  $core.bool hasCreateTime() => $_has(6);
  void clearCreateTime() => clearField(7);
}

class CIMMsgDataReadAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgDataReadAck', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(3, 'msgId')
    ..e<$0.CIMSessionType>(4, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..hasRequiredFields = false
  ;

  CIMMsgDataReadAck() : super();
  CIMMsgDataReadAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMMsgDataReadAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMMsgDataReadAck clone() => CIMMsgDataReadAck()..mergeFromMessage(this);
  CIMMsgDataReadAck copyWith(void Function(CIMMsgDataReadAck) updates) => super.copyWith((message) => updates(message as CIMMsgDataReadAck));
  $pb.BuilderInfo get info_ => _i;
  static CIMMsgDataReadAck create() => CIMMsgDataReadAck();
  CIMMsgDataReadAck createEmptyInstance() => create();
  static $pb.PbList<CIMMsgDataReadAck> createRepeated() => $pb.PbList<CIMMsgDataReadAck>();
  static CIMMsgDataReadAck getDefault() => _defaultInstance ??= create()..freeze();
  static CIMMsgDataReadAck _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  Int64 get sessionId => $_getI64(1);
  set sessionId(Int64 v) { $_setInt64(1, v); }
  $core.bool hasSessionId() => $_has(1);
  void clearSessionId() => clearField(2);

  $core.String get msgId => $_getS(2, '');
  set msgId($core.String v) { $_setString(2, v); }
  $core.bool hasMsgId() => $_has(2);
  void clearMsgId() => clearField(3);

  $0.CIMSessionType get sessionType => $_getN(3);
  set sessionType($0.CIMSessionType v) { setField(4, v); }
  $core.bool hasSessionType() => $_has(3);
  void clearSessionType() => clearField(4);
}

class CIMMsgDataReadNotify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgDataReadNotify', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(3, 'msgId')
    ..e<$0.CIMSessionType>(4, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..hasRequiredFields = false
  ;

  CIMMsgDataReadNotify() : super();
  CIMMsgDataReadNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMMsgDataReadNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMMsgDataReadNotify clone() => CIMMsgDataReadNotify()..mergeFromMessage(this);
  CIMMsgDataReadNotify copyWith(void Function(CIMMsgDataReadNotify) updates) => super.copyWith((message) => updates(message as CIMMsgDataReadNotify));
  $pb.BuilderInfo get info_ => _i;
  static CIMMsgDataReadNotify create() => CIMMsgDataReadNotify();
  CIMMsgDataReadNotify createEmptyInstance() => create();
  static $pb.PbList<CIMMsgDataReadNotify> createRepeated() => $pb.PbList<CIMMsgDataReadNotify>();
  static CIMMsgDataReadNotify getDefault() => _defaultInstance ??= create()..freeze();
  static CIMMsgDataReadNotify _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  Int64 get sessionId => $_getI64(1);
  set sessionId(Int64 v) { $_setInt64(1, v); }
  $core.bool hasSessionId() => $_has(1);
  void clearSessionId() => clearField(2);

  $core.String get msgId => $_getS(2, '');
  set msgId($core.String v) { $_setString(2, v); }
  $core.bool hasMsgId() => $_has(2);
  void clearMsgId() => clearField(3);

  $0.CIMSessionType get sessionType => $_getN(3);
  set sessionType($0.CIMSessionType v) { setField(4, v); }
  $core.bool hasSessionType() => $_has(3);
  void clearSessionType() => clearField(4);
}

class CIMGetLatestMsgIdReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetLatestMsgIdReq', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<Int64>(3, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMGetLatestMsgIdReq() : super();
  CIMGetLatestMsgIdReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMGetLatestMsgIdReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMGetLatestMsgIdReq clone() => CIMGetLatestMsgIdReq()..mergeFromMessage(this);
  CIMGetLatestMsgIdReq copyWith(void Function(CIMGetLatestMsgIdReq) updates) => super.copyWith((message) => updates(message as CIMGetLatestMsgIdReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMGetLatestMsgIdReq create() => CIMGetLatestMsgIdReq();
  CIMGetLatestMsgIdReq createEmptyInstance() => create();
  static $pb.PbList<CIMGetLatestMsgIdReq> createRepeated() => $pb.PbList<CIMGetLatestMsgIdReq>();
  static CIMGetLatestMsgIdReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMGetLatestMsgIdReq _defaultInstance;

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
}

class CIMGetLatestMsgIdRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetLatestMsgIdRsp', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<Int64>(3, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(4, 'latestMsgId')
    ..hasRequiredFields = false
  ;

  CIMGetLatestMsgIdRsp() : super();
  CIMGetLatestMsgIdRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMGetLatestMsgIdRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMGetLatestMsgIdRsp clone() => CIMGetLatestMsgIdRsp()..mergeFromMessage(this);
  CIMGetLatestMsgIdRsp copyWith(void Function(CIMGetLatestMsgIdRsp) updates) => super.copyWith((message) => updates(message as CIMGetLatestMsgIdRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMGetLatestMsgIdRsp create() => CIMGetLatestMsgIdRsp();
  CIMGetLatestMsgIdRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGetLatestMsgIdRsp> createRepeated() => $pb.PbList<CIMGetLatestMsgIdRsp>();
  static CIMGetLatestMsgIdRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMGetLatestMsgIdRsp _defaultInstance;

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

  $core.String get latestMsgId => $_getS(3, '');
  set latestMsgId($core.String v) { $_setString(3, v); }
  $core.bool hasLatestMsgId() => $_has(3);
  void clearLatestMsgId() => clearField(4);
}

class CIMGetMsgByIdReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgByIdReq', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<Int64>(3, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..pPS(4, 'msgIdList')
    ..hasRequiredFields = false
  ;

  CIMGetMsgByIdReq() : super();
  CIMGetMsgByIdReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMGetMsgByIdReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMGetMsgByIdReq clone() => CIMGetMsgByIdReq()..mergeFromMessage(this);
  CIMGetMsgByIdReq copyWith(void Function(CIMGetMsgByIdReq) updates) => super.copyWith((message) => updates(message as CIMGetMsgByIdReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMGetMsgByIdReq create() => CIMGetMsgByIdReq();
  CIMGetMsgByIdReq createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgByIdReq> createRepeated() => $pb.PbList<CIMGetMsgByIdReq>();
  static CIMGetMsgByIdReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMGetMsgByIdReq _defaultInstance;

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

  $core.List<$core.String> get msgIdList => $_getList(3);
}

class CIMGetMsgByIdRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGetMsgByIdRsp', package: const $pb.PackageName('CIM.Message'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, $0.CIMSessionType.kCIM_SESSION_TYPE_Invalid, $0.CIMSessionType.valueOf, $0.CIMSessionType.values)
    ..a<Int64>(3, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..pc<$0.CIMMsgInfo>(4, 'msgList', $pb.PbFieldType.PM,$0.CIMMsgInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGetMsgByIdRsp() : super();
  CIMGetMsgByIdRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMGetMsgByIdRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMGetMsgByIdRsp clone() => CIMGetMsgByIdRsp()..mergeFromMessage(this);
  CIMGetMsgByIdRsp copyWith(void Function(CIMGetMsgByIdRsp) updates) => super.copyWith((message) => updates(message as CIMGetMsgByIdRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMGetMsgByIdRsp create() => CIMGetMsgByIdRsp();
  CIMGetMsgByIdRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGetMsgByIdRsp> createRepeated() => $pb.PbList<CIMGetMsgByIdRsp>();
  static CIMGetMsgByIdRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMGetMsgByIdRsp _defaultInstance;

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

  $core.List<$0.CIMMsgInfo> get msgList => $_getList(3);
}

