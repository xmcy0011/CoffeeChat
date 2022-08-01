CREATE TABLE `devices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` varchar(64) NOT NULL COMMENT '设备id',
  `app_version` int(11) NOT NULL COMMENT '版本号',
  `os_version` varchar(32) DEFAULT 0 COMMENT '系统版本',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nick_name` varchar(64) NOT NULL COMMENT '昵称',
  `sex` tinyint(1) DEFAULT '0' NOT NULL COMMENT '性别 0:未设置 1:男 2:女 3:非二次元性别',
  `phone` varchar(32) DEFAULT '' COMMENT '手机号',
  `email` varchar(128) DEFAULT '' COMMENT '邮箱',
  `extra` JSON DEFAULT NULL COMMENT '额外信息',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;