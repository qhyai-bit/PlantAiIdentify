/*
 Navicat Premium Dump SQL

 Source Server         : 本地MySQL8
 Source Server Type    : MySQL
 Source Server Version : 80030 (8.0.30)
 Source Host           : localhost:3306
 Source Schema         : pai

 Target Server Type    : MySQL
 Target Server Version : 80030 (8.0.30)
 File Encoding         : 65001

 Date: 28/07/2025 09:26:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `pai`; -- 创建数据库（若不存在则创建）
USE `pai`; -- 切换到pai数据库

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` int NOT NULL COMMENT '父权限ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限名称',
  `type` int NOT NULL COMMENT '权限类型（2按钮 1菜单 0目录）',
  `path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由路径',
  `component` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由组件',
  `perm` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '按钮权限标识',
  `hidden` int NULL DEFAULT NULL COMMENT '是否隐藏（1隐藏 0显示）',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '面包屑名称',
  `icon` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标名称',
  `sort` int NOT NULL COMMENT '排序字段',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 0, '数据集管理', 0, '/dataset', 'Layout', NULL, 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (2, 0, '算子管理', 0, '/operator', 'Layout', NULL, 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (3, 0, '模型管理', 0, '/model', 'Layout', NULL, 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (4, 0, '权限管理', 0, '/auth', 'Layout', NULL, 0, '权限管理', 'el-icon-share', 4, 0);
INSERT INTO `auth_permission` VALUES (5, 0, '系统管理', 0, '/system', 'Layout', NULL, 0, '系统管理', 'el-icon-setting', 5, 0);
INSERT INTO `auth_permission` VALUES (6, 0, '病虫害识别', 0, '/identify', 'Layout', NULL, 0, NULL, NULL, 6, 0);
INSERT INTO `auth_permission` VALUES (7, 1, '数据集列表', 1, 'list', 'dataset/list', NULL, 0, '数据集管理', 'el-icon-folder-opened', 1, 0);
INSERT INTO `auth_permission` VALUES (8, 1, '数据集详情', 1, 'detail', 'dataset/detail', NULL, 1, '数据集详情', NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (9, 1, '数据集实体列表', 1, 'entity', 'dataset/entity', NULL, 1, '实体图片列表', NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (10, 2, '算子列表', 1, 'list', 'operator/index', NULL, 0, '算子管理', 'el-icon-document', 1, 0);
INSERT INTO `auth_permission` VALUES (11, 3, '模型列表', 1, 'list', 'model/list', NULL, 0, '模型管理', 'el-icon-coin', 1, 0);
INSERT INTO `auth_permission` VALUES (12, 3, '模型训练', 1, 'train', 'model/train', NULL, 1, '模型训练', NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (13, 3, '模型详情', 1, 'detail', 'model/detail', NULL, 1, '模型详情', NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (14, 4, '用户管理', 1, 'user', 'auth/user', NULL, 0, '用户管理', 'el-icon-user', 1, 0);
INSERT INTO `auth_permission` VALUES (15, 4, '角色管理', 1, 'role', 'auth/role', NULL, 0, '角色管理', 'el-icon-user-solid', 2, 0);
INSERT INTO `auth_permission` VALUES (16, 4, '权限管理', 1, 'permission', 'auth/permission', NULL, 0, '权限管理', 'el-icon-menu', 3, 0);
INSERT INTO `auth_permission` VALUES (17, 5, '日志管理', 1, 'log', 'system/log', NULL, 0, '日志管理', 'el-icon-tickets', 1, 0);
INSERT INTO `auth_permission` VALUES (18, 5, '数据字典管理', 1, 'dictionary', 'system/dictionary', NULL, 0, '数据字典管理', 'el-icon-notebook-2', 2, 0);
INSERT INTO `auth_permission` VALUES (19, 6, '病虫害识别', 1, 'index', 'identify/index', NULL, 0, '病虫害识别', 'el-icon-view', 1, 0);
INSERT INTO `auth_permission` VALUES (20, 7, '添加数据集', 2, NULL, NULL, 'dataset:add', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (21, 7, '修改数据集', 2, NULL, NULL, 'dataset:modify', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (22, 7, '删除数据集', 2, NULL, NULL, 'dataset:remove', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (23, 7, '上传数据集', 2, NULL, NULL, 'dataset:upload', 0, NULL, NULL, 5, 0);
INSERT INTO `auth_permission` VALUES (24, 8, '查看数据集详情', 2, NULL, NULL, 'dataset:detail', 0, NULL, NULL, 4, 0);
INSERT INTO `auth_permission` VALUES (25, 8, '新增分类', 2, NULL, NULL, 'classify:add', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (26, 8, '修改分类', 2, NULL, NULL, 'classify:modify', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (27, 8, '删除分类', 2, NULL, NULL, 'classify:remove', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (28, 8, '查看分类详情', 2, NULL, NULL, 'classify:detail', 0, NULL, NULL, 4, 0);
INSERT INTO `auth_permission` VALUES (29, 9, '上传实体', 2, NULL, NULL, 'entity:upload', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (30, 9, '批量删除实体图片', 2, NULL, NULL, 'entity:remove:batch', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (31, 10, '导入数据', 2, NULL, NULL, 'operator:import', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (32, 10, '修改算子', 2, NULL, NULL, 'operator:modify', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (33, 10, '删除算子', 2, NULL, NULL, 'operator:remove', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (34, 10, '批量删除算子', 2, NULL, NULL, 'operator:remove:batch', 0, NULL, NULL, 4, 0);
INSERT INTO `auth_permission` VALUES (35, 11, '新增模型', 2, NULL, NULL, 'model:add', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (36, 11, '修改模型', 2, NULL, NULL, 'model:modify', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (37, 11, '删除模型', 2, NULL, NULL, 'model:remove', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (38, 11, '评估模型', 2, NULL, NULL, 'model:evaluate', 0, NULL, NULL, 6, 0);
INSERT INTO `auth_permission` VALUES (39, 11, '发布或取消发布模型', 2, NULL, NULL, 'model:release', 0, NULL, NULL, 7, 0);
INSERT INTO `auth_permission` VALUES (40, 12, '训练模型', 2, NULL, NULL, 'model:train', 0, NULL, NULL, 5, 0);
INSERT INTO `auth_permission` VALUES (41, 13, '查看模型详情', 2, NULL, NULL, 'model:detail', 0, NULL, NULL, 4, 0);
INSERT INTO `auth_permission` VALUES (42, 14, '添加用户', 2, NULL, NULL, 'user:add', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (43, 14, '上传头像', 2, NULL, NULL, 'user:upload', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (44, 14, '修改用户', 2, NULL, NULL, 'user:modify', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (45, 14, '重置密码', 2, NULL, NULL, 'user:reset', 0, NULL, NULL, 4, 0);
INSERT INTO `auth_permission` VALUES (46, 14, '删除用户', 2, NULL, NULL, 'user:remove', 0, NULL, NULL, 5, 0);
INSERT INTO `auth_permission` VALUES (47, 14, '启用或禁用用户', 2, NULL, NULL, 'user:disable', 0, NULL, NULL, 6, 0);
INSERT INTO `auth_permission` VALUES (48, 14, '分配角色', 2, NULL, NULL, 'user:assign:role', 0, NULL, NULL, 7, 0);
INSERT INTO `auth_permission` VALUES (49, 15, '新增角色', 2, NULL, NULL, 'role:add', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (50, 15, '修改角色', 2, NULL, NULL, 'role:modify', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (51, 15, '删除角色', 2, NULL, NULL, 'role:remove', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (52, 15, '分配权限', 2, NULL, NULL, 'role:assign:permission', 0, NULL, NULL, 4, 0);
INSERT INTO `auth_permission` VALUES (53, 17, '导出日志', 2, NULL, NULL, 'log:export', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (54, 18, '新增数据字典', 2, NULL, NULL, 'dictionary:add', 0, NULL, NULL, 1, 0);
INSERT INTO `auth_permission` VALUES (55, 18, '修改数据字典', 2, NULL, NULL, 'dictionary:modify', 0, NULL, NULL, 2, 0);
INSERT INTO `auth_permission` VALUES (56, 18, '删除数据字典', 2, NULL, NULL, 'dictionary:remove', 0, NULL, NULL, 3, 0);
INSERT INTO `auth_permission` VALUES (57, 19, '病虫害识别', 2, NULL, NULL, 'identify', 0, NULL, NULL, 1, 0);

-- ----------------------------
-- Table structure for auth_role
-- ----------------------------
DROP TABLE IF EXISTS `auth_role`;
CREATE TABLE `auth_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_role
-- ----------------------------
INSERT INTO `auth_role` VALUES (1, '数据集管理员', '用于管理数据集相关操作', 0);
INSERT INTO `auth_role` VALUES (2, '算子管理员', '用于管理模型训练用到的算子', 0);
INSERT INTO `auth_role` VALUES (3, '模型管理员', '用于管理模型相关操作', 0);
INSERT INTO `auth_role` VALUES (4, '权限管理员', '用于用户、角色、权限管理', 0);
INSERT INTO `auth_role` VALUES (5, '系统管理员', '用于数据字典、日志管理', 0);
INSERT INTO `auth_role` VALUES (6, '普通用户', '用于进行病虫害识别测试角色', 0);

-- ----------------------------
-- Table structure for auth_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_role_permission`;
CREATE TABLE `auth_role_permission`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` int NOT NULL COMMENT '角色ID',
  `permission_id` int NOT NULL COMMENT '权限ID',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_role_permission
-- ----------------------------
INSERT INTO `auth_role_permission` VALUES (1, 1, 1, 0);
INSERT INTO `auth_role_permission` VALUES (2, 1, 20, 0);
INSERT INTO `auth_role_permission` VALUES (3, 1, 21, 0);
INSERT INTO `auth_role_permission` VALUES (4, 1, 22, 0);
INSERT INTO `auth_role_permission` VALUES (5, 1, 23, 0);
INSERT INTO `auth_role_permission` VALUES (6, 1, 24, 0);
INSERT INTO `auth_role_permission` VALUES (7, 1, 25, 0);
INSERT INTO `auth_role_permission` VALUES (8, 1, 26, 0);
INSERT INTO `auth_role_permission` VALUES (9, 1, 27, 0);
INSERT INTO `auth_role_permission` VALUES (10, 1, 28, 0);
INSERT INTO `auth_role_permission` VALUES (11, 1, 29, 0);
INSERT INTO `auth_role_permission` VALUES (12, 1, 30, 0);
INSERT INTO `auth_role_permission` VALUES (13, 1, 7, 0);
INSERT INTO `auth_role_permission` VALUES (14, 1, 8, 0);
INSERT INTO `auth_role_permission` VALUES (15, 1, 9, 0);
INSERT INTO `auth_role_permission` VALUES (16, 2, 10, 0);
INSERT INTO `auth_role_permission` VALUES (17, 2, 2, 0);
INSERT INTO `auth_role_permission` VALUES (18, 2, 31, 0);
INSERT INTO `auth_role_permission` VALUES (19, 2, 32, 0);
INSERT INTO `auth_role_permission` VALUES (20, 2, 33, 0);
INSERT INTO `auth_role_permission` VALUES (21, 2, 34, 0);
INSERT INTO `auth_role_permission` VALUES (22, 3, 11, 0);
INSERT INTO `auth_role_permission` VALUES (23, 3, 12, 0);
INSERT INTO `auth_role_permission` VALUES (24, 3, 13, 0);
INSERT INTO `auth_role_permission` VALUES (25, 3, 3, 0);
INSERT INTO `auth_role_permission` VALUES (26, 3, 35, 0);
INSERT INTO `auth_role_permission` VALUES (27, 3, 36, 0);
INSERT INTO `auth_role_permission` VALUES (28, 3, 37, 0);
INSERT INTO `auth_role_permission` VALUES (29, 3, 38, 0);
INSERT INTO `auth_role_permission` VALUES (30, 3, 39, 0);
INSERT INTO `auth_role_permission` VALUES (31, 3, 40, 0);
INSERT INTO `auth_role_permission` VALUES (32, 3, 41, 0);
INSERT INTO `auth_role_permission` VALUES (33, 4, 14, 0);
INSERT INTO `auth_role_permission` VALUES (34, 4, 15, 0);
INSERT INTO `auth_role_permission` VALUES (35, 4, 16, 0);
INSERT INTO `auth_role_permission` VALUES (36, 4, 4, 0);
INSERT INTO `auth_role_permission` VALUES (37, 4, 42, 0);
INSERT INTO `auth_role_permission` VALUES (38, 4, 43, 0);
INSERT INTO `auth_role_permission` VALUES (39, 4, 44, 0);
INSERT INTO `auth_role_permission` VALUES (40, 4, 45, 0);
INSERT INTO `auth_role_permission` VALUES (41, 4, 46, 0);
INSERT INTO `auth_role_permission` VALUES (42, 4, 47, 0);
INSERT INTO `auth_role_permission` VALUES (43, 4, 48, 0);
INSERT INTO `auth_role_permission` VALUES (44, 4, 49, 0);
INSERT INTO `auth_role_permission` VALUES (45, 4, 50, 0);
INSERT INTO `auth_role_permission` VALUES (46, 4, 51, 0);
INSERT INTO `auth_role_permission` VALUES (47, 4, 52, 0);
INSERT INTO `auth_role_permission` VALUES (48, 5, 17, 0);
INSERT INTO `auth_role_permission` VALUES (49, 5, 18, 0);
INSERT INTO `auth_role_permission` VALUES (50, 5, 5, 0);
INSERT INTO `auth_role_permission` VALUES (51, 5, 53, 0);
INSERT INTO `auth_role_permission` VALUES (52, 5, 54, 0);
INSERT INTO `auth_role_permission` VALUES (53, 5, 55, 0);
INSERT INTO `auth_role_permission` VALUES (54, 5, 56, 0);
INSERT INTO `auth_role_permission` VALUES (55, 6, 19, 0);
INSERT INTO `auth_role_permission` VALUES (56, 6, 57, 0);
INSERT INTO `auth_role_permission` VALUES (57, 6, 6, 0);

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `real_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `telephone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `header_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像地址',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `status` int NOT NULL DEFAULT 0 COMMENT '用户状态（1禁用 0未禁用）',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'briup', '5fa4d6fc78072f42e0b9817d310bcd35', '杰普', '19951154250', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', '2025-02-28 15:06:19', 0, 0);
INSERT INTO `auth_user` VALUES (2, 'tom', 'e10adc3949ba59abbe56e057f20f883e', '张三', '', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', '2025-04-26 22:56:15', 0, 0);

-- ----------------------------
-- Table structure for auth_user_role
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_role`;
CREATE TABLE `auth_user_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `role_id` int NOT NULL COMMENT '角色ID',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user_role
-- ----------------------------
INSERT INTO `auth_user_role` VALUES (1, 1, 1, 0);
INSERT INTO `auth_user_role` VALUES (2, 1, 2, 0);
INSERT INTO `auth_user_role` VALUES (3, 1, 3, 0);
INSERT INTO `auth_user_role` VALUES (4, 1, 4, 0);
INSERT INTO `auth_user_role` VALUES (5, 1, 5, 0);
INSERT INTO `auth_user_role` VALUES (6, 2, 5, 0);
INSERT INTO `auth_user_role` VALUES (7, 2, 1, 0);

-- ----------------------------
-- Table structure for d_classify
-- ----------------------------
DROP TABLE IF EXISTS `d_classify`;
CREATE TABLE `d_classify`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dataset_id` int NOT NULL COMMENT '数据集ID',
  `classify_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据集名称',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of d_classify
-- ----------------------------
INSERT INTO `d_classify` VALUES (1, 1, '叶枯病', 0);
INSERT INTO `d_classify` VALUES (2, 1, '条锈病', 0);
INSERT INTO `d_classify` VALUES (3, 1, '褐锈病', 0);
INSERT INTO `d_classify` VALUES (4, 1, '针壳孢属', 0);

-- ----------------------------
-- Table structure for d_dataset
-- ----------------------------
DROP TABLE IF EXISTS `d_dataset`;
CREATE TABLE `d_dataset`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dataset_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据集名称',
  `dataset_type` int NOT NULL COMMENT '数据集类型',
  `dataset_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据集详情',
  `dataset_status` int NOT NULL COMMENT '数据集状态（0初始化 1上传中 2完成）',
  `dataset_usage` int NOT NULL COMMENT '数据集用途（0初始化训练 1优化训练 2评估）',
  `create_by` int NOT NULL COMMENT '创建用户',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据集表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of d_dataset
-- ----------------------------
INSERT INTO `d_dataset` VALUES (1, '通用病害识别数据集', 2, '通用病害识别数据集', 2, 0, 1, '2025-06-09 13:55:41', 0);

-- ----------------------------
-- Table structure for d_entity
-- ----------------------------
DROP TABLE IF EXISTS `d_entity`;
CREATE TABLE `d_entity`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `classify_id` int NOT NULL COMMENT '分类ID',
  `entity_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实体图片路径',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1239 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '实体表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of d_entity
-- ----------------------------
INSERT INTO `d_entity` VALUES (1, 1, 'b06442f8-aebd-482b-96c9-5b00e2aa2314.png', 0);
INSERT INTO `d_entity` VALUES (2, 1, '117da7eb-5fde-4c86-bf6e-c4794b1758ce.png', 0);
INSERT INTO `d_entity` VALUES (3, 1, '70dfad50-e78e-4965-b1ce-a5ba216c0f2e.png', 0);
INSERT INTO `d_entity` VALUES (4, 1, 'a2765f54-67ff-4365-b4f4-2e6e723c5b56.png', 0);
INSERT INTO `d_entity` VALUES (5, 1, 'ac600d76-4df8-49d0-8b97-e5e10cfe5fd9.png', 0);
INSERT INTO `d_entity` VALUES (6, 1, 'cea235e1-ca78-43b7-b5d2-856833de4bd9.png', 0);
INSERT INTO `d_entity` VALUES (7, 1, '053dde84-e9c9-4ba4-be92-df38ce03864e.png', 0);
INSERT INTO `d_entity` VALUES (8, 1, '322da490-66d4-4c56-845b-d6c93f539420.png', 0);
INSERT INTO `d_entity` VALUES (9, 1, 'e5136397-f4fa-47e9-92a5-fd292dc13951.png', 0);
INSERT INTO `d_entity` VALUES (10, 1, 'f0843015-8dab-4179-8556-cd4166fb6d08.png', 0);
INSERT INTO `d_entity` VALUES (11, 1, 'e63b0fa1-1824-4acb-a49c-906b48d16946.png', 0);
INSERT INTO `d_entity` VALUES (12, 1, '6166dc5a-0179-410f-a700-b7a420a05b1b.png', 0);
INSERT INTO `d_entity` VALUES (13, 1, '750c7f05-a521-4a76-8e3a-58b0b35fbf54.png', 0);
INSERT INTO `d_entity` VALUES (14, 1, '7355cc2a-2af9-40b2-8abd-ea827b74f364.png', 0);
INSERT INTO `d_entity` VALUES (15, 1, '79bdcb6b-37b5-4b37-8878-74e4471bf577.png', 0);
INSERT INTO `d_entity` VALUES (16, 1, 'da5081af-cfcd-4af3-b108-7a506f6a2673.png', 0);
INSERT INTO `d_entity` VALUES (17, 1, 'd4fa3798-c6a7-43d2-85ad-9e2ea4a51185.png', 0);
INSERT INTO `d_entity` VALUES (18, 1, 'f3b4f5c6-a1ff-4fee-918f-a594aa48282a.png', 0);
INSERT INTO `d_entity` VALUES (19, 1, '085627c0-50b8-4f5a-adb9-e119320cad01.png', 0);
INSERT INTO `d_entity` VALUES (20, 1, 'b973c100-9b49-4ff2-8753-1f5d7296302c.png', 0);
INSERT INTO `d_entity` VALUES (21, 1, '2770e13f-9206-4232-8f07-9ba2aa5b6182.png', 0);
INSERT INTO `d_entity` VALUES (22, 1, 'c14fb707-8f70-439b-861a-087f2b83b27f.png', 0);
INSERT INTO `d_entity` VALUES (23, 1, '083886e9-95c2-44ed-9dd0-f6bc342c1af7.png', 0);
INSERT INTO `d_entity` VALUES (24, 1, '454dfa2b-6601-45f8-84fb-0af220d8a2e9.png', 0);
INSERT INTO `d_entity` VALUES (25, 1, '4e65376a-99d6-4992-b24c-0832c41f0926.png', 0);
INSERT INTO `d_entity` VALUES (26, 1, '00336633-1b61-455e-adcb-53fa6b73a190.png', 0);
INSERT INTO `d_entity` VALUES (27, 1, 'd52d1e15-5b71-4521-8dd7-6799bb6c815c.png', 0);
INSERT INTO `d_entity` VALUES (28, 1, '0dbbeed7-d7ff-4756-a1bf-a28b11ad9c9f.png', 0);
INSERT INTO `d_entity` VALUES (29, 1, '797d8772-350f-4f0f-b2a1-83ddb66343bd.png', 0);
INSERT INTO `d_entity` VALUES (30, 1, 'fd2fb39d-37da-4594-8c34-65cff1a776a6.png', 0);
INSERT INTO `d_entity` VALUES (31, 1, '1b4cc3ed-1704-4c1b-8db1-a050ac63bb31.png', 0);
INSERT INTO `d_entity` VALUES (32, 1, '44184bf5-fa86-4eaa-92eb-8a00e0ecf51f.png', 0);
INSERT INTO `d_entity` VALUES (33, 1, '53dd7000-15df-438c-aa35-2cf56724b4ae.png', 0);
INSERT INTO `d_entity` VALUES (34, 1, '38f2abc5-e4ca-494c-80ff-0338b1ccfca2.png', 0);
INSERT INTO `d_entity` VALUES (35, 1, '35b1624f-095a-4c92-b70f-3e1e8b15708a.png', 0);
INSERT INTO `d_entity` VALUES (36, 1, 'd5910432-90fd-41ce-86c5-63240afbba78.png', 0);
INSERT INTO `d_entity` VALUES (37, 1, '78573578-702a-4708-880e-1d7fa8e706c6.png', 0);
INSERT INTO `d_entity` VALUES (38, 1, '9ad95cef-cc41-45f3-8de6-0bb0fbf6708b.png', 0);
INSERT INTO `d_entity` VALUES (39, 1, '3d4a12e1-39cf-4882-a415-b0f579cffa14.png', 0);
INSERT INTO `d_entity` VALUES (40, 1, '5cf2a172-3f27-4a7a-be69-7192d7760a0f.png', 0);
INSERT INTO `d_entity` VALUES (41, 1, '1e295f1d-e4f0-4a3a-a4d2-29823bd1f465.png', 0);
INSERT INTO `d_entity` VALUES (42, 1, 'b2dd228d-0c8c-4da0-9a9d-6d6b1a3e9070.png', 0);
INSERT INTO `d_entity` VALUES (43, 1, '5027103f-65a1-4adb-867a-19d9471d46a3.png', 0);
INSERT INTO `d_entity` VALUES (44, 1, '576c32dc-a1da-4bb8-a809-f16bd2de38bb.png', 0);
INSERT INTO `d_entity` VALUES (45, 1, 'b4076bfa-ae03-4dca-902b-df6a4070e023.png', 0);
INSERT INTO `d_entity` VALUES (46, 1, '45039dff-4a86-4c71-bbe0-6200c0c4b3ca.png', 0);
INSERT INTO `d_entity` VALUES (47, 1, 'b0c4670a-7ef0-475c-86b5-1725b257fee2.png', 0);
INSERT INTO `d_entity` VALUES (48, 1, 'bba963bc-2d00-4e40-b5b6-257e7f3ca7e7.png', 0);
INSERT INTO `d_entity` VALUES (49, 1, 'b1493846-47b2-4cf3-b770-33ff921d3337.png', 0);
INSERT INTO `d_entity` VALUES (50, 1, 'c1af653d-df50-4ca9-a95c-eefa52b5e961.png', 0);
INSERT INTO `d_entity` VALUES (51, 1, '87bab929-451b-45e9-803b-7ad5e996a0dd.png', 0);
INSERT INTO `d_entity` VALUES (52, 1, 'eca83d6e-a420-4dba-ab4c-e4cf0f9a311c.png', 0);
INSERT INTO `d_entity` VALUES (53, 1, '8a88532a-d132-4974-b036-da3b87ea85f7.png', 0);
INSERT INTO `d_entity` VALUES (54, 1, '35970a69-bed0-448a-80dc-4e2f67d1e789.png', 0);
INSERT INTO `d_entity` VALUES (55, 1, '33a0d92f-1d8e-4d61-bfc5-3149e14c4f64.png', 0);
INSERT INTO `d_entity` VALUES (56, 1, 'c3bb01b7-ea83-429d-ba2e-5853f57d42c7.png', 0);
INSERT INTO `d_entity` VALUES (57, 1, '097cf34c-2bf4-4848-a931-5ee44008fe32.png', 0);
INSERT INTO `d_entity` VALUES (58, 1, '3a7a813e-4c91-41e6-b8f3-6ccc28d1b9cd.png', 0);
INSERT INTO `d_entity` VALUES (59, 1, 'a2a66f8f-707c-4132-8060-4a59e1f42ee4.png', 0);
INSERT INTO `d_entity` VALUES (60, 1, 'fb102d8b-67ea-43a1-a11a-894045bef35e.png', 0);
INSERT INTO `d_entity` VALUES (61, 1, '351aee35-064b-40fe-8f0e-3bf10faac2c7.png', 0);
INSERT INTO `d_entity` VALUES (62, 1, '13c74b51-cc55-47e0-a60e-242a46a10961.png', 0);
INSERT INTO `d_entity` VALUES (63, 1, '9b419b30-c512-495c-af63-787561b15322.png', 0);
INSERT INTO `d_entity` VALUES (64, 1, '953dc013-7879-4735-a652-501308ffb597.png', 0);
INSERT INTO `d_entity` VALUES (65, 1, '4823c93c-5226-4671-86a5-9fa5285d4f87.png', 0);
INSERT INTO `d_entity` VALUES (66, 1, '10b68810-2bbf-4ba7-826a-ba1f6fbcf137.png', 0);
INSERT INTO `d_entity` VALUES (67, 1, 'b597e32c-a872-4e65-9373-390fbb14c622.png', 0);
INSERT INTO `d_entity` VALUES (68, 1, '0d1c39ca-13ee-486c-8a3d-50cbbe861cc0.png', 0);
INSERT INTO `d_entity` VALUES (69, 1, 'dfe83b68-007e-4b7a-aa33-6d407f645b53.png', 0);
INSERT INTO `d_entity` VALUES (70, 1, '6c7795f1-d7a0-4754-8c74-e246b747f951.png', 0);
INSERT INTO `d_entity` VALUES (71, 1, '97526adf-304a-43fe-9b75-9bac3cf71e80.png', 0);
INSERT INTO `d_entity` VALUES (72, 1, '2cef3562-e559-49ff-9907-77159d325250.png', 0);
INSERT INTO `d_entity` VALUES (73, 1, '975bb727-a8c7-4e9e-bfdc-75935f99f895.png', 0);
INSERT INTO `d_entity` VALUES (74, 1, '16287387-dd8d-436b-872f-5a9014c05fd5.png', 0);
INSERT INTO `d_entity` VALUES (75, 1, '217a7b76-ef23-4932-b9a1-799aafed602e.png', 0);
INSERT INTO `d_entity` VALUES (76, 1, 'f376e349-5d6f-41ef-81cb-b57fc4b9fc4b.png', 0);
INSERT INTO `d_entity` VALUES (77, 1, 'ef8cd3c7-484e-42d9-8b4a-7d873c5c0b06.png', 0);
INSERT INTO `d_entity` VALUES (78, 1, '92238cf5-e92c-4734-96d6-21600593fb39.png', 0);
INSERT INTO `d_entity` VALUES (79, 1, '8adffa0e-545e-4d8d-b228-f330f43a8c01.png', 0);
INSERT INTO `d_entity` VALUES (80, 1, 'fb6bffb5-f2ff-4cc5-929d-c2b4e5d65e5e.png', 0);
INSERT INTO `d_entity` VALUES (81, 1, '23b5cf1e-ca2c-4ddb-98e7-d6c3e8620630.png', 0);
INSERT INTO `d_entity` VALUES (82, 1, '8e813927-baca-48ab-83cb-0aa1dbd323b9.png', 0);
INSERT INTO `d_entity` VALUES (83, 1, 'bea4ec69-6fc2-47da-9547-69d2c5951261.png', 0);
INSERT INTO `d_entity` VALUES (84, 1, 'f33843f7-fc49-4238-a3ca-f0f922f49027.png', 0);
INSERT INTO `d_entity` VALUES (85, 1, 'def76a0b-664a-4917-84d2-00c962cc21df.png', 0);
INSERT INTO `d_entity` VALUES (86, 1, 'b0964e3a-3909-4295-848f-e7b6d12587b5.png', 0);
INSERT INTO `d_entity` VALUES (87, 1, '592a2823-92e1-4f4b-af2b-e7a752a86436.png', 0);
INSERT INTO `d_entity` VALUES (88, 1, 'bf4020b3-21eb-45e6-a1dd-2187baf4dd16.png', 0);
INSERT INTO `d_entity` VALUES (89, 1, 'f3c6ae56-81c7-47f8-91fb-d1216ecdea69.png', 0);
INSERT INTO `d_entity` VALUES (90, 1, '549f1be1-83ac-435e-8323-812f232a7ee7.png', 0);
INSERT INTO `d_entity` VALUES (91, 1, '15ec0a3e-d4ad-4823-9e82-c02fb967c983.png', 0);
INSERT INTO `d_entity` VALUES (92, 1, '7094c118-9188-4222-9d03-caa5c21e6d4e.png', 0);
INSERT INTO `d_entity` VALUES (93, 1, '8011c420-12c5-47f1-89f6-cbe815665485.png', 0);
INSERT INTO `d_entity` VALUES (94, 1, '968598ae-f8fd-447a-9e20-69310695f693.png', 0);
INSERT INTO `d_entity` VALUES (95, 1, '78f7b52e-c818-4a29-857d-75afb0a7873b.png', 0);
INSERT INTO `d_entity` VALUES (96, 1, '7d4349e5-81ad-4605-8386-16188b6e24f0.png', 0);
INSERT INTO `d_entity` VALUES (97, 1, '0c9712f1-0ada-454b-8c59-72a0180dbc67.png', 0);
INSERT INTO `d_entity` VALUES (98, 1, '842f213e-8c80-40ec-85cd-b9c00c641004.png', 0);
INSERT INTO `d_entity` VALUES (99, 1, '739a4f05-10ac-4200-8a62-a4e6afdd1832.png', 0);
INSERT INTO `d_entity` VALUES (100, 1, '2959877e-a500-4620-914f-e1db09e3a9a0.png', 0);
INSERT INTO `d_entity` VALUES (101, 1, '5f1d0231-d387-4dc3-8370-76a1eb25d6c2.png', 0);
INSERT INTO `d_entity` VALUES (102, 1, 'b3919da0-5009-49e9-b668-2800cb578485.png', 0);
INSERT INTO `d_entity` VALUES (103, 1, '0b8fc953-cae0-4b74-85ac-be64b721ce91.png', 0);
INSERT INTO `d_entity` VALUES (104, 1, 'c121533e-12f9-4839-8b11-6c7c55ccf4f9.png', 0);
INSERT INTO `d_entity` VALUES (105, 1, '7440e90e-04ef-4ac6-9955-cf4bab386e01.png', 0);
INSERT INTO `d_entity` VALUES (106, 1, 'da697c6f-ea62-4032-b2e6-efba41086360.png', 0);
INSERT INTO `d_entity` VALUES (107, 1, 'e1d3c94c-6ef1-4ec5-964e-c3a38d99e6c6.png', 0);
INSERT INTO `d_entity` VALUES (108, 1, 'b4b5a6de-9ae1-458d-9fee-cd48bcfd3dde.png', 0);
INSERT INTO `d_entity` VALUES (109, 1, '35106968-410f-40b3-8225-1f07cb458bcd.png', 0);
INSERT INTO `d_entity` VALUES (110, 1, 'b64dde3f-24b6-49c8-9796-c44fd76d88ee.png', 0);
INSERT INTO `d_entity` VALUES (111, 1, '284c639b-cdec-4aa1-8824-c53b7de91728.png', 0);
INSERT INTO `d_entity` VALUES (112, 1, 'b2a86d1f-bbe2-48c9-a34b-8c640985bc82.png', 0);
INSERT INTO `d_entity` VALUES (113, 1, '822331c0-6692-4228-90f0-f3b41da9e589.png', 0);
INSERT INTO `d_entity` VALUES (114, 1, '2626ffb6-e794-47fe-b183-db0d837f79bd.png', 0);
INSERT INTO `d_entity` VALUES (115, 1, '41906433-4618-4a4a-b9db-e4b1fac49e5f.png', 0);
INSERT INTO `d_entity` VALUES (116, 1, '66d830b5-9221-41a3-86d9-1d05d28f02ca.png', 0);
INSERT INTO `d_entity` VALUES (117, 1, '06241c9a-ce81-4f36-9281-87e4c61548c3.png', 0);
INSERT INTO `d_entity` VALUES (118, 1, '64e94e4b-615e-4842-81a3-d6572ccaadef.png', 0);
INSERT INTO `d_entity` VALUES (119, 1, 'e9bb7871-d586-4806-8aef-f11f8976b2af.png', 0);
INSERT INTO `d_entity` VALUES (120, 1, '5cde27bb-fc78-4e85-9aaa-3f3cebfd5576.png', 0);
INSERT INTO `d_entity` VALUES (121, 1, '561d20eb-1348-41f0-9736-0fc4b5f4e082.png', 0);
INSERT INTO `d_entity` VALUES (122, 1, '16382b4e-4b9b-405a-a8f8-9ec0297c589c.png', 0);
INSERT INTO `d_entity` VALUES (123, 1, 'a994711c-8e10-4822-8cba-1a30c68e208f.png', 0);
INSERT INTO `d_entity` VALUES (124, 1, '85213700-9383-4a4e-88de-9af377841630.png', 0);
INSERT INTO `d_entity` VALUES (125, 1, '2d476a47-beb1-48e6-9726-79eb4c942aa7.png', 0);
INSERT INTO `d_entity` VALUES (126, 1, 'b3cb029b-64e6-40ba-bb20-1bcf3ccd3af0.png', 0);
INSERT INTO `d_entity` VALUES (127, 1, '9c75ff44-bc8f-40ed-a1ff-46562b4f8b09.png', 0);
INSERT INTO `d_entity` VALUES (128, 1, '2a2a22cf-ff64-42b4-a7a2-ac72c81c831e.png', 0);
INSERT INTO `d_entity` VALUES (129, 1, '4ea034d0-5f40-4fee-8599-48808b83f9e7.png', 0);
INSERT INTO `d_entity` VALUES (130, 1, 'f1a6a8fa-42a8-423a-81e6-6b7c940c1b91.png', 0);
INSERT INTO `d_entity` VALUES (131, 1, '04322a29-ca9c-43e0-b75e-edd4d011e567.png', 0);
INSERT INTO `d_entity` VALUES (132, 1, 'ba22f5ee-4a07-4a1d-8fa8-f16f98b4f7ae.png', 0);
INSERT INTO `d_entity` VALUES (133, 1, '1c14d2f8-09c6-4ee9-be82-0d8466871700.png', 0);
INSERT INTO `d_entity` VALUES (134, 1, '39259fe0-dee4-4357-b377-50faeaeed8a7.png', 0);
INSERT INTO `d_entity` VALUES (135, 1, '7adf9ff8-1cac-484b-8e78-83a7263a91e2.png', 0);
INSERT INTO `d_entity` VALUES (136, 1, '32a608b3-f2ff-4271-871a-1a6a720c151a.png', 0);
INSERT INTO `d_entity` VALUES (137, 1, '559b1813-cfda-4005-875c-fe15fb03144e.png', 0);
INSERT INTO `d_entity` VALUES (138, 1, 'e89b7d9b-19c5-4669-ba13-3e3e3c2f9d21.png', 0);
INSERT INTO `d_entity` VALUES (139, 1, 'e301398b-1ee0-4d12-be00-dce01ab7ba19.png', 0);
INSERT INTO `d_entity` VALUES (140, 1, 'f41449de-9d7b-42c7-97df-149588aeb89e.png', 0);
INSERT INTO `d_entity` VALUES (141, 1, '025a88d6-01fd-4cb0-8f08-f86f9286368f.png', 0);
INSERT INTO `d_entity` VALUES (142, 1, 'cf7ae92a-bc41-4e45-8ab7-4c48ae7c8509.png', 0);
INSERT INTO `d_entity` VALUES (143, 1, 'd228e0e9-bd97-4b63-be93-868e571fac2c.png', 0);
INSERT INTO `d_entity` VALUES (144, 1, '1fbf28c1-2d44-4fb1-ae5f-87920e71c56f.png', 0);
INSERT INTO `d_entity` VALUES (145, 1, '16a351c7-0e7b-49cc-a694-263d709b6b5f.png', 0);
INSERT INTO `d_entity` VALUES (146, 1, '6ab649f0-6f5b-49db-97d5-dd6a1ac3f955.png', 0);
INSERT INTO `d_entity` VALUES (147, 1, '3158c44c-15af-4cc7-bb81-683e5722de54.png', 0);
INSERT INTO `d_entity` VALUES (148, 1, '507355a8-0985-49bf-ae09-9f74df40fe5a.png', 0);
INSERT INTO `d_entity` VALUES (149, 1, 'edc2eb0a-a15c-4930-b2a6-14533aa3c1ab.png', 0);
INSERT INTO `d_entity` VALUES (150, 1, 'c6adebcd-15e3-4144-a6ad-2d7fa987fb19.png', 0);
INSERT INTO `d_entity` VALUES (151, 1, '9a4c80d7-3de2-49fe-a5fb-eb32ca621fb4.png', 0);
INSERT INTO `d_entity` VALUES (152, 1, '0bcff30a-bf32-4392-9a07-3a9ef97a7017.png', 0);
INSERT INTO `d_entity` VALUES (153, 1, 'bedf6743-0113-47c4-88a6-3dbb010b8fd4.png', 0);
INSERT INTO `d_entity` VALUES (154, 1, 'ebd15ac6-9b52-48e5-9d16-fea7eaf26f73.png', 0);
INSERT INTO `d_entity` VALUES (155, 1, '142f7975-5fc5-4ca9-b77e-f5f80a610ea6.png', 0);
INSERT INTO `d_entity` VALUES (156, 1, '2c3e4682-54a1-42d5-aa09-c39cca3ff19d.png', 0);
INSERT INTO `d_entity` VALUES (157, 1, 'a2fc83cf-f13d-48ff-ac91-05d85d2cd818.png', 0);
INSERT INTO `d_entity` VALUES (158, 1, 'af140ee5-4026-421b-aaf9-6db242de76d6.png', 0);
INSERT INTO `d_entity` VALUES (159, 1, 'c8cb749a-1192-4ed8-a569-e742aad063ed.png', 0);
INSERT INTO `d_entity` VALUES (160, 1, '5c54fe32-a85b-4639-b993-072d8cb978a3.png', 0);
INSERT INTO `d_entity` VALUES (161, 1, 'a1b559ba-f941-4ee9-a98e-0d31ddb63ba6.png', 0);
INSERT INTO `d_entity` VALUES (162, 1, '2042929c-3390-4d98-ae48-f91d67cdc63d.png', 0);
INSERT INTO `d_entity` VALUES (163, 1, 'e2a4c9fd-b750-49c1-a7b8-76c1178d6e8c.png', 0);
INSERT INTO `d_entity` VALUES (164, 1, '6584e34d-2b74-4329-9c42-6cfbd1acd154.png', 0);
INSERT INTO `d_entity` VALUES (165, 1, '3b27d5a3-0f31-46b3-a8f4-8418263ac7f2.png', 0);
INSERT INTO `d_entity` VALUES (166, 1, '7b4bbc98-a0c2-4a09-abb4-8977c83523ec.png', 0);
INSERT INTO `d_entity` VALUES (167, 1, 'a24bd67b-6afd-4993-a185-de2b85b66853.png', 0);
INSERT INTO `d_entity` VALUES (168, 1, '2ae665b7-0747-4851-9bac-ac2dbb57d3a6.png', 0);
INSERT INTO `d_entity` VALUES (169, 1, 'aefd0a8a-d527-41dc-b0d2-0aa30c601138.png', 0);
INSERT INTO `d_entity` VALUES (170, 1, '5c47805f-d126-4c77-92f6-e60e1ed9c133.png', 0);
INSERT INTO `d_entity` VALUES (171, 1, '9a79dbd4-be7f-4b94-90b1-7d614e9889ea.png', 0);
INSERT INTO `d_entity` VALUES (172, 1, '8a30889a-750e-4927-a117-124a24c9e60f.png', 0);
INSERT INTO `d_entity` VALUES (173, 1, '7c3ecccd-ff68-44a7-8248-d89ed9a22125.png', 0);
INSERT INTO `d_entity` VALUES (174, 1, 'a968c630-e4e5-4478-a696-c725f65ef842.png', 0);
INSERT INTO `d_entity` VALUES (175, 1, 'ee3ca326-08e3-4b86-ae86-20b1afb253a4.png', 0);
INSERT INTO `d_entity` VALUES (176, 1, '24c2062c-9eb7-47a9-8712-251ffcc5a2fe.png', 0);
INSERT INTO `d_entity` VALUES (177, 1, '3e01ea19-de11-47f0-a859-02d6ec2302ce.png', 0);
INSERT INTO `d_entity` VALUES (178, 1, '09e705fb-a01a-4c30-b13e-1fbcf9df528a.png', 0);
INSERT INTO `d_entity` VALUES (179, 1, 'ebe63d4c-7b93-4348-a802-026db640f27e.png', 0);
INSERT INTO `d_entity` VALUES (180, 1, '94263aa4-94b4-4458-855e-61052a6241a5.png', 0);
INSERT INTO `d_entity` VALUES (181, 1, '205fd12d-25c8-4dec-8fae-79885f8d4e36.png', 0);
INSERT INTO `d_entity` VALUES (182, 1, '57a3d9e9-8069-4bd1-b10e-75c17fce66dd.png', 0);
INSERT INTO `d_entity` VALUES (183, 1, 'af782348-a7ee-45fb-9a49-500368d0f956.png', 0);
INSERT INTO `d_entity` VALUES (184, 1, '778c4166-dec7-4f74-9c1b-a86035524fd0.png', 0);
INSERT INTO `d_entity` VALUES (185, 1, 'd807f243-88d8-4797-8fc2-232440e3f2aa.png', 0);
INSERT INTO `d_entity` VALUES (186, 1, '9ca4a82f-1538-422e-a159-7e2bd734afb7.png', 0);
INSERT INTO `d_entity` VALUES (187, 1, '4203eb3b-58a8-40f9-96bb-896cda7453ff.png', 0);
INSERT INTO `d_entity` VALUES (188, 1, '6992b1ef-b46c-4a44-ba7f-8dba881801b7.png', 0);
INSERT INTO `d_entity` VALUES (189, 1, 'a3ec1ee4-4f04-4615-8ece-fa0ba6c0303e.png', 0);
INSERT INTO `d_entity` VALUES (190, 1, '14d8e58e-0ad8-4fd3-af34-a26ca218332b.png', 0);
INSERT INTO `d_entity` VALUES (191, 1, '75890851-4ca6-4d99-bb68-5cfcb373b303.png', 0);
INSERT INTO `d_entity` VALUES (192, 1, '9391706a-3cd3-488d-8abd-c9166011e063.png', 0);
INSERT INTO `d_entity` VALUES (193, 1, 'c3b2c4dd-d621-4498-9a48-b0711c3d42f7.png', 0);
INSERT INTO `d_entity` VALUES (194, 1, 'c8a57f23-97d5-4b15-b93e-e5a38e54b3fa.png', 0);
INSERT INTO `d_entity` VALUES (195, 1, '7804a19d-2efc-42d1-8371-0583af2292cd.png', 0);
INSERT INTO `d_entity` VALUES (196, 1, '97733f3b-5da8-4b9e-8691-d60c49177879.png', 0);
INSERT INTO `d_entity` VALUES (197, 1, '8f0067b6-d853-48a7-aa5d-4f55ffa64c35.png', 0);
INSERT INTO `d_entity` VALUES (198, 1, '87dac01f-7a79-4683-863f-83857c520789.png', 0);
INSERT INTO `d_entity` VALUES (199, 1, '7f5574bd-a5d1-4aa6-b69e-1ff141a8a962.png', 0);
INSERT INTO `d_entity` VALUES (200, 1, 'e36bc6ea-2e4f-42d9-b134-328a5ddee372.png', 0);
INSERT INTO `d_entity` VALUES (201, 1, 'fdfcc2c8-03af-4826-9e5e-f4e86d8565b2.png', 0);
INSERT INTO `d_entity` VALUES (202, 1, '450b0ed3-ef3f-45cd-aa48-f899efe02b87.png', 0);
INSERT INTO `d_entity` VALUES (203, 1, 'daf0eb30-1b71-4781-841a-cf3118dd3554.png', 0);
INSERT INTO `d_entity` VALUES (204, 1, '4a30c634-4f32-4f2a-837f-8bdcdb3cd9d3.png', 0);
INSERT INTO `d_entity` VALUES (205, 1, 'a1635e0a-9bf3-4e6e-8634-8cb9f164b2b9.png', 0);
INSERT INTO `d_entity` VALUES (206, 1, '48611016-268e-4c5b-9a83-6e6752f8de7b.png', 0);
INSERT INTO `d_entity` VALUES (207, 1, 'debea09f-b160-44ee-90fc-00d4f6f9e462.png', 0);
INSERT INTO `d_entity` VALUES (208, 1, 'b6f24b4d-f2f9-4cc0-90a8-ad7ca8d815f2.png', 0);
INSERT INTO `d_entity` VALUES (209, 1, '3027ffb3-294e-42d1-8e7a-a4e0647cd05f.png', 0);
INSERT INTO `d_entity` VALUES (210, 1, 'aba4076e-b53c-4fe0-95c0-2e2cef49d302.png', 0);
INSERT INTO `d_entity` VALUES (211, 1, 'df35e532-e503-4616-965c-ff6a05d82850.png', 0);
INSERT INTO `d_entity` VALUES (212, 1, '4b2e13ca-1301-43c9-94d2-75f8019e14ae.png', 0);
INSERT INTO `d_entity` VALUES (213, 1, 'e055780b-8967-4306-90b6-31872df5d288.png', 0);
INSERT INTO `d_entity` VALUES (214, 1, '55469037-afb2-46b8-b0ae-466104663609.png', 0);
INSERT INTO `d_entity` VALUES (215, 1, '6deccc9b-06bc-44aa-b0da-9123a3c38072.png', 0);
INSERT INTO `d_entity` VALUES (216, 1, '0fbdaa56-32e3-424a-85f0-c7df5df3c726.png', 0);
INSERT INTO `d_entity` VALUES (217, 1, '2327c74c-3e4d-4842-9878-a1e028dec914.png', 0);
INSERT INTO `d_entity` VALUES (218, 1, 'ceeff778-d858-4c66-acc8-ec4bd079355b.png', 0);
INSERT INTO `d_entity` VALUES (219, 1, '9c40a4c1-ac52-40d1-b780-11414f5869ef.png', 0);
INSERT INTO `d_entity` VALUES (220, 1, '68f4602e-b064-40a7-9562-f8c5600abb6e.png', 0);
INSERT INTO `d_entity` VALUES (221, 1, '3fceaf3a-eef6-4191-b7ca-d2d2981afc92.png', 0);
INSERT INTO `d_entity` VALUES (222, 1, '1da4e20f-ca05-41ed-99fe-1026fb2dc57c.png', 0);
INSERT INTO `d_entity` VALUES (223, 1, '1f368af9-677e-4e52-a2f8-07cc344fe25d.png', 0);
INSERT INTO `d_entity` VALUES (224, 1, 'baf2695b-f0a0-4c9b-9b6b-b11f824ba390.png', 0);
INSERT INTO `d_entity` VALUES (225, 1, '3e23c390-6ad9-4c76-a8e8-b75da78dc21e.png', 0);
INSERT INTO `d_entity` VALUES (226, 1, '1644ff04-ace5-4e95-8901-de309efce8d9.png', 0);
INSERT INTO `d_entity` VALUES (227, 1, '69cb8b8d-e12d-400b-8207-1dbb7dca2485.png', 0);
INSERT INTO `d_entity` VALUES (228, 1, 'f03b4a6a-331a-4e8e-b88a-f49abb8f1aae.png', 0);
INSERT INTO `d_entity` VALUES (229, 1, '62deaf7a-074c-4963-94d5-afa21975d2b6.png', 0);
INSERT INTO `d_entity` VALUES (230, 1, '29e46317-a766-418f-9733-b4326d78a102.png', 0);
INSERT INTO `d_entity` VALUES (231, 1, '9cb8d554-2cf6-4887-a0bf-602f6a979b58.png', 0);
INSERT INTO `d_entity` VALUES (232, 1, 'fb57e34b-0a8b-4cb2-8e95-49559d1a78e6.png', 0);
INSERT INTO `d_entity` VALUES (233, 1, 'd402e408-9ddc-4e61-81ef-34d80fa553d3.png', 0);
INSERT INTO `d_entity` VALUES (234, 1, 'ec2cb0f6-e72e-4e6f-b1a0-3f39e8f75e1d.png', 0);
INSERT INTO `d_entity` VALUES (235, 1, 'acbcb991-56b2-4414-b187-e2a92c31d40a.png', 0);
INSERT INTO `d_entity` VALUES (236, 1, '38172055-21f0-42ad-ba49-21c9327dd0d9.png', 0);
INSERT INTO `d_entity` VALUES (237, 1, '11208919-7c35-4434-9fa8-aef082203dc7.png', 0);
INSERT INTO `d_entity` VALUES (238, 1, '8af9ce75-7a41-4ac7-98e3-1715419eb9a1.png', 0);
INSERT INTO `d_entity` VALUES (239, 1, 'c0a69b6b-0714-4d88-a7a4-6e2551c3ba33.png', 0);
INSERT INTO `d_entity` VALUES (240, 1, 'cf354498-98b4-4dbd-a497-fc0ffde8e3f9.png', 0);
INSERT INTO `d_entity` VALUES (241, 1, '9da46fea-ed1e-4ff3-9e91-5b70d5fcc636.png', 0);
INSERT INTO `d_entity` VALUES (242, 1, '2d7377ce-6c78-4d64-bfb6-e4ee18ad0fc2.png', 0);
INSERT INTO `d_entity` VALUES (243, 1, '4cc54feb-65ae-4ec8-b0ab-b7b451f5795e.png', 0);
INSERT INTO `d_entity` VALUES (244, 1, '94a3e194-11c7-4efc-9c5a-83aa09f002df.png', 0);
INSERT INTO `d_entity` VALUES (245, 1, '6ee6976a-9b13-4959-8c03-f9e19d98435f.png', 0);
INSERT INTO `d_entity` VALUES (246, 1, 'a03bc349-b575-4e66-858e-4fc88665c998.png', 0);
INSERT INTO `d_entity` VALUES (247, 1, '438261f0-f202-419c-af00-2ce5a029323e.png', 0);
INSERT INTO `d_entity` VALUES (248, 1, '28c4a6ca-0da5-4b8b-8932-7d3db3c8e2a6.png', 0);
INSERT INTO `d_entity` VALUES (249, 1, '3423cf22-d58a-49b7-b3c4-2caf7fcfefa3.png', 0);
INSERT INTO `d_entity` VALUES (250, 1, '0c7d6333-63ab-4266-be38-40e90fca0f6a.png', 0);
INSERT INTO `d_entity` VALUES (251, 1, 'e22f8bfd-b5d3-4574-a5b8-5d42e9475230.png', 0);
INSERT INTO `d_entity` VALUES (252, 1, '4b80721f-dbd5-4848-83da-3c97e89f9b18.png', 0);
INSERT INTO `d_entity` VALUES (253, 1, '39cb8474-3a08-43f7-bf2a-1c54799cd2ca.png', 0);
INSERT INTO `d_entity` VALUES (254, 1, '19c1bc1e-0369-44a3-b364-e04653662817.png', 0);
INSERT INTO `d_entity` VALUES (255, 1, '8fcbbefb-1618-4c0b-9f66-d32f311196f5.png', 0);
INSERT INTO `d_entity` VALUES (256, 1, 'f6568cb2-194b-4798-b271-64f3e6e44238.png', 0);
INSERT INTO `d_entity` VALUES (257, 1, '5d541577-4c70-49e1-87b0-c5e92628a1ec.png', 0);
INSERT INTO `d_entity` VALUES (258, 1, 'd1268799-0f95-41c0-968f-40796b3446de.png', 0);
INSERT INTO `d_entity` VALUES (259, 1, '44e3d33f-748b-4ca0-8c28-9ad2bf54f162.png', 0);
INSERT INTO `d_entity` VALUES (260, 1, '51c73bb6-d976-45d3-92db-cac294df561e.png', 0);
INSERT INTO `d_entity` VALUES (261, 1, 'a15641aa-a74d-4872-b5ff-dfebd4ed2f35.png', 0);
INSERT INTO `d_entity` VALUES (262, 1, '343e9105-95e0-4c2f-933d-44f4e8f5b866.png', 0);
INSERT INTO `d_entity` VALUES (263, 1, '49a57ac5-9d97-4b2d-afd0-67e989dc6b5b.png', 0);
INSERT INTO `d_entity` VALUES (264, 1, 'ae0c5853-151c-4e8f-8486-093ff1498b02.png', 0);
INSERT INTO `d_entity` VALUES (265, 1, '8ebf071e-d96e-4e3f-a827-37bd67997abc.png', 0);
INSERT INTO `d_entity` VALUES (266, 1, 'ff155bc9-0f8e-4cb6-bf94-19925b3d0183.png', 0);
INSERT INTO `d_entity` VALUES (267, 1, 'c9929e3e-a44b-4ef8-bb8b-9950f6576f53.png', 0);
INSERT INTO `d_entity` VALUES (268, 1, '844d10cd-c5d7-494f-bd7d-c1cb4d993d6b.png', 0);
INSERT INTO `d_entity` VALUES (269, 1, '37372b7b-9b43-4909-9f37-0ad485f58eea.png', 0);
INSERT INTO `d_entity` VALUES (270, 1, '87219b0c-c724-4181-8112-4e8e0165ff9b.png', 0);
INSERT INTO `d_entity` VALUES (271, 1, 'bbf3496d-b6a7-41a8-b089-01b980012a8b.png', 0);
INSERT INTO `d_entity` VALUES (272, 1, 'fd66c44d-8769-4c31-b5ad-77bb2634c32b.png', 0);
INSERT INTO `d_entity` VALUES (273, 1, 'dd07d82e-acd0-4207-8e79-33ae550024e7.png', 0);
INSERT INTO `d_entity` VALUES (274, 1, '0e20b675-582f-4fc3-9068-3201144c857e.png', 0);
INSERT INTO `d_entity` VALUES (275, 1, '4c99dbdf-4eff-4ab3-a64d-912673cfd1f0.png', 0);
INSERT INTO `d_entity` VALUES (276, 1, '3a974672-1fac-4037-9545-8b1a7a04e356.png', 0);
INSERT INTO `d_entity` VALUES (277, 1, '05dcf1fc-fe66-4598-b6d8-0c7658995f5c.png', 0);
INSERT INTO `d_entity` VALUES (278, 1, '59ac89bc-2ab9-4047-84be-3d5cccc259f0.png', 0);
INSERT INTO `d_entity` VALUES (279, 1, '721af819-bbc8-49f4-8033-bf28c3846fee.png', 0);
INSERT INTO `d_entity` VALUES (280, 1, '1c3300e2-2b30-4bfb-9bf9-6474b9185d88.png', 0);
INSERT INTO `d_entity` VALUES (281, 1, '1ad7e86d-4066-428f-905f-398f10415efb.png', 0);
INSERT INTO `d_entity` VALUES (282, 1, '4403fc1e-e393-40d1-911d-c246463b1dc1.png', 0);
INSERT INTO `d_entity` VALUES (283, 1, 'a00414eb-9a87-48dd-a8b1-9b8367e4f11c.png', 0);
INSERT INTO `d_entity` VALUES (284, 1, '20bdd5bd-76d3-4f32-82b9-d1df10b487ec.png', 0);
INSERT INTO `d_entity` VALUES (285, 1, '5737ef09-49b2-49ac-8c22-57cc6a9895ef.png', 0);
INSERT INTO `d_entity` VALUES (286, 1, 'a45e8f39-189b-47c7-8bea-b912604c57d2.png', 0);
INSERT INTO `d_entity` VALUES (287, 1, '33ba946e-aeb2-4453-bb54-05b71affc9e5.png', 0);
INSERT INTO `d_entity` VALUES (288, 1, '2e9ee2ac-00ef-4e37-821a-399ffaafa8d8.png', 0);
INSERT INTO `d_entity` VALUES (289, 1, 'd400a7d6-21f9-4b00-b15d-2268b6d5e040.png', 0);
INSERT INTO `d_entity` VALUES (290, 1, '3fb3a19b-f679-4285-97aa-268bbdb70e7d.png', 0);
INSERT INTO `d_entity` VALUES (291, 1, '24c813d7-05d1-4795-bdd5-a23c32900854.png', 0);
INSERT INTO `d_entity` VALUES (292, 1, '169fd169-1b03-4006-8186-cf52fdc37f30.png', 0);
INSERT INTO `d_entity` VALUES (293, 1, '7385ad14-8b08-414e-8785-e33eab4f9379.png', 0);
INSERT INTO `d_entity` VALUES (294, 1, '64e0e212-b1a5-467f-a80e-79d40285729f.png', 0);
INSERT INTO `d_entity` VALUES (295, 1, 'b49dc312-a051-42f9-9dce-366a118fcd42.png', 0);
INSERT INTO `d_entity` VALUES (296, 1, 'e15ad70c-1c67-40f3-b349-5d57de4edb52.png', 0);
INSERT INTO `d_entity` VALUES (297, 1, 'd0ac92a5-a131-49ea-9064-8fbf543eadd7.png', 0);
INSERT INTO `d_entity` VALUES (298, 1, 'd4e0aade-e4ae-44b7-bc53-ecdc2f06cce3.png', 0);
INSERT INTO `d_entity` VALUES (299, 1, '925a340a-e5b8-4d06-bbc3-95c20a622bbf.png', 0);
INSERT INTO `d_entity` VALUES (300, 1, '7bb9b553-c5af-462b-9fcf-3a119a83ff0d.png', 0);
INSERT INTO `d_entity` VALUES (301, 1, 'a02500c3-0c8b-4269-a0eb-7c4c1dada2da.png', 0);
INSERT INTO `d_entity` VALUES (302, 1, '52faf78d-5d28-45d9-adf6-9683eb8b88bc.png', 0);
INSERT INTO `d_entity` VALUES (303, 1, '47aaf48d-fa02-47e9-9029-e0be4ecf32b5.png', 0);
INSERT INTO `d_entity` VALUES (304, 1, 'f8feb0d0-a4ad-40ae-8051-88db42a8b1a8.png', 0);
INSERT INTO `d_entity` VALUES (305, 1, 'aa54cf86-dc75-4b2d-8cd6-d5f96e939f34.png', 0);
INSERT INTO `d_entity` VALUES (306, 1, '94a7b8fd-ed7f-426f-bd18-fd7ec0b72788.png', 0);
INSERT INTO `d_entity` VALUES (307, 2, 'ca007baa-0806-4a3a-8bab-270eee8c2499.png', 0);
INSERT INTO `d_entity` VALUES (308, 2, 'cd8a86d0-0f8e-4282-89c5-eff9ac7b739e.png', 0);
INSERT INTO `d_entity` VALUES (309, 2, '510f4a0e-4fd2-4070-bc7e-7e40fc930565.png', 0);
INSERT INTO `d_entity` VALUES (310, 2, '5b79de15-aae6-4a09-86f6-876187f0ddb4.png', 0);
INSERT INTO `d_entity` VALUES (311, 2, '0cab7671-557a-470e-bd00-d9d56ce33587.png', 0);
INSERT INTO `d_entity` VALUES (312, 2, 'e418b67f-a777-4a95-b6a7-76dece97ba0d.png', 0);
INSERT INTO `d_entity` VALUES (313, 2, '19d8bd5a-ce1c-4d4a-8806-c139d17ab129.png', 0);
INSERT INTO `d_entity` VALUES (314, 2, 'f6259031-ef6b-48a7-8614-a87b901e3004.png', 0);
INSERT INTO `d_entity` VALUES (315, 2, '919adb74-bdbd-440d-a76a-1e879071cf83.png', 0);
INSERT INTO `d_entity` VALUES (316, 2, 'aa02237f-0a52-4863-8fa2-c2914b95c111.png', 0);
INSERT INTO `d_entity` VALUES (317, 2, '05a4cac7-2727-4bea-a64a-73de24727875.png', 0);
INSERT INTO `d_entity` VALUES (318, 2, 'a83c3b65-4af2-4b66-89d0-819dc30350f2.png', 0);
INSERT INTO `d_entity` VALUES (319, 2, 'aef6bec4-907f-4c4c-bd58-f22a87ac283c.png', 0);
INSERT INTO `d_entity` VALUES (320, 2, 'a60129ae-2326-436d-b8a7-68614f65a6df.png', 0);
INSERT INTO `d_entity` VALUES (321, 2, 'a346bbfb-277d-4c77-96d8-acec9468ca70.png', 0);
INSERT INTO `d_entity` VALUES (322, 2, '9fe7a0b2-afd7-41a2-b771-7ad6e46f87ad.png', 0);
INSERT INTO `d_entity` VALUES (323, 2, 'f5714e82-7387-4c03-837b-dc6264642165.png', 0);
INSERT INTO `d_entity` VALUES (324, 2, 'fa718a3b-6a03-4107-86d8-a271d9cbd4ce.png', 0);
INSERT INTO `d_entity` VALUES (325, 2, '3a9400c5-782a-4fba-af61-736a180410be.png', 0);
INSERT INTO `d_entity` VALUES (326, 2, 'd7d6540a-b5bd-4301-8162-17a0dd568986.png', 0);
INSERT INTO `d_entity` VALUES (327, 2, '37dbf704-9d6b-4d6f-b5aa-5e5e156b8682.png', 0);
INSERT INTO `d_entity` VALUES (328, 2, 'e08f4205-85a9-4309-a384-b88719d5ade5.png', 0);
INSERT INTO `d_entity` VALUES (329, 2, '37497a4b-875e-4092-893c-9dc6e19926a6.png', 0);
INSERT INTO `d_entity` VALUES (330, 2, '0453a235-f00e-414e-bc06-286bbb10d32d.png', 0);
INSERT INTO `d_entity` VALUES (331, 2, '83f494e0-a7f2-430c-801c-9f89136374eb.png', 0);
INSERT INTO `d_entity` VALUES (332, 2, '4d17aca4-6637-4e08-88b4-45a1afc6da65.png', 0);
INSERT INTO `d_entity` VALUES (333, 2, 'a1a60651-9af6-43e6-ac5e-616dffc134a5.png', 0);
INSERT INTO `d_entity` VALUES (334, 2, 'c53c9eb9-b84d-45b0-b944-6cc2340991ea.png', 0);
INSERT INTO `d_entity` VALUES (335, 2, 'fc1314ce-e930-475e-a472-9aff6a3c7cff.png', 0);
INSERT INTO `d_entity` VALUES (336, 2, 'a0ac7b14-855e-475e-b352-7de65af81669.png', 0);
INSERT INTO `d_entity` VALUES (337, 2, '9f197df6-1488-491b-8fb0-10fedbfdc680.png', 0);
INSERT INTO `d_entity` VALUES (338, 2, 'de7f82e1-d214-400c-b46f-7d413a2ccf70.png', 0);
INSERT INTO `d_entity` VALUES (339, 2, '4db01839-2154-42e2-a3f4-845724c505a7.png', 0);
INSERT INTO `d_entity` VALUES (340, 2, '6a1dbf64-7c51-47fa-bb13-5f1d17c2bd3d.png', 0);
INSERT INTO `d_entity` VALUES (341, 2, '95a9a84b-8f58-4cd5-a7c1-0a7117f9d0b6.png', 0);
INSERT INTO `d_entity` VALUES (342, 2, 'c0ab7af4-5717-4a0e-b3e4-17571de5a329.png', 0);
INSERT INTO `d_entity` VALUES (343, 2, '74f671c8-4285-446d-aa1c-a228bf0f90fa.png', 0);
INSERT INTO `d_entity` VALUES (344, 2, 'a034dccc-4e31-4e04-95ca-8f0fa6d93a50.png', 0);
INSERT INTO `d_entity` VALUES (345, 2, '63a8a0a6-9c43-402c-8017-acbdfd8edc98.png', 0);
INSERT INTO `d_entity` VALUES (346, 2, '1a29e35d-b502-4440-863b-b18702a283c9.png', 0);
INSERT INTO `d_entity` VALUES (347, 2, '3c75b0e3-8d5c-4bd6-9ac7-0b238b558206.png', 0);
INSERT INTO `d_entity` VALUES (348, 2, 'f9ced07a-8581-4e61-880f-382c08622694.png', 0);
INSERT INTO `d_entity` VALUES (349, 2, '5e35d0b4-f90d-49e6-b379-5e6564634a05.png', 0);
INSERT INTO `d_entity` VALUES (350, 2, '4045e94e-5140-4f6a-8c2b-dd92dbae3c14.png', 0);
INSERT INTO `d_entity` VALUES (351, 2, 'bd0f6478-5d8b-47de-af34-fd700b59cafa.png', 0);
INSERT INTO `d_entity` VALUES (352, 2, '4ca3cb52-1b1e-46cc-a813-4c9f9461f0eb.png', 0);
INSERT INTO `d_entity` VALUES (353, 2, 'f0b9468f-6438-4dbb-9644-735271443db7.png', 0);
INSERT INTO `d_entity` VALUES (354, 2, '514f4b1a-359e-4469-8173-4d3d9408743c.png', 0);
INSERT INTO `d_entity` VALUES (355, 2, 'da4bf890-3070-4d15-8120-1dd4a299c3a8.png', 0);
INSERT INTO `d_entity` VALUES (356, 2, 'f3a950f5-5206-4c18-83ec-c64343155f8b.png', 0);
INSERT INTO `d_entity` VALUES (357, 2, 'fb11f137-8683-4302-b1ca-18209565b8a9.png', 0);
INSERT INTO `d_entity` VALUES (358, 2, '2c7b3177-b588-4a68-ba32-a712f4e49807.png', 0);
INSERT INTO `d_entity` VALUES (359, 2, '7b331d62-3be1-4fd3-ac60-9626903e9189.png', 0);
INSERT INTO `d_entity` VALUES (360, 2, '2dbb0762-f031-4cb6-8e19-da953250cdca.png', 0);
INSERT INTO `d_entity` VALUES (361, 2, '56ca1785-1c71-4404-96b2-95b90598fe2c.png', 0);
INSERT INTO `d_entity` VALUES (362, 2, 'f92cb8b8-5c79-47ad-b857-8a32973bc700.png', 0);
INSERT INTO `d_entity` VALUES (363, 2, '862ee2ef-4859-4ac1-aff4-2e9333e70518.png', 0);
INSERT INTO `d_entity` VALUES (364, 2, '031050ae-8d7a-4ebf-8a92-30f7e433fe4c.png', 0);
INSERT INTO `d_entity` VALUES (365, 2, '21263d5a-f537-457d-95fc-1cf472197548.png', 0);
INSERT INTO `d_entity` VALUES (366, 2, 'b986911b-0f41-412f-8ea8-dd5b8ceb5e5c.png', 0);
INSERT INTO `d_entity` VALUES (367, 2, '8a5b394f-433c-436c-804b-cc6a6aff5f93.png', 0);
INSERT INTO `d_entity` VALUES (368, 2, '296a059f-d555-40e0-9be4-568d2a87fe46.png', 0);
INSERT INTO `d_entity` VALUES (369, 2, 'baaff2d1-11cb-4382-b7c9-fd4e89886419.png', 0);
INSERT INTO `d_entity` VALUES (370, 2, '08b3538b-c51c-47d5-aca6-9abd152cee79.png', 0);
INSERT INTO `d_entity` VALUES (371, 2, 'a8fdc848-fbd4-4def-8e86-2015db09a632.png', 0);
INSERT INTO `d_entity` VALUES (372, 2, 'acc16998-e11e-44b5-8fce-1405f5b4b68a.png', 0);
INSERT INTO `d_entity` VALUES (373, 2, 'b2d55dda-f059-4e96-9083-2c2a7b554d34.png', 0);
INSERT INTO `d_entity` VALUES (374, 2, 'a341b2e6-3950-4581-b58b-705e8e5ffcfe.png', 0);
INSERT INTO `d_entity` VALUES (375, 2, 'cd7c59f9-8b02-4749-a865-7554d0b3bfcd.png', 0);
INSERT INTO `d_entity` VALUES (376, 2, 'd6656119-2ad1-44db-998f-2bb1e2a72ebb.png', 0);
INSERT INTO `d_entity` VALUES (377, 2, '7afa1a3b-d61c-429c-8059-4d9a327622d9.png', 0);
INSERT INTO `d_entity` VALUES (378, 2, '486bf5c3-a76d-4919-978f-835b7dd50812.png', 0);
INSERT INTO `d_entity` VALUES (379, 2, 'ea3dab5f-74b3-4f85-bde8-1eceffa1b499.png', 0);
INSERT INTO `d_entity` VALUES (380, 2, 'a05ee31c-8d5f-438c-b987-18a6e9a59baa.png', 0);
INSERT INTO `d_entity` VALUES (381, 2, '8379e1cc-1e93-49c5-86d6-985b0d855726.png', 0);
INSERT INTO `d_entity` VALUES (382, 2, 'b641a1a1-e1f3-40b4-aac0-30be60c139a3.png', 0);
INSERT INTO `d_entity` VALUES (383, 2, '8718b422-86ef-409e-a051-6800124d4ef9.png', 0);
INSERT INTO `d_entity` VALUES (384, 2, '4dbd0ef1-9844-4497-8b49-a108e5d16040.png', 0);
INSERT INTO `d_entity` VALUES (385, 2, 'fd1e7520-0076-4a10-9ea1-5910cce3f993.png', 0);
INSERT INTO `d_entity` VALUES (386, 2, '07fd26aa-b322-4490-b4d1-a49a8477f3f2.png', 0);
INSERT INTO `d_entity` VALUES (387, 2, '1f9bd478-923f-40f3-8712-4e54416c4375.png', 0);
INSERT INTO `d_entity` VALUES (388, 2, '8a153444-7217-48ff-9389-bd95fabbb001.png', 0);
INSERT INTO `d_entity` VALUES (389, 2, '14429b2b-e345-4e0a-a8c0-20676debd78b.png', 0);
INSERT INTO `d_entity` VALUES (390, 2, 'c0fd3b82-8dff-43dd-83ae-7d0ac8bb9d41.png', 0);
INSERT INTO `d_entity` VALUES (391, 2, '043017d7-f85a-4a0e-a57d-7a6c1a9e88dd.png', 0);
INSERT INTO `d_entity` VALUES (392, 2, '5fe6037b-1550-4979-a01b-fc531f936b30.png', 0);
INSERT INTO `d_entity` VALUES (393, 2, '3ae5851b-8b2b-4788-a895-7b873cab7d79.png', 0);
INSERT INTO `d_entity` VALUES (394, 2, '5bff0c32-9b1e-4538-9840-479d6eb3b37e.png', 0);
INSERT INTO `d_entity` VALUES (395, 2, 'b20f9237-70ec-4c18-ac03-9f49feb77c83.png', 0);
INSERT INTO `d_entity` VALUES (396, 2, '03e1d136-a87b-457c-8500-f2f69ddd2c6f.png', 0);
INSERT INTO `d_entity` VALUES (397, 2, '843c8c05-967d-4f68-a5a1-6e6e6fbc4361.png', 0);
INSERT INTO `d_entity` VALUES (398, 2, '833444d8-1388-46c4-b01d-6dbc41241088.png', 0);
INSERT INTO `d_entity` VALUES (399, 2, 'd4863b2e-4d07-4c80-a5c3-588a29127e6f.png', 0);
INSERT INTO `d_entity` VALUES (400, 2, '936a4482-6c23-4c9b-8215-b44c9f3c1990.png', 0);
INSERT INTO `d_entity` VALUES (401, 2, '6a8d086e-bd59-4ec8-b31d-6f14f85519d4.png', 0);
INSERT INTO `d_entity` VALUES (402, 2, 'a5d7c97e-c6e3-46c9-bee8-dc660b203655.png', 0);
INSERT INTO `d_entity` VALUES (403, 2, '92c771e4-c103-4b5c-9eb4-ee4c02afa9f4.png', 0);
INSERT INTO `d_entity` VALUES (404, 2, '1d65345f-c79f-404e-b890-afdc22c9525d.png', 0);
INSERT INTO `d_entity` VALUES (405, 2, '1b52a50f-d23c-4b7c-b1e0-8f5668cf2b68.png', 0);
INSERT INTO `d_entity` VALUES (406, 2, 'f253f718-4ba5-4fe2-b613-2b58f9966cec.png', 0);
INSERT INTO `d_entity` VALUES (407, 2, '45fd4ee8-4eee-4e5d-a990-01efdb4f7c7e.png', 0);
INSERT INTO `d_entity` VALUES (408, 2, 'abdb6b10-3ff2-42dc-8075-bae5f48bf8d3.png', 0);
INSERT INTO `d_entity` VALUES (409, 2, '9d55bf5f-8f19-4f93-be4e-775ac3225552.png', 0);
INSERT INTO `d_entity` VALUES (410, 2, '836d1075-c381-40dc-910b-b72233996e62.png', 0);
INSERT INTO `d_entity` VALUES (411, 2, '30f358a4-b884-4a9c-9164-a8ac256247eb.png', 0);
INSERT INTO `d_entity` VALUES (412, 2, '216fe38a-be62-4f1d-8b6f-e768b1875df5.png', 0);
INSERT INTO `d_entity` VALUES (413, 2, '7763aa8a-4e1f-4fb3-a7c7-9ba2119e91b4.png', 0);
INSERT INTO `d_entity` VALUES (414, 2, '61b58415-dda1-42ff-95b0-4e2f9ad425fd.png', 0);
INSERT INTO `d_entity` VALUES (415, 2, 'd7e50fc2-a4ba-4bc5-8da3-13eded727b01.png', 0);
INSERT INTO `d_entity` VALUES (416, 2, '9e38647f-f6b3-4f29-bd92-2983d666731d.png', 0);
INSERT INTO `d_entity` VALUES (417, 2, '31b931fe-4015-4ebb-a19f-e38837e32302.png', 0);
INSERT INTO `d_entity` VALUES (418, 2, '1dc323fc-7724-4dd8-9875-113be8623867.png', 0);
INSERT INTO `d_entity` VALUES (419, 2, '07236296-9350-4de5-884f-6eefbd6aa0c5.png', 0);
INSERT INTO `d_entity` VALUES (420, 2, '90874cc2-6ff5-4d2e-ae89-0c1ac90f503b.png', 0);
INSERT INTO `d_entity` VALUES (421, 2, '2a690f0a-7247-4dd8-abe4-57b40a425d01.png', 0);
INSERT INTO `d_entity` VALUES (422, 2, '53c94541-cf66-40d2-bb0e-783382ad06be.png', 0);
INSERT INTO `d_entity` VALUES (423, 2, '811bebb8-cb4f-4b9d-abe2-da04b59ff37b.png', 0);
INSERT INTO `d_entity` VALUES (424, 2, '075ab266-1278-4636-96ce-992dd3213b56.png', 0);
INSERT INTO `d_entity` VALUES (425, 2, 'cf155e8f-127c-4415-a9cf-b2334ff3f8aa.png', 0);
INSERT INTO `d_entity` VALUES (426, 2, 'df6c021d-fddd-407c-b8b1-5238dabeb31d.png', 0);
INSERT INTO `d_entity` VALUES (427, 2, '4cb5f1e3-2630-4761-9d98-b6aea78f1b71.png', 0);
INSERT INTO `d_entity` VALUES (428, 2, 'e5bdece3-591d-4e6e-94a6-eab0a7e8fc7e.png', 0);
INSERT INTO `d_entity` VALUES (429, 2, '543d60fd-9233-4c76-b6a0-c372bc0d46f5.png', 0);
INSERT INTO `d_entity` VALUES (430, 2, 'af4299cc-fc9e-4693-93e5-e2dc7e24e457.png', 0);
INSERT INTO `d_entity` VALUES (431, 2, 'cd5b6733-0224-4578-b470-ecbad86545ad.png', 0);
INSERT INTO `d_entity` VALUES (432, 2, '0ac5f022-59a3-4402-be94-3d20df8b3e52.png', 0);
INSERT INTO `d_entity` VALUES (433, 2, 'c9b452f8-d40d-4cc8-8f3b-cc569dcec481.png', 0);
INSERT INTO `d_entity` VALUES (434, 2, 'ed75c02e-64f8-47c0-bfb0-d1390d33912c.png', 0);
INSERT INTO `d_entity` VALUES (435, 2, 'e5129999-736e-43a6-bd7a-7b75c927550b.png', 0);
INSERT INTO `d_entity` VALUES (436, 2, 'db278e73-0deb-4143-a473-22490e18303b.png', 0);
INSERT INTO `d_entity` VALUES (437, 2, '6290bb8d-1f2e-41f1-9bdc-6398974475fe.png', 0);
INSERT INTO `d_entity` VALUES (438, 2, '4597b94a-18d3-447c-8f53-950c09d1fcaf.png', 0);
INSERT INTO `d_entity` VALUES (439, 2, '5ebb75c9-860f-474d-9d7a-cfe8fea9981c.png', 0);
INSERT INTO `d_entity` VALUES (440, 2, '17e6b4ab-7d26-4606-8093-91e09029e0f6.png', 0);
INSERT INTO `d_entity` VALUES (441, 2, '630172fe-89f1-4291-8c81-750cce21e040.png', 0);
INSERT INTO `d_entity` VALUES (442, 2, '65adbac3-0d91-41f4-8a7b-744fd289704c.png', 0);
INSERT INTO `d_entity` VALUES (443, 2, '30511238-b112-467d-aa76-febb2384e0dc.png', 0);
INSERT INTO `d_entity` VALUES (444, 2, '49f10f95-f948-44e2-9d52-2e520cc439f1.png', 0);
INSERT INTO `d_entity` VALUES (445, 2, 'a62b5766-eca0-4c67-b7e1-b33dec920a71.png', 0);
INSERT INTO `d_entity` VALUES (446, 2, '2ebfa826-28f0-4103-9959-dea592beb67d.png', 0);
INSERT INTO `d_entity` VALUES (447, 2, 'dbdf3c31-3862-42b5-9cdb-03b558a2896f.png', 0);
INSERT INTO `d_entity` VALUES (448, 2, '4b5a2cdc-46f5-45eb-bdf6-b1721c277519.png', 0);
INSERT INTO `d_entity` VALUES (449, 2, '007af354-beb8-4733-9f91-a47160fd81f5.png', 0);
INSERT INTO `d_entity` VALUES (450, 2, '74bee861-7569-4f10-a053-baefbb9bdd63.png', 0);
INSERT INTO `d_entity` VALUES (451, 2, '018ed173-440a-43ef-b1f0-9807c8602e51.png', 0);
INSERT INTO `d_entity` VALUES (452, 2, '91541e24-5985-4e18-9ac7-783ab59b987d.png', 0);
INSERT INTO `d_entity` VALUES (453, 2, '52119e2f-cf15-4a4d-b49c-1a5d6df067a0.png', 0);
INSERT INTO `d_entity` VALUES (454, 2, '92f370b4-e91b-4ebd-ad39-c3d109355028.png', 0);
INSERT INTO `d_entity` VALUES (455, 2, '4bee1610-c46f-45ff-bf78-26a8cc83953e.png', 0);
INSERT INTO `d_entity` VALUES (456, 2, 'd1fcabd1-9179-44fd-8f71-34d3b96fb50f.png', 0);
INSERT INTO `d_entity` VALUES (457, 2, 'd448f102-1554-476e-84d1-c919bd4b1ee7.png', 0);
INSERT INTO `d_entity` VALUES (458, 2, '86aeb69f-846a-4f08-826d-6e8bef8067a1.png', 0);
INSERT INTO `d_entity` VALUES (459, 2, 'e67b6892-13ce-44f6-971b-894b1d0edb6d.png', 0);
INSERT INTO `d_entity` VALUES (460, 2, 'f8b3e6c4-7892-48f4-b1de-b1458242bb7d.png', 0);
INSERT INTO `d_entity` VALUES (461, 2, '216bf3ba-5e95-48b5-9dd1-d14b98fa3240.png', 0);
INSERT INTO `d_entity` VALUES (462, 2, 'b5ffb7d7-1a36-4fa5-ac0c-6d491627d27d.png', 0);
INSERT INTO `d_entity` VALUES (463, 2, 'f9f3bc6e-b615-4451-b264-c984147236c8.png', 0);
INSERT INTO `d_entity` VALUES (464, 2, 'c7b1535a-6a7b-4e6e-8379-4f44e596440c.png', 0);
INSERT INTO `d_entity` VALUES (465, 2, 'a52f9a3c-150a-43f0-85a2-31a6161e26b1.png', 0);
INSERT INTO `d_entity` VALUES (466, 2, '0c1c2254-d633-49c7-8d2b-1998738ccf28.png', 0);
INSERT INTO `d_entity` VALUES (467, 2, '51fb672a-7287-44ba-a7f7-b98d5c812bdb.png', 0);
INSERT INTO `d_entity` VALUES (468, 2, 'c0488e6c-b899-4ee9-ad2a-6eb79f0db0cc.png', 0);
INSERT INTO `d_entity` VALUES (469, 2, 'f49a234c-344b-4ea5-a6bf-2bce8f10a2d1.png', 0);
INSERT INTO `d_entity` VALUES (470, 2, '084d2612-9cd7-4ffc-a853-17c91e06cd10.png', 0);
INSERT INTO `d_entity` VALUES (471, 2, 'c4ce5d3a-e5c4-4e47-abb1-5c3c2020afbe.png', 0);
INSERT INTO `d_entity` VALUES (472, 2, '27ffe230-2740-4e3c-864f-45d08c745cea.png', 0);
INSERT INTO `d_entity` VALUES (473, 2, '108eccec-6e12-49f3-9d84-ad37146acc36.png', 0);
INSERT INTO `d_entity` VALUES (474, 2, 'ff860b80-6635-4f22-8475-1a672671a532.png', 0);
INSERT INTO `d_entity` VALUES (475, 2, '72f4ac2d-ae3a-495c-8069-7108e15dea8c.png', 0);
INSERT INTO `d_entity` VALUES (476, 2, 'd64dcf94-6788-4382-bae5-a8fc0c32f773.png', 0);
INSERT INTO `d_entity` VALUES (477, 2, '9d5d6111-b2c9-4593-8c8c-4f0a2eb01c30.png', 0);
INSERT INTO `d_entity` VALUES (478, 2, '9cc4b528-177f-472c-a8b5-54a46dfe786f.png', 0);
INSERT INTO `d_entity` VALUES (479, 2, '1f076d80-aeb0-4830-be47-e7263b68d1af.png', 0);
INSERT INTO `d_entity` VALUES (480, 2, '0786a06a-d92d-4ad4-b8cb-5cfc4b01c839.png', 0);
INSERT INTO `d_entity` VALUES (481, 2, 'edb6f980-a98c-4119-b236-42d6256d31af.png', 0);
INSERT INTO `d_entity` VALUES (482, 2, '173f9abc-654c-481d-9a7c-24ff3b99284c.png', 0);
INSERT INTO `d_entity` VALUES (483, 2, 'f9d134b8-0641-4b24-891c-192d7e7ce86c.png', 0);
INSERT INTO `d_entity` VALUES (484, 2, 'b78b0962-6111-4318-aef6-399ee7a12af9.png', 0);
INSERT INTO `d_entity` VALUES (485, 2, 'b6ed130b-dce9-48c4-8d6c-4f1cecf566f5.png', 0);
INSERT INTO `d_entity` VALUES (486, 2, 'dc10c47b-b1ce-4ba5-adeb-d3705daf71b6.png', 0);
INSERT INTO `d_entity` VALUES (487, 2, '72326be2-9d41-40ab-a93a-762abc44d905.png', 0);
INSERT INTO `d_entity` VALUES (488, 2, 'ac6c4a9f-e87a-4bcd-be15-649bcba16f97.png', 0);
INSERT INTO `d_entity` VALUES (489, 2, '59b97268-0c25-4fc2-9cf4-612d5f84c1f6.png', 0);
INSERT INTO `d_entity` VALUES (490, 2, '3947e84e-a0b5-4b00-835c-b66913c1a23a.png', 0);
INSERT INTO `d_entity` VALUES (491, 2, '6f237b46-de2d-4d72-9b6d-fc0e6918b4ab.png', 0);
INSERT INTO `d_entity` VALUES (492, 2, '1ebd1c0d-ed40-425c-b137-6b9421fd4fb3.png', 0);
INSERT INTO `d_entity` VALUES (493, 2, '6d364dd0-d432-4cf9-aecc-96813214ba87.png', 0);
INSERT INTO `d_entity` VALUES (494, 2, 'ebbc08a9-e90c-4858-9804-6f89d0c291c3.png', 0);
INSERT INTO `d_entity` VALUES (495, 2, '15818bdf-4f66-4320-ba48-36a381f0dd15.png', 0);
INSERT INTO `d_entity` VALUES (496, 2, 'f41266bc-5226-4ad1-8b98-20dcff7256b1.png', 0);
INSERT INTO `d_entity` VALUES (497, 2, '7b91fd7c-e8b7-4a91-84a9-ea1bcbaa0a62.png', 0);
INSERT INTO `d_entity` VALUES (498, 2, '59439dc7-7591-4f27-b83e-36265b57c8dc.png', 0);
INSERT INTO `d_entity` VALUES (499, 2, 'fdac2794-d183-4c53-9f6f-b4955bb4708c.png', 0);
INSERT INTO `d_entity` VALUES (500, 2, '8c5329f1-157d-4823-9d92-f77384f78f0d.png', 0);
INSERT INTO `d_entity` VALUES (501, 2, '72e1a7be-2138-4632-89cf-6cf3ad854ee8.png', 0);
INSERT INTO `d_entity` VALUES (502, 2, 'be21a188-a2fb-49fe-93e7-ff6ec563372b.png', 0);
INSERT INTO `d_entity` VALUES (503, 2, '471bc501-6139-4ef8-b5ac-da21b03f7ca7.png', 0);
INSERT INTO `d_entity` VALUES (504, 2, '8bd8ec6f-6593-4c17-a383-8982293adcff.png', 0);
INSERT INTO `d_entity` VALUES (505, 2, 'd942d8c5-7aa4-4d60-9a86-87b1ccb94426.png', 0);
INSERT INTO `d_entity` VALUES (506, 2, '7068b713-22b8-44d8-9a22-57d65434f2a9.png', 0);
INSERT INTO `d_entity` VALUES (507, 2, 'ef56d514-4abf-4abd-88b4-a48e37d6b1ff.png', 0);
INSERT INTO `d_entity` VALUES (508, 2, '3c9faeca-eccc-4a66-b594-bfbba30948e4.png', 0);
INSERT INTO `d_entity` VALUES (509, 2, 'de7a72e1-b6b9-4b4e-aef2-f46b1176efc4.png', 0);
INSERT INTO `d_entity` VALUES (510, 2, '0392136e-50cf-45ed-a419-a4901e231258.png', 0);
INSERT INTO `d_entity` VALUES (511, 2, 'ff9d9b7f-8dc3-416d-a1b7-f55db696b271.png', 0);
INSERT INTO `d_entity` VALUES (512, 2, '9c6e1508-2e7d-4191-b866-fbec9a0208f4.png', 0);
INSERT INTO `d_entity` VALUES (513, 2, '6ec5a4df-daaf-41f5-b64b-75a145d40905.png', 0);
INSERT INTO `d_entity` VALUES (514, 2, 'b6ba5472-9cdf-49cc-9f4a-2074d3f98933.png', 0);
INSERT INTO `d_entity` VALUES (515, 2, '9c462aeb-f103-4ba6-8600-e719afd3205c.png', 0);
INSERT INTO `d_entity` VALUES (516, 2, '67f056fe-bd75-40bf-a46f-fc2e5cf3e506.png', 0);
INSERT INTO `d_entity` VALUES (517, 2, '90bbf1da-474c-45bf-80a7-d25ac3175835.png', 0);
INSERT INTO `d_entity` VALUES (518, 2, '11dcf829-1b4d-40db-8bc7-e6953129234f.png', 0);
INSERT INTO `d_entity` VALUES (519, 2, 'b54f834a-46a5-479f-a273-6413b0b1fc1f.png', 0);
INSERT INTO `d_entity` VALUES (520, 2, 'e1877675-afd2-4d25-b925-a6103e4e6e90.png', 0);
INSERT INTO `d_entity` VALUES (521, 2, '22f1c0f9-3563-4b36-bca0-ccec3200d268.png', 0);
INSERT INTO `d_entity` VALUES (522, 2, '4f55b31d-160f-46ec-8ac2-51fb970c6cc7.png', 0);
INSERT INTO `d_entity` VALUES (523, 2, '70cf67c7-6ea7-49ff-975f-4c66c47b8d03.png', 0);
INSERT INTO `d_entity` VALUES (524, 2, 'a4e21fd2-a7a7-4dfc-8f39-a9686549baba.png', 0);
INSERT INTO `d_entity` VALUES (525, 2, '313206d8-af95-43fd-99a3-d4ccdbd00cf8.png', 0);
INSERT INTO `d_entity` VALUES (526, 2, 'a98074db-1902-468c-8ffc-30e5f60a2468.png', 0);
INSERT INTO `d_entity` VALUES (527, 2, 'df354445-a44f-41d5-876e-f8e31cdeb79d.png', 0);
INSERT INTO `d_entity` VALUES (528, 2, '9b29774c-ad0e-4f99-bb2e-5be57218f900.png', 0);
INSERT INTO `d_entity` VALUES (529, 2, 'df784cf3-76e8-4f31-9994-2451cb962bfc.png', 0);
INSERT INTO `d_entity` VALUES (530, 2, '4a1181c0-c383-4018-a90f-bc488447c385.png', 0);
INSERT INTO `d_entity` VALUES (531, 2, '2f9eacdb-2c1c-4daf-a3e4-0f8560469a5e.png', 0);
INSERT INTO `d_entity` VALUES (532, 2, '53cca599-ebfb-44f9-a370-ca07a694467a.png', 0);
INSERT INTO `d_entity` VALUES (533, 2, '226a3872-da12-4433-82ab-4eb8ada348a4.png', 0);
INSERT INTO `d_entity` VALUES (534, 2, 'e4625d6e-7a96-4e1f-93f0-59373344092f.png', 0);
INSERT INTO `d_entity` VALUES (535, 2, '8731a2cb-a0c7-41cf-9069-1660fa442bd5.png', 0);
INSERT INTO `d_entity` VALUES (536, 2, 'c551a3b5-e434-425c-8a80-915ca319a832.png', 0);
INSERT INTO `d_entity` VALUES (537, 2, 'ef186882-069c-49f0-a3e7-1ed76fb6cf0b.png', 0);
INSERT INTO `d_entity` VALUES (538, 2, '4f2e407d-b3a2-4ef1-bfad-f6f5019a005b.png', 0);
INSERT INTO `d_entity` VALUES (539, 2, 'db7bf18a-c17b-4889-b2a8-ce96087f97a2.png', 0);
INSERT INTO `d_entity` VALUES (540, 2, '7b200214-183f-4714-ba11-c69b7e8fd44d.png', 0);
INSERT INTO `d_entity` VALUES (541, 2, '1626c161-38e2-471e-9169-c0f75f483032.png', 0);
INSERT INTO `d_entity` VALUES (542, 2, '89fe9b2a-fed8-4237-9fff-e1d77c5910dd.png', 0);
INSERT INTO `d_entity` VALUES (543, 2, 'f47c0994-dfce-43d9-b17c-6d32e8798a55.png', 0);
INSERT INTO `d_entity` VALUES (544, 2, '90da6d03-3a84-4d9b-9015-19ab23f47f80.png', 0);
INSERT INTO `d_entity` VALUES (545, 2, '4d7897ea-a1d4-4151-9b91-183623f20963.png', 0);
INSERT INTO `d_entity` VALUES (546, 2, '8e0dfe28-3c17-43aa-976e-a5f515df89d2.png', 0);
INSERT INTO `d_entity` VALUES (547, 2, 'c5091ee2-8bd6-428b-9a0e-0d51e71d03e0.png', 0);
INSERT INTO `d_entity` VALUES (548, 2, '4bfa1068-a554-470f-a942-65837636083a.png', 0);
INSERT INTO `d_entity` VALUES (549, 2, '1b24fc64-fd7e-482c-915d-cae22511a46a.png', 0);
INSERT INTO `d_entity` VALUES (550, 2, 'bf4616c8-631e-4056-b919-73904dc3e8b9.png', 0);
INSERT INTO `d_entity` VALUES (551, 2, 'cf0c5e45-9103-44c0-a667-e2e39c6250d5.png', 0);
INSERT INTO `d_entity` VALUES (552, 2, '20f3cf97-f028-446e-8f64-9614ee31c70f.png', 0);
INSERT INTO `d_entity` VALUES (553, 2, 'ca79cc0b-a991-4ae4-903f-ddacac4600c4.png', 0);
INSERT INTO `d_entity` VALUES (554, 2, '32aacd00-1c17-46fc-8db0-0a4487da0608.png', 0);
INSERT INTO `d_entity` VALUES (555, 2, 'f87cd3bb-32d2-4475-a418-e4bcca297d91.png', 0);
INSERT INTO `d_entity` VALUES (556, 2, 'bca80336-90d4-47d2-b820-f982cf9368e7.png', 0);
INSERT INTO `d_entity` VALUES (557, 2, 'f2133425-2bdb-48bd-acc8-b774f4384712.png', 0);
INSERT INTO `d_entity` VALUES (558, 2, 'befff57e-f319-4517-bd40-1c68efdb7c1e.png', 0);
INSERT INTO `d_entity` VALUES (559, 2, '676f7c04-6504-4367-8096-3cf276a6c1b1.png', 0);
INSERT INTO `d_entity` VALUES (560, 2, '37afb938-739c-4c80-a834-a9466a1515e5.png', 0);
INSERT INTO `d_entity` VALUES (561, 2, 'd6e0f5b4-063c-4fb7-a7e8-96f180732402.png', 0);
INSERT INTO `d_entity` VALUES (562, 2, '0fdf3341-1bb0-4410-87d8-9ef8b0ec725f.png', 0);
INSERT INTO `d_entity` VALUES (563, 2, '35c690c6-5636-45da-aca0-bac3d27fd92d.png', 0);
INSERT INTO `d_entity` VALUES (564, 2, '7f7dc502-c548-4ade-a14d-ab5b99bc07db.png', 0);
INSERT INTO `d_entity` VALUES (565, 2, '12feb421-5796-4a75-bc6a-3e2cdf53fe79.png', 0);
INSERT INTO `d_entity` VALUES (566, 2, '0e0fdc0e-0940-4118-a3be-833505658bad.png', 0);
INSERT INTO `d_entity` VALUES (567, 2, 'b95a553a-8884-4b38-bce4-6bcbb35c1d19.png', 0);
INSERT INTO `d_entity` VALUES (568, 2, '884edbbc-b5db-4a55-a0d2-bc8ebd025206.png', 0);
INSERT INTO `d_entity` VALUES (569, 2, '865c3be8-16ab-477d-a77f-41d6a80984df.png', 0);
INSERT INTO `d_entity` VALUES (570, 2, '37b5fd8d-86e0-4b05-b871-22e810bd9f1a.png', 0);
INSERT INTO `d_entity` VALUES (571, 2, 'f7500e45-6acc-4cd0-bb78-a612b98a38f2.png', 0);
INSERT INTO `d_entity` VALUES (572, 2, '7e0df32d-ed4a-4cd6-b390-54359350ad5c.png', 0);
INSERT INTO `d_entity` VALUES (573, 2, '67ae2f82-7ac7-4c97-84b5-f5e578aa2a51.png', 0);
INSERT INTO `d_entity` VALUES (574, 2, '6b768e38-4d79-46d7-901d-4be986a6faa7.png', 0);
INSERT INTO `d_entity` VALUES (575, 2, '73a70535-04a7-42fd-b8a7-e196574d30ee.png', 0);
INSERT INTO `d_entity` VALUES (576, 2, 'fcc84035-bd0d-4f74-b46b-c7f5b193b0a8.png', 0);
INSERT INTO `d_entity` VALUES (577, 2, '934eaa16-b2b3-4f8c-90e2-b823a700282a.png', 0);
INSERT INTO `d_entity` VALUES (578, 2, '186a5e3e-edd4-4252-b961-74fc115b10a1.png', 0);
INSERT INTO `d_entity` VALUES (579, 2, 'ad2bc7db-a662-4ea7-99d7-e43fd0a8ecd8.png', 0);
INSERT INTO `d_entity` VALUES (580, 2, 'f73cfc2c-0139-47bc-a0e2-11e0fc9e830d.png', 0);
INSERT INTO `d_entity` VALUES (581, 2, 'ea263284-7ed7-42c9-aa6d-344e307364c6.png', 0);
INSERT INTO `d_entity` VALUES (582, 2, '2021f00e-d0da-4c7d-a91c-5ec72ca3fe7e.png', 0);
INSERT INTO `d_entity` VALUES (583, 2, '2bd08c06-d056-4a59-be8c-7bae58967913.png', 0);
INSERT INTO `d_entity` VALUES (584, 2, '8bc7588f-fff9-4545-8337-e231b3a6e05d.png', 0);
INSERT INTO `d_entity` VALUES (585, 2, 'f9a7ea4b-75c5-4779-9f97-5c38c5caa8ed.png', 0);
INSERT INTO `d_entity` VALUES (586, 2, 'e7ff1f18-fb69-4cd9-beb0-d70a049f099c.png', 0);
INSERT INTO `d_entity` VALUES (587, 2, '4a323a80-6e9e-476b-bef4-74278796c6ba.png', 0);
INSERT INTO `d_entity` VALUES (588, 2, '2da693c1-37ae-422d-8b71-96678d6202af.png', 0);
INSERT INTO `d_entity` VALUES (589, 2, '8eeeb880-17a0-48ce-9933-9e65e87b51e2.png', 0);
INSERT INTO `d_entity` VALUES (590, 2, 'ec7bd0dc-3455-4a94-a058-327aa4ef85f6.png', 0);
INSERT INTO `d_entity` VALUES (591, 2, '8f2ae4f0-ebc7-4910-88f1-c1e964c0859f.png', 0);
INSERT INTO `d_entity` VALUES (592, 2, '32765bef-75c9-4309-ab03-defd75db21d6.png', 0);
INSERT INTO `d_entity` VALUES (593, 2, 'b5f43b8f-c969-4563-bcb4-e0079cc1a1f2.png', 0);
INSERT INTO `d_entity` VALUES (594, 2, '1d80541c-cbed-404f-984b-8ce0777137b8.png', 0);
INSERT INTO `d_entity` VALUES (595, 2, 'd015b01b-002a-40f4-9aea-366f2e2e1e33.png', 0);
INSERT INTO `d_entity` VALUES (596, 2, 'feb56c9a-4e9a-4370-afc8-1bc2071abc94.png', 0);
INSERT INTO `d_entity` VALUES (597, 2, '881a9a8c-1f2b-4d15-8973-5268cf595673.png', 0);
INSERT INTO `d_entity` VALUES (598, 2, '434f1879-effb-4101-bc5e-75c3e9265239.png', 0);
INSERT INTO `d_entity` VALUES (599, 2, 'a25d755a-c396-4eb4-a9db-2fe0c800683f.png', 0);
INSERT INTO `d_entity` VALUES (600, 2, '827513bc-22f4-44da-b03b-bacb60e16011.png', 0);
INSERT INTO `d_entity` VALUES (601, 2, '0167485b-6eb3-420a-a251-f35a1ab3e144.png', 0);
INSERT INTO `d_entity` VALUES (602, 2, '9fad8495-cfb6-4c51-8323-8dfe9465311f.png', 0);
INSERT INTO `d_entity` VALUES (603, 2, '6dc9272f-d00a-4aa8-8279-8466c5bbe725.png', 0);
INSERT INTO `d_entity` VALUES (604, 2, '79455366-b92a-4daa-b79e-d736c39e21b8.png', 0);
INSERT INTO `d_entity` VALUES (605, 2, '3352ca89-0ac1-4f82-9934-37d0b7bf6077.png', 0);
INSERT INTO `d_entity` VALUES (606, 2, '3a5a7c11-69ea-4e60-8cfd-1e069aa10bb3.png', 0);
INSERT INTO `d_entity` VALUES (607, 2, '5653f076-3844-4fd5-a153-612cb8e1c1c6.png', 0);
INSERT INTO `d_entity` VALUES (608, 2, '682c5b13-5e06-4460-a67e-666be25d0340.png', 0);
INSERT INTO `d_entity` VALUES (609, 2, '9723bf1a-53c3-4988-96e1-c4a4833d245c.png', 0);
INSERT INTO `d_entity` VALUES (610, 2, '079c3c47-3ccb-408f-84b8-8eeee3d3e004.png', 0);
INSERT INTO `d_entity` VALUES (611, 2, 'f90d3163-4582-4645-a699-933d1e2a38fe.png', 0);
INSERT INTO `d_entity` VALUES (612, 2, '2e40c213-0dbe-4428-8c18-d1e0b34772a1.png', 0);
INSERT INTO `d_entity` VALUES (613, 2, '0ec0c1eb-b8d2-4b94-a8b5-624ff5a3af1a.png', 0);
INSERT INTO `d_entity` VALUES (614, 2, '385f7e45-02e0-4be3-89eb-a30c31379dc6.png', 0);
INSERT INTO `d_entity` VALUES (615, 2, '5bdd3ad7-f663-49ca-96bf-35861aeef047.png', 0);
INSERT INTO `d_entity` VALUES (616, 2, '52a4d907-c12f-4443-a5a6-f09753c9f1b7.png', 0);
INSERT INTO `d_entity` VALUES (617, 2, 'e1cfa4d1-a519-421e-817f-7c78796e71af.png', 0);
INSERT INTO `d_entity` VALUES (618, 2, 'a89b2bd0-8083-4f08-a133-96055cce1aaa.png', 0);
INSERT INTO `d_entity` VALUES (619, 2, '5aa0ed0b-234e-455b-b054-b7268e56013a.png', 0);
INSERT INTO `d_entity` VALUES (620, 2, '46f62c10-8957-4281-b96f-4a17010f9272.png', 0);
INSERT INTO `d_entity` VALUES (621, 2, 'b8e38b41-0199-44f9-bd81-31f9ece390e1.png', 0);
INSERT INTO `d_entity` VALUES (622, 2, '847e8797-d7f2-481a-a458-ed25c7b0bf9b.png', 0);
INSERT INTO `d_entity` VALUES (623, 2, 'a3119d6d-b6cc-47ac-9b20-71fc6bad2361.png', 0);
INSERT INTO `d_entity` VALUES (624, 2, '4407df28-ce95-45dc-be98-4db05859ca5e.png', 0);
INSERT INTO `d_entity` VALUES (625, 2, 'b332475f-6700-4da4-95a4-9f61ae0482d9.png', 0);
INSERT INTO `d_entity` VALUES (626, 2, '849f5a7f-c839-40e1-a305-7733d70fb06a.png', 0);
INSERT INTO `d_entity` VALUES (627, 2, '50d48f4d-aee7-4a1f-b100-6e4e6ab3a11f.png', 0);
INSERT INTO `d_entity` VALUES (628, 2, '07f71d05-016c-465a-b5ae-ae1f91c77f8f.png', 0);
INSERT INTO `d_entity` VALUES (629, 2, '99dbb23c-aabd-48d2-ae70-b0abf85ff1a7.png', 0);
INSERT INTO `d_entity` VALUES (630, 2, '7884af83-d2c4-4066-921f-b8756d7c133c.png', 0);
INSERT INTO `d_entity` VALUES (631, 2, '7e369132-f86d-4008-924c-722ab0cf46af.png', 0);
INSERT INTO `d_entity` VALUES (632, 2, '3a29e9fc-bfca-41ce-82de-ea5274485c75.png', 0);
INSERT INTO `d_entity` VALUES (633, 2, 'ce14082d-ca28-40d4-880a-be8384349c6c.png', 0);
INSERT INTO `d_entity` VALUES (634, 2, 'd7495e59-1e24-4d62-a6af-ebdf20eb0819.png', 0);
INSERT INTO `d_entity` VALUES (635, 2, '653392ef-1fa1-4227-b92e-65c9dbd4da05.png', 0);
INSERT INTO `d_entity` VALUES (636, 2, 'e6199e59-da21-4155-9849-1e616d3a26ef.png', 0);
INSERT INTO `d_entity` VALUES (637, 2, 'fa14852a-c0c4-4cfd-877d-6e0eae6b65d0.png', 0);
INSERT INTO `d_entity` VALUES (638, 2, '1a0060ff-5a3f-42ee-a76b-377f168f9703.png', 0);
INSERT INTO `d_entity` VALUES (639, 2, '7dbd55d0-63f1-4912-b461-9ec5458453c3.png', 0);
INSERT INTO `d_entity` VALUES (640, 2, '1e772951-2211-40dd-bec1-b2ab416e46fc.png', 0);
INSERT INTO `d_entity` VALUES (641, 2, '465f7258-9d55-4934-a22f-95c0b508ef54.png', 0);
INSERT INTO `d_entity` VALUES (642, 2, '30ca85a6-da29-443f-8aea-7c906a2e397d.png', 0);
INSERT INTO `d_entity` VALUES (643, 2, '0237ba3e-aff9-4dc0-8e6c-d7e28f619c07.png', 0);
INSERT INTO `d_entity` VALUES (644, 2, 'f1b853a9-444f-4c09-9978-31d75414a00e.png', 0);
INSERT INTO `d_entity` VALUES (645, 2, '2c852c79-6753-45a9-8dff-c99c4464bde2.png', 0);
INSERT INTO `d_entity` VALUES (646, 2, 'b437e2b5-5ea3-46c5-ad1f-af18579e5089.png', 0);
INSERT INTO `d_entity` VALUES (647, 2, '9268fc6b-ab32-4bd1-ae7b-14bd42e29ef7.png', 0);
INSERT INTO `d_entity` VALUES (648, 2, '57d7a5b0-140d-4333-865c-c67407db6f18.png', 0);
INSERT INTO `d_entity` VALUES (649, 2, '4571862f-09bd-4082-ac4c-860bcd74eec6.png', 0);
INSERT INTO `d_entity` VALUES (650, 2, 'bf191be9-bf54-49db-998c-c94d826d6f84.png', 0);
INSERT INTO `d_entity` VALUES (651, 2, '03adbddc-6fa6-460d-9bc0-098968f294b7.png', 0);
INSERT INTO `d_entity` VALUES (652, 2, 'e7cf0a92-8be6-4e86-bf26-de96522a60e1.png', 0);
INSERT INTO `d_entity` VALUES (653, 2, '105abbfc-1532-49c9-9148-2b7743694b29.png', 0);
INSERT INTO `d_entity` VALUES (654, 2, '4e972399-12f0-4e11-9eff-6f06ca4a4831.png', 0);
INSERT INTO `d_entity` VALUES (655, 2, '85e85b8c-2ad7-4f88-9641-9cce92a28407.png', 0);
INSERT INTO `d_entity` VALUES (656, 2, 'e6515a0a-c902-432c-9f20-593ff535532b.png', 0);
INSERT INTO `d_entity` VALUES (657, 2, '49a7424a-26fd-4316-9c44-19f35184a960.png', 0);
INSERT INTO `d_entity` VALUES (658, 2, '0b6ac9b4-33b5-4779-8670-a4211dbb9c7f.png', 0);
INSERT INTO `d_entity` VALUES (659, 2, '7fbf6d30-8b86-4f7e-8fc3-c0297ddbc852.png', 0);
INSERT INTO `d_entity` VALUES (660, 2, 'ac4ce5cb-94a1-42b1-bafc-8aadeba79fd3.png', 0);
INSERT INTO `d_entity` VALUES (661, 2, '48c3620d-6ffb-46df-b116-0987fc3c54e4.png', 0);
INSERT INTO `d_entity` VALUES (662, 2, 'e72b7cd9-4436-4074-999f-fdd0f0289069.png', 0);
INSERT INTO `d_entity` VALUES (663, 2, '6bee2656-67dc-48cd-a095-b2eb5b16eb9d.png', 0);
INSERT INTO `d_entity` VALUES (664, 2, '477f4f3b-8ee6-45a7-9d0d-281510d3ee29.png', 0);
INSERT INTO `d_entity` VALUES (665, 2, 'af8d7fdf-7046-4264-9a4b-55467f59a67e.png', 0);
INSERT INTO `d_entity` VALUES (666, 2, '8620fa11-4c53-49f5-bba1-a1f975ab5a82.png', 0);
INSERT INTO `d_entity` VALUES (667, 2, '5716c702-e96c-48c7-9cf7-ff68ca52b0bf.png', 0);
INSERT INTO `d_entity` VALUES (668, 2, '60544cce-e357-4203-8280-7b2b583e9f64.png', 0);
INSERT INTO `d_entity` VALUES (669, 2, '1fc32d1a-02d4-4201-b409-f26f6dd921b2.png', 0);
INSERT INTO `d_entity` VALUES (670, 2, 'b8526a3f-294c-4051-9117-881e9dd2f9a8.png', 0);
INSERT INTO `d_entity` VALUES (671, 2, '7bcd3eb3-c456-445d-92a4-b8dd4e831b53.png', 0);
INSERT INTO `d_entity` VALUES (672, 2, 'd23476bb-69b3-4311-b683-df59dfb76cbc.png', 0);
INSERT INTO `d_entity` VALUES (673, 2, '7aebc735-6fab-4fa6-b132-7b9b84ae73e7.png', 0);
INSERT INTO `d_entity` VALUES (674, 2, '9f50e149-7843-40d6-87df-178b6c5607c6.png', 0);
INSERT INTO `d_entity` VALUES (675, 2, '3d9f0d1e-67d5-4033-b8dd-4f38f22ec5b0.png', 0);
INSERT INTO `d_entity` VALUES (676, 2, '775d0aa3-37a1-4f3b-b30d-63488fe55919.png', 0);
INSERT INTO `d_entity` VALUES (677, 2, 'ae4f3974-f671-4bbe-b2e2-8c30b21143e6.png', 0);
INSERT INTO `d_entity` VALUES (678, 2, '218e6742-7d38-4ca8-a870-6b217c4d23fb.png', 0);
INSERT INTO `d_entity` VALUES (679, 2, '940fad1d-3de9-4d7d-9eb2-c10580b9c7cd.png', 0);
INSERT INTO `d_entity` VALUES (680, 2, '154d5e28-cfd1-445f-8acc-e18c935f1f67.png', 0);
INSERT INTO `d_entity` VALUES (681, 2, '55452fed-802a-4ceb-af92-75d3d8f9d614.png', 0);
INSERT INTO `d_entity` VALUES (682, 2, '3b183183-ab35-4656-ad5a-7963648d5947.png', 0);
INSERT INTO `d_entity` VALUES (683, 2, '4916df14-57ce-4194-92e0-194a787dd453.png', 0);
INSERT INTO `d_entity` VALUES (684, 2, '9054ddec-eb32-4e40-a8bd-552af0e04d24.png', 0);
INSERT INTO `d_entity` VALUES (685, 2, '0d4356a0-0ab8-4006-8904-932c64ccf548.png', 0);
INSERT INTO `d_entity` VALUES (686, 2, '78aa28f6-1df7-4729-87c8-2d4091b0814a.png', 0);
INSERT INTO `d_entity` VALUES (687, 2, '2a4da873-be3b-490c-aeb8-edb47494e518.png', 0);
INSERT INTO `d_entity` VALUES (688, 2, 'eda26feb-65ec-441c-87b9-72ac093b1c6a.png', 0);
INSERT INTO `d_entity` VALUES (689, 2, 'b1b2c2e7-4cf3-4f87-8bcc-241845e7ec1d.png', 0);
INSERT INTO `d_entity` VALUES (690, 2, 'feae97c7-6c46-4510-aef7-323bfa57c20d.png', 0);
INSERT INTO `d_entity` VALUES (691, 2, '795a571d-99d6-4a2c-a564-ec953df7018a.png', 0);
INSERT INTO `d_entity` VALUES (692, 2, '7435e633-7a07-4042-bbd4-f7186261bf85.png', 0);
INSERT INTO `d_entity` VALUES (693, 2, '97562fbc-1eed-4e83-b529-7556e378b7ea.png', 0);
INSERT INTO `d_entity` VALUES (694, 2, '85c9f83e-92f3-4f26-82b3-b788abd883c1.png', 0);
INSERT INTO `d_entity` VALUES (695, 2, 'f3f8c8af-2e98-475a-8f58-51fd2dc109e9.png', 0);
INSERT INTO `d_entity` VALUES (696, 2, 'afa8711f-6a01-4de8-b06a-0aaf1e7d0861.png', 0);
INSERT INTO `d_entity` VALUES (697, 2, 'ffd4e470-bcb3-47e8-91da-18e006b79f69.png', 0);
INSERT INTO `d_entity` VALUES (698, 2, '09b32ce7-edf0-443d-bf71-97f2dd5e8cf9.png', 0);
INSERT INTO `d_entity` VALUES (699, 2, '4fda81f3-e2dd-4433-a357-d1ced3ee884d.png', 0);
INSERT INTO `d_entity` VALUES (700, 2, '8eb88301-7c2c-4d17-bb3f-894fc4eddc6b.png', 0);
INSERT INTO `d_entity` VALUES (701, 2, 'ad8aa8b3-20db-4435-8ac4-22cda1f691b0.png', 0);
INSERT INTO `d_entity` VALUES (702, 2, 'ba68b59f-fc12-427e-bb88-48c6341f7261.png', 0);
INSERT INTO `d_entity` VALUES (703, 2, '0a90e102-5862-42b2-9449-e61d56f7fc33.png', 0);
INSERT INTO `d_entity` VALUES (704, 2, '226fbf20-287d-4f61-968c-b0dcda2cd5c6.png', 0);
INSERT INTO `d_entity` VALUES (705, 2, '918b262d-1b5c-4616-8658-faea55892021.png', 0);
INSERT INTO `d_entity` VALUES (706, 2, '41b41bad-388c-404f-9d7f-89da8f32232b.png', 0);
INSERT INTO `d_entity` VALUES (707, 2, '6910ff6f-085b-4d67-b84f-fe2ca0dfc32e.png', 0);
INSERT INTO `d_entity` VALUES (708, 2, 'cb4c3e62-a0b1-4db1-9bc5-de015ff5a5d9.png', 0);
INSERT INTO `d_entity` VALUES (709, 2, '1467968d-4cc8-41ca-94b6-2dc144a3050d.png', 0);
INSERT INTO `d_entity` VALUES (710, 2, '3f02a787-6c19-4c5f-bf4b-ee17522ec308.png', 0);
INSERT INTO `d_entity` VALUES (711, 2, '33bd1ecc-48a3-4517-96a8-3a9a34310b52.png', 0);
INSERT INTO `d_entity` VALUES (712, 2, '3f152189-d106-4e40-b77a-bc7be6df163d.png', 0);
INSERT INTO `d_entity` VALUES (713, 2, 'fdfc4c25-0226-446c-9780-73e00827e6fb.png', 0);
INSERT INTO `d_entity` VALUES (714, 2, 'f44e2e8e-8c23-4795-ae90-a5295a9255d7.png', 0);
INSERT INTO `d_entity` VALUES (715, 2, '60ddcac8-4af5-42c8-af58-89890e18ce94.png', 0);
INSERT INTO `d_entity` VALUES (716, 2, '18fd6280-f020-4ee1-9702-46e126a0d201.png', 0);
INSERT INTO `d_entity` VALUES (717, 2, 'dd306047-42c2-49dd-bb25-096f8d78746a.png', 0);
INSERT INTO `d_entity` VALUES (718, 2, '7499eca2-c66c-4392-a2a5-d30d0f33b9b0.png', 0);
INSERT INTO `d_entity` VALUES (719, 2, 'ebf46f9b-8a40-466d-80a3-ebfc853b5f41.png', 0);
INSERT INTO `d_entity` VALUES (720, 2, 'e301c0bd-2e9f-496a-8945-99d4d6c57d02.png', 0);
INSERT INTO `d_entity` VALUES (721, 2, 'd200f6e7-1ad1-4676-9e5e-bd6d79cc20b3.png', 0);
INSERT INTO `d_entity` VALUES (722, 2, '26ea64e4-c517-4591-8fad-53e8716e2ff0.png', 0);
INSERT INTO `d_entity` VALUES (723, 2, 'd849a21c-9639-4e96-8559-76ebde6a2157.png', 0);
INSERT INTO `d_entity` VALUES (724, 2, 'cade5eec-fa53-4d60-896c-ece6604e36b1.png', 0);
INSERT INTO `d_entity` VALUES (725, 2, 'ae6a3f85-01aa-40a7-8645-40a2cdf31fa8.png', 0);
INSERT INTO `d_entity` VALUES (726, 2, 'e0c84563-6dc6-4b9b-8eae-c2031de44ed5.png', 0);
INSERT INTO `d_entity` VALUES (727, 2, '2c14c106-ff3d-4ac4-bc7f-d8c4c40f0581.png', 0);
INSERT INTO `d_entity` VALUES (728, 2, '23d00ed7-fe86-4365-8a0b-15b8aecdc025.png', 0);
INSERT INTO `d_entity` VALUES (729, 2, '85ccafda-4320-4a45-9298-11c43f9442eb.png', 0);
INSERT INTO `d_entity` VALUES (730, 2, '6abce198-3976-439a-bede-853bc5281dbc.png', 0);
INSERT INTO `d_entity` VALUES (731, 2, '2c3f5670-a774-4175-9d2a-510db561bd50.png', 0);
INSERT INTO `d_entity` VALUES (732, 2, 'b5cb89e3-aa6d-421d-99d9-ee56a87b4910.png', 0);
INSERT INTO `d_entity` VALUES (733, 2, 'beb291cf-fb0a-43bd-85e1-7c9d64963cd7.png', 0);
INSERT INTO `d_entity` VALUES (734, 2, 'f7d0a97a-3e54-46c2-8c07-4b2d9853a6c4.png', 0);
INSERT INTO `d_entity` VALUES (735, 2, 'c0dec09b-c628-4990-934e-30e823d6f158.png', 0);
INSERT INTO `d_entity` VALUES (736, 2, '75e137e5-d8fe-490a-b324-44d5df9da897.png', 0);
INSERT INTO `d_entity` VALUES (737, 2, '6e578247-e38b-42c5-a1f8-53ef8d6f0508.png', 0);
INSERT INTO `d_entity` VALUES (738, 2, '9ef7752c-ac97-47f1-a205-7ba97287d075.png', 0);
INSERT INTO `d_entity` VALUES (739, 2, '97b9bfb1-c0b3-4702-a648-25afb9b67745.png', 0);
INSERT INTO `d_entity` VALUES (740, 2, '6b572f3e-3a61-46b5-b1aa-b062744fc007.png', 0);
INSERT INTO `d_entity` VALUES (741, 2, '70deec3e-9204-4328-b2f2-16576276398b.png', 0);
INSERT INTO `d_entity` VALUES (742, 2, '56cfc51b-6048-4fce-977f-a078a73619b2.png', 0);
INSERT INTO `d_entity` VALUES (743, 2, 'f893d25b-4749-4f54-b7a8-46ea0212521d.png', 0);
INSERT INTO `d_entity` VALUES (744, 2, 'c563d4c8-6e2b-4d94-89b6-712150077981.png', 0);
INSERT INTO `d_entity` VALUES (745, 2, '98c86102-e5d0-4919-9264-2b2bf3052122.png', 0);
INSERT INTO `d_entity` VALUES (746, 2, 'b0805a0d-b440-4ff6-bc3a-b328982b7e01.png', 0);
INSERT INTO `d_entity` VALUES (747, 2, '46c2d60c-27d9-41e2-83f9-68d52ca32c79.png', 0);
INSERT INTO `d_entity` VALUES (748, 2, 'b52dea5c-d5da-485b-a9a7-e7111a971f8f.png', 0);
INSERT INTO `d_entity` VALUES (749, 2, 'c7b26390-1287-4e72-b172-830feb8104f4.png', 0);
INSERT INTO `d_entity` VALUES (750, 2, '511a4a2f-9dd9-4dae-8b4e-1b6a29a55760.png', 0);
INSERT INTO `d_entity` VALUES (751, 2, '5af32b5c-2ac8-4cae-b966-1b9bf149d781.png', 0);
INSERT INTO `d_entity` VALUES (752, 2, 'b8ffda10-dafd-4fc0-827c-ccb6ed24c874.png', 0);
INSERT INTO `d_entity` VALUES (753, 2, 'a2a58ef9-f1f6-489f-bd50-09f0e72be013.png', 0);
INSERT INTO `d_entity` VALUES (754, 2, '87f0611c-5581-4156-b6a0-c601f565ce5c.png', 0);
INSERT INTO `d_entity` VALUES (755, 2, '64a92c25-cb07-42a5-8999-2eebe7db3045.png', 0);
INSERT INTO `d_entity` VALUES (756, 2, 'bed6ff3f-4e97-41da-bade-1beab21ccd02.png', 0);
INSERT INTO `d_entity` VALUES (757, 2, 'a1d8b25e-f8ff-411a-af6d-7c3e229a7459.png', 0);
INSERT INTO `d_entity` VALUES (758, 2, '4e8abe85-c3c5-4c23-bd0e-94e1b95aec3a.png', 0);
INSERT INTO `d_entity` VALUES (759, 2, '10cfce8a-7153-4b0c-b0d2-5b7e2d603a79.png', 0);
INSERT INTO `d_entity` VALUES (760, 2, '0a4bf137-eed8-40a3-aee2-929dabe51155.png', 0);
INSERT INTO `d_entity` VALUES (761, 2, 'd0fa610e-56e5-441e-a6fc-32c358297e89.png', 0);
INSERT INTO `d_entity` VALUES (762, 2, '1c394b6c-d953-49cf-9ffa-eea1cb7cdbad.png', 0);
INSERT INTO `d_entity` VALUES (763, 2, '8929a00a-7cd6-441c-8f07-f32da12fec8b.png', 0);
INSERT INTO `d_entity` VALUES (764, 2, '48ce0601-749a-426f-98d4-df279d181313.png', 0);
INSERT INTO `d_entity` VALUES (765, 2, '483cfcfb-3966-4c90-92fb-f7d7b08328ec.png', 0);
INSERT INTO `d_entity` VALUES (766, 2, '22afc59c-55c5-42b5-b629-8cc7a5f44879.png', 0);
INSERT INTO `d_entity` VALUES (767, 2, '88544341-0450-4ce4-baed-811f73148968.png', 0);
INSERT INTO `d_entity` VALUES (768, 2, 'aa807ca8-3ed1-46b5-9cce-bf4b077ca175.png', 0);
INSERT INTO `d_entity` VALUES (769, 2, '4d557e15-b135-45c6-acad-cc499e1cdea3.png', 0);
INSERT INTO `d_entity` VALUES (770, 2, '19101391-0d80-412b-a05e-bdacb981bbf9.png', 0);
INSERT INTO `d_entity` VALUES (771, 2, 'a47eada1-6e32-4d1a-92ee-cb46c5ba609c.png', 0);
INSERT INTO `d_entity` VALUES (772, 2, '7a1a36fe-41c8-41cf-9677-c258821e59e1.png', 0);
INSERT INTO `d_entity` VALUES (773, 2, '738adb6d-8846-4230-8e12-001d39647f22.png', 0);
INSERT INTO `d_entity` VALUES (774, 2, 'e1862ddd-5b0a-4802-a86b-e86f56e65cf0.png', 0);
INSERT INTO `d_entity` VALUES (775, 2, 'c6571a1f-a44a-4230-a33f-d0441ef61520.png', 0);
INSERT INTO `d_entity` VALUES (776, 2, '27197897-8e17-4d31-8163-64a78622d034.png', 0);
INSERT INTO `d_entity` VALUES (777, 2, '8fb1850e-3a3b-4409-87a6-47b28b1b09f8.png', 0);
INSERT INTO `d_entity` VALUES (778, 2, '2646a7e8-69ec-4634-b62e-568289885734.png', 0);
INSERT INTO `d_entity` VALUES (779, 2, '11ce6f78-9cb7-4dd5-bf34-24cf6f03941a.png', 0);
INSERT INTO `d_entity` VALUES (780, 2, 'd77b3b16-da74-427c-98c1-b3452a051ba9.png', 0);
INSERT INTO `d_entity` VALUES (781, 2, 'ac4c4970-69f6-429c-9c6a-9bfff7e0e8c3.png', 0);
INSERT INTO `d_entity` VALUES (782, 2, '2c215cb5-6d30-487d-bd1e-05e8b9375df9.png', 0);
INSERT INTO `d_entity` VALUES (783, 2, 'de51defa-8792-4da6-bb96-d66ce6ae5fb3.png', 0);
INSERT INTO `d_entity` VALUES (784, 2, 'd7aa3ef4-f2a2-4da3-87e6-e38b891fcd96.png', 0);
INSERT INTO `d_entity` VALUES (785, 2, 'b0361b59-cf47-47a1-9020-8978cd27cee1.png', 0);
INSERT INTO `d_entity` VALUES (786, 2, 'dda8f056-ff2c-45ff-a483-4d28172c3b3c.png', 0);
INSERT INTO `d_entity` VALUES (787, 2, '5a95cce9-d04e-4fd6-af4d-0a27fb1d5ffa.png', 0);
INSERT INTO `d_entity` VALUES (788, 2, 'c373bbce-cd5d-4450-814e-d59fb54e911e.png', 0);
INSERT INTO `d_entity` VALUES (789, 2, 'a38f62a1-0e5d-4929-b686-11c3ac8ebf51.png', 0);
INSERT INTO `d_entity` VALUES (790, 2, 'cf2efe1c-b049-43ca-b485-4b2564653eaa.png', 0);
INSERT INTO `d_entity` VALUES (791, 2, '529bec2b-a923-4475-b692-00697c9211cf.png', 0);
INSERT INTO `d_entity` VALUES (792, 2, '04870c30-7413-457d-a819-047fe14c7cd5.png', 0);
INSERT INTO `d_entity` VALUES (793, 2, '75bee04e-6240-48aa-88f6-83d6957084cd.png', 0);
INSERT INTO `d_entity` VALUES (794, 2, '82c56849-ea54-4ec9-8ddc-e828a26cf7a2.png', 0);
INSERT INTO `d_entity` VALUES (795, 2, 'f1972a85-3ac1-45cb-8f4d-877b40726930.png', 0);
INSERT INTO `d_entity` VALUES (796, 2, 'b18eb495-2f91-4012-88ae-e31a53bd8fee.png', 0);
INSERT INTO `d_entity` VALUES (797, 2, '3be28f5a-352a-4344-bc87-5abc808dd33a.png', 0);
INSERT INTO `d_entity` VALUES (798, 2, 'ceb643e3-6619-4000-a61d-4759ff0602b5.png', 0);
INSERT INTO `d_entity` VALUES (799, 2, '3f56814e-58a5-4c56-a2df-6cdd815f7ad4.png', 0);
INSERT INTO `d_entity` VALUES (800, 2, 'fc9c3392-e333-4b69-9b18-eca391e1faa9.png', 0);
INSERT INTO `d_entity` VALUES (801, 2, 'cc712824-1d07-48ee-b173-55de8f5f6874.png', 0);
INSERT INTO `d_entity` VALUES (802, 2, 'a93efa5b-e348-4875-bf36-4b1b326cc6c8.png', 0);
INSERT INTO `d_entity` VALUES (803, 2, '8cc4340a-06c5-490e-b4b0-bc44f0d617a3.png', 0);
INSERT INTO `d_entity` VALUES (804, 2, '3a6d6898-4b9e-47ee-9c70-fd234f399bcf.png', 0);
INSERT INTO `d_entity` VALUES (805, 2, '62a42b5b-ea25-49db-9ef7-f2eea4ba48f4.png', 0);
INSERT INTO `d_entity` VALUES (806, 2, 'f7a18a5c-bc93-4ccf-b9b3-e263ceb0a410.png', 0);
INSERT INTO `d_entity` VALUES (807, 2, 'f204e493-0c1a-4199-9403-e0efcdfcb5ec.png', 0);
INSERT INTO `d_entity` VALUES (808, 2, 'accc85a6-c8b3-4f2f-864a-6aa6e827824f.png', 0);
INSERT INTO `d_entity` VALUES (809, 2, '550fd5d5-232d-49ed-9d46-e657cc984c9c.png', 0);
INSERT INTO `d_entity` VALUES (810, 2, 'bf49978f-0532-4512-aeed-a89cc37e12e8.png', 0);
INSERT INTO `d_entity` VALUES (811, 2, '6abbea3b-050f-4d99-aeb9-3a0a1441fc0a.png', 0);
INSERT INTO `d_entity` VALUES (812, 2, 'ea55de9c-2b14-4966-a125-5a1732803257.png', 0);
INSERT INTO `d_entity` VALUES (813, 2, '4e325357-0eac-4889-b967-3161a845de92.png', 0);
INSERT INTO `d_entity` VALUES (814, 2, 'fee017bf-a835-4b63-8ab5-1b5bed2afeb2.png', 0);
INSERT INTO `d_entity` VALUES (815, 2, '2c2e7ce6-5ca3-4b4b-b79f-0fd9cb601e49.png', 0);
INSERT INTO `d_entity` VALUES (816, 2, '8ef69593-be78-4b0e-a025-54cd3b64fa07.png', 0);
INSERT INTO `d_entity` VALUES (817, 2, 'b3047a9c-c291-4e42-a02a-5e40ef42acff.png', 0);
INSERT INTO `d_entity` VALUES (818, 2, '84701268-d266-4fde-be24-e8c20dcc32f4.png', 0);
INSERT INTO `d_entity` VALUES (819, 2, '6a176b47-1859-4e17-ace3-32e4470eaa14.png', 0);
INSERT INTO `d_entity` VALUES (820, 2, 'b5b6f98f-6ec1-4b61-a012-d76556f90f62.png', 0);
INSERT INTO `d_entity` VALUES (821, 2, '983492d6-b7a7-4081-9d13-4e773388645b.png', 0);
INSERT INTO `d_entity` VALUES (822, 2, '4854a259-a00d-4581-874b-587656ec471f.png', 0);
INSERT INTO `d_entity` VALUES (823, 2, '372d3926-1d3c-4298-ab91-c778a797d6af.png', 0);
INSERT INTO `d_entity` VALUES (824, 2, '3c49a2e7-77c9-45c5-a499-08a2795130ce.png', 0);
INSERT INTO `d_entity` VALUES (825, 2, 'c13dc5ad-4b92-48b1-946b-b3bcc86e6d84.png', 0);
INSERT INTO `d_entity` VALUES (826, 2, '083f682e-bfcb-4d9d-af6b-5a918a490308.png', 0);
INSERT INTO `d_entity` VALUES (827, 2, '1f0d282e-219e-49d0-afbd-53e622f14162.png', 0);
INSERT INTO `d_entity` VALUES (828, 2, '0bd28e50-55bf-4538-932e-06e7f243fa8b.png', 0);
INSERT INTO `d_entity` VALUES (829, 2, '4ea163d6-eb62-4f6f-b513-499fef65a6fe.png', 0);
INSERT INTO `d_entity` VALUES (830, 2, '0f130f56-76f0-4bba-a73d-a552a7a64b25.png', 0);
INSERT INTO `d_entity` VALUES (831, 2, '0c9833ca-9c91-4568-84ce-d2951f5397e2.png', 0);
INSERT INTO `d_entity` VALUES (832, 2, 'b0f08949-bd19-4b83-955f-0b01f220aa79.png', 0);
INSERT INTO `d_entity` VALUES (833, 2, '82d1c18e-c69c-4a8c-ad80-228f3d944728.png', 0);
INSERT INTO `d_entity` VALUES (834, 2, 'e545609f-3d57-453c-8d21-c3ce36d80e19.png', 0);
INSERT INTO `d_entity` VALUES (835, 2, 'b42d783c-363e-4748-85b1-176b20373a20.png', 0);
INSERT INTO `d_entity` VALUES (836, 2, '77a9cd52-7e05-40b9-aa6c-4587bc88e623.png', 0);
INSERT INTO `d_entity` VALUES (837, 2, '5fcecc16-138b-44f1-8781-43f50fba2a24.png', 0);
INSERT INTO `d_entity` VALUES (838, 2, '41373204-90e5-43d4-908a-7e222740a191.png', 0);
INSERT INTO `d_entity` VALUES (839, 2, 'a61d673a-f441-42b4-853f-519470b76f71.png', 0);
INSERT INTO `d_entity` VALUES (840, 2, '3a4db870-9413-4d38-9731-461cdb7c93eb.png', 0);
INSERT INTO `d_entity` VALUES (841, 2, '8e932e78-d46c-4ee3-99ed-4fbe3ebcd74b.png', 0);
INSERT INTO `d_entity` VALUES (842, 2, '954b50c7-092d-47d6-ac44-81dc49097b56.png', 0);
INSERT INTO `d_entity` VALUES (843, 2, '576e19b0-3f15-4b3c-8b0c-96bf2a9252f8.png', 0);
INSERT INTO `d_entity` VALUES (844, 2, '9fe59f46-bc83-452f-a057-5596735bcf90.png', 0);
INSERT INTO `d_entity` VALUES (845, 2, 'dc648c61-5542-4c6e-b7ad-f578ce56ff14.png', 0);
INSERT INTO `d_entity` VALUES (846, 2, '2a7f8d46-e891-4356-b5bc-957805a9a442.png', 0);
INSERT INTO `d_entity` VALUES (847, 2, '348b1c2e-a6d4-4bb6-8417-71ff87f80b8e.png', 0);
INSERT INTO `d_entity` VALUES (848, 2, 'b465568f-5b6f-4508-bfc3-d811ec8b7a74.png', 0);
INSERT INTO `d_entity` VALUES (849, 2, '769b1aaa-3a27-4ac8-974e-141a626dcb34.png', 0);
INSERT INTO `d_entity` VALUES (850, 2, '3b26d34f-3ff7-4169-a85d-4aaedc96708c.png', 0);
INSERT INTO `d_entity` VALUES (851, 2, '7fe2826f-ec54-423b-8590-f0b4bd0491e1.png', 0);
INSERT INTO `d_entity` VALUES (852, 2, 'a4a9b3c4-119e-4ad1-ac0c-60b9bbda569d.png', 0);
INSERT INTO `d_entity` VALUES (853, 2, 'ffc6a8e0-228d-43c1-9b17-f58bd9916171.png', 0);
INSERT INTO `d_entity` VALUES (854, 2, '79943de7-066b-4da7-b93e-3c4b6c99a772.png', 0);
INSERT INTO `d_entity` VALUES (855, 2, '27282ca5-1f5a-421d-96b1-259a39aa4bd5.png', 0);
INSERT INTO `d_entity` VALUES (856, 2, '861d8ec6-dc29-4849-9e57-c11fe134d699.png', 0);
INSERT INTO `d_entity` VALUES (857, 2, '9110ff60-2bca-4a4e-8dd9-2ee236ab07f6.png', 0);
INSERT INTO `d_entity` VALUES (858, 2, 'a7c9914e-e6bc-4c8e-901e-ae0dc27ae32c.png', 0);
INSERT INTO `d_entity` VALUES (859, 2, 'a4a351b5-3567-4523-a4c4-4c1f3debb318.png', 0);
INSERT INTO `d_entity` VALUES (860, 2, 'ea8d48af-7ed0-4e17-b345-9ab8570a4967.png', 0);
INSERT INTO `d_entity` VALUES (861, 2, '47903370-4e0e-4acb-807e-5d6f95129ade.png', 0);
INSERT INTO `d_entity` VALUES (862, 2, 'f90d8cee-c69a-4f93-b736-1d64c71e2955.png', 0);
INSERT INTO `d_entity` VALUES (863, 2, '2a2bd86d-619a-46bd-98ca-b73aea70ee34.png', 0);
INSERT INTO `d_entity` VALUES (864, 2, '43dd95d6-77d0-4c31-b553-c6f29c55a599.png', 0);
INSERT INTO `d_entity` VALUES (865, 2, '619ff367-8070-40fe-8173-0279f4478d71.png', 0);
INSERT INTO `d_entity` VALUES (866, 2, '876d8115-dcf4-4b89-9fd3-b4bdbd4ac8a6.png', 0);
INSERT INTO `d_entity` VALUES (867, 2, '9250d5e4-ae12-47b6-98a2-0fffe4916764.png', 0);
INSERT INTO `d_entity` VALUES (868, 2, 'ad51c6d4-cde5-4f22-bc69-4bacc790af61.png', 0);
INSERT INTO `d_entity` VALUES (869, 2, 'd2de28cd-caf0-4f2d-927f-13498f11560c.png', 0);
INSERT INTO `d_entity` VALUES (870, 2, 'f04c55e7-ab35-435a-a5f8-0891026bf52f.png', 0);
INSERT INTO `d_entity` VALUES (871, 2, '3f9992f9-0012-4e00-b33d-ad3f8f31dbf5.png', 0);
INSERT INTO `d_entity` VALUES (872, 2, 'ea6cd1a5-91c5-4c79-a482-86cd34049202.png', 0);
INSERT INTO `d_entity` VALUES (873, 2, '8f155e72-68a0-4fb1-a0cd-32912a074bbb.png', 0);
INSERT INTO `d_entity` VALUES (874, 2, '013806f3-8f13-431e-a166-14d71847405c.png', 0);
INSERT INTO `d_entity` VALUES (875, 2, '2f5d4b3a-6c68-4b33-9cd2-3f63a41520d6.png', 0);
INSERT INTO `d_entity` VALUES (876, 2, '72fb0790-b1aa-45a4-b5b0-44d10043201f.png', 0);
INSERT INTO `d_entity` VALUES (877, 2, '08c71957-677a-4dd3-a1ce-d48f03c88a53.png', 0);
INSERT INTO `d_entity` VALUES (878, 2, '8c3a7585-06c4-4a3b-b859-5ea96e8b6155.png', 0);
INSERT INTO `d_entity` VALUES (879, 2, 'dd839e1c-4080-4b2c-a53b-3dbe76158704.png', 0);
INSERT INTO `d_entity` VALUES (880, 3, '39ff7ed6-7009-4afa-a87c-73bb5a677e48.png', 0);
INSERT INTO `d_entity` VALUES (881, 3, 'e2add6f6-0ff4-48f8-a8c9-668a15513e27.png', 0);
INSERT INTO `d_entity` VALUES (882, 3, '058dd56d-3a1f-4a32-96a3-1f8d79193057.png', 0);
INSERT INTO `d_entity` VALUES (883, 3, '20c00287-e0fb-4cf2-b472-8ce52e0abd13.png', 0);
INSERT INTO `d_entity` VALUES (884, 3, 'c7221c64-877c-45f3-80b4-1849e87517f5.png', 0);
INSERT INTO `d_entity` VALUES (885, 3, '1a18c0ad-ce49-45d5-84f5-a3b98501b7cf.png', 0);
INSERT INTO `d_entity` VALUES (886, 3, '18bdc023-276b-4057-8384-0a78ad1dfaa4.png', 0);
INSERT INTO `d_entity` VALUES (887, 3, '31d9c1ec-731b-405c-90c2-d9d60aa866ab.png', 0);
INSERT INTO `d_entity` VALUES (888, 3, '9193ed58-5454-4dac-80a4-1dae9130c104.png', 0);
INSERT INTO `d_entity` VALUES (889, 3, 'df448bfb-5621-47d7-9168-41e2579c614f.png', 0);
INSERT INTO `d_entity` VALUES (890, 3, 'a8fa3abe-36a7-432c-bc53-bc9f8b070b5c.png', 0);
INSERT INTO `d_entity` VALUES (891, 3, '1a557212-b50f-494b-a338-b905210536b9.png', 0);
INSERT INTO `d_entity` VALUES (892, 3, '81f49a48-54dc-4097-adc9-273c6429557a.png', 0);
INSERT INTO `d_entity` VALUES (893, 3, 'e406e167-6910-41cc-85e3-1186748fab0c.png', 0);
INSERT INTO `d_entity` VALUES (894, 3, '37bbcb52-3429-4e83-9850-d0c6a7f3627b.png', 0);
INSERT INTO `d_entity` VALUES (895, 3, '9a9048c9-3b9d-4ec8-bff6-b43d391487fa.png', 0);
INSERT INTO `d_entity` VALUES (896, 3, '862334f0-4355-4006-b80a-c893fb75cc62.png', 0);
INSERT INTO `d_entity` VALUES (897, 3, 'd75ffa12-16b2-40f7-b568-2a831e681f1b.png', 0);
INSERT INTO `d_entity` VALUES (898, 3, '040f88bf-b819-4efa-90e9-87052d52322e.png', 0);
INSERT INTO `d_entity` VALUES (899, 3, 'c566ad3f-abef-47a2-aa37-ed6968088bbf.png', 0);
INSERT INTO `d_entity` VALUES (900, 3, '5cf04a71-d220-4210-a571-3c795395f202.png', 0);
INSERT INTO `d_entity` VALUES (901, 3, '3131afb5-1be5-4999-954b-f64cda46bb67.png', 0);
INSERT INTO `d_entity` VALUES (902, 3, '5bcba705-559a-48ce-8c6b-8e8784fa8238.png', 0);
INSERT INTO `d_entity` VALUES (903, 3, 'c97c5133-9724-4061-bfdf-f9657b6c8752.png', 0);
INSERT INTO `d_entity` VALUES (904, 3, '767c6efd-5ccb-44c7-a875-45ff54f79f73.png', 0);
INSERT INTO `d_entity` VALUES (905, 3, '278a6d75-9f94-4ce5-9893-920012f85c67.png', 0);
INSERT INTO `d_entity` VALUES (906, 3, 'c617a285-afda-4b57-97ef-28d5645c5408.png', 0);
INSERT INTO `d_entity` VALUES (907, 3, '203baffb-47f5-4227-9590-9e500630465d.png', 0);
INSERT INTO `d_entity` VALUES (908, 3, 'e72abe5c-5eaf-4184-9f1a-9ffda1d8a669.png', 0);
INSERT INTO `d_entity` VALUES (909, 3, 'b0b1c0d6-5a09-405c-9aa0-c17da8297429.png', 0);
INSERT INTO `d_entity` VALUES (910, 3, '97c80394-8ce3-49e2-819d-9d917104c210.png', 0);
INSERT INTO `d_entity` VALUES (911, 3, '2d2d7ca5-5976-485e-85bc-0d55b07e59a2.png', 0);
INSERT INTO `d_entity` VALUES (912, 3, '857857f4-7560-4b90-9984-3e6f07f9da94.png', 0);
INSERT INTO `d_entity` VALUES (913, 3, 'd0397571-5e19-4154-a42e-33eb51c0bb32.png', 0);
INSERT INTO `d_entity` VALUES (914, 3, '829a4690-83c7-4348-99b1-5fa775b5762c.png', 0);
INSERT INTO `d_entity` VALUES (915, 3, '5a9f6e10-7a33-418a-9a10-1ce2d17a0292.png', 0);
INSERT INTO `d_entity` VALUES (916, 3, '3f677fed-924e-493b-9361-487beebcd904.png', 0);
INSERT INTO `d_entity` VALUES (917, 3, 'b82fb4fc-d1f1-4e24-80ff-98baf4585f8e.png', 0);
INSERT INTO `d_entity` VALUES (918, 3, '59d61176-1249-4f1d-a2b4-394ae35338b2.png', 0);
INSERT INTO `d_entity` VALUES (919, 3, '731d4b2c-75f2-4fdb-9e34-7880c3d4df67.png', 0);
INSERT INTO `d_entity` VALUES (920, 3, 'c010854a-7118-40af-abb5-fdc075a6e5c5.png', 0);
INSERT INTO `d_entity` VALUES (921, 3, 'd837da7d-4c05-4431-ba94-432ee6e784b4.png', 0);
INSERT INTO `d_entity` VALUES (922, 3, '919ea830-4f27-49d2-aae6-9927b5c6b1e9.png', 0);
INSERT INTO `d_entity` VALUES (923, 3, '4a5052f8-afd1-4512-bc59-ae7eaa1ecdcf.png', 0);
INSERT INTO `d_entity` VALUES (924, 3, 'd8253773-9f50-40e3-8e24-26fa95a2799d.png', 0);
INSERT INTO `d_entity` VALUES (925, 3, 'e31e7d98-0fb6-48e1-a41f-3d05b1099cf5.png', 0);
INSERT INTO `d_entity` VALUES (926, 3, '15055e0a-19a8-410a-a2f2-7d81c1a652c6.png', 0);
INSERT INTO `d_entity` VALUES (927, 3, 'a2fb40ed-b9ce-4649-a901-7e10aaa6c442.png', 0);
INSERT INTO `d_entity` VALUES (928, 3, 'c3132bab-e02b-44cd-9453-346d799ea68b.png', 0);
INSERT INTO `d_entity` VALUES (929, 3, '23e3da1b-711a-418e-8dcd-f23d5572564e.png', 0);
INSERT INTO `d_entity` VALUES (930, 3, '99224e8d-3ab5-46a7-95a5-64025f023411.png', 0);
INSERT INTO `d_entity` VALUES (931, 3, 'df00534c-bd90-434e-a0b5-d72e1cf50090.png', 0);
INSERT INTO `d_entity` VALUES (932, 3, 'd8f535e2-edf1-4a20-a3d9-f7fae5dc91c2.png', 0);
INSERT INTO `d_entity` VALUES (933, 3, '7371ab76-35bf-4695-bed2-6039fd43f390.png', 0);
INSERT INTO `d_entity` VALUES (934, 3, 'e66cad4d-f05c-4d3d-a17f-b30ae2fe8eba.png', 0);
INSERT INTO `d_entity` VALUES (935, 3, 'c9517114-6733-460b-a187-1cb2d0411ab6.png', 0);
INSERT INTO `d_entity` VALUES (936, 3, 'b82dc3a8-02b9-4943-821f-16cf1e54feec.png', 0);
INSERT INTO `d_entity` VALUES (937, 3, 'faf4a224-f769-4297-8e80-0c8508f42358.png', 0);
INSERT INTO `d_entity` VALUES (938, 3, '0b4db425-bc5d-45b2-967c-5bc92c8a1b82.png', 0);
INSERT INTO `d_entity` VALUES (939, 3, '63822464-271f-436f-8e4b-723ec1b704db.png', 0);
INSERT INTO `d_entity` VALUES (940, 3, '78363fdd-5675-46bb-9151-578c15e08d09.png', 0);
INSERT INTO `d_entity` VALUES (941, 3, '835dc4f1-e302-449b-a8f2-41fcfdbdd3f8.png', 0);
INSERT INTO `d_entity` VALUES (942, 3, '247ff4da-05c8-4b7b-9f70-b3d3d5333eae.png', 0);
INSERT INTO `d_entity` VALUES (943, 3, '10c3335c-8a41-4429-bc32-c8dde83e5a4d.png', 0);
INSERT INTO `d_entity` VALUES (944, 3, 'ba2b740f-a0cf-4ec6-a6c0-74aaf6cc324a.png', 0);
INSERT INTO `d_entity` VALUES (945, 3, '2cd1085e-01a3-42d8-a66d-9f89b08d57ae.png', 0);
INSERT INTO `d_entity` VALUES (946, 3, 'aac4db5e-d665-4dba-88b4-7fb5e4750bf5.png', 0);
INSERT INTO `d_entity` VALUES (947, 3, '6d53ef31-da57-4d37-aea5-a235fc4d69b8.png', 0);
INSERT INTO `d_entity` VALUES (948, 3, '314964eb-95f9-44ea-8441-8fa5ec7c2c0a.png', 0);
INSERT INTO `d_entity` VALUES (949, 3, 'd9c9cd83-79ce-4fee-9e41-b312122b4bb2.png', 0);
INSERT INTO `d_entity` VALUES (950, 3, '64f327d3-5a40-4a51-b7a8-d61805aba507.png', 0);
INSERT INTO `d_entity` VALUES (951, 3, '10315cc7-811b-48de-9a08-545fec0ade11.png', 0);
INSERT INTO `d_entity` VALUES (952, 3, '541f2d17-920c-4961-adcf-7294c43e438f.png', 0);
INSERT INTO `d_entity` VALUES (953, 3, 'c5835338-a9fa-4be1-90da-0a98570a44e0.png', 0);
INSERT INTO `d_entity` VALUES (954, 3, '95c279ad-f737-46c6-b205-ba4c7757f584.png', 0);
INSERT INTO `d_entity` VALUES (955, 3, '34bb5025-f404-4782-8d03-f1caff51d824.png', 0);
INSERT INTO `d_entity` VALUES (956, 3, '32bda46b-95e1-43ff-9aeb-4db070bd6054.png', 0);
INSERT INTO `d_entity` VALUES (957, 3, '885cd4ee-7d46-4dad-a37e-a5fdcbb1649c.png', 0);
INSERT INTO `d_entity` VALUES (958, 3, 'd602c1ad-f6bd-405b-81d8-88f8a9726dcc.png', 0);
INSERT INTO `d_entity` VALUES (959, 3, '931115ab-baa7-479a-93a8-e1dcf984bff6.png', 0);
INSERT INTO `d_entity` VALUES (960, 3, '755d0c55-68fc-4db0-84f6-c3b162e2c089.png', 0);
INSERT INTO `d_entity` VALUES (961, 3, 'd8f592da-7e90-4a7f-bae8-72ab30d5a99a.png', 0);
INSERT INTO `d_entity` VALUES (962, 3, '27066d5d-9d0f-4c08-a846-2dd9b3b621d0.png', 0);
INSERT INTO `d_entity` VALUES (963, 3, 'fb38ad99-18b8-42ea-a3eb-f5e7f6f23129.png', 0);
INSERT INTO `d_entity` VALUES (964, 3, '73366c5a-5e18-4b66-9662-f4aac7937ac3.png', 0);
INSERT INTO `d_entity` VALUES (965, 3, 'a58f064b-6931-4d01-bed8-f3d88bda1678.png', 0);
INSERT INTO `d_entity` VALUES (966, 3, 'ea957cd3-e39b-4dbf-b15a-7d2e1f56cbad.png', 0);
INSERT INTO `d_entity` VALUES (967, 3, '24dea641-86a4-4b18-8427-9e2bdf262484.png', 0);
INSERT INTO `d_entity` VALUES (968, 3, '8d5e834d-5dc4-418b-8256-920ecee71320.png', 0);
INSERT INTO `d_entity` VALUES (969, 3, '57fc3b5b-412a-4046-89ae-eae339c82c73.png', 0);
INSERT INTO `d_entity` VALUES (970, 3, '0cb6575b-81e6-4531-902a-41a7a9e8d1da.png', 0);
INSERT INTO `d_entity` VALUES (971, 3, '06d3f4cf-94e9-4f82-94b6-a22a439f528b.png', 0);
INSERT INTO `d_entity` VALUES (972, 3, 'bf3a2047-2826-4eed-8c99-a1c078c2a110.png', 0);
INSERT INTO `d_entity` VALUES (973, 3, 'a28535bc-e966-4303-bfb8-7eee69b2b3a4.png', 0);
INSERT INTO `d_entity` VALUES (974, 3, '73b2bc18-59e3-46bd-b5a8-e20a365f95ea.png', 0);
INSERT INTO `d_entity` VALUES (975, 3, 'b8f9f3fb-4f90-46ef-acbf-2632ffbf291d.png', 0);
INSERT INTO `d_entity` VALUES (976, 3, '0346a3e7-6e20-4979-974d-1b4919c2998d.png', 0);
INSERT INTO `d_entity` VALUES (977, 3, '3c1a3dbb-82ae-4ad8-84ad-094179bd1904.png', 0);
INSERT INTO `d_entity` VALUES (978, 3, '4d449485-4426-495a-be90-f78d89e75f9b.png', 0);
INSERT INTO `d_entity` VALUES (979, 3, '59f7364d-79ec-43c3-9cff-0b77cbee725f.png', 0);
INSERT INTO `d_entity` VALUES (980, 3, 'f326afed-7304-4936-b55c-a8e84eed15fc.png', 0);
INSERT INTO `d_entity` VALUES (981, 3, '839448f9-6f99-42a5-a2ca-6456577a899c.png', 0);
INSERT INTO `d_entity` VALUES (982, 3, '7b11735b-d196-44c5-893d-0882f714e307.png', 0);
INSERT INTO `d_entity` VALUES (983, 3, '5d6aa6bf-9962-429b-b62c-65a398374d90.png', 0);
INSERT INTO `d_entity` VALUES (984, 3, 'c19b83b8-1d05-4776-a9d6-05d95cc49c07.png', 0);
INSERT INTO `d_entity` VALUES (985, 3, 'e3e7d119-e118-41ab-83e6-d0781fceff25.png', 0);
INSERT INTO `d_entity` VALUES (986, 3, '51e52900-a7f2-457f-b0bc-b79d9fd3cb99.png', 0);
INSERT INTO `d_entity` VALUES (987, 3, '7407142b-fb41-4142-bb9d-03f353165526.png', 0);
INSERT INTO `d_entity` VALUES (988, 3, 'af5eeb5c-bf56-42b7-8ba8-cfbde4e4cde1.png', 0);
INSERT INTO `d_entity` VALUES (989, 3, 'c46dbb04-fe78-4644-b822-3101faf1b406.png', 0);
INSERT INTO `d_entity` VALUES (990, 3, '1f918d01-857d-442e-8fa0-9c23b098d9bf.png', 0);
INSERT INTO `d_entity` VALUES (991, 3, '1fc09042-e92d-4a23-b7c2-5ea774d7afdd.png', 0);
INSERT INTO `d_entity` VALUES (992, 3, '377bc275-2090-4686-af23-58262dc1c7d8.png', 0);
INSERT INTO `d_entity` VALUES (993, 3, '060eb676-7c83-4be3-914c-ecbf32bff47b.png', 0);
INSERT INTO `d_entity` VALUES (994, 3, '81ccde8c-8b9d-4e9c-9664-f52a9ac6cf20.png', 0);
INSERT INTO `d_entity` VALUES (995, 3, '59867e89-3d29-4002-8b68-772a0dd2ac2d.png', 0);
INSERT INTO `d_entity` VALUES (996, 3, '9af9c960-75b6-4283-b746-46ed2610e061.png', 0);
INSERT INTO `d_entity` VALUES (997, 3, '6ee950a9-397e-4170-86e1-b9cdf81f2643.png', 0);
INSERT INTO `d_entity` VALUES (998, 3, 'ac34f5da-d736-4d1f-8785-1a356875c8cd.png', 0);
INSERT INTO `d_entity` VALUES (999, 3, 'afeb9d08-4267-4347-97aa-0fd3ca5ae007.png', 0);
INSERT INTO `d_entity` VALUES (1000, 3, '32fce0a8-e89b-49fe-8204-362c182759a7.png', 0);
INSERT INTO `d_entity` VALUES (1001, 3, '79fef52b-f02e-44a2-a7c2-0234824d22e7.png', 0);
INSERT INTO `d_entity` VALUES (1002, 3, '09a36fa9-b50a-4420-b875-b38d0a6f43b7.png', 0);
INSERT INTO `d_entity` VALUES (1003, 3, '68702e68-fdf3-4765-b4b6-09883684e0e9.png', 0);
INSERT INTO `d_entity` VALUES (1004, 3, '9c29a46f-224b-41f8-91fb-6f2cdb6898db.png', 0);
INSERT INTO `d_entity` VALUES (1005, 3, 'a5976e16-17e9-403e-a00a-06001f7ae000.png', 0);
INSERT INTO `d_entity` VALUES (1006, 3, '5e18d3c7-3794-45a8-8948-109ca331acc5.png', 0);
INSERT INTO `d_entity` VALUES (1007, 3, '136248af-73b5-42be-8e17-086294d64e1d.png', 0);
INSERT INTO `d_entity` VALUES (1008, 3, '34e80ce5-b575-4288-a83c-a250ff3c8309.png', 0);
INSERT INTO `d_entity` VALUES (1009, 3, 'e79fd7a8-a107-470f-9cef-46cdcce9421a.png', 0);
INSERT INTO `d_entity` VALUES (1010, 3, '4cde38f3-9f02-4c6b-be72-9a91504b91d6.png', 0);
INSERT INTO `d_entity` VALUES (1011, 3, 'edd56cc0-6fb1-434d-a953-c4f99210d0f2.png', 0);
INSERT INTO `d_entity` VALUES (1012, 3, 'e2f3c39d-1a45-43d9-9ec9-474f59c83b33.png', 0);
INSERT INTO `d_entity` VALUES (1013, 3, 'a097baf5-8807-4b30-bf1f-daaa8d02d89f.png', 0);
INSERT INTO `d_entity` VALUES (1014, 3, 'e86614d3-2081-4aed-b383-02a06aabaf44.png', 0);
INSERT INTO `d_entity` VALUES (1015, 3, '3e2c3ff4-6d3d-4158-9943-78d15a1d5d7b.png', 0);
INSERT INTO `d_entity` VALUES (1016, 3, 'd3341ead-7afc-4c8b-b2a3-e7b5bbf0e46d.png', 0);
INSERT INTO `d_entity` VALUES (1017, 3, 'a0830aea-f7a5-44c3-a3dd-25078657693f.png', 0);
INSERT INTO `d_entity` VALUES (1018, 3, 'd2c1cde0-6f45-4780-b984-3d4cb2b6c1cd.png', 0);
INSERT INTO `d_entity` VALUES (1019, 3, 'da2017d4-2e62-4a82-a385-44f9db029fd7.png', 0);
INSERT INTO `d_entity` VALUES (1020, 3, '3cc6b6f0-4665-42e3-8f71-9c178a30e00c.png', 0);
INSERT INTO `d_entity` VALUES (1021, 3, '7eca0249-1ceb-4a7b-b09d-30cee2bbe2ac.png', 0);
INSERT INTO `d_entity` VALUES (1022, 3, '98542b97-7479-4f39-8b0b-ff72dcee6bc2.png', 0);
INSERT INTO `d_entity` VALUES (1023, 3, '6e31f8fa-9b1a-4187-96e4-e0b75f9c6f8d.png', 0);
INSERT INTO `d_entity` VALUES (1024, 3, 'fd55ead3-542c-439a-91a9-415250059ef6.png', 0);
INSERT INTO `d_entity` VALUES (1025, 3, '8890bd41-0c54-4194-b390-69c02f31606f.png', 0);
INSERT INTO `d_entity` VALUES (1026, 3, 'f56bd6b5-36a4-4206-bd79-45fdf4885c01.png', 0);
INSERT INTO `d_entity` VALUES (1027, 3, '3d9a6fb9-eedd-459e-bf42-2953a839d1b9.png', 0);
INSERT INTO `d_entity` VALUES (1028, 3, '3d1e80b6-0f0b-442a-b0d7-1c0ee68d2c55.png', 0);
INSERT INTO `d_entity` VALUES (1029, 3, '14610742-50a5-44be-ac5a-8dd3f54a375c.png', 0);
INSERT INTO `d_entity` VALUES (1030, 3, '188ffe81-fca2-4d11-b402-9222b418d03a.png', 0);
INSERT INTO `d_entity` VALUES (1031, 3, '705ed332-b2d5-42b5-b2b0-b73609b8af9f.png', 0);
INSERT INTO `d_entity` VALUES (1032, 3, 'a545c02a-8e54-432b-85d4-581506148fb1.png', 0);
INSERT INTO `d_entity` VALUES (1033, 3, 'fa6bcaad-fda6-4c9b-a774-d9c1228b1905.png', 0);
INSERT INTO `d_entity` VALUES (1034, 3, 'b168ff43-2cd0-4204-958a-7b5a2f9d8097.png', 0);
INSERT INTO `d_entity` VALUES (1035, 3, 'e886db2a-0638-42b6-af25-38e62940ec27.png', 0);
INSERT INTO `d_entity` VALUES (1036, 3, '82f05a3d-ab3f-4b7b-9a73-88e1c733939a.png', 0);
INSERT INTO `d_entity` VALUES (1037, 3, '95485936-2f40-4a06-b0e0-7a2007993c8b.png', 0);
INSERT INTO `d_entity` VALUES (1038, 3, '3cc6c227-4155-42ec-a5c6-e1e1cb40eccc.png', 0);
INSERT INTO `d_entity` VALUES (1039, 3, '3ebe4579-af91-4b7b-a776-0408899dd1ff.png', 0);
INSERT INTO `d_entity` VALUES (1040, 3, '6a111e82-bde6-4287-859c-e481525664c4.png', 0);
INSERT INTO `d_entity` VALUES (1041, 3, '9f448707-7937-4f7a-941e-68c748a55ee0.png', 0);
INSERT INTO `d_entity` VALUES (1042, 3, '80efcd11-56b6-41d9-b325-505c8e535e71.png', 0);
INSERT INTO `d_entity` VALUES (1043, 3, '6a61866a-6d14-4483-9295-737c6902126f.png', 0);
INSERT INTO `d_entity` VALUES (1044, 3, '99f54665-a9c4-4c6e-a3c0-3c5985e41f43.png', 0);
INSERT INTO `d_entity` VALUES (1045, 3, 'c0b26ffa-d3bf-45ce-973d-4dd0b053464a.png', 0);
INSERT INTO `d_entity` VALUES (1046, 3, '36830d64-18c3-4d5d-949b-95c31d883657.png', 0);
INSERT INTO `d_entity` VALUES (1047, 3, 'a19b36c3-fa15-430d-aa68-4b7f48b752ea.png', 0);
INSERT INTO `d_entity` VALUES (1048, 3, '8a875708-defc-405c-9667-daccfbd949dd.png', 0);
INSERT INTO `d_entity` VALUES (1049, 3, 'e015f91b-3bbc-4ff2-9838-ddd9e585813d.png', 0);
INSERT INTO `d_entity` VALUES (1050, 3, '829ffc12-8f45-41eb-b971-965eb1f83f66.png', 0);
INSERT INTO `d_entity` VALUES (1051, 3, 'e17ced97-cd50-4b2a-9db7-37bc2eb4e852.png', 0);
INSERT INTO `d_entity` VALUES (1052, 3, '1b807263-97c4-4004-bd28-0667afe656eb.png', 0);
INSERT INTO `d_entity` VALUES (1053, 3, 'f3fb10d1-8d4d-463a-a6a0-475b685f6173.png', 0);
INSERT INTO `d_entity` VALUES (1054, 3, '8cdd49a5-5bbc-41f8-b2ca-170dab1fc1ba.png', 0);
INSERT INTO `d_entity` VALUES (1055, 3, '0c16efa8-e5bf-4708-93ec-549040e721ac.png', 0);
INSERT INTO `d_entity` VALUES (1056, 3, 'bce3ad86-acc3-4cf0-b87b-7a896835a3e0.png', 0);
INSERT INTO `d_entity` VALUES (1057, 3, 'abdaf1fe-7d32-443b-9b30-a5c8195d46b7.png', 0);
INSERT INTO `d_entity` VALUES (1058, 3, 'f6b90af0-587e-476b-b2d6-c42a556435f6.png', 0);
INSERT INTO `d_entity` VALUES (1059, 3, 'a3ee3906-f6a0-43ab-a3ed-f23e6c59eaac.png', 0);
INSERT INTO `d_entity` VALUES (1060, 3, '598fc715-c5e9-4a95-8134-2d041fc29fc8.png', 0);
INSERT INTO `d_entity` VALUES (1061, 3, 'a27a5861-aaac-4871-9124-1c6c28ba6fae.png', 0);
INSERT INTO `d_entity` VALUES (1062, 3, '4e7f47d9-eae9-4c33-9562-6f5258a746ca.png', 0);
INSERT INTO `d_entity` VALUES (1063, 3, '96c02f5d-e9c4-40b6-86ee-d84258dec0f3.png', 0);
INSERT INTO `d_entity` VALUES (1064, 3, 'b46ce18e-c0bf-4684-862f-f6e161f04a2c.png', 0);
INSERT INTO `d_entity` VALUES (1065, 3, '54759417-cadd-4b0a-a036-fdd0c44be800.png', 0);
INSERT INTO `d_entity` VALUES (1066, 3, '49a4e2c7-d370-4588-892a-b4c52db3c6ba.png', 0);
INSERT INTO `d_entity` VALUES (1067, 3, '1ebcca8d-c9f6-4f02-a3ef-d2f014b05c4d.png', 0);
INSERT INTO `d_entity` VALUES (1068, 3, 'af43a83c-0b6e-4cd5-9717-15b0e3a23b8a.png', 0);
INSERT INTO `d_entity` VALUES (1069, 3, '03b9e8e8-7532-4f77-8c5d-fa650eb0c4d5.png', 0);
INSERT INTO `d_entity` VALUES (1070, 3, 'ed34a1de-2561-4b4d-9ff7-367ee6cd1167.png', 0);
INSERT INTO `d_entity` VALUES (1071, 3, '8ad05d89-6fa4-4833-8d0c-fcdaba571221.png', 0);
INSERT INTO `d_entity` VALUES (1072, 3, '589b06ef-9cb7-4c9d-89d7-a332871e3b8d.png', 0);
INSERT INTO `d_entity` VALUES (1073, 3, 'f2fcd782-c929-438d-9611-f58e7078364c.png', 0);
INSERT INTO `d_entity` VALUES (1074, 3, 'c31a47e3-d47f-4872-8572-f0503f7f92f9.png', 0);
INSERT INTO `d_entity` VALUES (1075, 3, '3d589d2e-1518-4a54-aab9-5f7aaa1f7555.png', 0);
INSERT INTO `d_entity` VALUES (1076, 3, 'e0a34c69-d596-4338-b11e-2709f26d5db1.png', 0);
INSERT INTO `d_entity` VALUES (1077, 3, 'c17cde55-743d-41d1-ac4d-a7a4e61f7dd9.png', 0);
INSERT INTO `d_entity` VALUES (1078, 3, 'df7d9073-d7ef-4991-b87b-5e4a3f0871b3.png', 0);
INSERT INTO `d_entity` VALUES (1079, 4, 'aff0f1fa-0959-4a1c-bda2-207d924c8fc2.png', 0);
INSERT INTO `d_entity` VALUES (1080, 4, 'f8f56346-6ed2-4204-b095-c719a135c7d2.png', 0);
INSERT INTO `d_entity` VALUES (1081, 4, 'edec54f3-5089-4240-be5f-45eac3b3e2ef.png', 0);
INSERT INTO `d_entity` VALUES (1082, 4, '703d6a9e-a809-4212-8e45-0796cf8fa44b.png', 0);
INSERT INTO `d_entity` VALUES (1083, 4, '4ca36b9f-69f5-47b1-b4fa-f8dc5dceed6d.png', 0);
INSERT INTO `d_entity` VALUES (1084, 4, '2ceecf29-df54-4932-8e30-b3034fb3759f.png', 0);
INSERT INTO `d_entity` VALUES (1085, 4, '922dca68-f0c6-4c20-b779-66c079d6aef8.png', 0);
INSERT INTO `d_entity` VALUES (1086, 4, 'd01bd8db-0784-4f1f-a2d3-a8614acf0663.png', 0);
INSERT INTO `d_entity` VALUES (1087, 4, 'b16c4bc4-0a6b-4d56-b0ed-1f5889f3ec7d.png', 0);
INSERT INTO `d_entity` VALUES (1088, 4, '84bd680f-fea4-4c50-8239-b47c9e070999.png', 0);
INSERT INTO `d_entity` VALUES (1089, 4, '5d33620e-cba7-484a-a261-999878c82093.png', 0);
INSERT INTO `d_entity` VALUES (1090, 4, 'e170df67-ebfd-4725-ad3b-2d245e859006.png', 0);
INSERT INTO `d_entity` VALUES (1091, 4, '8e2fa54f-4761-4ee0-b8cd-a7651a5fca69.png', 0);
INSERT INTO `d_entity` VALUES (1092, 4, '335cb5a2-e107-40b3-bf86-48a29590c253.png', 0);
INSERT INTO `d_entity` VALUES (1093, 4, '08435016-8a07-4f7b-97d0-38af32d3328d.png', 0);
INSERT INTO `d_entity` VALUES (1094, 4, 'dbc57291-f5ed-470d-ac25-38065e7d76ca.png', 0);
INSERT INTO `d_entity` VALUES (1095, 4, '23e68b36-d339-454f-967b-e445df563e3f.png', 0);
INSERT INTO `d_entity` VALUES (1096, 4, 'c88e9198-c323-4582-9ae2-c1b31f9d04ce.png', 0);
INSERT INTO `d_entity` VALUES (1097, 4, 'fd9c116c-da55-49ed-932e-4451cfd811ee.png', 0);
INSERT INTO `d_entity` VALUES (1098, 4, 'd9d359fd-e45e-49d7-abb6-adfaf48943b1.png', 0);
INSERT INTO `d_entity` VALUES (1099, 4, '44d5837e-a9b2-4c03-bbf8-8756075caa40.png', 0);
INSERT INTO `d_entity` VALUES (1100, 4, '79a2de3f-be53-4e96-a900-88d39c9ea6a3.png', 0);
INSERT INTO `d_entity` VALUES (1101, 4, 'fe3c2f3e-5f5c-4388-85da-f45b89970f83.png', 0);
INSERT INTO `d_entity` VALUES (1102, 4, 'a7f13fe1-705e-4c51-ba1b-fb3726d4d5d7.png', 0);
INSERT INTO `d_entity` VALUES (1103, 4, 'd9d64481-8b36-4d7a-938c-14bdd85654dc.png', 0);
INSERT INTO `d_entity` VALUES (1104, 4, 'f7abe76a-a0bb-410d-bdb9-90366aa62101.png', 0);
INSERT INTO `d_entity` VALUES (1105, 4, '21056532-b8f5-4909-8fa1-05a684ce5cc8.png', 0);
INSERT INTO `d_entity` VALUES (1106, 4, 'eb3d82c6-87f9-4e90-b996-84692e444dc4.png', 0);
INSERT INTO `d_entity` VALUES (1107, 4, '8e42f4dd-da59-41d8-815a-72ad49d7c402.png', 0);
INSERT INTO `d_entity` VALUES (1108, 4, '195c5ef4-84be-4eea-953c-c4f71cd1834a.png', 0);
INSERT INTO `d_entity` VALUES (1109, 4, 'c34e11f0-1e58-4c09-a3d7-04d541c9acdd.png', 0);
INSERT INTO `d_entity` VALUES (1110, 4, 'e21335bb-021a-4e47-9d8d-58cefd74b573.png', 0);
INSERT INTO `d_entity` VALUES (1111, 4, 'ac82292a-86f7-44d8-bb93-b97c56f5d283.png', 0);
INSERT INTO `d_entity` VALUES (1112, 4, '1746e3fe-f205-4287-97ef-95552719dc56.png', 0);
INSERT INTO `d_entity` VALUES (1113, 4, '3d90ac73-28fb-485d-a5dc-3712f41510ec.png', 0);
INSERT INTO `d_entity` VALUES (1114, 4, 'ac7be1b1-b51f-4fcf-bcfa-877871701746.png', 0);
INSERT INTO `d_entity` VALUES (1115, 4, 'caf875de-3ea8-4ed7-8e1a-ab1a9361fa9f.png', 0);
INSERT INTO `d_entity` VALUES (1116, 4, '78a8d04f-c8fb-4221-8632-5b8993022a35.png', 0);
INSERT INTO `d_entity` VALUES (1117, 4, '8d057bbc-9225-428d-bdc9-77784301ce46.png', 0);
INSERT INTO `d_entity` VALUES (1118, 4, '54901276-978b-4fd0-aaf2-f1d103c5866f.png', 0);
INSERT INTO `d_entity` VALUES (1119, 4, '34b43d1a-a7b2-418d-abfd-30fedf97a5f2.png', 0);
INSERT INTO `d_entity` VALUES (1120, 4, 'b68e561e-9c28-4b0c-acd5-effa6d180608.png', 0);
INSERT INTO `d_entity` VALUES (1121, 4, '9637b7de-d530-4580-b244-a0865c48b3dc.png', 0);
INSERT INTO `d_entity` VALUES (1122, 4, '7e41ff25-b9c1-42ca-a9fa-26672be3dcf6.png', 0);
INSERT INTO `d_entity` VALUES (1123, 4, 'e98e8563-eefe-46eb-a7d3-51b805996cc4.png', 0);
INSERT INTO `d_entity` VALUES (1124, 4, '4e30dde2-6254-40b1-a0f0-6225f1535cc4.png', 0);
INSERT INTO `d_entity` VALUES (1125, 4, '50beb3f6-8138-4e9f-adc6-802cbc177c76.png', 0);
INSERT INTO `d_entity` VALUES (1126, 4, '96a8a5df-a756-43b5-b050-b5aea9c14671.png', 0);
INSERT INTO `d_entity` VALUES (1127, 4, '1d8409e1-90c4-42a1-80b0-af00ef290500.png', 0);
INSERT INTO `d_entity` VALUES (1128, 4, '9985beb8-48e2-47b8-8569-799115ee00c3.png', 0);
INSERT INTO `d_entity` VALUES (1129, 4, '0c7cdd6d-9014-4366-9eba-ef216bfecc91.png', 0);
INSERT INTO `d_entity` VALUES (1130, 4, '41648151-6517-4620-b7ac-4beb15d25d71.png', 0);
INSERT INTO `d_entity` VALUES (1131, 4, 'e5f06a32-8809-4a73-a91c-b1ad5a748887.png', 0);
INSERT INTO `d_entity` VALUES (1132, 4, 'e610551b-80c6-43e8-bd2c-5c944134ba15.png', 0);
INSERT INTO `d_entity` VALUES (1133, 4, 'b4cc993c-5eb6-4404-b4ba-7c93956abb92.png', 0);
INSERT INTO `d_entity` VALUES (1134, 4, '310aa82c-d9e1-4f18-b727-01dd80b0c6c6.png', 0);
INSERT INTO `d_entity` VALUES (1135, 4, 'a7e952e3-9c02-475b-bc28-76648dcd2440.png', 0);
INSERT INTO `d_entity` VALUES (1136, 4, '8c5f8a54-fbea-4d95-b8e7-a473dadcc5f4.png', 0);
INSERT INTO `d_entity` VALUES (1137, 4, '4daa67cb-96c7-4c3a-b689-a593ed4f853c.png', 0);
INSERT INTO `d_entity` VALUES (1138, 4, '75d1ced2-2b83-42bb-a6a6-a5a909b602a6.png', 0);
INSERT INTO `d_entity` VALUES (1139, 4, '72473ceb-d215-4740-bda2-2776fecaed2b.png', 0);
INSERT INTO `d_entity` VALUES (1140, 4, '24808f58-75e4-44bd-95bc-8718fc1d0847.png', 0);
INSERT INTO `d_entity` VALUES (1141, 4, '39383c0f-90d9-43bc-b9a9-658dc4fef945.png', 0);
INSERT INTO `d_entity` VALUES (1142, 4, 'a73a209a-8b5f-4dec-bc25-7a0cad7a096b.png', 0);
INSERT INTO `d_entity` VALUES (1143, 4, '0082f37f-da10-4fd4-b3ca-6f9720f4ef0d.png', 0);
INSERT INTO `d_entity` VALUES (1144, 4, '9393f78e-8155-4b40-ba3c-350fa38abc0f.png', 0);
INSERT INTO `d_entity` VALUES (1145, 4, '8d41dfea-b257-4a48-8ba4-d6c7d7add0ca.png', 0);
INSERT INTO `d_entity` VALUES (1146, 4, '45a4ae3a-7143-4cca-beed-1cabe9af2b1c.png', 0);
INSERT INTO `d_entity` VALUES (1147, 4, 'a5f2671d-4977-42b3-877a-6bfee1f000c2.png', 0);
INSERT INTO `d_entity` VALUES (1148, 4, '5aee8464-f4bd-465d-b331-904acc66c86b.png', 0);
INSERT INTO `d_entity` VALUES (1149, 4, 'f9dea835-53c0-4429-9b4a-7bdee4e119c1.png', 0);
INSERT INTO `d_entity` VALUES (1150, 4, '20d7c86e-30e0-4ed9-98cf-a11e9aff0e6d.png', 0);
INSERT INTO `d_entity` VALUES (1151, 4, 'ae3a8639-d832-49c9-8f44-e988c18a68e9.png', 0);
INSERT INTO `d_entity` VALUES (1152, 4, 'ec8ca587-ffa5-489f-9fe0-682c7cc01f4d.png', 0);
INSERT INTO `d_entity` VALUES (1153, 4, 'a80e82da-07ec-4433-bf3d-3544ea18d2f9.png', 0);
INSERT INTO `d_entity` VALUES (1154, 4, '6d1d9903-e1d2-4ecd-a9e4-ed8c6fd69ae7.png', 0);
INSERT INTO `d_entity` VALUES (1155, 4, 'f10bf6b1-6922-4204-bb07-74c2a82b07db.png', 0);
INSERT INTO `d_entity` VALUES (1156, 4, 'b39a6627-6e36-44ea-b7c1-058b6c98cead.png', 0);
INSERT INTO `d_entity` VALUES (1157, 4, '7e7e36ff-744f-415e-b74f-f96e9b0da0a4.png', 0);
INSERT INTO `d_entity` VALUES (1158, 4, '070f1606-4d81-4e74-af19-6e94048b0c84.png', 0);
INSERT INTO `d_entity` VALUES (1159, 4, '6e32b492-07ce-4af6-8f6c-f917f8033d90.png', 0);
INSERT INTO `d_entity` VALUES (1160, 4, '6b4f51e4-f1b8-4fe4-a214-69666bd305b6.png', 0);
INSERT INTO `d_entity` VALUES (1161, 4, '61482e4e-5f9e-43ab-a848-057a467e43e2.png', 0);
INSERT INTO `d_entity` VALUES (1162, 4, '5476260a-05bd-4dab-bb25-c944cc9fbc27.png', 0);
INSERT INTO `d_entity` VALUES (1163, 4, 'ac2b4bcc-53ed-47e4-9840-d6a8b495911f.png', 0);
INSERT INTO `d_entity` VALUES (1164, 4, 'eef5b717-f321-481c-b1df-e783727c0433.png', 0);
INSERT INTO `d_entity` VALUES (1165, 4, '11828135-f44f-468f-b6b4-268d0a013b23.png', 0);
INSERT INTO `d_entity` VALUES (1166, 4, 'd2d37f1d-c807-41b7-9dd8-382d9985017e.png', 0);
INSERT INTO `d_entity` VALUES (1167, 4, 'd1d40b93-77e0-4a6c-a7c5-6802e4428ee1.png', 0);
INSERT INTO `d_entity` VALUES (1168, 4, '0e5d575b-a97b-41c5-86c7-4c738673f6a1.png', 0);
INSERT INTO `d_entity` VALUES (1169, 4, '6c151135-11eb-493e-9ef8-4c95131a7291.png', 0);
INSERT INTO `d_entity` VALUES (1170, 4, '8bd91c75-b13f-460d-8667-c211f8cde751.png', 0);
INSERT INTO `d_entity` VALUES (1171, 4, '42ffc0c0-6e05-428e-9286-71762986ec76.png', 0);
INSERT INTO `d_entity` VALUES (1172, 4, 'e06ef92d-f81e-423c-adb2-221d8bc0c5fb.png', 0);
INSERT INTO `d_entity` VALUES (1173, 4, 'b0465527-523c-42d1-b86d-a803799cc779.png', 0);
INSERT INTO `d_entity` VALUES (1174, 4, '4bf05155-d72b-4f8a-a4e6-401523312ea1.png', 0);
INSERT INTO `d_entity` VALUES (1175, 4, 'f13ea470-887a-432e-a81b-6ffd11ba74e4.png', 0);
INSERT INTO `d_entity` VALUES (1176, 4, '495e3ebc-8af3-4791-a541-04852263cdb7.png', 0);
INSERT INTO `d_entity` VALUES (1177, 4, '9ccff982-20ca-4ac3-b731-96a49db98c5c.png', 0);
INSERT INTO `d_entity` VALUES (1178, 4, 'fbf84b7a-ce04-468e-a049-527c15055d23.png', 0);
INSERT INTO `d_entity` VALUES (1179, 4, '18c7c803-80eb-4056-b810-1713a61eca2f.png', 0);
INSERT INTO `d_entity` VALUES (1180, 4, '5ec572e1-0cac-4375-912f-a823f2c328e3.png', 0);
INSERT INTO `d_entity` VALUES (1181, 4, '7ed632f1-326d-4779-bbd6-e9da40b876b1.png', 0);
INSERT INTO `d_entity` VALUES (1182, 4, 'eebc750e-10bf-4b23-bb74-016b3c226502.png', 0);
INSERT INTO `d_entity` VALUES (1183, 4, '53fce965-469c-4fc3-bd87-de0985b799aa.png', 0);
INSERT INTO `d_entity` VALUES (1184, 4, '2373fe02-5442-4f5b-b00d-cd63772eaf8f.png', 0);
INSERT INTO `d_entity` VALUES (1185, 4, '631d8bc8-378a-4c2b-b8aa-bc9805b98f7b.png', 0);
INSERT INTO `d_entity` VALUES (1186, 4, 'e29de43f-f2e1-4dbf-8126-635825137922.png', 0);
INSERT INTO `d_entity` VALUES (1187, 4, '62225284-4fe1-4769-b289-6727fc75566e.png', 0);
INSERT INTO `d_entity` VALUES (1188, 4, 'efea312f-38a6-4b0e-bee0-6b81b7fa2fc5.png', 0);
INSERT INTO `d_entity` VALUES (1189, 4, '42919db9-53e4-4057-a71c-ba3e26f270b9.png', 0);
INSERT INTO `d_entity` VALUES (1190, 4, 'c70791a2-03de-4dce-9638-d85116f3f3a7.png', 0);
INSERT INTO `d_entity` VALUES (1191, 4, 'b00b4d33-4bbd-4a1d-89e7-684d6fb66ae1.png', 0);
INSERT INTO `d_entity` VALUES (1192, 4, '1da70295-3994-4a81-a4cd-6160d275be61.png', 0);
INSERT INTO `d_entity` VALUES (1193, 4, '41fb6a9c-c0e5-45ab-a682-d5b8d8ae22b6.png', 0);
INSERT INTO `d_entity` VALUES (1194, 4, '216e3dc3-e107-4589-8775-c8708d6f1178.png', 0);
INSERT INTO `d_entity` VALUES (1195, 4, '761c8f05-415f-4749-986e-e8468967577c.png', 0);
INSERT INTO `d_entity` VALUES (1196, 4, 'cd3dbeb7-8a3e-447c-aa51-7e32c8500c5c.png', 0);
INSERT INTO `d_entity` VALUES (1197, 4, '155f32b4-7d03-4197-a6c9-4bcef1cd838b.png', 0);
INSERT INTO `d_entity` VALUES (1198, 4, 'a72b8d69-d768-4f71-85e6-501ab96d136b.png', 0);
INSERT INTO `d_entity` VALUES (1199, 4, '71ba5e79-a63d-46ff-bc46-4c3e7bbd68a4.png', 0);
INSERT INTO `d_entity` VALUES (1200, 4, 'c3d3959a-c2c9-4b9b-a901-5e96a8a9d058.png', 0);
INSERT INTO `d_entity` VALUES (1201, 4, 'c7bb67ab-9552-4f32-bcac-c81a38707a81.png', 0);
INSERT INTO `d_entity` VALUES (1202, 4, '876efc08-76fc-4f8f-a00d-85b5c1dc99b2.png', 0);
INSERT INTO `d_entity` VALUES (1203, 4, '61013274-0ba5-48ab-a5c6-fc97f5053e15.png', 0);
INSERT INTO `d_entity` VALUES (1204, 4, 'bd02702b-8066-4ea3-b420-d83f84c52788.png', 0);
INSERT INTO `d_entity` VALUES (1205, 4, '32513599-6730-433d-9399-307789b23216.png', 0);
INSERT INTO `d_entity` VALUES (1206, 4, '5d988f84-4f45-43bc-9e58-dc3f043917e5.png', 0);
INSERT INTO `d_entity` VALUES (1207, 4, '9b570952-5be7-4e55-852e-31d47d9e4e18.png', 0);
INSERT INTO `d_entity` VALUES (1208, 4, '66dfb87e-7c2c-4e48-afa2-a579745f5f6a.png', 0);
INSERT INTO `d_entity` VALUES (1209, 4, 'a1849666-d4e4-417e-a9af-4a77765700ea.png', 0);
INSERT INTO `d_entity` VALUES (1210, 4, 'dd678916-f9d2-434f-9e2f-6556f69824b0.png', 0);
INSERT INTO `d_entity` VALUES (1211, 4, 'da25b147-c278-4091-9535-f9e0a406cdad.png', 0);
INSERT INTO `d_entity` VALUES (1212, 4, 'f36c7c97-c95c-4aea-81a7-cad5144d5f68.png', 0);
INSERT INTO `d_entity` VALUES (1213, 4, 'ea0b0822-e2f5-4a65-ab8d-8276183dbe66.png', 0);
INSERT INTO `d_entity` VALUES (1214, 4, '8ca59b9e-0f5a-4c59-bfc2-faedcde221e0.png', 0);
INSERT INTO `d_entity` VALUES (1215, 4, '2a1c45e8-7601-4188-a90d-493e405cd16d.png', 0);
INSERT INTO `d_entity` VALUES (1216, 4, '171d860b-9499-42ec-b0d0-5064c63ac9f7.png', 0);
INSERT INTO `d_entity` VALUES (1217, 4, '9ef9baab-f550-4699-8251-e6894875e17d.png', 0);
INSERT INTO `d_entity` VALUES (1218, 4, '6dc542af-2536-48aa-ba62-e27f3b48325f.png', 0);
INSERT INTO `d_entity` VALUES (1219, 4, 'abe5b3fa-dbaa-4586-81df-9dec2434fd24.png', 0);
INSERT INTO `d_entity` VALUES (1220, 4, 'd5a1a0a4-8cac-4bd0-a8b4-64111b551870.png', 0);
INSERT INTO `d_entity` VALUES (1221, 4, 'a27fb358-d454-4cac-bb44-dec76540785f.png', 0);
INSERT INTO `d_entity` VALUES (1222, 4, '12591b68-b69c-417b-8e89-6412755fa333.png', 0);
INSERT INTO `d_entity` VALUES (1223, 4, '11f845e2-5824-444b-a9eb-4768090ea3a4.png', 0);
INSERT INTO `d_entity` VALUES (1224, 4, '1af3ba4c-10d7-4c27-81dc-edbf7c1e871c.png', 0);
INSERT INTO `d_entity` VALUES (1225, 4, 'a5bd7ced-0482-4f18-9a27-5d2855758262.png', 0);
INSERT INTO `d_entity` VALUES (1226, 4, 'b871e8e7-f2a4-4d82-bed3-fdebe9288992.png', 0);
INSERT INTO `d_entity` VALUES (1227, 4, '96ee49e4-4569-4c33-b18e-a1aa54fd5bbf.png', 0);
INSERT INTO `d_entity` VALUES (1228, 4, '326b80fb-f483-40c2-964e-0bf3e73ae5a5.png', 0);
INSERT INTO `d_entity` VALUES (1229, 4, '1d570e63-d5bd-47f2-820b-d23b995da1ea.png', 0);
INSERT INTO `d_entity` VALUES (1230, 4, '060bd675-b2a2-4823-897a-e36f05f62512.png', 0);
INSERT INTO `d_entity` VALUES (1231, 4, '174969bd-94bf-4052-aff2-bfe9bd03dbf5.png', 0);
INSERT INTO `d_entity` VALUES (1232, 4, '4833e74c-4f7a-48a8-8f95-a4fd7adc82f2.png', 0);
INSERT INTO `d_entity` VALUES (1233, 4, '76f925d9-4536-48bc-abd6-63b2e4b936a5.png', 0);
INSERT INTO `d_entity` VALUES (1234, 4, '7ba30861-81fd-44ff-a5e5-5cabafb648c7.png', 0);
INSERT INTO `d_entity` VALUES (1235, 4, '38f99c33-7a10-4b94-9ec0-60e087ebb5d9.png', 0);
INSERT INTO `d_entity` VALUES (1236, 4, 'aff19145-caa5-4f24-9b50-eb4d814a7951.png', 0);
INSERT INTO `d_entity` VALUES (1237, 4, 'f8d1055b-5793-406b-ab7d-1c80d4f4144f.png', 0);
INSERT INTO `d_entity` VALUES (1238, 4, 'dddbbac7-8032-41ee-8b9f-7250e8046535.png', 0);

-- ----------------------------
-- Table structure for d_file_chunk
-- ----------------------------
DROP TABLE IF EXISTS `d_file_chunk`;
CREATE TABLE `d_file_chunk`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `file_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件hash值',
  `chunk_index` int NOT NULL COMMENT '分片索引',
  `chunk_size` int NOT NULL COMMENT '分片大小(字节)',
  `chunk_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分片存储路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 194 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件分片状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of d_file_chunk
-- ----------------------------

-- ----------------------------
-- Table structure for d_file_info
-- ----------------------------
DROP TABLE IF EXISTS `d_file_info`;
CREATE TABLE `d_file_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `file_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件hash值',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_size` bigint NOT NULL COMMENT '文件大小(字节)',
  `chunk_size` bigint NOT NULL COMMENT '分片大小(字节)',
  `chunk_num` bigint NOT NULL COMMENT '分片数量',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件存储路径',
  `upload_status` int NOT NULL COMMENT '上传状态(0初始化 1上传中 2已暂停 3已完成 4上传失败)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件上传任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of d_file_info
-- ----------------------------
INSERT INTO `d_file_info` VALUES (1, 'e0ddd30b09257745d7c9f76589a633bb', 'CommonWheatDisease.zip', 1011184491, 5242880, 193, 'D:/nginx/pai-file-nginx/html/file/e0ddd30b09257745d7c9f76589a633bb/CommonWheatDisease.zip', 3);

-- ----------------------------
-- Table structure for m_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `m_evaluate`;
CREATE TABLE `m_evaluate`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `training_id` int NOT NULL COMMENT '训练ID',
  `dataset_id` int NOT NULL COMMENT '数据集ID',
  `accuracy_rate` decimal(10, 5) NULL DEFAULT NULL COMMENT '评估准确率',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模型评估表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_evaluate
-- ----------------------------

-- ----------------------------
-- Table structure for m_evaluate_error
-- ----------------------------
DROP TABLE IF EXISTS `m_evaluate_error`;
CREATE TABLE `m_evaluate_error`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `evaluate_id` int NOT NULL COMMENT '评估ID',
  `pic_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片地址',
  `old_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片原始标签',
  `new_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片识别标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评估错误表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_evaluate_error
-- ----------------------------

-- ----------------------------
-- Table structure for m_evaluate_label
-- ----------------------------
DROP TABLE IF EXISTS `m_evaluate_label`;
CREATE TABLE `m_evaluate_label`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `evaluate_id` int NOT NULL COMMENT '评估ID',
  `label_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称',
  `F1Score` decimal(10, 5) NOT NULL COMMENT 'F1Score指数',
  `GScore` decimal(10, 5) NOT NULL COMMENT 'GScore指数',
  `precision_rate` decimal(10, 5) NOT NULL COMMENT '精确率',
  `recall_rate` decimal(10, 5) NOT NULL COMMENT '召回率',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评估结果表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_evaluate_label
-- ----------------------------

-- ----------------------------
-- Table structure for m_model
-- ----------------------------
DROP TABLE IF EXISTS `m_model`;
CREATE TABLE `m_model`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `model_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型名称',
  `model_status` int NOT NULL COMMENT '模型状态（1发布 0未发布）',
  `model_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模型描述',
  `model_type` int NOT NULL COMMENT '模型类型',
  `last_model_version` int NOT NULL COMMENT '模型最新版本',
  `training_status` int NOT NULL COMMENT '训练状态（0未训练 1训练中 2优化中 3评估中 4训练完成 5训练失败）',
  `accuracy_rate` decimal(10, 5) NULL DEFAULT NULL COMMENT '模型准确率',
  `create_by` int NOT NULL COMMENT '创建用户',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_model
-- ----------------------------
INSERT INTO `m_model` VALUES (1, '玉米叶片病害识别模型', 0, '用于识别玉米叶片病害识别的模型', 2, 0, 0, 0.00000, 1, '2025-05-09 15:05:24', 0);

-- ----------------------------
-- Table structure for m_model_config
-- ----------------------------
DROP TABLE IF EXISTS `m_model_config`;
CREATE TABLE `m_model_config`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `model_id` int NOT NULL COMMENT '模型编号',
  `resolution` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分辨率',
  `iterate_times` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '迭代次数',
  `network_structure` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '网络结构',
  `optimizer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优化器',
  `loss_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '损失值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模型训练配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_model_config
-- ----------------------------

-- ----------------------------
-- Table structure for m_release
-- ----------------------------
DROP TABLE IF EXISTS `m_release`;
CREATE TABLE `m_release`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `model_id` int NOT NULL COMMENT '模型ID',
  `model_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型访问地址',
  `create_by` int NOT NULL COMMENT '创建用户',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模型发布表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_release
-- ----------------------------

-- ----------------------------
-- Table structure for m_training
-- ----------------------------
DROP TABLE IF EXISTS `m_training`;
CREATE TABLE `m_training`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `model_id` int NOT NULL COMMENT '模型ID',
  `model_file_addr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模型文件地址',
  `accuracy_rate` decimal(10, 5) NULL DEFAULT NULL COMMENT '训练准确率',
  `model_version` int NOT NULL COMMENT '模型版本',
  `create_by` int NOT NULL COMMENT '创建用户',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模型训练表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_training
-- ----------------------------

-- ----------------------------
-- Table structure for m_training_dataset
-- ----------------------------
DROP TABLE IF EXISTS `m_training_dataset`;
CREATE TABLE `m_training_dataset`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `training_id` int NOT NULL COMMENT '训练ID',
  `dataset_id` int NOT NULL COMMENT '数据集ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '训练数据集表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_training_dataset
-- ----------------------------

-- ----------------------------
-- Table structure for m_training_label
-- ----------------------------
DROP TABLE IF EXISTS `m_training_label`;
CREATE TABLE `m_training_label`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `training_id` int NOT NULL COMMENT '训练ID',
  `label_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称',
  `F1Score` decimal(10, 5) NOT NULL COMMENT 'F1Score',
  `GScore` decimal(10, 5) NOT NULL COMMENT 'GScore',
  `precision_rate` decimal(10, 5) NOT NULL COMMENT '精确率',
  `recall_rate` decimal(10, 5) NOT NULL COMMENT '召回率',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '训练结果表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of m_training_label
-- ----------------------------

-- ----------------------------
-- Table structure for o_operator
-- ----------------------------
DROP TABLE IF EXISTS `o_operator`;
CREATE TABLE `o_operator`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '算子名称',
  `operator_type` int NOT NULL COMMENT '算子类型（1自定义算子 0基础算子）',
  `operator_url` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '算子路径',
  `operator_category` int NOT NULL COMMENT '算子类型（1网络结构 2优化器 3损失函数）',
  `create_by` int NOT NULL COMMENT '创建用户',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '算子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_operator
-- ----------------------------

-- ----------------------------
-- Table structure for sys_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `sys_dictionary`;
CREATE TABLE `sys_dictionary`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` int NOT NULL COMMENT '父字典ID',
  `dict_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典编码',
  `dict_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典值',
  `is_deleted` int NOT NULL DEFAULT 0 COMMENT '是否删除（1删除 0未删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dictionary
-- ----------------------------
INSERT INTO `sys_dictionary` VALUES (1, 0, 'DATASET_TYPE', '数据集类型', 0);
INSERT INTO `sys_dictionary` VALUES (2, 1, 'IMAGE_CLASSIFICATION', '图像分类', 0);
INSERT INTO `sys_dictionary` VALUES (3, 1, 'OBJECT_DETECTION', '物体检测', 0);
INSERT INTO `sys_dictionary` VALUES (4, 1, 'IMAGE_SEGMENTATION', '图像分割', 0);
INSERT INTO `sys_dictionary` VALUES (5, 1, 'SOUND_CLASSIFICATION', '声音分类', 0);
INSERT INTO `sys_dictionary` VALUES (6, 1, 'TEXT_CLASSIFICATION', '文本分类', 0);
INSERT INTO `sys_dictionary` VALUES (7, 0, 'DATASET_RATIO', '数据集分辨率', 0);
INSERT INTO `sys_dictionary` VALUES (8, 7, '640*480', '640*480', 0);
INSERT INTO `sys_dictionary` VALUES (9, 7, '480*320', '480*320', 0);
INSERT INTO `sys_dictionary` VALUES (10, 7, '320*420', '320*420', 0);
INSERT INTO `sys_dictionary` VALUES (11, 7, '480*480', '480*480', 0);
INSERT INTO `sys_dictionary` VALUES (12, 7, '320*320', '320*320', 0);
INSERT INTO `sys_dictionary` VALUES (13, 7, '240*240', '240*240', 0);
INSERT INTO `sys_dictionary` VALUES (14, 0, 'ITERATION_NUMBER', '迭代次数', 0);
INSERT INTO `sys_dictionary` VALUES (15, 14, '100', '100', 0);
INSERT INTO `sys_dictionary` VALUES (16, 14, '200', '200', 0);
INSERT INTO `sys_dictionary` VALUES (17, 14, '300', '300', 0);
INSERT INTO `sys_dictionary` VALUES (18, 14, '400', '400', 0);
INSERT INTO `sys_dictionary` VALUES (19, 14, '500', '500', 0);
INSERT INTO `sys_dictionary` VALUES (20, 14, '600', '600', 0);

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type` int NOT NULL COMMENT '日志类型（1操作日志 2登录日志）',
  `request_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请求URI',
  `request_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请求方式',
  `request_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请求IP',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数',
  `method_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请求方法名称',
  `request_time` int NOT NULL COMMENT '请求耗时（单位：ms）',
  `is_success` int NOT NULL COMMENT '是否成功（1成功 2失败）',
  `response_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '响应数据',
  `operate_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作用户（用户名或者手机号码）',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 983 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
