CREATE TABLE `im_message_send_0` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` bigint(20) NOT NULL COMMENT '服务端消息ID',
  `client_msg_id` varchar(64) NOT NULL COMMENT '客户端消息ID-UUID',
  `from_id` bigint(11) NOT NULL,
  `to_id` bigint(11) NOT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `msg_type` int(11) DEFAULT NULL,
  `msg_content` varchar(2048) DEFAULT NULL,
  `msg_res_code` tinyint(4) DEFAULT NULL COMMENT '消息错误码 0：一切正常',
  `msg_feature` tinyint(4) DEFAULT NULL COMMENT '消息属性 0：默认 1：离线消息 2：漫游消息 3：同步消息 4：透传消息',
  `msg_status` tinyint(4) DEFAULT '0' COMMENT '消息状态 0：默认 1：收到消息，未读 2：收到消息，已读 3：已删 4：发送中 5：已发送 7：草稿 8：发送取消 9：被对方拒绝，如在黑名单中',
  `created` int(11) DEFAULT NULL,
  `updated` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;