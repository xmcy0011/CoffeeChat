///
//  Generated code. Do not modify.
//  source: CIM.Group.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Group.pbenum.dart';

export 'CIM.Group.pbenum.dart';

class CIMGroupCreateReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupCreateReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, 'groupName')
    ..p<$fixnum.Int64>(3, 'memberIdList', $pb.PbFieldType.PU6)
    ..hasRequiredFields = false
  ;

  CIMGroupCreateReq._() : super();
  factory CIMGroupCreateReq() => create();
  factory CIMGroupCreateReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupCreateReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupCreateReq clone() => CIMGroupCreateReq()..mergeFromMessage(this);
  CIMGroupCreateReq copyWith(void Function(CIMGroupCreateReq) updates) => super.copyWith((message) => updates(message as CIMGroupCreateReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupCreateReq create() => CIMGroupCreateReq._();
  CIMGroupCreateReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupCreateReq> createRepeated() => $pb.PbList<CIMGroupCreateReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupCreateReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupCreateReq>(create);
  static CIMGroupCreateReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get groupName => $_getSZ(1);
  @$pb.TagNumber(2)
  set groupName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupName() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$fixnum.Int64> get memberIdList => $_getList(2);
}

class CIMGroupCreateRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupCreateRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'resultCode', $pb.PbFieldType.OU3)
    ..aOM<CIMGroupInfo>(3, 'groupInfo', subBuilder: CIMGroupInfo.create)
    ..p<$fixnum.Int64>(4, 'memberIdList', $pb.PbFieldType.PU6)
    ..a<$core.List<$core.int>>(10, 'attachNotificatinoMsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMGroupCreateRsp._() : super();
  factory CIMGroupCreateRsp() => create();
  factory CIMGroupCreateRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupCreateRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupCreateRsp clone() => CIMGroupCreateRsp()..mergeFromMessage(this);
  CIMGroupCreateRsp copyWith(void Function(CIMGroupCreateRsp) updates) => super.copyWith((message) => updates(message as CIMGroupCreateRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupCreateRsp create() => CIMGroupCreateRsp._();
  CIMGroupCreateRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupCreateRsp> createRepeated() => $pb.PbList<CIMGroupCreateRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupCreateRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupCreateRsp>(create);
  static CIMGroupCreateRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get resultCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set resultCode($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResultCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultCode() => clearField(2);

  @$pb.TagNumber(3)
  CIMGroupInfo get groupInfo => $_getN(2);
  @$pb.TagNumber(3)
  set groupInfo(CIMGroupInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasGroupInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupInfo() => clearField(3);
  @$pb.TagNumber(3)
  CIMGroupInfo ensureGroupInfo() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$fixnum.Int64> get memberIdList => $_getList(3);

  @$pb.TagNumber(10)
  $core.List<$core.int> get attachNotificatinoMsg => $_getN(4);
  @$pb.TagNumber(10)
  set attachNotificatinoMsg($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(10)
  $core.bool hasAttachNotificatinoMsg() => $_has(4);
  @$pb.TagNumber(10)
  void clearAttachNotificatinoMsg() => clearField(10);
}

class CIMGroupDisbandingReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupDisbandingReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMGroupDisbandingReq._() : super();
  factory CIMGroupDisbandingReq() => create();
  factory CIMGroupDisbandingReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupDisbandingReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupDisbandingReq clone() => CIMGroupDisbandingReq()..mergeFromMessage(this);
  CIMGroupDisbandingReq copyWith(void Function(CIMGroupDisbandingReq) updates) => super.copyWith((message) => updates(message as CIMGroupDisbandingReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupDisbandingReq create() => CIMGroupDisbandingReq._();
  CIMGroupDisbandingReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupDisbandingReq> createRepeated() => $pb.PbList<CIMGroupDisbandingReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupDisbandingReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupDisbandingReq>(create);
  static CIMGroupDisbandingReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);
}

class CIMGroupDisbandingRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupDisbandingRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, 'resultCode', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(10, 'attachNotificatinoMsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMGroupDisbandingRsp._() : super();
  factory CIMGroupDisbandingRsp() => create();
  factory CIMGroupDisbandingRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupDisbandingRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupDisbandingRsp clone() => CIMGroupDisbandingRsp()..mergeFromMessage(this);
  CIMGroupDisbandingRsp copyWith(void Function(CIMGroupDisbandingRsp) updates) => super.copyWith((message) => updates(message as CIMGroupDisbandingRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupDisbandingRsp create() => CIMGroupDisbandingRsp._();
  CIMGroupDisbandingRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupDisbandingRsp> createRepeated() => $pb.PbList<CIMGroupDisbandingRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupDisbandingRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupDisbandingRsp>(create);
  static CIMGroupDisbandingRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resultCode => $_getIZ(2);
  @$pb.TagNumber(3)
  set resultCode($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResultCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearResultCode() => clearField(3);

  @$pb.TagNumber(10)
  $core.List<$core.int> get attachNotificatinoMsg => $_getN(3);
  @$pb.TagNumber(10)
  set attachNotificatinoMsg($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(10)
  $core.bool hasAttachNotificatinoMsg() => $_has(3);
  @$pb.TagNumber(10)
  void clearAttachNotificatinoMsg() => clearField(10);
}

class CIMGroupExitReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupExitReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMGroupExitReq._() : super();
  factory CIMGroupExitReq() => create();
  factory CIMGroupExitReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupExitReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupExitReq clone() => CIMGroupExitReq()..mergeFromMessage(this);
  CIMGroupExitReq copyWith(void Function(CIMGroupExitReq) updates) => super.copyWith((message) => updates(message as CIMGroupExitReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupExitReq create() => CIMGroupExitReq._();
  CIMGroupExitReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupExitReq> createRepeated() => $pb.PbList<CIMGroupExitReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupExitReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupExitReq>(create);
  static CIMGroupExitReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);
}

class CIMGroupExitRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupExitRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, 'resultCode', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(10, 'attachNotificatinoMsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMGroupExitRsp._() : super();
  factory CIMGroupExitRsp() => create();
  factory CIMGroupExitRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupExitRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupExitRsp clone() => CIMGroupExitRsp()..mergeFromMessage(this);
  CIMGroupExitRsp copyWith(void Function(CIMGroupExitRsp) updates) => super.copyWith((message) => updates(message as CIMGroupExitRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupExitRsp create() => CIMGroupExitRsp._();
  CIMGroupExitRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupExitRsp> createRepeated() => $pb.PbList<CIMGroupExitRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupExitRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupExitRsp>(create);
  static CIMGroupExitRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resultCode => $_getIZ(2);
  @$pb.TagNumber(3)
  set resultCode($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResultCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearResultCode() => clearField(3);

  @$pb.TagNumber(10)
  $core.List<$core.int> get attachNotificatinoMsg => $_getN(3);
  @$pb.TagNumber(10)
  set attachNotificatinoMsg($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(10)
  $core.bool hasAttachNotificatinoMsg() => $_has(3);
  @$pb.TagNumber(10)
  void clearAttachNotificatinoMsg() => clearField(10);
}

class CIMGroupListReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupListReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMGroupListReq._() : super();
  factory CIMGroupListReq() => create();
  factory CIMGroupListReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupListReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupListReq clone() => CIMGroupListReq()..mergeFromMessage(this);
  CIMGroupListReq copyWith(void Function(CIMGroupListReq) updates) => super.copyWith((message) => updates(message as CIMGroupListReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupListReq create() => CIMGroupListReq._();
  CIMGroupListReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupListReq> createRepeated() => $pb.PbList<CIMGroupListReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupListReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupListReq>(create);
  static CIMGroupListReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class CIMGroupListRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupListRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<CIMGroupVersionInfo>(2, 'groupVersionList', $pb.PbFieldType.PM, subBuilder: CIMGroupVersionInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGroupListRsp._() : super();
  factory CIMGroupListRsp() => create();
  factory CIMGroupListRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupListRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupListRsp clone() => CIMGroupListRsp()..mergeFromMessage(this);
  CIMGroupListRsp copyWith(void Function(CIMGroupListRsp) updates) => super.copyWith((message) => updates(message as CIMGroupListRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupListRsp create() => CIMGroupListRsp._();
  CIMGroupListRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupListRsp> createRepeated() => $pb.PbList<CIMGroupListRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupListRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupListRsp>(create);
  static CIMGroupListRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<CIMGroupVersionInfo> get groupVersionList => $_getList(1);
}

class CIMGroupInfoReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupInfoReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<CIMGroupVersionInfo>(2, 'groupVersionList', $pb.PbFieldType.PM, subBuilder: CIMGroupVersionInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGroupInfoReq._() : super();
  factory CIMGroupInfoReq() => create();
  factory CIMGroupInfoReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupInfoReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupInfoReq clone() => CIMGroupInfoReq()..mergeFromMessage(this);
  CIMGroupInfoReq copyWith(void Function(CIMGroupInfoReq) updates) => super.copyWith((message) => updates(message as CIMGroupInfoReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupInfoReq create() => CIMGroupInfoReq._();
  CIMGroupInfoReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupInfoReq> createRepeated() => $pb.PbList<CIMGroupInfoReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupInfoReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupInfoReq>(create);
  static CIMGroupInfoReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<CIMGroupVersionInfo> get groupVersionList => $_getList(1);
}

class CIMGroupInfoRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupInfoRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'resultCode', $pb.PbFieldType.OU3)
    ..pc<CIMGroupInfo>(3, 'groupInfoList', $pb.PbFieldType.PM, subBuilder: CIMGroupInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGroupInfoRsp._() : super();
  factory CIMGroupInfoRsp() => create();
  factory CIMGroupInfoRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupInfoRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupInfoRsp clone() => CIMGroupInfoRsp()..mergeFromMessage(this);
  CIMGroupInfoRsp copyWith(void Function(CIMGroupInfoRsp) updates) => super.copyWith((message) => updates(message as CIMGroupInfoRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupInfoRsp create() => CIMGroupInfoRsp._();
  CIMGroupInfoRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupInfoRsp> createRepeated() => $pb.PbList<CIMGroupInfoRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupInfoRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupInfoRsp>(create);
  static CIMGroupInfoRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get resultCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set resultCode($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResultCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<CIMGroupInfo> get groupInfoList => $_getList(2);
}

class CIMGroupInviteMemberReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupInviteMemberReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$fixnum.Int64>(3, 'memberIdList', $pb.PbFieldType.PU6)
    ..hasRequiredFields = false
  ;

  CIMGroupInviteMemberReq._() : super();
  factory CIMGroupInviteMemberReq() => create();
  factory CIMGroupInviteMemberReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupInviteMemberReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupInviteMemberReq clone() => CIMGroupInviteMemberReq()..mergeFromMessage(this);
  CIMGroupInviteMemberReq copyWith(void Function(CIMGroupInviteMemberReq) updates) => super.copyWith((message) => updates(message as CIMGroupInviteMemberReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupInviteMemberReq create() => CIMGroupInviteMemberReq._();
  CIMGroupInviteMemberReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupInviteMemberReq> createRepeated() => $pb.PbList<CIMGroupInviteMemberReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupInviteMemberReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupInviteMemberReq>(create);
  static CIMGroupInviteMemberReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$fixnum.Int64> get memberIdList => $_getList(2);
}

class CIMGroupInviteMemberRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupInviteMemberRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, 'resultCode', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(10, 'attachNotificatinoMsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMGroupInviteMemberRsp._() : super();
  factory CIMGroupInviteMemberRsp() => create();
  factory CIMGroupInviteMemberRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupInviteMemberRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupInviteMemberRsp clone() => CIMGroupInviteMemberRsp()..mergeFromMessage(this);
  CIMGroupInviteMemberRsp copyWith(void Function(CIMGroupInviteMemberRsp) updates) => super.copyWith((message) => updates(message as CIMGroupInviteMemberRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupInviteMemberRsp create() => CIMGroupInviteMemberRsp._();
  CIMGroupInviteMemberRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupInviteMemberRsp> createRepeated() => $pb.PbList<CIMGroupInviteMemberRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupInviteMemberRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupInviteMemberRsp>(create);
  static CIMGroupInviteMemberRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resultCode => $_getIZ(2);
  @$pb.TagNumber(3)
  set resultCode($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResultCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearResultCode() => clearField(3);

  @$pb.TagNumber(10)
  $core.List<$core.int> get attachNotificatinoMsg => $_getN(3);
  @$pb.TagNumber(10)
  set attachNotificatinoMsg($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(10)
  $core.bool hasAttachNotificatinoMsg() => $_has(3);
  @$pb.TagNumber(10)
  void clearAttachNotificatinoMsg() => clearField(10);
}

class CIMGroupKickOutMemberReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupKickOutMemberReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$fixnum.Int64>(3, 'memberIdList', $pb.PbFieldType.PU6)
    ..hasRequiredFields = false
  ;

  CIMGroupKickOutMemberReq._() : super();
  factory CIMGroupKickOutMemberReq() => create();
  factory CIMGroupKickOutMemberReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupKickOutMemberReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupKickOutMemberReq clone() => CIMGroupKickOutMemberReq()..mergeFromMessage(this);
  CIMGroupKickOutMemberReq copyWith(void Function(CIMGroupKickOutMemberReq) updates) => super.copyWith((message) => updates(message as CIMGroupKickOutMemberReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupKickOutMemberReq create() => CIMGroupKickOutMemberReq._();
  CIMGroupKickOutMemberReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupKickOutMemberReq> createRepeated() => $pb.PbList<CIMGroupKickOutMemberReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupKickOutMemberReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupKickOutMemberReq>(create);
  static CIMGroupKickOutMemberReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$fixnum.Int64> get memberIdList => $_getList(2);
}

class CIMGroupKickOutMemberRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupKickOutMemberRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, 'resultCode', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(10, 'attachNotificatinoMsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CIMGroupKickOutMemberRsp._() : super();
  factory CIMGroupKickOutMemberRsp() => create();
  factory CIMGroupKickOutMemberRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupKickOutMemberRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupKickOutMemberRsp clone() => CIMGroupKickOutMemberRsp()..mergeFromMessage(this);
  CIMGroupKickOutMemberRsp copyWith(void Function(CIMGroupKickOutMemberRsp) updates) => super.copyWith((message) => updates(message as CIMGroupKickOutMemberRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupKickOutMemberRsp create() => CIMGroupKickOutMemberRsp._();
  CIMGroupKickOutMemberRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupKickOutMemberRsp> createRepeated() => $pb.PbList<CIMGroupKickOutMemberRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupKickOutMemberRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupKickOutMemberRsp>(create);
  static CIMGroupKickOutMemberRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resultCode => $_getIZ(2);
  @$pb.TagNumber(3)
  set resultCode($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResultCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearResultCode() => clearField(3);

  @$pb.TagNumber(10)
  $core.List<$core.int> get attachNotificatinoMsg => $_getN(3);
  @$pb.TagNumber(10)
  set attachNotificatinoMsg($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(10)
  $core.bool hasAttachNotificatinoMsg() => $_has(3);
  @$pb.TagNumber(10)
  void clearAttachNotificatinoMsg() => clearField(10);
}

class CIMGroupMemberListReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupMemberListReq', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMGroupMemberListReq._() : super();
  factory CIMGroupMemberListReq() => create();
  factory CIMGroupMemberListReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupMemberListReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupMemberListReq clone() => CIMGroupMemberListReq()..mergeFromMessage(this);
  CIMGroupMemberListReq copyWith(void Function(CIMGroupMemberListReq) updates) => super.copyWith((message) => updates(message as CIMGroupMemberListReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberListReq create() => CIMGroupMemberListReq._();
  CIMGroupMemberListReq createEmptyInstance() => create();
  static $pb.PbList<CIMGroupMemberListReq> createRepeated() => $pb.PbList<CIMGroupMemberListReq>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberListReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupMemberListReq>(create);
  static CIMGroupMemberListReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);
}

class CIMGroupMemberListRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupMemberListRsp', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$fixnum.Int64>(3, 'memberIdList', $pb.PbFieldType.PU6)
    ..hasRequiredFields = false
  ;

  CIMGroupMemberListRsp._() : super();
  factory CIMGroupMemberListRsp() => create();
  factory CIMGroupMemberListRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupMemberListRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupMemberListRsp clone() => CIMGroupMemberListRsp()..mergeFromMessage(this);
  CIMGroupMemberListRsp copyWith(void Function(CIMGroupMemberListRsp) updates) => super.copyWith((message) => updates(message as CIMGroupMemberListRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberListRsp create() => CIMGroupMemberListRsp._();
  CIMGroupMemberListRsp createEmptyInstance() => create();
  static $pb.PbList<CIMGroupMemberListRsp> createRepeated() => $pb.PbList<CIMGroupMemberListRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberListRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupMemberListRsp>(create);
  static CIMGroupMemberListRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$fixnum.Int64> get memberIdList => $_getList(2);
}

class CIMGroupMemberChangedNotify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupMemberChangedNotify', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<CIMGroupMemberChangedInfo>(3, 'changedList', $pb.PbFieldType.PM, subBuilder: CIMGroupMemberChangedInfo.create)
    ..hasRequiredFields = false
  ;

  CIMGroupMemberChangedNotify._() : super();
  factory CIMGroupMemberChangedNotify() => create();
  factory CIMGroupMemberChangedNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupMemberChangedNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupMemberChangedNotify clone() => CIMGroupMemberChangedNotify()..mergeFromMessage(this);
  CIMGroupMemberChangedNotify copyWith(void Function(CIMGroupMemberChangedNotify) updates) => super.copyWith((message) => updates(message as CIMGroupMemberChangedNotify));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberChangedNotify create() => CIMGroupMemberChangedNotify._();
  CIMGroupMemberChangedNotify createEmptyInstance() => create();
  static $pb.PbList<CIMGroupMemberChangedNotify> createRepeated() => $pb.PbList<CIMGroupMemberChangedNotify>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberChangedNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupMemberChangedNotify>(create);
  static CIMGroupMemberChangedNotify _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<CIMGroupMemberChangedInfo> get changedList => $_getList(2);
}

class CIMGroupMemberChangedInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupMemberChangedInfo', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<CIMGroupMemberChangedType>(2, 'type', $pb.PbFieldType.OE, defaultOrMaker: CIMGroupMemberChangedType.kCIM_GROUP_MEMBER_CHANGED_TYPE_DEFAULT, valueOf: CIMGroupMemberChangedType.valueOf, enumValues: CIMGroupMemberChangedType.values)
    ..hasRequiredFields = false
  ;

  CIMGroupMemberChangedInfo._() : super();
  factory CIMGroupMemberChangedInfo() => create();
  factory CIMGroupMemberChangedInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupMemberChangedInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupMemberChangedInfo clone() => CIMGroupMemberChangedInfo()..mergeFromMessage(this);
  CIMGroupMemberChangedInfo copyWith(void Function(CIMGroupMemberChangedInfo) updates) => super.copyWith((message) => updates(message as CIMGroupMemberChangedInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberChangedInfo create() => CIMGroupMemberChangedInfo._();
  CIMGroupMemberChangedInfo createEmptyInstance() => create();
  static $pb.PbList<CIMGroupMemberChangedInfo> createRepeated() => $pb.PbList<CIMGroupMemberChangedInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupMemberChangedInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupMemberChangedInfo>(create);
  static CIMGroupMemberChangedInfo _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  CIMGroupMemberChangedType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(CIMGroupMemberChangedType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);
}

class CIMGroupInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupInfo', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, 'groupName')
    ..e<CIMGroupType>(3, 'groupType', $pb.PbFieldType.OE, defaultOrMaker: CIMGroupType.kCIM_GROUP_TYPE_UNKNOWN, valueOf: CIMGroupType.valueOf, enumValues: CIMGroupType.values)
    ..e<CIMGroupJoinModel>(4, 'joinModel', $pb.PbFieldType.OE, defaultOrMaker: CIMGroupJoinModel.kCIM_GROUP_JOIN_MODEL_DEFAULT, valueOf: CIMGroupJoinModel.valueOf, enumValues: CIMGroupJoinModel.values)
    ..e<CIMGroupBeInviteMode>(5, 'beInviteModel', $pb.PbFieldType.OE, defaultOrMaker: CIMGroupBeInviteMode.kCIM_GROUP_BE_INVITE_MODEL_DEFAULT, valueOf: CIMGroupBeInviteMode.valueOf, enumValues: CIMGroupBeInviteMode.values)
    ..e<CIMGroupMuteModel>(6, 'muteModel', $pb.PbFieldType.OE, defaultOrMaker: CIMGroupMuteModel.kCIM_GROUP_MUTE_MODEL_DEFAULT, valueOf: CIMGroupMuteModel.valueOf, enumValues: CIMGroupMuteModel.values)
    ..a<$fixnum.Int64>(7, 'groupOwnerId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(8, 'createTime', $pb.PbFieldType.OU3)
    ..a<$core.int>(9, 'updateTime', $pb.PbFieldType.OU3)
    ..aOS(10, 'groupIntro')
    ..aOS(11, 'announcement')
    ..aOS(12, 'groupAvatar')
    ..hasRequiredFields = false
  ;

  CIMGroupInfo._() : super();
  factory CIMGroupInfo() => create();
  factory CIMGroupInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupInfo clone() => CIMGroupInfo()..mergeFromMessage(this);
  CIMGroupInfo copyWith(void Function(CIMGroupInfo) updates) => super.copyWith((message) => updates(message as CIMGroupInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupInfo create() => CIMGroupInfo._();
  CIMGroupInfo createEmptyInstance() => create();
  static $pb.PbList<CIMGroupInfo> createRepeated() => $pb.PbList<CIMGroupInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupInfo>(create);
  static CIMGroupInfo _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get groupName => $_getSZ(1);
  @$pb.TagNumber(2)
  set groupName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupName() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupName() => clearField(2);

  @$pb.TagNumber(3)
  CIMGroupType get groupType => $_getN(2);
  @$pb.TagNumber(3)
  set groupType(CIMGroupType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasGroupType() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupType() => clearField(3);

  @$pb.TagNumber(4)
  CIMGroupJoinModel get joinModel => $_getN(3);
  @$pb.TagNumber(4)
  set joinModel(CIMGroupJoinModel v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasJoinModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinModel() => clearField(4);

  @$pb.TagNumber(5)
  CIMGroupBeInviteMode get beInviteModel => $_getN(4);
  @$pb.TagNumber(5)
  set beInviteModel(CIMGroupBeInviteMode v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasBeInviteModel() => $_has(4);
  @$pb.TagNumber(5)
  void clearBeInviteModel() => clearField(5);

  @$pb.TagNumber(6)
  CIMGroupMuteModel get muteModel => $_getN(5);
  @$pb.TagNumber(6)
  set muteModel(CIMGroupMuteModel v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasMuteModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearMuteModel() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get groupOwnerId => $_getI64(6);
  @$pb.TagNumber(7)
  set groupOwnerId($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGroupOwnerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroupOwnerId() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get createTime => $_getIZ(7);
  @$pb.TagNumber(8)
  set createTime($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreateTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreateTime() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get updateTime => $_getIZ(8);
  @$pb.TagNumber(9)
  set updateTime($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdateTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdateTime() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get groupIntro => $_getSZ(9);
  @$pb.TagNumber(10)
  set groupIntro($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasGroupIntro() => $_has(9);
  @$pb.TagNumber(10)
  void clearGroupIntro() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get announcement => $_getSZ(10);
  @$pb.TagNumber(11)
  set announcement($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAnnouncement() => $_has(10);
  @$pb.TagNumber(11)
  void clearAnnouncement() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get groupAvatar => $_getSZ(11);
  @$pb.TagNumber(12)
  set groupAvatar($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasGroupAvatar() => $_has(11);
  @$pb.TagNumber(12)
  void clearGroupAvatar() => clearField(12);
}

class CIMGroupVersionInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMGroupVersionInfo', package: const $pb.PackageName('CIM.Group'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'groupId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'groupVersion', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CIMGroupVersionInfo._() : super();
  factory CIMGroupVersionInfo() => create();
  factory CIMGroupVersionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMGroupVersionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMGroupVersionInfo clone() => CIMGroupVersionInfo()..mergeFromMessage(this);
  CIMGroupVersionInfo copyWith(void Function(CIMGroupVersionInfo) updates) => super.copyWith((message) => updates(message as CIMGroupVersionInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMGroupVersionInfo create() => CIMGroupVersionInfo._();
  CIMGroupVersionInfo createEmptyInstance() => create();
  static $pb.PbList<CIMGroupVersionInfo> createRepeated() => $pb.PbList<CIMGroupVersionInfo>();
  @$core.pragma('dart2js:noInline')
  static CIMGroupVersionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMGroupVersionInfo>(create);
  static CIMGroupVersionInfo _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get groupVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set groupVersion($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupVersion() => clearField(2);
}

