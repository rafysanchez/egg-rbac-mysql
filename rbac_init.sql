# ************************************************************
# Sequel Pro SQL dump
# Version 5425
#
# https://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.5.5-10.3.10-MariaDB)
# Database: gxly
# Generation Time: 2018-12-18 08:44:23 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE=''NO_AUTO_VALUE_ON_ZERO'' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table sys_menu
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_menu`;

CREATE TABLE `sys_menu` (
  `id` varchar(36) NOT NULL,
  `parent_id` varchar(1000) NOT NULL DEFAULT '''' COMMENT ''所有上级菜单id，以","号分割，根级菜单为-1。'',
  `name` varchar(50) NOT NULL DEFAULT '''' COMMENT ''菜单语义化名称'',
  `type` tinyint(4) DEFAULT NULL COMMENT ''菜单类型：0顶部菜单，1左侧菜单，2子页面(不显示在菜单中)'',
  `path` varchar(255) NOT NULL DEFAULT '''' COMMENT ''菜单请求路径：若是左侧菜单，可以是folder收缩菜单'',
  `icon` varchar(20) DEFAULT NULL COMMENT ''菜单图标'',
  `sort` int(11) NOT NULL COMMENT ''菜单排序'',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''菜单信息'';

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;

INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `icon`, `sort`)
VALUES
	(''0ca8b94e-028d-11e9-b545-e0d55e085c6e'',''-1'',''会员信息'',0,''/admin/wxmember'',''ios-people'',1),
	(''1a4956d0-028d-11e9-b545-e0d55e085c6e'',''-1'',''分级信息'',0,''/admin/category/analyze'',''ios-keypad'',2),
	(''24600eba-028e-11e9-b545-e0d55e085c6e'',''-1,599664c2-028d-11e9-b545-e0d55e085c6e,ae777b7a-028d-11e9-b545-e0d55e085c6e'',''广告管理'',2,'''',NULL,0),
	(''599664c2-028d-11e9-b545-e0d55e085c6e'',''-1'',''商户信息'',0,''/admin/merchant'',''ios-pulse'',3),
	(''646f8716-028d-11e9-b545-e0d55e085c6e'',''-1'',''系统设置'',0,''/admin/setting'',''ios-cog-outline'',4),
	(''94f2ad78-028d-11e9-b545-e0d55e085c6e'',''-1,1a4956d0-028d-11e9-b545-e0d55e085c6e'',''分级管理'',1,''/admin/category'',NULL,0),
	(''a50e6562-028d-11e9-b545-e0d55e085c6e'',''-1,1a4956d0-028d-11e9-b545-e0d55e085c6e,94f2ad78-028d-11e9-b545-e0d55e085c6e'',''二等分级'',2,''/admin/category/sub'',NULL,0),
	(''ae777b7a-028d-11e9-b545-e0d55e085c6e'',''-1,599664c2-028d-11e9-b545-e0d55e085c6e'',''商户管理'',1,'''',NULL,0),
	(''f09b6738-028c-11e9-b545-e0d55e085c6e'',''-1'',''工作台'',0,''/admin/dashboard'',NULL,0);

/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_operation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_operation`;

CREATE TABLE `sys_operation` (
  `id` varchar(36) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '''' COMMENT ''操作语义化名称'',
  `path` varchar(255) NOT NULL DEFAULT '''' COMMENT ''操作请求路径'',
  `icon` varchar(20) DEFAULT NULL COMMENT ''操作图标'',
  `sort` int(11) NOT NULL COMMENT ''操作排序'',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''操作信息'';

LOCK TABLES `sys_operation` WRITE;
/*!40000 ALTER TABLE `sys_operation` DISABLE KEYS */;

INSERT INTO `sys_operation` (`id`, `name`, `path`, `icon`, `sort`)
VALUES
	(''0a0f0cf2-028c-11e9-b545-e0d55e085c6e'',''批量删除分级'',''/admin/category/batch'',NULL,4),
	(''2bc9f3c0-028c-11e9-b545-e0d55e085c6e'',''排序分级'',''/admin/category/sort'',NULL,5),
	(''46c663de-028c-11e9-b545-e0d55e085c6e'',''删除分级'',''/admin/category/$'',NULL,3),
	(''501e3948-028c-11e9-b545-e0d55e085c6e'',''修改分级'',''/admin/category/$/edit'',NULL,2),
	(''752da728-028c-11e9-b545-e0d55e085c6e'',''新增分级'',''/admin/category/new'',NULL,1),
	(''fba8e098-028b-11e9-b545-e0d55e085c6e'',''文件上传'',''/admin/upload'',NULL,0);

/*!40000 ALTER TABLE `sys_operation` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_permission`;

CREATE TABLE `sys_permission` (
  `id` varchar(36) NOT NULL DEFAULT '''' COMMENT ''编号'',
  `type` tinyint(4) DEFAULT NULL COMMENT ''类型：0菜单，1操作'',
  `f_id` varchar(200) NOT NULL DEFAULT '''' COMMENT ''外键'',
  `create_by` varchar(36) NOT NULL DEFAULT ''system'' COMMENT ''创建者'',
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT ''创建时间'',
  `update_by` varchar(36) NOT NULL DEFAULT '''' COMMENT ''更新者'',
  `update_time` timestamp NOT NULL DEFAULT ''0000-00-00 00:00:00'' ON UPDATE current_timestamp() COMMENT ''更新时间'',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''权限信息'';

LOCK TABLES `sys_permission` WRITE;
/*!40000 ALTER TABLE `sys_permission` DISABLE KEYS */;

INSERT INTO `sys_permission` (`id`, `type`, `f_id`, `create_by`, `create_time`, `update_by`, `update_time`)
VALUES
	(''6875eca0-028e-11e9-b545-e0d55e085c6e'',0,''f09b6738-028c-11e9-b545-e0d55e085c6e'',''system'',''2017-07-17 14:51:25'','''',''2018-12-18 14:30:27''),
	(''6b4e6a6a-028e-11e9-b545-e0d55e085c6e'',0,''0ca8b94e-028d-11e9-b545-e0d55e085c6e'',''system'',''2017-07-17 14:51:38'','''',''2018-12-18 14:30:32''),
	(''6d6845aa-028e-11e9-b545-e0d55e085c6e'',0,''1a4956d0-028d-11e9-b545-e0d55e085c6e'',''system'',''2017-07-17 14:51:46'','''',''2018-12-18 14:30:35''),
	(''6f4918e0-028e-11e9-b545-e0d55e085c6e'',0,''599664c2-028d-11e9-b545-e0d55e085c6e'',''system'',''2017-07-17 14:51:54'','''',''2018-12-18 14:30:38''),
	(''70f8094e-028e-11e9-b545-e0d55e085c6e'',0,''646f8716-028d-11e9-b545-e0d55e085c6e'',''system'',''2018-09-30 11:55:31'','''',''2018-12-18 14:30:41''),
	(''72d10ca2-028e-11e9-b545-e0d55e085c6e'',0,''94f2ad78-028d-11e9-b545-e0d55e085c6e'',''system'',''2018-09-30 11:55:43'','''',''2018-12-18 14:30:44''),
	(''7551ea78-028e-11e9-b545-e0d55e085c6e'',0,''a50e6562-028d-11e9-b545-e0d55e085c6e'',''system'',''2018-09-30 11:55:49'','''',''2018-12-18 14:30:48''),
	(''775e863c-028e-11e9-b545-e0d55e085c6e'',0,''ae777b7a-028d-11e9-b545-e0d55e085c6e'',''system'',''2018-09-30 11:55:58'','''',''2018-12-18 14:30:52''),
	(''798b78ac-028e-11e9-b545-e0d55e085c6e'',0,''24600eba-028e-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 14:57:38'','''',''2018-12-18 14:30:55''),
	(''7bf3907a-028e-11e9-b545-e0d55e085c6e'',1,''752da728-028c-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 14:57:50'','''',''2018-12-18 14:30:59''),
	(''7ddf9dfc-028e-11e9-b545-e0d55e085c6e'',1,''501e3948-028c-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 14:57:56'','''',''2018-12-18 14:31:03''),
	(''7f982e20-028e-11e9-b545-e0d55e085c6e'',1,''46c663de-028c-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 14:58:03'','''',''2018-12-18 14:31:06''),
	(''814d2108-028e-11e9-b545-e0d55e085c6e'',1,''2bc9f3c0-028c-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 14:58:12'','''',''2018-12-18 14:31:08''),
	(''82fc1f22-028e-11e9-b545-e0d55e085c6e'',1,''0a0f0cf2-028c-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 15:36:12'','''',''2018-12-18 14:31:11''),
	(''8552ffa2-028e-11e9-b545-e0d55e085c6e'',1,''fba8e098-028b-11e9-b545-e0d55e085c6e'',''system'',''2018-12-17 14:58:19'','''',''2018-12-18 14:31:15'');

/*!40000 ALTER TABLE `sys_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
  `id` varchar(36) NOT NULL DEFAULT '''' COMMENT ''编号'',
  `name` varchar(100) NOT NULL DEFAULT '''' COMMENT ''角色名称'',
  `enable` char(1) NOT NULL DEFAULT ''F'' COMMENT ''是否可用'',
  `create_by` varchar(36) NOT NULL DEFAULT ''system'' COMMENT ''创建者'',
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT ''创建时间'',
  `update_by` varchar(36) NOT NULL DEFAULT '''' COMMENT ''更新者'',
  `update_time` timestamp NOT NULL DEFAULT ''0000-00-00 00:00:00'' ON UPDATE current_timestamp() COMMENT ''更新时间'',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''角色信息'';

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;

INSERT INTO `sys_role` (`id`, `name`, `enable`, `create_by`, `create_time`, `update_by`, `update_time`)
VALUES
	(''admin'',''超级管理员'',''T'',''system'',''2017-07-17 16:01:02'','''',''2018-09-30 11:51:27'');

/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_role_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_role_permission`;

CREATE TABLE `sys_role_permission` (
  `role_id` varchar(36) NOT NULL DEFAULT '''' COMMENT ''角色编号'',
  `permission_id` varchar(36) NOT NULL DEFAULT '''' COMMENT ''菜单编号'',
  PRIMARY KEY (`role_id`,`permission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''角色-菜单'';

LOCK TABLES `sys_role_permission` WRITE;
/*!40000 ALTER TABLE `sys_role_permission` DISABLE KEYS */;

INSERT INTO `sys_role_permission` (`role_id`, `permission_id`)
VALUES
	(''admin'',''6875eca0-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''6b4e6a6a-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''6d6845aa-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''6f4918e0-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''70f8094e-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''72d10ca2-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''7551ea78-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''775e863c-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''798b78ac-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''7bf3907a-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''7ddf9dfc-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''7f982e20-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''814d2108-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''82fc1f22-028e-11e9-b545-e0d55e085c6e''),
	(''admin'',''8552ffa2-028e-11e9-b545-e0d55e085c6e'');

/*!40000 ALTER TABLE `sys_role_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_user`;

CREATE TABLE `sys_user` (
  `id` varchar(36) NOT NULL DEFAULT '''',
  `name` varchar(100) NOT NULL DEFAULT '''' COMMENT ''登录名'',
  `password` varchar(100) NOT NULL DEFAULT '''' COMMENT ''登录密码'',
  `enable` char(1) NOT NULL DEFAULT ''F'' COMMENT ''T - 启用，F - 禁用'',
  `f_id` varchar(100) NOT NULL DEFAULT '''' COMMENT ''外部关联id'',
  `create_by` varchar(36) NOT NULL DEFAULT ''system'',
  `create_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `update_by` varchar(36) NOT NULL DEFAULT ''system'',
  `update_time` timestamp NOT NULL DEFAULT ''0000-00-00 00:00:00'' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''操作员信息'';

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;

INSERT INTO `sys_user` (`id`, `name`, `password`, `enable`, `f_id`, `create_by`, `create_time`, `update_by`, `update_time`)
VALUES
	(''074e04e0-bae9-11e8-98a6-9dd5135ca7bb'',''test'',''123456'',''T'','''',''system'',''2017-07-17 16:00:51'',''system'',''2018-09-30 11:52:15'');

/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_user_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_user_role`;

CREATE TABLE `sys_user_role` (
  `user_id` varchar(36) NOT NULL DEFAULT '''' COMMENT ''操作员编号'',
  `role_id` varchar(36) NOT NULL DEFAULT '''' COMMENT ''角色编号'',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''操作员-角色'';

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;

INSERT INTO `sys_user_role` (`user_id`, `role_id`)
VALUES
	(''074e04e0-bae9-11e8-98a6-9dd5135ca7bb'',''admin'');

/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
