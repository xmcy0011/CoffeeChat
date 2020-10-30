///
//  Generated code. Do not modify.
//  source: CIM.Def.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pbenum.dart';

export 'CIM.Def.pbenum.dart';

class CIMUserInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMUserInfo', package: const $pb.PackageName('CIM.Def'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, 'nickName')
    ..aOS(3, 'nickNameSpell')
    ..aOS(9, 'phone')
    ..aOS(10, 'avatarUrl')
    ..aOS(11, 'attachInfo')
    ..hasRequiredFields = false
  ;

  CIMUserInfo._() : super();
  factory CIMUserInfo() => create();
  factory CIMUserInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMUserInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMUserInfo clone() => CIMUserInfo()..mergeFromMessage(this);
  CIMUserInfo copyWith(void Function(CIMUserInfo) updates) => super.copyWith((message) => updates(message as CIMUserInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMUserInfo create() => CIMUserInfo._();
  CIMUserInfo createEmptyInstance() => create();
  static $pb.PbList<CIMUserInfo> createRepeated() => $pb.PbList<CIMUserInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMUserInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMUserInfo>(create);
  static CIMUserInfo _defaultInstance;

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
  $core.String get nickNameSpell => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickNameSpell($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNickNameSpell() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickNameSpell() => clearField(3);

  @$pb.TagNumber(9)
  $core.String get phone => $_getSZ(3);
  @$pb.TagNumber(9)
  set phone($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(9)
  $core.bool hasPhone() => $_has(3);
  @$pb.TagNumber(9)
  void clearPhone() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get avatarUrl => $_getSZ(4);
  @$pb.TagNumber(10)
  set avatarUrl($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(10)
  $core.bool hasAvatarUrl() => $_has(4);
  @$pb.TagNumber(10)
  void clearAvatarUrl() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get attachInfo => $_getSZ(5);
  @$pb.TagNumber(11)
  set attachInfo($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(11)
  $core.bool hasAttachInfo() => $_has(5);
  @$pb.TagNumber(11)
  void clearAttachInfo() => clearField(11);
}

class CIMContactSessionInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMContactSessionInfo', package: const $pb.PackageName('CIM.Def'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'sessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: CIMSessionType.valueOf, enumValues: CIMSessionType.values)
    ..e<CIMSessionStatusType>(3, 'sessionStatus', $pb.PbFieldType.OE, defaultOrMaker: CIMSessionStatusType.kCIM_SESSION_STATUS_UNKNOWN, valueOf: CIMSessionStatusType.valueOf, enumValues: CIMSessionStatusType.values)
    ..a<$core.int>(4, 'unreadCnt', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, 'updatedTime', $pb.PbFieldType.OU3)
    ..aOS(6, 'msgId')
    ..a<$fixnum.Int64>(7, 'serverMsgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(8, 'msgTimeStamp', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(9, 'msgData', $pb.PbFieldType.OY)
    ..e<CIMMsgType>(10, 'msgType', $pb.PbFieldType.OE, defaultOrMaker: CIMMsgType.kCIM_MSG_TYPE_UNKNOWN, valueOf: CIMMsgType.valueOf, enumValues: CIMMsgType.values)
    ..a<$fixnum.Int64>(11, 'msgFromUserId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<CIMMsgStatus>(12, 'msgStatus', $pb.PbFieldType.OE, defaultOrMaker: CIMMsgStatus.kCIM_MSG_STATUS_NONE, valueOf: CIMMsgStatus.valueOf, enumValues: CIMMsgStatus.values)
    ..aOS(13, 'msgAttach')
    ..aOS(14, 'extendData')
    ..aOB(15, 'isRobotSession')
    ..hasRequiredFields = false
  ;

  CIMContactSessionInfo._() : super();
  factory CIMContactSessionInfo() => create();
  factory CIMContactSessionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMContactSessionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMContactSessionInfo clone() => CIMContactSessionInfo()..mergeFromMessage(this);
  CIMContactSessionInfo copyWith(void Function(CIMContactSessionInfo) updates) => super.copyWith((message) => updates(message as CIMContactSessionInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMContactSessionInfo create() => CIMContactSessionInfo._();
  CIMContactSessionInfo createEmptyInstance() => create();
  static $pb.PbList<CIMContactSessionInfo> createRepeated() => $pb.PbList<CIMContactSessionInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMContactSessionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMContactSessionInfo>(create);
  static CIMContactSessionInfo _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sessionId => $_getI64(0);
  @$pb.TagNumber(1)
  set sessionId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  CIMSessionType get sessionType => $_getN(1);
  @$pb.TagNumber(2)
  set sessionType(CIMSessionType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionType() => clearField(2);

  @$pb.TagNumber(3)
  CIMSessionStatusType get sessionStatus => $_getN(2);
  @$pb.TagNumber(3)
  set sessionStatus(CIMSessionStatusType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionStatus() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get unreadCnt => $_getIZ(3);
  @$pb.TagNumber(4)
  set unreadCnt($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnreadCnt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadCnt() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get updatedTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set updatedTime($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUpdatedTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedTime() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get msgId => $_getSZ(5);
  @$pb.TagNumber(6)
  set msgId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMsgId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMsgId() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get serverMsgId => $_getI64(6);
  @$pb.TagNumber(7)
  set serverMsgId($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasServerMsgId() => $_has(6);
  @$pb.TagNumber(7)
  void clearServerMsgId() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get msgTimeStamp => $_getIZ(7);
  @$pb.TagNumber(8)
  set msgTimeStamp($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMsgTimeStamp() => $_has(7);
  @$pb.TagNumber(8)
  void clearMsgTimeStamp() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get msgData => $_getN(8);
  @$pb.TagNumber(9)
  set msgData($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMsgData() => $_has(8);
  @$pb.TagNumber(9)
  void clearMsgData() => clearField(9);

  @$pb.TagNumber(10)
  CIMMsgType get msgType => $_getN(9);
  @$pb.TagNumber(10)
  set msgType(CIMMsgType v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasMsgType() => $_has(9);
  @$pb.TagNumber(10)
  void clearMsgType() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get msgFromUserId => $_getI64(10);
  @$pb.TagNumber(11)
  set msgFromUserId($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasMsgFromUserId() => $_has(10);
  @$pb.TagNumber(11)
  void clearMsgFromUserId() => clearField(11);

  @$pb.TagNumber(12)
  CIMMsgStatus get msgStatus => $_getN(11);
  @$pb.TagNumber(12)
  set msgStatus(CIMMsgStatus v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasMsgStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearMsgStatus() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get msgAttach => $_getSZ(12);
  @$pb.TagNumber(13)
  set msgAttach($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasMsgAttach() => $_has(12);
  @$pb.TagNumber(13)
  void clearMsgAttach() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get extendData => $_getSZ(13);
  @$pb.TagNumber(14)
  set extendData($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasExtendData() => $_has(13);
  @$pb.TagNumber(14)
  void clearExtendData() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get isRobotSession => $_getBF(14);
  @$pb.TagNumber(15)
  set isRobotSession($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasIsRobotSession() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsRobotSession() => clearField(15);
}

class CIMMsgInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgInfo', package: const $pb.PackageName('CIM.Def'), createEmptyInstance: create)
    ..aOS(1, 'clientMsgId')
    ..a<$fixnum.Int64>(2, 'serverMsgId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<CIMResCode>(3, 'msgResCode', $pb.PbFieldType.OE, defaultOrMaker: CIMResCode.kCIM_RES_CODE_UNKNOWN, valueOf: CIMResCode.valueOf, enumValues: CIMResCode.values)
    ..e<CIMMsgFeature>(4, 'msgFeature', $pb.PbFieldType.OE, defaultOrMaker: CIMMsgFeature.kCIM_MSG_FEATURE_DEFAULT, valueOf: CIMMsgFeature.valueOf, enumValues: CIMMsgFeature.values)
    ..e<CIMSessionType>(5, 'sessionType', $pb.PbFieldType.OE, defaultOrMaker: CIMSessionType.kCIM_SESSION_TYPE_Invalid, valueOf: CIMSessionType.valueOf, enumValues: CIMSessionType.values)
    ..a<$fixnum.Int64>(6, 'fromUserId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, 'toSessionId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(8, 'createTime', $pb.PbFieldType.OU3)
    ..e<CIMMsgType>(9, 'msgType', $pb.PbFieldType.OE, defaultOrMaker: CIMMsgType.kCIM_MSG_TYPE_UNKNOWN, valueOf: CIMMsgType.valueOf, enumValues: CIMMsgType.values)
    ..e<CIMMsgStatus>(10, 'msgStatus', $pb.PbFieldType.OE, defaultOrMaker: CIMMsgStatus.kCIM_MSG_STATUS_NONE, valueOf: CIMMsgStatus.valueOf, enumValues: CIMMsgStatus.values)
    ..a<$core.List<$core.int>>(11, 'msgData', $pb.PbFieldType.OY)
    ..aOS(12, 'attach')
    ..e<CIMClientType>(13, 'senderClientType', $pb.PbFieldType.OE, defaultOrMaker: CIMClientType.kCIM_CLIENT_TYPE_DEFAULT, valueOf: CIMClientType.valueOf, enumValues: CIMClientType.values)
    ..hasRequiredFields = false
  ;

  CIMMsgInfo._() : super();
  factory CIMMsgInfo() => create();
  factory CIMMsgInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMMsgInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMMsgInfo clone() => CIMMsgInfo()..mergeFromMessage(this);
  CIMMsgInfo copyWith(void Function(CIMMsgInfo) updates) => super.copyWith((message) => updates(message as CIMMsgInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMMsgInfo create() => CIMMsgInfo._();
  CIMMsgInfo createEmptyInstance() => create();
  static $pb.PbList<CIMMsgInfo> createRepeated() => $pb.PbList<CIMMsgInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMMsgInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMMsgInfo>(create);
  static CIMMsgInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientMsgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientMsgId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientMsgId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get serverMsgId => $_getI64(1);
  @$pb.TagNumber(2)
  set serverMsgId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServerMsgId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerMsgId() => clearField(2);

  @$pb.TagNumber(3)
  CIMResCode get msgResCode => $_getN(2);
  @$pb.TagNumber(3)
  set msgResCode(CIMResCode v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMsgResCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsgResCode() => clearField(3);

  @$pb.TagNumber(4)
  CIMMsgFeature get msgFeature => $_getN(3);
  @$pb.TagNumber(4)
  set msgFeature(CIMMsgFeature v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMsgFeature() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsgFeature() => clearField(4);

  @$pb.TagNumber(5)
  CIMSessionType get sessionType => $_getN(4);
  @$pb.TagNumber(5)
  set sessionType(CIMSessionType v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSessionType() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionType() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get fromUserId => $_getI64(5);
  @$pb.TagNumber(6)
  set fromUserId($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFromUserId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFromUserId() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get toSessionId => $_getI64(6);
  @$pb.TagNumber(7)
  set toSessionId($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasToSessionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearToSessionId() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get createTime => $_getIZ(7);
  @$pb.TagNumber(8)
  set createTime($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreateTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreateTime() => clearField(8);

  @$pb.TagNumber(9)
  CIMMsgType get msgType => $_getN(8);
  @$pb.TagNumber(9)
  set msgType(CIMMsgType v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasMsgType() => $_has(8);
  @$pb.TagNumber(9)
  void clearMsgType() => clearField(9);

  @$pb.TagNumber(10)
  CIMMsgStatus get msgStatus => $_getN(9);
  @$pb.TagNumber(10)
  set msgStatus(CIMMsgStatus v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasMsgStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearMsgStatus() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.int> get msgData => $_getN(10);
  @$pb.TagNumber(11)
  set msgData($core.List<$core.int> v) { $_setBytes(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasMsgData() => $_has(10);
  @$pb.TagNumber(11)
  void clearMsgData() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get attach => $_getSZ(11);
  @$pb.TagNumber(12)
  set attach($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAttach() => $_has(11);
  @$pb.TagNumber(12)
  void clearAttach() => clearField(12);

  @$pb.TagNumber(13)
  CIMClientType get senderClientType => $_getN(12);
  @$pb.TagNumber(13)
  set senderClientType(CIMClientType v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasSenderClientType() => $_has(12);
  @$pb.TagNumber(13)
  void clearSenderClientType() => clearField(13);
}

class CIMChannelInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMChannelInfo', package: const $pb.PackageName('CIM.Def'), createEmptyInstance: create)
    ..aOS(1, 'channelName')
    ..aOS(2, 'channelToken')
    ..a<$fixnum.Int64>(3, 'creatorId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMChannelInfo._() : super();
  factory CIMChannelInfo() => create();
  factory CIMChannelInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMChannelInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMChannelInfo clone() => CIMChannelInfo()..mergeFromMessage(this);
  CIMChannelInfo copyWith(void Function(CIMChannelInfo) updates) => super.copyWith((message) => updates(message as CIMChannelInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMChannelInfo create() => CIMChannelInfo._();
  CIMChannelInfo createEmptyInstance() => create();
  static $pb.PbList<CIMChannelInfo> createRepeated() => $pb.PbList<CIMChannelInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMChannelInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMChannelInfo>(create);
  static CIMChannelInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelName => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannelName() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get channelToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set channelToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChannelToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelToken() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get creatorId => $_getI64(2);
  @$pb.TagNumber(3)
  set creatorId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorId() => clearField(3);
}

