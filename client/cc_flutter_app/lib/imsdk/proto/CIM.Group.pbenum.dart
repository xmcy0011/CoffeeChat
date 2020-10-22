///
//  Generated code. Do not modify.
//  source: CIM.Group.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CIMGroupMemberChangedType extends $pb.ProtobufEnum {
  static const CIMGroupMemberChangedType kCIM_GROUP_MEMBER_CHANGED_TYPE_DEFAULT = CIMGroupMemberChangedType._(0, 'kCIM_GROUP_MEMBER_CHANGED_TYPE_DEFAULT');
  static const CIMGroupMemberChangedType kCIM_GROUP_MEMBER_CHANGED_TYPE_ADD = CIMGroupMemberChangedType._(1, 'kCIM_GROUP_MEMBER_CHANGED_TYPE_ADD');
  static const CIMGroupMemberChangedType kCIM_GROUP_MEMBER_CHANGED_TYPE_DEL = CIMGroupMemberChangedType._(2, 'kCIM_GROUP_MEMBER_CHANGED_TYPE_DEL');

  static const $core.List<CIMGroupMemberChangedType> values = <CIMGroupMemberChangedType> [
    kCIM_GROUP_MEMBER_CHANGED_TYPE_DEFAULT,
    kCIM_GROUP_MEMBER_CHANGED_TYPE_ADD,
    kCIM_GROUP_MEMBER_CHANGED_TYPE_DEL,
  ];

  static final $core.Map<$core.int, CIMGroupMemberChangedType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMGroupMemberChangedType valueOf($core.int value) => _byValue[value];

  const CIMGroupMemberChangedType._($core.int v, $core.String n) : super(v, n);
}

class CIMGroupType extends $pb.ProtobufEnum {
  static const CIMGroupType kCIM_GROUP_TYPE_UNKNOWN = CIMGroupType._(0, 'kCIM_GROUP_TYPE_UNKNOWN');
  static const CIMGroupType kCIM_GROUP_TYPE_GROUP_NORMAL = CIMGroupType._(1, 'kCIM_GROUP_TYPE_GROUP_NORMAL');
  static const CIMGroupType kCIM_GROUP_TYPE_GROUP_SUPER = CIMGroupType._(2, 'kCIM_GROUP_TYPE_GROUP_SUPER');

  static const $core.List<CIMGroupType> values = <CIMGroupType> [
    kCIM_GROUP_TYPE_UNKNOWN,
    kCIM_GROUP_TYPE_GROUP_NORMAL,
    kCIM_GROUP_TYPE_GROUP_SUPER,
  ];

  static final $core.Map<$core.int, CIMGroupType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMGroupType valueOf($core.int value) => _byValue[value];

  const CIMGroupType._($core.int v, $core.String n) : super(v, n);
}

class CIMGroupJoinModel extends $pb.ProtobufEnum {
  static const CIMGroupJoinModel kCIM_GROUP_JOIN_MODEL_DEFAULT = CIMGroupJoinModel._(0, 'kCIM_GROUP_JOIN_MODEL_DEFAULT');
  static const CIMGroupJoinModel kCIM_GROUP_JOIN_MODEL_NEED_AUTH = CIMGroupJoinModel._(1, 'kCIM_GROUP_JOIN_MODEL_NEED_AUTH');
  static const CIMGroupJoinModel kCIM_GROUP_JOIN_MODEL_REJECT = CIMGroupJoinModel._(2, 'kCIM_GROUP_JOIN_MODEL_REJECT');

  static const $core.List<CIMGroupJoinModel> values = <CIMGroupJoinModel> [
    kCIM_GROUP_JOIN_MODEL_DEFAULT,
    kCIM_GROUP_JOIN_MODEL_NEED_AUTH,
    kCIM_GROUP_JOIN_MODEL_REJECT,
  ];

  static final $core.Map<$core.int, CIMGroupJoinModel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMGroupJoinModel valueOf($core.int value) => _byValue[value];

  const CIMGroupJoinModel._($core.int v, $core.String n) : super(v, n);
}

class CIMGroupBeInviteMode extends $pb.ProtobufEnum {
  static const CIMGroupBeInviteMode kCIM_GROUP_BE_INVITE_MODEL_DEFAULT = CIMGroupBeInviteMode._(0, 'kCIM_GROUP_BE_INVITE_MODEL_DEFAULT');
  static const CIMGroupBeInviteMode kCIM_GROUP_BE_INVITE_MODEL_NEED_AGREE = CIMGroupBeInviteMode._(1, 'kCIM_GROUP_BE_INVITE_MODEL_NEED_AGREE');

  static const $core.List<CIMGroupBeInviteMode> values = <CIMGroupBeInviteMode> [
    kCIM_GROUP_BE_INVITE_MODEL_DEFAULT,
    kCIM_GROUP_BE_INVITE_MODEL_NEED_AGREE,
  ];

  static final $core.Map<$core.int, CIMGroupBeInviteMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMGroupBeInviteMode valueOf($core.int value) => _byValue[value];

  const CIMGroupBeInviteMode._($core.int v, $core.String n) : super(v, n);
}

class CIMGroupMuteModel extends $pb.ProtobufEnum {
  static const CIMGroupMuteModel kCIM_GROUP_MUTE_MODEL_DEFAULT = CIMGroupMuteModel._(0, 'kCIM_GROUP_MUTE_MODEL_DEFAULT');
  static const CIMGroupMuteModel kCIM_GROUP_MUTE_MODEL_ALL = CIMGroupMuteModel._(1, 'kCIM_GROUP_MUTE_MODEL_ALL');

  static const $core.List<CIMGroupMuteModel> values = <CIMGroupMuteModel> [
    kCIM_GROUP_MUTE_MODEL_DEFAULT,
    kCIM_GROUP_MUTE_MODEL_ALL,
  ];

  static final $core.Map<$core.int, CIMGroupMuteModel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CIMGroupMuteModel valueOf($core.int value) => _byValue[value];

  const CIMGroupMuteModel._($core.int v, $core.String n) : super(v, n);
}

