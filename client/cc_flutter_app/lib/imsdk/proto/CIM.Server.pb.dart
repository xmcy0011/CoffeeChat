///
//  Generated code. Do not modify.
//  source: CIM.Server.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'CIM.Message.pb.dart' as $1;

class CIMServer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMServer', package: const $pb.PackageName('CIM.Server'))
    ..a<Int64>(1, 'userId', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'key')
    ..aOS(3, 'server')
    ..hasRequiredFields = false
  ;

  CIMServer() : super();
  CIMServer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMServer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMServer clone() => CIMServer()..mergeFromMessage(this);
  CIMServer copyWith(void Function(CIMServer) updates) => super.copyWith((message) => updates(message as CIMServer));
  $pb.BuilderInfo get info_ => _i;
  static CIMServer create() => CIMServer();
  CIMServer createEmptyInstance() => create();
  static $pb.PbList<CIMServer> createRepeated() => $pb.PbList<CIMServer>();
  static CIMServer getDefault() => _defaultInstance ??= create()..freeze();
  static CIMServer _defaultInstance;

  Int64 get userId => $_getI64(0);
  set userId(Int64 v) { $_setInt64(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  $core.String get key => $_getS(1, '');
  set key($core.String v) { $_setString(1, v); }
  $core.bool hasKey() => $_has(1);
  void clearKey() => clearField(2);

  $core.String get server => $_getS(2, '');
  set server($core.String v) { $_setString(2, v); }
  $core.bool hasServer() => $_has(2);
  void clearServer() => clearField(3);
}

class CIMInternalMsgData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMInternalMsgData', package: const $pb.PackageName('CIM.Server'))
    ..a<CIMServer>(1, 'server', $pb.PbFieldType.OM, CIMServer.getDefault, CIMServer.create)
    ..a<$1.CIMMsgData>(2, 'msgData', $pb.PbFieldType.OM, $1.CIMMsgData.getDefault, $1.CIMMsgData.create)
    ..hasRequiredFields = false
  ;

  CIMInternalMsgData() : super();
  CIMInternalMsgData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMInternalMsgData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMInternalMsgData clone() => CIMInternalMsgData()..mergeFromMessage(this);
  CIMInternalMsgData copyWith(void Function(CIMInternalMsgData) updates) => super.copyWith((message) => updates(message as CIMInternalMsgData));
  $pb.BuilderInfo get info_ => _i;
  static CIMInternalMsgData create() => CIMInternalMsgData();
  CIMInternalMsgData createEmptyInstance() => create();
  static $pb.PbList<CIMInternalMsgData> createRepeated() => $pb.PbList<CIMInternalMsgData>();
  static CIMInternalMsgData getDefault() => _defaultInstance ??= create()..freeze();
  static CIMInternalMsgData _defaultInstance;

  CIMServer get server => $_getN(0);
  set server(CIMServer v) { setField(1, v); }
  $core.bool hasServer() => $_has(0);
  void clearServer() => clearField(1);

  $1.CIMMsgData get msgData => $_getN(1);
  set msgData($1.CIMMsgData v) { setField(2, v); }
  $core.bool hasMsgData() => $_has(1);
  void clearMsgData() => clearField(2);
}

class CIMInternalMsgDataReadAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMInternalMsgDataReadAck', package: const $pb.PackageName('CIM.Server'))
    ..a<CIMServer>(1, 'server', $pb.PbFieldType.OM, CIMServer.getDefault, CIMServer.create)
    ..a<$1.CIMMsgDataReadAck>(2, 'readAck', $pb.PbFieldType.OM, $1.CIMMsgDataReadAck.getDefault, $1.CIMMsgDataReadAck.create)
    ..hasRequiredFields = false
  ;

  CIMInternalMsgDataReadAck() : super();
  CIMInternalMsgDataReadAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMInternalMsgDataReadAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMInternalMsgDataReadAck clone() => CIMInternalMsgDataReadAck()..mergeFromMessage(this);
  CIMInternalMsgDataReadAck copyWith(void Function(CIMInternalMsgDataReadAck) updates) => super.copyWith((message) => updates(message as CIMInternalMsgDataReadAck));
  $pb.BuilderInfo get info_ => _i;
  static CIMInternalMsgDataReadAck create() => CIMInternalMsgDataReadAck();
  CIMInternalMsgDataReadAck createEmptyInstance() => create();
  static $pb.PbList<CIMInternalMsgDataReadAck> createRepeated() => $pb.PbList<CIMInternalMsgDataReadAck>();
  static CIMInternalMsgDataReadAck getDefault() => _defaultInstance ??= create()..freeze();
  static CIMInternalMsgDataReadAck _defaultInstance;

  CIMServer get server => $_getN(0);
  set server(CIMServer v) { setField(1, v); }
  $core.bool hasServer() => $_has(0);
  void clearServer() => clearField(1);

  $1.CIMMsgDataReadAck get readAck => $_getN(1);
  set readAck($1.CIMMsgDataReadAck v) { setField(2, v); }
  $core.bool hasReadAck() => $_has(1);
  void clearReadAck() => clearField(2);
}

class CIMInternalMsgDataReadNotify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CIMInternalMsgDataReadNotify', package: const $pb.PackageName('CIM.Server'))
    ..a<CIMServer>(1, 'server', $pb.PbFieldType.OM, CIMServer.getDefault, CIMServer.create)
    ..a<$1.CIMMsgDataReadNotify>(3, 'readNotify', $pb.PbFieldType.OM, $1.CIMMsgDataReadNotify.getDefault, $1.CIMMsgDataReadNotify.create)
    ..hasRequiredFields = false
  ;

  CIMInternalMsgDataReadNotify() : super();
  CIMInternalMsgDataReadNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CIMInternalMsgDataReadNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CIMInternalMsgDataReadNotify clone() => CIMInternalMsgDataReadNotify()..mergeFromMessage(this);
  CIMInternalMsgDataReadNotify copyWith(void Function(CIMInternalMsgDataReadNotify) updates) => super.copyWith((message) => updates(message as CIMInternalMsgDataReadNotify));
  $pb.BuilderInfo get info_ => _i;
  static CIMInternalMsgDataReadNotify create() => CIMInternalMsgDataReadNotify();
  CIMInternalMsgDataReadNotify createEmptyInstance() => create();
  static $pb.PbList<CIMInternalMsgDataReadNotify> createRepeated() => $pb.PbList<CIMInternalMsgDataReadNotify>();
  static CIMInternalMsgDataReadNotify getDefault() => _defaultInstance ??= create()..freeze();
  static CIMInternalMsgDataReadNotify _defaultInstance;

  CIMServer get server => $_getN(0);
  set server(CIMServer v) { setField(1, v); }
  $core.bool hasServer() => $_has(0);
  void clearServer() => clearField(1);

  $1.CIMMsgDataReadNotify get readNotify => $_getN(1);
  set readNotify($1.CIMMsgDataReadNotify v) { setField(3, v); }
  $core.bool hasReadNotify() => $_has(1);
  void clearReadNotify() => clearField(3);
}

