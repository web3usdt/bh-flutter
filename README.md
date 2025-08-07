****# demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## 应用资产生成

当修改了应用图标或启动图的源文件后，需要手动执行以下命令来重新生成相应平台的资产。

### 生成应用图标 (App Icons)

此命令会读取 `pubspec.yaml` 中 `icons_launcher`部分的配置，并根据 `image_path` 指定的源图片，生成所有平台（Android, iOS）所需要的不同尺寸的应用图标。

```bash
flutter pub run icons_launcher:create
```

### 生成启动图 (Splash Screen)

此命令会读取 `pubspec.yaml` 中 `flutter_native_splash`部分的配置，来创建或更新应用的原生启动图。

```bash
flutter pub run flutter_native_splash:create
```

---

## 构建与环境配置

本项目使用 `--dart-define` 编译参数来区分 **开发构建 (dev)** 和 **生产构建 (prod)**。这可以确保生产包的安全纯净，同时保留开发过程中的调试灵活性。

### 构建模式说明

- **开发构建 (`dev`)**: 默认模式。此模式下会显示所有调试工具，例如环境切换按钮、开发者模式入口等。
- **生产构建 (`prod`)**: 用于发布的模式。此模式下会自动隐藏所有调试相关的UI入口，并强制锁定API环境为生产环境。

### 命令行使用

通过传递 `APP_BUILD` 参数来指定构建模式。

- **运行开发模式**:
  ```bash
  flutter run
  # 或者明确指定
  flutter run --dart-define=APP_BUILD=dev
  ```

- **构建生产包**:
  
  当需要构建一个用于**调试的、行为和生产环境一致**的包时，可以运行：
  ```bash
  # Android (Debug-Prod)
  flutter build apk --dart-define=APP_BUILD=prod

  # iOS (Debug-Prod)
  flutter build ipa --dart-define=APP_BUILD=prod
  ```
  
  当需要构建**正式发布**的包时，应同时使用 `--release` 标志以获得最佳性能：
  ```bash
  # Android (Release-Prod)
  flutter build apk --release --dart-define=APP_BUILD=prod

  # iOS (Release-Prod)
  flutter build ipa --release --dart-define=APP_BUILD=prod
  flutter build ipa --release --dart-define=APP_BUILD=prod --export-options-plist=./ios/export.plist
  ```

### VS Code 配置

为了方便在IDE中调试，项目已配置了 `.vscode/launch.json`。你可以在 "Run and Debug" 视图的下拉菜单中选择不同的启动配置：

- `happy (dev)`: 以开发模式启动应用。
- `happy (prod)`: 以生产模式启动应用，用于模拟和调试最终发布状态。

---

## 持续集成 (CI/CD) with Jenkins

本项目可以方便地通过 Jenkins 进行自动化构建。以下是在 Jenkins 中配置构建任务的推荐方法。

### 1. Jenkins Job 参数化配置

在 Jenkins Job 的配置页面，勾选 **"This project is parameterized"**，并添加以下两个 **"Choice Parameter"**：

1.  **第一个参数 (构建类型)**:
    - **Name**: `APP_TYPE`
    - **Choices**:
      ```
      dev
      test
      release
      ```
    - **Description**: `构建类型: dev(开发包), test(测试包), 或 release(发布包)`

2.  **第二个参数 (环境类型)**:
    - **Name**: `ENV_TYPE`
    - **Choices**:
      ```
      dev
      prod
      ```
    - **Description**: `环境类型: dev(开发环境) 或 prod(生产环境)`

**构建类型说明:**
- **`dev`**: 开发包。包含所有调试UI（如环境切换），可以连接任意环境。
- **`test`**: 测试包。UI与发布包一致（隐藏调试功能），但API固定连接到 **dev环境**。
- **`release`**: 发布包。UI纯净，API固定连接到 **prod环境**。

### 2. Jenkins "Execute shell" 构建脚本

在 "Build" 或 "Build Steps" 部分，添加一个 **"Execute shell"** 步骤，并将以下脚本粘贴进去。

**脚本核心功能**:
- **版本号自动化**: 脚本会自动读取 `pubspec.yaml` 中的版本名，并使用 Jenkins 的构建号 (`BUILD_NUMBER`) 作为 App 的 build number，确保每个构建都有唯一的版本标识。
- **动态产物命名**: 构建出的 APK 会被重命名为包含构建类型、版本名和构建号的格式（例如 `happy_release_V1.0.0_123.apk`），清晰易懂。
- **产物归档**: 最终的 APK 文件会被统一移动到项目根目录下的 `artifacts/` 目录中，方便 Jenkins 归档。
- **Telegram 通知**: 在构建开始和结束时，会向指定的 Telegram 频道发送状态通知。

```bash
#!/bin/bash
# Jenkins 构建脚本
# 任何命令失败都会使脚本立即退出
set -e

CHAT_ID=-4936107763
CHAT_TOKEN=bot7531324184:AAG6Gm68wt2CgdpgyggeQEUKY6NReeooai8

curl -s -X POST https://api.telegram.org/$CHAT_TOKEN/sendMessage \
     -d chat_id=$CHAT_ID \
     -d text="""🚀 你好，Jenkins 开始打包 happy.apk for flutter！
     number: $BUILD_NUMBER"""

     
flutter clean
flutter pub get

echo "storePassword=$ANDROID_STORE_PWS" > android/key.properties
echo "keyPassword=$ANDROID_KEY_PWD" >> android/key.properties
echo "keyAlias=$ANDROID_KEY_PWD" >> android/key.properties
echo "storeFile=happyexchange.jks" >> android/key.properties

# 删除旧文件或修改权限
[ -f ./android/app/happyexchange.jks ] && chmod +w ./android/app/happyexchange.jks && rm -f ./android/app/happyexchange.jks
# 拷贝新文件
cp "$HAPPY_EXCHANGE_JKS" ./android/app/happyexchange.jks


echo "================================================="
echo "Build parameters:"
echo "APP_TYPE: ${APP_TYPE}"
echo "================================================="

# --- 使用 Jenkins 构建号作为 App 的 Build Number ---
echo "--> Setting build number from Jenkins..."
# 检查 Jenkins 的 BUILD_NUMBER 是否存在
if [ -z "$BUILD_NUMBER" ]; then
    echo "Error: JENKINS_BUILD_NUMBER is not set. Running outside of Jenkins?"
    # 在非Jenkins环境下，使用一个默认值或直接退出
    BUILD_NUMBER="1"
fi
echo "--> Using Jenkins Build Number: ${BUILD_NUMBER}"
# 从 pubspec.yaml 读取当前版本行
FULL_VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}')
# 只取版本名部分 (例如 '1.0.0')
VERSION_NAME=$(echo ${FULL_VERSION} | cut -d+ -f1)
# 将版本名和 Jenkins 构建号拼接成新的版本字符串
NEW_VERSION_STRING="${VERSION_NAME}+${BUILD_NUMBER}"
echo "--> New version string will be: ${NEW_VERSION_STRING}"
# 使用sed命令替换文件中的版本号，确保应用内部版本号与Jenkins任务号一致
sed -i '' "s/version: ${FULL_VERSION}/version: ${NEW_VERSION_STRING}/" pubspec.yaml
echo "--> pubspec.yaml updated successfully."

# 准备 Flutter 环境
echo "--> Cleaning project..."
flutter clean
echo "--> Getting dependencies..."
flutter pub get

echo "================================================="
echo "Build parameters:"
echo "APP_TYPE: ${APP_TYPE}"
echo "================================================="

# 动态组装构建命令
echo "--> Assembling build command..."

DART_DEFINE_FLAG="--dart-define=APP_BUILD=${APP_TYPE}"

flutter pub run icons_launcher:create 
flutter pub run flutter_native_splash:create

# 组装并执行最终命令
FINAL_COMMAND="flutter build apk --release ${DART_DEFINE_FLAG} --verbose"

echo "--> Executing: ${FINAL_COMMAND}"
eval ${FINAL_COMMAND}

echo "--> Build completed successfully!"

# --- 重命名并准备产物 ---
echo "--> Renaming and preparing artifact..."
echo "--> Jenkins Build Number: ${BUILD_NUMBER}"

# 根据构建类型确定原始APK文件名
SOURCE_APK_NAME="app-release.apk"

SOURCE_APK_PATH="build/app/outputs/flutter-apk/${SOURCE_APK_NAME}"

# 定义新的文件名和路径 (确保 artifacts 目录存在)
mkdir -p artifacts
# 将 Jenkins 构建号也加入文件名中
FINAL_APK_NAME="happy_${APP_TYPE}_V${VERSION_NAME}_${BUILD_NUMBER}.apk"
DESTINATION_APK_PATH="artifacts/${FINAL_APK_NAME}"

# 移动并重命名文件
echo "--> Moving ${SOURCE_APK_PATH} to ${DESTINATION_APK_PATH}"
mv "${SOURCE_APK_PATH}" "${DESTINATION_APK_PATH}"

echo "--> Artifact ready at: ${DESTINATION_APK_PATH}"

JENKINS_BASE_URL="http://192.168.0.199:8800"
BUILD_URL="$JENKINS_BASE_URL/job/$JOB_NAME/$BUILD_NUMBER"

APK_URL="$BUILD_URL/${DESTINATION_APK_PATH}"
echo "构建链接是：$APK_URL"  

curl -s -X POST https://api.telegram.org/$CHAT_TOKEN/sendMessage \
     -d chat_id=$CHAT_ID \
     -d text="""✅ 构建成功!!
     Job: $JOB_NAME #$BUILD_NUMBER
     apk: $FINAL_APK_NAME
     📦 任务链接: $BUILD_URL"""

```

### 3. 构建产物归档

在 Jenkins Job 配置的 "Post-build Actions"（构建后操作）部分，添加 **"Archive the artifacts"** 步骤。由于上面的脚本已将产物重命名并移动到了统一的 `artifacts` 目录下，这里的配置非常简单：

- **Files to archive**: `artifacts/**/*.apk`
- 勾选 **"Fingerprint all archived files"**