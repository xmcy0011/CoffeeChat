///
//  Generated code. Do not modify.
//  source: CIM.Voip.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMVoipInviteReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipInviteReq', package: const $pb.PackageName('CIM.Voip'))
    ..a<Int64>(1, 'creatorUserId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..p<Int64>(2, 'inviteUserList', $pb.PbFieldType.PU6)
    ..e<$0.CIMVoipInviteType>(3, 'inviteType', $pb.PbFieldType.OE, $0.CIMVoipInviteType.kCIM_VOIP_INVITE_TYPE_UNKNOWN, $0.CIMVoipInviteType.valueOf, $0.CIMVoipInviteType.values)
    ..a<$0.CIMChannelInfo>(4, 'channelInfo', $pb.PbFieldType.OM, $0.CIMChannelInfo.getDefault, $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipInviteReq() : super();
  CIMVoipInviteReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipInviteReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipInviteReq clone() => CIMVoipInviteReq()..mergeFromMessage(this);
  CIMVoipInviteReq copyWith(void Function(CIMVoipInviteReq) updates) => super.copyWith((message) => updates(message as CIMVoipInviteReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipInviteReq create() => CIMVoipInviteReq();
  CIMVoipInviteReq createEmptyInstance() => create();
  static $pb.PbList<CIMVoipInviteReq> createRepeated() => $pb.PbList<CIMVoipInviteReq>();
  static CIMVoipInviteReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipInviteReq _defaultInstance;

  Int64 get creatorUserId => $_getI64(0);
  set creatorUserId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasCreatorUserId() => $_has(0);
  void clearCreatorUserId() => clearField(1);

  $core.List<Int64> get inviteUserList => $_getList(1);

  $0.CIMVoipInviteType get inviteType => $_getN(2);
  set inviteType($0.CIMVoipInviteType v) { setField(3, v); }
  $core.bool hasInviteType() => $_has(2);
  void clearInviteType() => clearField(3);

  $0.CIMChannelInfo get channelInfo => $_getN(3);
  set channelInfo($0.CIMChannelInfo v) { setField(4, v); }
  $core.bool hasChannelInfo() => $_has(3);
  void clearChannelInfo() => clearField(4);
}

class CIMVoipInviteReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipInviteReply', package: const $pb.PackageName('CIM.Voip'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMInviteRspCode>(2, 'rspCode', $pb.PbFieldType.OE, $0.CIMInviteRspCode.kCIM_VOIP_INVITE_CODE_UNKNOWN, $0.CIMInviteRspCode.valueOf, $0.CIMInviteRspCode.values)
    ..a<$0.CIMChannelInfo>(3, 'channelInfo', $pb.PbFieldType.OM, $0.CIMChannelInfo.getDefault, $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipInviteReply() : super();
  CIMVoipInviteReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipInviteReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipInviteReply clone() => CIMVoipInviteReply()..mergeFromMessage(this);
  CIMVoipInviteReply copyWith(void Function(CIMVoipInviteReply) updates) => super.copyWith((message) => updates(message as CIMVoipInviteReply));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipInviteReply create() => CIMVoipInviteReply();
  CIMVoipInviteReply createEmptyInstance() => create();
  static $pb.PbList<CIMVoipInviteReply> createRepeated() => $pb.PbList<CIMVoipInviteReply>();
  static CIMVoipInviteReply getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipInviteReply _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $0.CIMInviteRspCode get rspCode => $_getN(1);
  set rspCode($0.CIMInviteRspCode v) { setField(2, v); }
  $core.bool hasRspCode() => $_has(1);
  void clearRspCode() => clearField(2);

  $0.CIMChannelInfo get channelInfo => $_getN(2);
  set channelInfo($0.CIMChannelInfo v) { setField(3, v); }
  $core.bool hasChannelInfo() => $_has(2);
  void clearChannelInfo() => clearField(3);
}

class CIMVoipInviteReplyAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipInviteReplyAck', package: const $pb.PackageName('CIM.Voip'))
    ..a<$0.CIMChannelInfo>(1, 'channelInfo', $pb.PbFieldType.OM, $0.CIMChannelInfo.getDefault, $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipInviteReplyAck() : super();
  CIMVoipInviteReplyAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipInviteReplyAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipInviteReplyAck clone() => CIMVoipInviteReplyAck()..mergeFromMessage(this);
  CIMVoipInviteReplyAck copyWith(void Function(CIMVoipInviteReplyAck) updates) => super.copyWith((message) => updates(message as CIMVoipInviteReplyAck));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipInviteReplyAck create() => CIMVoipInviteReplyAck();
  CIMVoipInviteReplyAck createEmptyInstance() => create();
  static $pb.PbList<CIMVoipInviteReplyAck> createRepeated() => $pb.PbList<CIMVoipInviteReplyAck>();
  static CIMVoipInviteReplyAck getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipInviteReplyAck _defaultInstance;

  $0.CIMChannelInfo get channelInfo => $_getN(0);
  set channelInfo($0.CIMChannelInfo v) { setField(1, v); }
  $core.bool hasChannelInfo() => $_has(0);
  void clearChannelInfo() => clearField(1);
}

class CIMVoipHeartbeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipHeartbeat', package: const $pb.PackageName('CIM.Voip'))
    ..hasRequiredFields = false
  ;

  CIMVoipHeartbeat() : super();
  CIMVoipHeartbeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipHeartbeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipHeartbeat clone() => CIMVoipHeartbeat()..mergeFromMessage(this);
  CIMVoipHeartbeat copyWith(void Function(CIMVoipHeartbeat) updates) => super.copyWith((message) => updates(message as CIMVoipHeartbeat));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipHeartbeat create() => CIMVoipHeartbeat();
  CIMVoipHeartbeat createEmptyInstance() => create();
  static $pb.PbList<CIMVoipHeartbeat> createRepeated() => $pb.PbList<CIMVoipHeartbeat>();
  static CIMVoipHeartbeat getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipHeartbeat _defaultInstance;
}

class CIMVoipByeReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipByeReq', package: const $pb.PackageName('CIM.Voip'))
    ..a<Int64>(1, 'localCallTimeLen', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$0.CIMChannelInfo>(3, 'channelInfo', $pb.PbFieldType.OM, $0.CIMChannelInfo.getDefault, $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipByeReq() : super();
  CIMVoipByeReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipByeReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipByeReq clone() => CIMVoipByeReq()..mergeFromMessage(this);
  CIMVoipByeReq copyWith(void Function(CIMVoipByeReq) updates) => super.copyWith((message) => updates(message as CIMVoipByeReq));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipByeReq create() => CIMVoipByeReq();
  CIMVoipByeReq createEmptyInstance() => create();
  static $pb.PbList<CIMVoipByeReq> createRepeated() => $pb.PbList<CIMVoipByeReq>();
  static CIMVoipByeReq getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipByeReq _defaultInstance;

  Int64 get localCallTimeLen => $_getI64(0);
  set localCallTimeLen(Int64 v) { $_setInt64(0, v); }
  $core.bool hasLocalCallTimeLen() => $_has(0);
  void clearLocalCallTimeLen() => clearField(1);

  Int64 get userId => $_getI64(1);
  set userId(Int64 v) { $_setInt64(1, v); }
  $core.bool hasUserId() => $_has(1);
  void clearUserId() => clearField(2);

  $0.CIMChannelInfo get channelInfo => $_getN(2);
  set channelInfo($0.CIMChannelInfo v) { setField(3, v); }
  $core.bool hasChannelInfo() => $_has(2);
  void clearChannelInfo() => clearField(3);
}

class CIMVoipByeRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipByeRsp', package: const $pb.PackageName('CIM.Voip'))
    ..e<$0.CIMErrorCode>(1, 'errorCode', $pb.PbFieldType.OE, $0.CIMErrorCode.kCIM_ERR_SUCCSSE, $0.CIMErrorCode.valueOf, $0.CIMErrorCode.values)
    ..hasRequiredFields = false
  ;

  CIMVoipByeRsp() : super();
  CIMVoipByeRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipByeRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipByeRsp clone() => CIMVoipByeRsp()..mergeFromMessage(this);
  CIMVoipByeRsp copyWith(void Function(CIMVoipByeRsp) updates) => super.copyWith((message) => updates(message as CIMVoipByeRsp));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipByeRsp create() => CIMVoipByeRsp();
  CIMVoipByeRsp createEmptyInstance() => create();
  static $pb.PbList<CIMVoipByeRsp> createRepeated() => $pb.PbList<CIMVoipByeRsp>();
  static CIMVoipByeRsp getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipByeRsp _defaultInstance;

  $0.CIMErrorCode get errorCode => $_getN(0);
  set errorCode($0.CIMErrorCode v) { setField(1, v); }
  $core.bool hasErrorCode() => $_has(0);
  void clearErrorCode() => clearField(1);
}

class CIMVoipByeNotify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipByeNotify', package: const $pb.PackageName('CIM.Voip'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<$0.CIMVoipByeReason>(2, 'byeReason', $pb.PbFieldType.OE, $0.CIMVoipByeReason.kCIM_VOIP_BYE_REASON_UNKNOWN, $0.CIMVoipByeReason.valueOf, $0.CIMVoipByeReason.values)
    ..hasRequiredFields = false
  ;

  CIMVoipByeNotify() : super();
  CIMVoipByeNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMVoipByeNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMVoipByeNotify clone() => CIMVoipByeNotify()..mergeFromMessage(this);
  CIMVoipByeNotify copyWith(void Function(CIMVoipByeNotify) updates) => super.copyWith((message) => updates(message as CIMVoipByeNotify));
  $pb.BuilderInfo get info_ => _i;
  static CIMVoipByeNotify create() => CIMVoipByeNotify();
  CIMVoipByeNotify createEmptyInstance() => create();
  static $pb.PbList<CIMVoipByeNotify> createRepeated() => $pb.PbList<CIMVoipByeNotify>();
  static CIMVoipByeNotify getDefault() => _defaultInstance ??= create()..freeze();
  static CIMVoipByeNotify _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $0.CIMVoipByeReason get byeReason => $_getN(1);
  set byeReason($0.CIMVoipByeReason v) { setField(2, v); }
  $core.bool hasByeReason() => $_has(1);
  void clearByeReason() => clearField(2);
}

