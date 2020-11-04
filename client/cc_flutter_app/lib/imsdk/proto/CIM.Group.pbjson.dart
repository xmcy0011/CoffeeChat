///
//  Generated code. Do not modify.
//  source: CIM.Group.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CIMGroupMemberChangedType$json = const {
  '1': 'CIMGroupMemberChangedType',
  '2': const [
    const {'1': 'kCIM_GROUP_MEMBER_CHANGED_TYPE_DEFAULT', '2': 0},
    const {'1': 'kCIM_GROUP_MEMBER_CHANGED_TYPE_ADD', '2': 1},
    const {'1': 'kCIM_GROUP_MEMBER_CHANGED_TYPE_DEL', '2': 2},
  ],
};

const CIMGroupType$json = const {
  '1': 'CIMGroupType',
  '2': const [
    const {'1': 'kCIM_GROUP_TYPE_UNKNOWN', '2': 0},
    const {'1': 'kCIM_GROUP_TYPE_GROUP_NORMAL', '2': 1},
    const {'1': 'kCIM_GROUP_TYPE_GROUP_SUPER', '2': 2},
  ],
};

const CIMGroupJoinModel$json = const {
  '1': 'CIMGroupJoinModel',
  '2': const [
    const {'1': 'kCIM_GROUP_JOIN_MODEL_DEFAULT', '2': 0},
    const {'1': 'kCIM_GROUP_JOIN_MODEL_NEED_AUTH', '2': 1},
    const {'1': 'kCIM_GROUP_JOIN_MODEL_REJECT', '2': 2},
  ],
};

const CIMGroupBeInviteMode$json = const {
  '1': 'CIMGroupBeInviteMode',
  '2': const [
    const {'1': 'kCIM_GROUP_BE_INVITE_MODEL_DEFAULT', '2': 0},
    const {'1': 'kCIM_GROUP_BE_INVITE_MODEL_NEED_AGREE', '2': 1},
  ],
};

const CIMGroupMuteModel$json = const {
  '1': 'CIMGroupMuteModel',
  '2': const [
    const {'1': 'kCIM_GROUP_MUTE_MODEL_DEFAULT', '2': 0},
    const {'1': 'kCIM_GROUP_MUTE_MODEL_ALL', '2': 1},
  ],
};

const CIMGroupCreateReq$json = const {
  '1': 'CIMGroupCreateReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_name', '3': 2, '4': 1, '5': 9, '10': 'groupName'},
    const {'1': 'member_id_list', '3': 3, '4': 3, '5': 4, '10': 'memberIdList'},
  ],
};

const CIMGroupCreateRsp$json = const {
  '1': 'CIMGroupCreateRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'result_code', '3': 2, '4': 1, '5': 13, '10': 'resultCode'},
    const {'1': 'group_info', '3': 3, '4': 1, '5': 11, '6': '.CIM.Group.CIMGroupInfo', '10': 'groupInfo'},
    const {'1': 'member_id_list', '3': 4, '4': 3, '5': 4, '10': 'memberIdList'},
    const {'1': 'attach_notificatino_msg', '3': 10, '4': 1, '5': 12, '10': 'attachNotificatinoMsg'},
  ],
};

const CIMGroupDisbandingReq$json = const {
  '1': 'CIMGroupDisbandingReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
  ],
};

const CIMGroupDisbandingRsp$json = const {
  '1': 'CIMGroupDisbandingRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'result_code', '3': 3, '4': 1, '5': 13, '10': 'resultCode'},
    const {'1': 'attach_notificatino_msg', '3': 10, '4': 1, '5': 12, '10': 'attachNotificatinoMsg'},
  ],
};

const CIMGroupExitReq$json = const {
  '1': 'CIMGroupExitReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
  ],
};

const CIMGroupExitRsp$json = const {
  '1': 'CIMGroupExitRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'result_code', '3': 3, '4': 1, '5': 13, '10': 'resultCode'},
    const {'1': 'attach_notificatino_msg', '3': 10, '4': 1, '5': 12, '10': 'attachNotificatinoMsg'},
  ],
};

const CIMGroupListReq$json = const {
  '1': 'CIMGroupListReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
  ],
};

const CIMGroupListRsp$json = const {
  '1': 'CIMGroupListRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_version_list', '3': 2, '4': 3, '5': 11, '6': '.CIM.Group.CIMGroupVersionInfo', '10': 'groupVersionList'},
  ],
};

const CIMGroupInfoReq$json = const {
  '1': 'CIMGroupInfoReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_version_list', '3': 2, '4': 3, '5': 11, '6': '.CIM.Group.CIMGroupVersionInfo', '10': 'groupVersionList'},
  ],
};

const CIMGroupInfoRsp$json = const {
  '1': 'CIMGroupInfoRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'result_code', '3': 2, '4': 1, '5': 13, '10': 'resultCode'},
    const {'1': 'group_info_list', '3': 3, '4': 3, '5': 11, '6': '.CIM.Group.CIMGroupInfo', '10': 'groupInfoList'},
  ],
};

const CIMGroupInviteMemberReq$json = const {
  '1': 'CIMGroupInviteMemberReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'member_id_list', '3': 3, '4': 3, '5': 4, '10': 'memberIdList'},
  ],
};

const CIMGroupInviteMemberRsp$json = const {
  '1': 'CIMGroupInviteMemberRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'result_code', '3': 3, '4': 1, '5': 13, '10': 'resultCode'},
    const {'1': 'attach_notificatino_msg', '3': 10, '4': 1, '5': 12, '10': 'attachNotificatinoMsg'},
  ],
};

const CIMGroupKickOutMemberReq$json = const {
  '1': 'CIMGroupKickOutMemberReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'member_id_list', '3': 3, '4': 3, '5': 4, '10': 'memberIdList'},
  ],
};

const CIMGroupKickOutMemberRsp$json = const {
  '1': 'CIMGroupKickOutMemberRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'result_code', '3': 3, '4': 1, '5': 13, '10': 'resultCode'},
    const {'1': 'attach_notificatino_msg', '3': 10, '4': 1, '5': 12, '10': 'attachNotificatinoMsg'},
  ],
};

const CIMGroupMemberListReq$json = const {
  '1': 'CIMGroupMemberListReq',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
  ],
};

const CIMGroupMemberListRsp$json = const {
  '1': 'CIMGroupMemberListRsp',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'member_id_list', '3': 3, '4': 3, '5': 4, '10': 'memberIdList'},
  ],
};

const CIMGroupMemberChangedNotify$json = const {
  '1': 'CIMGroupMemberChangedNotify',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'changed_list', '3': 3, '4': 3, '5': 11, '6': '.CIM.Group.CIMGroupMemberChangedInfo', '10': 'changedList'},
  ],
};

const CIMGroupMemberChangedInfo$json = const {
  '1': 'CIMGroupMemberChangedInfo',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.CIM.Group.CIMGroupMemberChangedType', '10': 'type'},
  ],
};

const CIMGroupInfo$json = const {
  '1': 'CIMGroupInfo',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'group_name', '3': 2, '4': 1, '5': 9, '10': 'groupName'},
    const {'1': 'group_type', '3': 3, '4': 1, '5': 14, '6': '.CIM.Group.CIMGroupType', '10': 'groupType'},
    const {'1': 'join_model', '3': 4, '4': 1, '5': 14, '6': '.CIM.Group.CIMGroupJoinModel', '10': 'joinModel'},
    const {'1': 'be_invite_model', '3': 5, '4': 1, '5': 14, '6': '.CIM.Group.CIMGroupBeInviteMode', '10': 'beInviteModel'},
    const {'1': 'mute_model', '3': 6, '4': 1, '5': 14, '6': '.CIM.Group.CIMGroupMuteModel', '10': 'muteModel'},
    const {'1': 'group_owner_id', '3': 7, '4': 1, '5': 4, '10': 'groupOwnerId'},
    const {'1': 'create_time', '3': 8, '4': 1, '5': 13, '10': 'createTime'},
    const {'1': 'update_time', '3': 9, '4': 1, '5': 13, '10': 'updateTime'},
    const {'1': 'group_intro', '3': 10, '4': 1, '5': 9, '10': 'groupIntro'},
    const {'1': 'announcement', '3': 11, '4': 1, '5': 9, '10': 'announcement'},
    const {'1': 'group_avatar', '3': 12, '4': 1, '5': 9, '10': 'groupAvatar'},
  ],
};

const CIMGroupVersionInfo$json = const {
  '1': 'CIMGroupVersionInfo',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 4, '10': 'groupId'},
    const {'1': 'group_version', '3': 2, '4': 1, '5': 13, '10': 'groupVersion'},
  ],
};

