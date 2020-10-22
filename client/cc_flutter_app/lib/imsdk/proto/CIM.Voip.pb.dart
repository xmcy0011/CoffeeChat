///
//  Generated code. Do not modify.
//  source: CIM.Voip.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

import 'CIM.Def.pbenum.dart' as $0;

class CIMVoipInviteReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipInviteReq', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'creatorUserId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$fixnum.Int64>(2, 'inviteUserList', $pb.PbFieldType.PU6)
    ..e<$0.CIMVoipInviteType>(3, 'inviteType', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMVoipInviteType.kCIM_VOIP_INVITE_TYPE_UNKNOWN, valueOf: $0.CIMVoipInviteType.valueOf, enumValues: $0.CIMVoipInviteType.values)
    ..aOM<$0.CIMChannelInfo>(4, 'channelInfo', subBuilder: $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipInviteReq._() : super();
  factory CIMVoipInviteReq() => create();
  factory CIMVoipInviteReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipInviteReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipInviteReq clone() => CIMVoipInviteReq()..mergeFromMessage(this);
  CIMVoipInviteReq copyWith(void Function(CIMVoipInviteReq) updates) => super.copyWith((message) => updates(message as CIMVoipInviteReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipInviteReq create() => CIMVoipInviteReq._();
  CIMVoipInviteReq createEmptyInstance() => create();
  static $pb.PbList<CIMVoipInviteReq> createRepeated() => $pb.PbList<CIMVoipInviteReq>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipInviteReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipInviteReq>(create);
  static CIMVoipInviteReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get creatorUserId => $_getI64(0);
  @$pb.TagNumber(1)
  set creatorUserId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreatorUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreatorUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$fixnum.Int64> get inviteUserList => $_getList(1);

  @$pb.TagNumber(3)
  $0.CIMVoipInviteType get inviteType => $_getN(2);
  @$pb.TagNumber(3)
  set inviteType($0.CIMVoipInviteType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasInviteType() => $_has(2);
  @$pb.TagNumber(3)
  void clearInviteType() => clearField(3);

  @$pb.TagNumber(4)
  $0.CIMChannelInfo get channelInfo => $_getN(3);
  @$pb.TagNumber(4)
  set channelInfo($0.CIMChannelInfo v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasChannelInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannelInfo() => clearField(4);
  @$pb.TagNumber(4)
  $0.CIMChannelInfo ensureChannelInfo() => $_ensure(3);
}

class CIMVoipInviteReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipInviteReply', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.CIMInviteRspCode>(2, 'rspCode', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMInviteRspCode.kCIM_VOIP_INVITE_CODE_UNKNOWN, valueOf: $0.CIMInviteRspCode.valueOf, enumValues: $0.CIMInviteRspCode.values)
    ..aOM<$0.CIMChannelInfo>(3, 'channelInfo', subBuilder: $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipInviteReply._() : super();
  factory CIMVoipInviteReply() => create();
  factory CIMVoipInviteReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipInviteReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipInviteReply clone() => CIMVoipInviteReply()..mergeFromMessage(this);
  CIMVoipInviteReply copyWith(void Function(CIMVoipInviteReply) updates) => super.copyWith((message) => updates(message as CIMVoipInviteReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipInviteReply create() => CIMVoipInviteReply._();
  CIMVoipInviteReply createEmptyInstance() => create();
  static $pb.PbList<CIMVoipInviteReply> createRepeated() => $pb.PbList<CIMVoipInviteReply>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipInviteReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipInviteReply>(create);
  static CIMVoipInviteReply _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMInviteRspCode get rspCode => $_getN(1);
  @$pb.TagNumber(2)
  set rspCode($0.CIMInviteRspCode v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRspCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearRspCode() => clearField(2);

  @$pb.TagNumber(3)
  $0.CIMChannelInfo get channelInfo => $_getN(2);
  @$pb.TagNumber(3)
  set channelInfo($0.CIMChannelInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasChannelInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelInfo() => clearField(3);
  @$pb.TagNumber(3)
  $0.CIMChannelInfo ensureChannelInfo() => $_ensure(2);
}

class CIMVoipInviteReplyAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipInviteReplyAck', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..aOM<$0.CIMChannelInfo>(1, 'channelInfo', subBuilder: $0.CIMChannelInfo.create)
    ..hasRequiredFields = false
  ;

  CIMVoipInviteReplyAck._() : super();
  factory CIMVoipInviteReplyAck() => create();
  factory CIMVoipInviteReplyAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipInviteReplyAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipInviteReplyAck clone() => CIMVoipInviteReplyAck()..mergeFromMessage(this);
  CIMVoipInviteReplyAck copyWith(void Function(CIMVoipInviteReplyAck) updates) => super.copyWith((message) => updates(message as CIMVoipInviteReplyAck));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipInviteReplyAck create() => CIMVoipInviteReplyAck._();
  CIMVoipInviteReplyAck createEmptyInstance() => create();
  static $pb.PbList<CIMVoipInviteReplyAck> createRepeated() => $pb.PbList<CIMVoipInviteReplyAck>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipInviteReplyAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipInviteReplyAck>(create);
  static CIMVoipInviteReplyAck _defaultInstance;

  @$pb.TagNumber(1)
  $0.CIMChannelInfo get channelInfo => $_getN(0);
  @$pb.TagNumber(1)
  set channelInfo($0.CIMChannelInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannelInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelInfo() => clearField(1);
  @$pb.TagNumber(1)
  $0.CIMChannelInfo ensureChannelInfo() => $_ensure(0);
}

class CIMVoipHeartbeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipHeartbeat', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  CIMVoipHeartbeat._() : super();
  factory CIMVoipHeartbeat() => create();
  factory CIMVoipHeartbeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipHeartbeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipHeartbeat clone() => CIMVoipHeartbeat()..mergeFromMessage(this);
  CIMVoipHeartbeat copyWith(void Function(CIMVoipHeartbeat) updates) => super.copyWith((message) => updates(message as CIMVoipHeartbeat));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipHeartbeat create() => CIMVoipHeartbeat._();
  CIMVoipHeartbeat createEmptyInstance() => create();
  static $pb.PbList<CIMVoipHeartbeat> createRepeated() => $pb.PbList<CIMVoipHeartbeat>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipHeartbeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipHeartbeat>(create);
  static CIMVoipHeartbeat _defaultInstance;
}

class CIMVoipByeReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipByeReq', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'localCallTimeLen', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.CIMChannelInfo>(3, 'channelInfo', subBuilder: $0.CIMChannelInfo.create)
    ..e<$0.CIMVoipByeReason>(4, 'byeReason', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMVoipByeReason.kCIM_VOIP_BYE_REASON_UNKNOWN, valueOf: $0.CIMVoipByeReason.valueOf, enumValues: $0.CIMVoipByeReason.values)
    ..hasRequiredFields = false
  ;

  CIMVoipByeReq._() : super();
  factory CIMVoipByeReq() => create();
  factory CIMVoipByeReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipByeReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipByeReq clone() => CIMVoipByeReq()..mergeFromMessage(this);
  CIMVoipByeReq copyWith(void Function(CIMVoipByeReq) updates) => super.copyWith((message) => updates(message as CIMVoipByeReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipByeReq create() => CIMVoipByeReq._();
  CIMVoipByeReq createEmptyInstance() => create();
  static $pb.PbList<CIMVoipByeReq> createRepeated() => $pb.PbList<CIMVoipByeReq>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipByeReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipByeReq>(create);
  static CIMVoipByeReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get localCallTimeLen => $_getI64(0);
  @$pb.TagNumber(1)
  set localCallTimeLen($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLocalCallTimeLen() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocalCallTimeLen() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userId => $_getI64(1);
  @$pb.TagNumber(2)
  set userId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $0.CIMChannelInfo get channelInfo => $_getN(2);
  @$pb.TagNumber(3)
  set channelInfo($0.CIMChannelInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasChannelInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelInfo() => clearField(3);
  @$pb.TagNumber(3)
  $0.CIMChannelInfo ensureChannelInfo() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.CIMVoipByeReason get byeReason => $_getN(3);
  @$pb.TagNumber(4)
  set byeReason($0.CIMVoipByeReason v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasByeReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearByeReason() => clearField(4);
}

class CIMVoipByeRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipByeRsp', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..e<$0.CIMErrorCode>(1, 'errorCode', $pb.PbFieldType.OE, defaultOrMaker: $0.CIMErrorCode.kCIM_ERR_UNKNOWN, valueOf: $0.CIMErrorCode.valueOf, enumValues: $0.CIMErrorCode.values)
    ..hasRequiredFields = false
  ;

  CIMVoipByeRsp._() : super();
  factory CIMVoipByeRsp() => create();
  factory CIMVoipByeRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipByeRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipByeRsp clone() => CIMVoipByeRsp()..mergeFromMessage(this);
  CIMVoipByeRsp copyWith(void Function(CIMVoipByeRsp) updates) => super.copyWith((message) => updates(message as CIMVoipByeRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipByeRsp create() => CIMVoipByeRsp._();
  CIMVoipByeRsp createEmptyInstance() => create();
  static $pb.PbList<CIMVoipByeRsp> createRepeated() => $pb.PbList<CIMVoipByeRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipByeRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipByeRsp>(create);
  static CIMVoipByeRsp _defaultInstance;

  @$pb.TagNumber(1)
  $0.CIMErrorCode get errorCode => $_getN(0);
  @$pb.TagNumber(1)
  set errorCode($0.CIMErrorCode v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorCode() => clearField(1);
}

class CIMVoipByeNotify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMVoipByeNotify', package: const $pb.PackageName('CIM.Voip'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.CIMChannelInfo>(2, 'channelInfo', subBuilder: $0.CIMChannelInfo.create)
    ..e<$0.CIMVoipByeReason>(3, 'byeReason', $pb.PbFieldType.OE, protoName: 'byeReason', defaultOrMaker: $0.CIMVoipByeReason.kCIM_VOIP_BYE_REASON_UNKNOWN, valueOf: $0.CIMVoipByeReason.valueOf, enumValues: $0.CIMVoipByeReason.values)
    ..hasRequiredFields = false
  ;

  CIMVoipByeNotify._() : super();
  factory CIMVoipByeNotify() => create();
  factory CIMVoipByeNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMVoipByeNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMVoipByeNotify clone() => CIMVoipByeNotify()..mergeFromMessage(this);
  CIMVoipByeNotify copyWith(void Function(CIMVoipByeNotify) updates) => super.copyWith((message) => updates(message as CIMVoipByeNotify));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMVoipByeNotify create() => CIMVoipByeNotify._();
  CIMVoipByeNotify createEmptyInstance() => create();
  static $pb.PbList<CIMVoipByeNotify> createRepeated() => $pb.PbList<CIMVoipByeNotify>();
  @$core.pragma('dart2js:noInline')
  static CIMVoipByeNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMVoipByeNotify>(create);
  static CIMVoipByeNotify _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.CIMChannelInfo get channelInfo => $_getN(1);
  @$pb.TagNumber(2)
  set channelInfo($0.CIMChannelInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasChannelInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelInfo() => clearField(2);
  @$pb.TagNumber(2)
  $0.CIMChannelInfo ensureChannelInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.CIMVoipByeReason get byeReason => $_getN(2);
  @$pb.TagNumber(3)
  set byeReason($0.CIMVoipByeReason v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasByeReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearByeReason() => clearField(3);
}

