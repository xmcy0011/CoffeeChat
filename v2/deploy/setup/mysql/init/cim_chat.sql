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

CREATE TABLE `im_message_send` (
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