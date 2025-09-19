# 项目设置指南

## AWS配置

本项目使用AWS Rekognition进行人脸识别功能。为了运行项目，您需要配置AWS凭证。

### 方法1：使用环境变量（推荐）

在运行Flutter应用之前，设置以下环境变量：

```bash
export AWS_ACCESS_KEY_ID="your_aws_access_key_here"
export AWS_SECRET_ACCESS_KEY="your_aws_secret_key_here"
export AWS_REGION="ap-northeast-1"
```

### 方法2：使用配置文件

1. 复制 `config.example.dart` 为 `config.dart`
2. 在 `config.dart` 中填入您的AWS凭证
3. 修改 `lib/pages/mine/realname_aws/controller.dart` 中的代码以使用配置文件

### 获取AWS凭证

1. 登录AWS控制台
2. 进入IAM服务
3. 创建新的访问密钥
4. 确保该密钥具有Rekognition服务的访问权限

### 安全注意事项

- 永远不要将真实的AWS凭证提交到版本控制系统
- 使用环境变量或配置文件来管理敏感信息
- 定期轮换访问密钥
- 为生产环境使用IAM角色而不是访问密钥

## 运行项目

```bash
# 安装依赖
flutter pub get

# 运行Web版本
flutter run -d chrome

# 运行移动端版本
flutter run
```
