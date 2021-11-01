CREATE TABLE `im_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) NOT NULL COMMENT '用户名',
  `user_pwd_salt` varchar(64) NOT NULL COMMENT '随机盐值',
  `user_pwd_hash` varchar(64) NOT NULL COMMENT '用户密码hash值',
  `user_nick_name` varchar(32) NOT NULL COMMENT '昵称',
  `user_token` varchar(64) DEFAULT '' COMMENT '口令',
  `user_attach` varchar(1024) DEFAULT '' COMMENT '附加信息（预留）',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* 2021-07-23 随机昵称生成表 */
CREATE TABLE `im_nick_generate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gen_key` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类别，lastname_v1：姓氏，classical_v1：古典名字',
  `gen_value` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '值',
  `flag` tinyint(1) DEFAULT '1' COMMENT '启用标志 1：是 0：否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_session` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `peer_id` int(11) NOT NULL COMMENT '对方id，单聊代表用户，群聊代表群组',
  `session_type` int(11) DEFAULT 0 COMMENT '会话类型，1：单聊，2：群聊',
  `session_status` int(11) DEFAULT 0 COMMENT '会话修改命令（预留）',
  `is_robot_session` tinyint(4) DEFAULT '0' COMMENT '是否为机器人会话，1是，0否',
  `created` int(11) NOT NULL COMMENT '创建时间戳',
  `updated` int(11) NOT NULL COMMENT '更新时间戳',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index` (`user_id`,`peer_id`,`session_type`),
  KEY `ix_userid_peerid_status` (`user_id`,`peer_id`,`session_type`,`session_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_group` (
  `group_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '群组id',
  `group_name` varchar(32) NOT NULL DEFAULT '' COMMENT '群名',
  `group_version` tinyint(4) NOT NULL DEFAULT '0' COMMENT '群版本',
  `create_user_id` bigint(20) NOT NULL COMMENT '创建者id',
  `owner` bigint(20) NOT NULL COMMENT '群主',
  `announcement` varchar(1024) DEFAULT '' COMMENT '群公告',
  `intro` varchar(128) DEFAULT '' COMMENT '群介绍',
  `avatar` varchar(256) NOT NULL DEFAULT '' COMMENT '群头像url',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '群类型 0：未知，1：普通群，2：超级群',
  `join_model` tinyint(4) NOT NULL DEFAULT '0' COMMENT '入群模式 0：所有人可邀请别人加入，1：需要管理员验证，2：拒绝所有人 ',
  `be_invite_model` tinyint(4) NOT NULL DEFAULT '0' COMMENT '被邀请人同意方式 0：不需要同意，1：需要',
  `mute_model` tinyint(4) NOT NULL DEFAULT '0' COMMENT '禁言模式 0：不禁言，1：全体禁言',
  `last_chat_time` int(11) NOT NULL COMMENT '最后聊天时间',
  `user_cnt` int(11) NOT NULL COMMENT '群内成员数量',
  `created` int(11) NOT NULL COMMENT '创建时间戳',
  `updated` int(11) NOT NULL COMMENT '更新时间戳',
  `del_flag` tinyint(4) NOT NULL DEFAULT '0' COMMENT '删除 0：否，1：是',
  KEY `ix_groupId_delFlag` (`group_id`,`del_flag`),
  KEY `ix_groupId_owner_delFlag` (`group_id`,`owner`,`del_flag`),
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_group_member` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL COMMENT '群组id',
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `created` int(11) NOT NULL COMMENT '创建时间戳',
  `updated` int(11) NOT NULL COMMENT '更新时间戳',
  `del_flag` tinyint(4) NOT NULL DEFAULT '0' COMMENT '删除 0：否，1：是',
  KEY `ix_groupId_userId` (`group_id`,`user_id`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_message_send_0` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_message_send_1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_message_send_2` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_message_send_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `im_message_recv_0` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) DEFAULT '0',
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `im_message_recv_1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) DEFAULT '0',
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `im_message_recv_2` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) DEFAULT '0',
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `im_message_recv_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(20) NOT NULL,
  `to_id` bigint(20) NOT NULL,
  `group_id` bigint(20) DEFAULT '0',
  `msg_type` int(11) NOT NULL,
  `msg_content` varchar(2048) NOT NULL,
  `msg_res_code` tinyint(4) NOT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT '0' COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  KEY `ix_fromId_toId_msgStatus_created` (`from_id`,`to_id`,`msg_status`,`created`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;