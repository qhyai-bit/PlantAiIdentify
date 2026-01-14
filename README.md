# PlantAiIdentify — 智慧农业植物病虫害 AI 识别系统

> 一个基于图像识别的农作物病虫害智能检测与管理平台，支持从数据上传、模型训练、评估到发布的完整 AI 模型生命周期管理。

## 📌 项目简介

**PlantAiIdentify** 是一个面向智慧农业的植物病虫害识别后台管理系统。系统以 AI 图像识别技术为核心，实现了病虫害数据的收集、标注、模型训练、评估与发布的全流程自动化管理，帮助农业生产者快速、准确地识别作物病虫害，提升防治效率与作物产量。

**核心目标**：构建一个可管理、可训练、可发布的 AI 识别系统，对接企业自有业务系统，实现病虫害识别的智能化升级。

------

## 🧩 功能模块

| 模块           | 功能说明                                                     |
| :------------- | :----------------------------------------------------------- |
| 🔐 统一认证登录 | 支持账号密码、短信验证码登录，JWT + SaToken 安全认证与权限控制 |
| 📁 数据集管理   | 数据集/分类/实体管理，支持大文件分片上传、断点续传、Excel 导入导出 |
| ⚙️ 算子管理     | 算子导入、编辑、删除，支持基础算子与自定义算子               |
| 🧠 模型管理     | 模型创建、训练、评估、发布全流程管理，支持版本管理与发布回滚 |
| 👥 权限管理     | 基于 RBAC 的用户-角色-权限三级管控，支持菜单与按钮级权限控制 |
| 📊 系统管理     | 数据字典统一管理、操作日志记录与导出（支持 Excel 格式）      |

------

## 🛠️ 技术栈

| 类别     | 技术选型                                                     |
| :------- | :----------------------------------------------------------- |
| 后端框架 | Spring Boot 3 + Spring MVC + MyBatis-Plus                    |
| 数据库   | MySQL 8.0                                                    |
| 缓存     | Redis + Spring Cache                                         |
| 消息队列 | RabbitMQ（与 Python 训练端异步通信）                         |
| 对象存储 | 七牛云 OSS（存储图片与模型文件）                             |
| 权限控制 | JWT + SaToken + RBAC 模型                                    |
| 工具库   | Hutool、MapStruct、Lombok、Fastjson2、EasyExcel、Knife4j（Swagger） |
| 部署方式 | Docker + Docker Compose（支持容器化部署）                    |

------

## 🏗️ 系统架构

### 架构分层

| 层级       | 说明                                                         |
| :--------- | :----------------------------------------------------------- |
| 表现层     | 前后端分离，前端 Vue.js 通过 REST API 与后端交互，Knife4j 提供接口文档 |
| 业务逻辑层 | Spring Boot 业务服务，包含用户、数据集、模型、权限等核心业务 |
| 数据访问层 | MyBatis-Plus 操作 MySQL，提供高效 CRUD 与复杂查询            |
| 缓存层     | Redis + Spring Cache 注解缓存，提升查询性能                  |
| 消息队列层 | RabbitMQ 实现与 Python 训练端的异步任务下发与结果回调        |

### 核心流程

1. **数据上传** → 用户上传病虫害图片，系统自动归类并生成数据集
2. **模型训练** → 选择数据集与算子，通过 RabbitMQ 下发训练任务至 Python 端
3. **评估与发布** → 训练完成后自动评估，达标后发布为可用模型
4. **识别调用** → 外部系统通过 API 调用已发布模型进行病虫害识别

------

## 🚀 快速开始

### 环境准备

- JDK 17
- Maven 3.6+
- MySQL 8.0
- Redis 7.x
- RabbitMQ 3.12+
- Docker & Docker Compose（可选）

### 配置文件

复制 `application-dev.yml.template` 为 `application-dev.yml`，并修改以下配置：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/pai
    username: root
    password: 123456
  redis:
    host: localhost
    port: 6379

rabbitmq:
  host: localhost
  port: 5672
  username: guest
  password: guest

qiniu:
  access-key: your-access-key
  secret-key: your-secret-key
  bucket: your-bucket-name
  domain: your-cdn-domain
```



### 启动项目

```bash
# 克隆仓库
git clone https://github.com/qhyai-bit/PlantAiIdentify.git
cd PlantAiIdentify

# 导入数据库
mysql -u root -p < docs/pai.sql

# 编译运行
mvn clean package
java -jar target/PlantAiIdentify-1.0.0.jar --spring.profiles.active=dev
```



### Docker 启动（推荐）

```bash
docker-compose up -d
```



访问地址：

- 后端 API 文档：http://localhost:8080/doc.html
- 前端页面（需独立启动）：[http://localhost:82](http://localhost:82/)

------

## 📁 项目结构

```text
PlantAiIdentify/
├── src/main/java/com/briup/pai/
│   ├── config/          # 配置类（Redis、RabbitMQ、MVC等）
│   ├── controller/      # 控制器层
│   ├── service/         # 业务逻辑层
│   ├── dao/             # 数据访问层
│   ├── entity/          # 实体类（PO、DTO、VO）
│   ├── common/          # 通用工具、枚举、异常等
│   └── aspect/          # 切面（日志、权限等）
├── src/main/resources/
│   ├── mapper/          # MyBatis XML 映射文件
│   └── application-*.yml # 配置文件
└── docs/                # 数据库脚本、流程图等
```



------

## 📄 数据库设计

系统包含以下核心表（详见 `docs/pai.sql`）：

- `auth_user`、`auth_role`、`auth_permission`（用户权限表）
- `d_dataset`、`d_classify`、`d_entity`（数据集表）
- `o_operator`（算子表）
- `m_model`、`m_training`、`m_evaluate`、`m_release`（模型相关表）
- `sys_dictionary`、`sys_log`（系统表）

------

## 📬 消息格式示例

### 训练任务下发（Java → Python）

```json
{
  "taskId": "train-001",
  "datasetId": 1,
  "operator": "resnet50",
  "hyperParams": {
    "batchSize": 32,
    "epochs": 50,
    "learningRate": 0.001
  }
}
```



### 训练结果回调（Python → Java）

```json
{
  "taskId": "train-001",
  "status": "SUCCESS",
  "metrics": {
    "accuracy": 0.92,
    "precision": 0.91,
    "recall": 0.90,
    "f1": 0.905
  },
  "modelUrl": "https://oss.example.com/models/model-001.pth"
}
```



------

## 🤝 参与贡献

欢迎提交 Issue 或 Pull Request 帮助改进项目。

1. Fork 本仓库
2. 创建分支：`git checkout -b feature/xxx`
3. 提交更改：`git commit -m 'feat: add xxx'`
4. 推送到分支：`git push origin feature/xxx`
5. 提交 Pull Request

------

## 📄 许可证

本项目基于 MIT 许可证开源，详情请见 [LICENSE](https://license/) 文件。

------

## 📞 联系与支持

- 项目仓库：https://github.com/qhyai-bit/PlantAiIdentify
- 问题反馈：[GitHub Issues](https://github.com/qhyai-bit/PlantAiIdentify/issues)

------

> **提示**：本项目为智慧农业实训项目，适用于学习 Spring Boot 全栈开发、AI 模型管理与系统架构设计。实际生产部署建议结合 Kubernetes、监控与日志系统
