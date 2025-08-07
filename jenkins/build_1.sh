CHAT_ID=-4936107763
CHAT_TOKEN=bot7531324184:AAG6Gm68wt2CgdpgyggeQEUKY6NReeooai8

#!/bin/bash
# Jenkins 构建脚本
# 任何命令失败都会使脚本立即退出
set -Eeuo pipefail
trap 'on_error $LINENO "$BASH_COMMAND"' ERR

on_error() {
  local lineno=$1
  local cmd=$2
  JENKINS_BASE_URL="http://192.168.0.199:8800"
  BUILD_URL="$JENKINS_BASE_URL/job/$JOB_NAME/$BUILD_NUMBER"

  echo "--> build failed: https://api.telegram.org/bot$CHAT_TOKEN/sendMessage"

  curl -s -X POST https://api.telegram.org/$CHAT_TOKEN/sendMessage \
     -d chat_id=$CHAT_ID \
     -d text="""❌ 构建失败!!
     
     Job: $JOB_NAME #$BUILD_NUMBER
     📦 任务链接: $BUILD_URL"""

  exit 1
}


curl -s -X POST https://api.telegram.org/$CHAT_TOKEN/sendMessage \
     -d chat_id=$CHAT_ID \
     -d text="""
     🚀 你好，Jenkins 开始打包 happy.apk for flutter！
     
     appType: $APP_TYPE
     jobNumber: $BUILD_NUMBER
             """

     
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
FINAL_COMMAND="flutter build ${H_PLATFORM} --release ${DART_DEFINE_FLAG} --verbose"

echo "--> Executing: ${FINAL_COMMAND}"
eval ${FINAL_COMMAND}

echo "--> FLUTTER Build completed successfully!"

# iOS 签名
if [ ${H_PLATFORM} == 'ios' ]
# 环境变量 ios_happy_p12  ios_happy_p12_pwd  ios_happy_profile
# 导入p12  
security import "$ios_happy_p12" -k ~/Library/Keychains/login.keychain -P "$ios_happy_p12_pwd" -T /usr/bin/codesign
# 组装命令


fi

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
DESTINATION_APK_PATH="./artifacts/${FINAL_APK_NAME}"

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
     -d text="""
     ✅ 构建成功!!
     
     Job: $JOB_NAME #$BUILD_NUMBER
     appType: $APP_TYPE
     apk: $FINAL_APK_NAME
     📦 任务链接: $BUILD_URL
     """


