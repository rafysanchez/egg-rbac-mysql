/*
 Navicat Premium Data Transfer

 Target Server Type    : MySQL
 Target Server Version : 50610
 File Encoding         : 65001

 Date: 10/10/2018 10:55:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` varchar(36) NOT NULL,
  `parent_id` varchar(36) NOT NULL DEFAULT '' COMMENT '所有上级菜单id，以","号分割，根级菜单为-1。',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单语义化名称',
  `type` tinyint(4) DEFAULT NULL COMMENT '菜单类型：0顶部菜单，1左侧菜单',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '菜单请求路径',
  `icon` varchar(20) DEFAULT NULL COMMENT '菜单图标',
  `sort` int(11) NOT NULL COMMENT '菜单排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单信息';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` VALUES ('1', '-1', '工作台', 0, '/admin/dashboard', 'ios-podium', 0);
INSERT INTO `sys_menu` VALUES ('2', '-1', '会员信息', 0, '/admin/wxmember', 'ios-people', 1);
INSERT INTO `sys_menu` VALUES ('3', '-1', '订单信息', 0, '/admin/order', 'ios-keypad', 2);
INSERT INTO `sys_menu` VALUES ('4', '-1', '墩位信息', 0, '/admin/device', 'ios-pulse', 3);
INSERT INTO `sys_menu` VALUES ('5', '-1', '系统设置', 0, '/admin/setting', 'ios-cog-outline', 4);
INSERT INTO `sys_menu` VALUES ('6', '-1,4', '墩位状态管理', 1, '/admin/device/status', '', 0);
INSERT INTO `sys_menu` VALUES ('7', '-1,4', '墩位数据统计', 1, 'folder', '', 1);
INSERT INTO `sys_menu` VALUES ('8', '-1,4,7', '墩位访问量', 1, '/admin/device/analytics/visit', '', 0);
INSERT INTO `sys_menu` VALUES ('9', '-1,4,7', '墩位报修量', 1, '/admin/device/analytics/maintain', '', 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_operator
-- ----------------------------
DROP TABLE IF EXISTS `sys_operator`;
CREATE TABLE `sys_operator` (
  `id` varchar(36) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '登录名',
  `password` varchar(100) NOT NULL DEFAULT '' COMMENT '登录密码',
  `enable` char(1) NOT NULL DEFAULT 'F' COMMENT 'T - 启用，F - 禁用',
  `f_id` varchar(100) NOT NULL DEFAULT '' COMMENT '外部关联id',
  `create_by` varchar(36) NOT NULL DEFAULT 'system',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(36) NOT NULL DEFAULT 'system',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作员信息';

-- ----------------------------
-- Records of sys_operator
-- ----------------------------
BEGIN;
INSERT INTO `sys_operator` VALUES ('074e04e0-bae9-11e8-98a6-9dd5135ca7bb', 'test', '123456', 'T', '', 'system', '2017-07-17 16:00:51', 'system', '2018-09-30 11:52:15');
COMMIT;

-- ----------------------------
-- Table structure for sys_operator_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_operator_role`;
CREATE TABLE `sys_operator_role` (
  `operator_id` varchar(36) NOT NULL DEFAULT '' COMMENT '操作员编号',
  `role_id` varchar(36) NOT NULL DEFAULT '' COMMENT '角色编号',
  PRIMARY KEY (`operator_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作员-角色';

-- ----------------------------
-- Records of sys_operator_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_operator_role` VALUES ('074e04e0-bae9-11e8-98a6-9dd5135ca7bb', 'admin');
COMMIT;

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` varchar(36) NOT NULL DEFAULT '' COMMENT '编号',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称',
  `type` tinyint(4) DEFAULT NULL COMMENT '类型：0链接，1按钮，2接口',
  `permission` varchar(200) NOT NULL DEFAULT '' COMMENT '权限标识（链接类为menu表id）',
  `create_by` varchar(36) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(36) NOT NULL DEFAULT '' COMMENT '更新者',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限信息';

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_permission` VALUES ('1', '工作台', 0, '1', 'system', '2017-07-17 14:51:25', '', '2018-10-10 10:14:19');
INSERT INTO `sys_permission` VALUES ('2', '会员信息', 0, '2', 'system', '2017-07-17 14:51:38', '', '2018-09-30 11:56:18');
INSERT INTO `sys_permission` VALUES ('3', '订单信息', 0, '3', 'system', '2017-07-17 14:51:46', '', '2018-09-30 11:56:19');
INSERT INTO `sys_permission` VALUES ('4', '墩位信息', 0, '4', 'system', '2017-07-17 14:51:54', '', '2018-09-30 11:56:21');
INSERT INTO `sys_permission` VALUES ('5', '系统设置', 0, '5', 'system', '2018-09-30 11:55:31', '', '2018-09-30 11:56:23');
INSERT INTO `sys_permission` VALUES ('6', '墩位状态管理', 0, '6', 'system', '2018-09-30 11:55:43', '', '2018-09-30 11:56:25');
INSERT INTO `sys_permission` VALUES ('7', '墩位数据统计', 0, '7', 'system', '2018-09-30 11:55:49', '', '2018-09-30 11:56:26');
INSERT INTO `sys_permission` VALUES ('8', '墩位访问量', 0, '8', 'system', '2018-09-30 11:55:58', '', '2018-09-30 11:56:27');
INSERT INTO `sys_permission` VALUES ('9', '墩位报修量', 0, '9', 'system', '2018-09-30 11:56:06', '', '2018-09-30 11:56:27');
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` varchar(36) NOT NULL DEFAULT '' COMMENT '编号',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '角色名称',
  `enable` char(1) NOT NULL DEFAULT 'F' COMMENT '是否可用',
  `create_by` varchar(36) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(36) NOT NULL DEFAULT '' COMMENT '更新者',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色信息';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES ('admin', '超级管理员', 'T', 'system', '2017-07-17 16:01:02', '', '2018-09-30 11:51:27');
COMMIT;

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `role_id` varchar(36) NOT NULL DEFAULT '' COMMENT '角色编号',
  `permission_id` varchar(36) NOT NULL DEFAULT '' COMMENT '菜单编号',
  PRIMARY KEY (`role_id`,`permission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色-菜单';

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_permission` VALUES ('admin', '1');
INSERT INTO `sys_role_permission` VALUES ('admin', '2');
INSERT INTO `sys_role_permission` VALUES ('admin', '3');
INSERT INTO `sys_role_permission` VALUES ('admin', '4');
INSERT INTO `sys_role_permission` VALUES ('admin', '5');
INSERT INTO `sys_role_permission` VALUES ('admin', '6');
INSERT INTO `sys_role_permission` VALUES ('admin', '7');
INSERT INTO `sys_role_permission` VALUES ('admin', '8');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
