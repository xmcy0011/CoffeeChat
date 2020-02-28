///
//  Generated code. Do not modify.
//  source: CIM.Def.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pbenum.dart';

export 'CIM.Def.pbenum.dart';

class CIMUserInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMUserInfo', package: const $pb.PackageName('CIM.Def'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'nickName')
    ..aOS(11, 'attachInfo')
    ..hasRequiredFields = false
  ;

  CIMUserInfo() : super();
  CIMUserInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMUserInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMUserInfo clone() => CIMUserInfo()..mergeFromMessage(this);
  CIMUserInfo copyWith(void Function(CIMUserInfo) updates) => super.copyWith((message) => updates(message as CIMUserInfo));
  $pb.BuilderInfo get info_ => _i;
  static CIMUserInfo create() => CIMUserInfo();
  CIMUserInfo createEmptyInstance() => create();
  static $pb.PbList<CIMUserInfo> createRepeated() => $pb.PbList<CIMUserInfo>();
  static CIMUserInfo getDefault() => _defaultInstance ??= create()..freeze();
  static CIMUserInfo _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $core.String get nickName => $_getS(1, '');
  set nickName($core.String v) { $_setString(1, v); }
  $core.bool hasNickName() => $_has(1);
  void clearNickName() => clearField(2);

  $core.String get attachInfo => $_getS(2, '');
  set attachInfo($core.String v) { $_setString(2, v); }
  $core.bool hasAttachInfo() => $_has(2);
  void clearAttachInfo() => clearField(11);
}

class CIMContactSessionInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMContactSessionInfo', package: const $pb.PackageName('CIM.Def'))
    ..a<Int64>(1, 'sessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<CIMSessionType>(2, 'sessionType', $pb.PbFieldType.OE, CIMSessionType.kCIM_SESSION_TYPE_Invalid, CIMSessionType.valueOf, CIMSessionType.values)
    ..e<CIMSessionStatusType>(3, 'sessionStatus', $pb.PbFieldType.OE, CIMSessionStatusType.kCIM_SESSION_STATUS_UNKNOWN, CIMSessionStatusType.valueOf, CIMSessionStatusType.values)
    ..a<$core.int>(4, 'unreadCnt', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, 'updatedTime', $pb.PbFieldType.OU3)
    ..aOS(6, 'msgId')
    ..a<Int64>(7, 'serverMsgId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.int>(8, 'msgTimeStamp', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(9, 'msgData', $pb.PbFieldType.OY)
    ..e<CIMMsgType>(10, 'msgType', $pb.PbFieldType.OE, CIMMsgType.kCIM_MSG_TYPE_UNKNOWN, CIMMsgType.valueOf, CIMMsgType.values)
    ..a<Int64>(11, 'msgFromUserId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<CIMMsgStatus>(12, 'msgStatus', $pb.PbFieldType.OE, CIMMsgStatus.kCIM_MSG_STATUS_NONE, CIMMsgStatus.valueOf, CIMMsgStatus.values)
    ..aOS(13, 'msgAttach')
    ..aOS(14, 'extendData')
    ..aOB(15, 'isRobotSession')
    ..hasRequiredFields = false
  ;

  CIMContactSessionInfo() : super();
  CIMContactSessionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMContactSessionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMContactSessionInfo clone() => CIMContactSessionInfo()..mergeFromMessage(this);
  CIMContactSessionInfo copyWith(void Function(CIMContactSessionInfo) updates) => super.copyWith((message) => updates(message as CIMContactSessionInfo));
  $pb.BuilderInfo get info_ => _i;
  static CIMContactSessionInfo create() => CIMContactSessionInfo();
  CIMContactSessionInfo createEmptyInstance() => create();
  static $pb.PbList<CIMContactSessionInfo> createRepeated() => $pb.PbList<CIMContactSessionInfo>();
  static CIMContactSessionInfo getDefault() => _defaultInstance ??= create()..freeze();
  static CIMContactSessionInfo _defaultInstance;

  Int64 get sessionId => $_getI64(0);
  set sessionId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasSessionId() => $_has(0);
  void clearSessionId() => clearField(1);

  CIMSessionType get sessionType => $_getN(1);
  set sessionType(CIMSessionType v) { setField(2, v); }
  $core.bool hasSessionType() => $_has(1);
  void clearSessionType() => clearField(2);

  CIMSessionStatusType get sessionStatus => $_getN(2);
  set sessionStatus(CIMSessionStatusType v) { setField(3, v); }
  $core.bool hasSessionStatus() => $_has(2);
  void clearSessionStatus() => clearField(3);

  $core.int get unreadCnt => $_get(3, 0);
  set unreadCnt($core.int v) { $_setUnsignedInt32(3, v); }
  $core.bool hasUnreadCnt() => $_has(3);
  void clearUnreadCnt() => clearField(4);

  $core.int get updatedTime => $_get(4, 0);
  set updatedTime($core.int v) { $_setUnsignedInt32(4, v); }
  $core.bool hasUpdatedTime() => $_has(4);
  void clearUpdatedTime() => clearField(5);

  $core.String get msgId => $_getS(5, '');
  set msgId($core.String v) { $_setString(5, v); }
  $core.bool hasMsgId() => $_has(5);
  void clearMsgId() => clearField(6);

  Int64 get serverMsgId => $_getI64(6);
  set serverMsgId(Int64 v) { $_setInt64(6, v); }
  $core.bool hasServerMsgId() => $_has(6);
  void clearServerMsgId() => clearField(7);

  $core.int get msgTimeStamp => $_get(7, 0);
  set msgTimeStamp($core.int v) { $_setUnsignedInt32(7, v); }
  $core.bool hasMsgTimeStamp() => $_has(7);
  void clearMsgTimeStamp() => clearField(8);

  $core.List<$core.int> get msgData => $_getN(8);
  set msgData($core.List<$core.int> v) { $_setBytes(8, v); }
  $core.bool hasMsgData() => $_has(8);
  void clearMsgData() => clearField(9);

  CIMMsgType get msgType => $_getN(9);
  set msgType(CIMMsgType v) { setField(10, v); }
  $core.bool hasMsgType() => $_has(9);
  void clearMsgType() => clearField(10);

  Int64 get msgFromUserId => $_getI64(10);
  set msgFromUserId(Int64 v) { $_setInt64(10, v); }
  $core.bool hasMsgFromUserId() => $_has(10);
  void clearMsgFromUserId() => clearField(11);

  CIMMsgStatus get msgStatus => $_getN(11);
  set msgStatus(CIMMsgStatus v) { setField(12, v); }
  $core.bool hasMsgStatus() => $_has(11);
  void clearMsgStatus() => clearField(12);

  $core.String get msgAttach => $_getS(12, '');
  set msgAttach($core.String v) { $_setString(12, v); }
  $core.bool hasMsgAttach() => $_has(12);
  void clearMsgAttach() => clearField(13);

  $core.String get extendData => $_getS(13, '');
  set extendData($core.String v) { $_setString(13, v); }
  $core.bool hasExtendData() => $_has(13);
  void clearExtendData() => clearField(14);

  $core.bool get isRobotSession => $_get(14, false);
  set isRobotSession($core.bool v) { $_setBool(14, v); }
  $core.bool hasIsRobotSession() => $_has(14);
  void clearIsRobotSession() => clearField(15);
}

class CIMMsgInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMMsgInfo', package: const $pb.PackageName('CIM.Def'))
    ..aOS(1, 'clientMsgId')
    ..a<Int64>(2, 'serverMsgId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<CIMResCode>(3, 'msgResCode', $pb.PbFieldType.OE, CIMResCode.kCIM_RES_CODE_UNKNOWN, CIMResCode.valueOf, CIMResCode.values)
    ..e<CIMMsgFeature>(4, 'msgFeature', $pb.PbFieldType.OE, CIMMsgFeature.kCIM_MSG_FEATURE_DEFAULT, CIMMsgFeature.valueOf, CIMMsgFeature.values)
    ..e<CIMSessionType>(5, 'sessionType', $pb.PbFieldType.OE, CIMSessionType.kCIM_SESSION_TYPE_Invalid, CIMSessionType.valueOf, CIMSessionType.values)
    ..a<Int64>(6, 'fromUserId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(7, 'toSessionId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.int>(8, 'createTime', $pb.PbFieldType.OU3)
    ..e<CIMMsgType>(9, 'msgType', $pb.PbFieldType.OE, CIMMsgType.kCIM_MSG_TYPE_UNKNOWN, CIMMsgType.valueOf, CIMMsgType.values)
    ..e<CIMMsgStatus>(10, 'msgStatus', $pb.PbFieldType.OE, CIMMsgStatus.kCIM_MSG_STATUS_NONE, CIMMsgStatus.valueOf, CIMMsgStatus.values)
    ..a<$core.List<$core.int>>(11, 'msgData', $pb.PbFieldType.OY)
    ..aOS(12, 'attach')
    ..e<CIMClientType>(13, 'senderClientType', $pb.PbFieldType.OE, CIMClientType.kCIM_CLIENT_TYPE_DEFAULT, CIMClientType.valueOf, CIMClientType.values)
    ..hasRequiredFields = false
  ;

  CIMMsgInfo() : super();
  CIMMsgInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMMsgInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMMsgInfo clone() => CIMMsgInfo()..mergeFromMessage(this);
  CIMMsgInfo copyWith(void Function(CIMMsgInfo) updates) => super.copyWith((message) => updates(message as CIMMsgInfo));
  $pb.BuilderInfo get info_ => _i;
  static CIMMsgInfo create() => CIMMsgInfo();
  CIMMsgInfo createEmptyInstance() => create();
  static $pb.PbList<CIMMsgInfo> createRepeated() => $pb.PbList<CIMMsgInfo>();
  static CIMMsgInfo getDefault() => _defaultInstance ??= create()..freeze();
  static CIMMsgInfo _defaultInstance;

  $core.String get clientMsgId => $_getS(0, '');
  set clientMsgId($core.String v) { $_setString(0, v); }
  $core.bool hasClientMsgId() => $_has(0);
  void clearClientMsgId() => clearField(1);

  Int64 get serverMsgId => $_getI64(1);
  set serverMsgId(Int64 v) { $_setInt64(1, v); }
  $core.bool hasServerMsgId() => $_has(1);
  void clearServerMsgId() => clearField(2);

  CIMResCode get msgResCode => $_getN(2);
  set msgResCode(CIMResCode v) { setField(3, v); }
  $core.bool hasMsgResCode() => $_has(2);
  void clearMsgResCode() => clearField(3);

  CIMMsgFeature get msgFeature => $_getN(3);
  set msgFeature(CIMMsgFeature v) { setField(4, v); }
  $core.bool hasMsgFeature() => $_has(3);
  void clearMsgFeature() => clearField(4);

  CIMSessionType get sessionType => $_getN(4);
  set sessionType(CIMSessionType v) { setField(5, v); }
  $core.bool hasSessionType() => $_has(4);
  void clearSessionType() => clearField(5);

  Int64 get fromUserId => $_getI64(5);
  set fromUserId(Int64 v) { $_setInt64(5, v); }
  $core.bool hasFromUserId() => $_has(5);
  void clearFromUserId() => clearField(6);

  Int64 get toSessionId => $_getI64(6);
  set toSessionId(Int64 v) { $_setInt64(6, v); }
  $core.bool hasToSessionId() => $_has(6);
  void clearToSessionId() => clearField(7);

  $core.int get createTime => $_get(7, 0);
  set createTime($core.int v) { $_setUnsignedInt32(7, v); }
  $core.bool hasCreateTime() => $_has(7);
  void clearCreateTime() => clearField(8);

  CIMMsgType get msgType => $_getN(8);
  set msgType(CIMMsgType v) { setField(9, v); }
  $core.bool hasMsgType() => $_has(8);
  void clearMsgType() => clearField(9);

  CIMMsgStatus get msgStatus => $_getN(9);
  set msgStatus(CIMMsgStatus v) { setField(10, v); }
  $core.bool hasMsgStatus() => $_has(9);
  void clearMsgStatus() => clearField(10);

  $core.List<$core.int> get msgData => $_getN(10);
  set msgData($core.List<$core.int> v) { $_setBytes(10, v); }
  $core.bool hasMsgData() => $_has(10);
  void clearMsgData() => clearField(11);

  $core.String get attach => $_getS(11, '');
  set attach($core.String v) { $_setString(11, v); }
  $core.bool hasAttach() => $_has(11);
  void clearAttach() => clearField(12);

  CIMClientType get senderClientType => $_getN(12);
  set senderClientType(CIMClientType v) { setField(13, v); }
  $core.bool hasSenderClientType() => $_has(12);
  void clearSenderClientType() => clearField(13);
}

class CIMChannelInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMChannelInfo', package: const $pb.PackageName('CIM.Def'))
    ..aOS(1, 'channelName')
    ..aOS(2, 'channelToken')
    ..a<Int64>(3, 'creatorId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMChannelInfo() : super();
  CIMChannelInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMChannelInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMChannelInfo clone() => CIMChannelInfo()..mergeFromMessage(this);
  CIMChannelInfo copyWith(void Function(CIMChannelInfo) updates) => super.copyWith((message) => updates(message as CIMChannelInfo));
  $pb.BuilderInfo get info_ => _i;
  static CIMChannelInfo create() => CIMChannelInfo();
  CIMChannelInfo createEmptyInstance() => create();
  static $pb.PbList<CIMChannelInfo> createRepeated() => $pb.PbList<CIMChannelInfo>();
  static CIMChannelInfo getDefault() => _defaultInstance ??= create()..freeze();
  static CIMChannelInfo _defaultInstance;

  $core.String get channelName => $_getS(0, '');
  set channelName($core.String v) { $_setString(0, v); }
  $core.bool hasChannelName() => $_has(0);
  void clearChannelName() => clearField(1);

  $core.String get channelToken => $_getS(1, '');
  set channelToken($core.String v) { $_setString(1, v); }
  $core.bool hasChannelToken() => $_has(1);
  void clearChannelToken() => clearField(2);

  Int64 get creatorId => $_getI64(2);
  set creatorId(Int64 v) { $_setInt64(2, v); }
  $core.bool hasCreatorId() => $_has(2);
  void clearCreatorId() => clearField(3);
}

