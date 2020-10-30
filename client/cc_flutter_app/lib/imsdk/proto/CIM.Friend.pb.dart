///
//  Generated code. Do not modify.
//  source: CIM.Friend.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Def.pb.dart' as $0;

class CIMFriendQueryUserListReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMFriendQueryUserListReq', package: const $pb.PackageName('CIM.Friend'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CIMFriendQueryUserListReq._() : super();
  factory CIMFriendQueryUserListReq() => create();
  factory CIMFriendQueryUserListReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMFriendQueryUserListReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMFriendQueryUserListReq clone() => CIMFriendQueryUserListReq()..mergeFromMessage(this);
  CIMFriendQueryUserListReq copyWith(void Function(CIMFriendQueryUserListReq) updates) => super.copyWith((message) => updates(message as CIMFriendQueryUserListReq));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMFriendQueryUserListReq create() => CIMFriendQueryUserListReq._();
  CIMFriendQueryUserListReq createEmptyInstance() => create();
  static $pb.PbList<CIMFriendQueryUserListReq> createRepeated() => $pb.PbList<CIMFriendQueryUserListReq>();
  @$core.pragma('dart2js:noInline')
  static CIMFriendQueryUserListReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMFriendQueryUserListReq>(create);
  static CIMFriendQueryUserListReq _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class CIMFriendQueryUserListRsp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMFriendQueryUserListRsp', package: const $pb.PackageName('CIM.Friend'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$0.CIMUserInfo>(2, 'userInfoList', $pb.PbFieldType.PM, subBuilder: $0.CIMUserInfo.create)
    ..hasRequiredFields = false
  ;

  CIMFriendQueryUserListRsp._() : super();
  factory CIMFriendQueryUserListRsp() => create();
  factory CIMFriendQueryUserListRsp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CIMFriendQueryUserListRsp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CIMFriendQueryUserListRsp clone() => CIMFriendQueryUserListRsp()..mergeFromMessage(this);
  CIMFriendQueryUserListRsp copyWith(void Function(CIMFriendQueryUserListRsp) updates) => super.copyWith((message) => updates(message as CIMFriendQueryUserListRsp));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CIMFriendQueryUserListRsp create() => CIMFriendQueryUserListRsp._();
  CIMFriendQueryUserListRsp createEmptyInstance() => create();
  static $pb.PbList<CIMFriendQueryUserListRsp> createRepeated() => $pb.PbList<CIMFriendQueryUserListRsp>();
  @$core.pragma('dart2js:noInline')
  static CIMFriendQueryUserListRsp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CIMFriendQueryUserListRsp>(create);
  static CIMFriendQueryUserListRsp _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$0.CIMUserInfo> get userInfoList => $_getList(1);
}

