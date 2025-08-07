#!/bin/bash
set -euo pipefail

# 参数列表（按顺序传入）
APP_TYPE=$1
H_PLATFORM=$2
ANDROID_STORE_PWS=$3
ANDROID_KEY_PWD=$4
ANDROID_KEY_ALIAS=$5
HAPPY_EXCHANGE_JKS=$6
IOS_P12_PATH=$7
IOS_P12_PWD=$8
BUILD_NUMBER=$9
JOB_NAME=${10}
WORKSPACE=${11}
CHAT_ID=${12}
CHAT_TOKEN=${13}
KEYCHAIN_PASSWORD=${14}

JENKINS_BASE_URL="http://192.168.0.199:8800"
BUILD_URL="$JENKINS_BASE_URL/job/$JOB_NAME/$BUILD_NUMBER"

function send_telegram() {
  local message="$1"
  if [[ -z "$CHAT_ID" || -z "$CHAT_TOKEN" ]]; then
    echo "⚠️ Telegram 配置缺失，无法发送通知"
    return
  fi
  curl -s -X POST "https://api.telegram.org/$CHAT_TOKEN/sendMessage" \
       -d chat_id="$CHAT_ID" \
       -d text="$message" > /dev/null
}

function on_error() {
  local lineno=$1
  local cmd=$2
  echo "❌ 构建失败，错误在第 $lineno 行: $cmd"
  send_telegram "❌ 构建失败‼️

Job: $JOB_NAME #$BUILD_NUMBER
命令行第 $lineno 行失败：
$cmd

任务链接: $BUILD_URL"
  exit 1
}

trap 'on_error $LINENO "$BASH_COMMAND"' ERR

# 构建开始通知
send_telegram "🚀 Jenkins 开始打包

Job: $JOB_NAME #$BUILD_NUMBER
平台: $H_PLATFORM
应用类型: $APP_TYPE
任务链接: $BUILD_URL"

echo "========================================="
echo "Start Flutter Build"
echo "APP_TYPE: $APP_TYPE"
echo "PLATFORM: $H_PLATFORM"
echo "BUILD_NUMBER: $BUILD_NUMBER"
echo "JOB_NAME: $JOB_NAME"
echo "WORKSPACE: $WORKSPACE"
echo "========================================="

cd "$WORKSPACE" || { echo "Error: WORKSPACE目录不存在"; exit 1; }

flutter clean
flutter pub get

cat > android/key.properties <<EOF
storePassword=$ANDROID_STORE_PWS
keyPassword=$ANDROID_KEY_PWD
keyAlias=$ANDROID_KEY_ALIAS
storeFile=happyexchange.jks
EOF

if [ -f ./android/app/happyexchange.jks ]; then
  chmod +w ./android/app/happyexchange.jks
  rm -f ./android/app/happyexchange.jks
fi
cp "$HAPPY_EXCHANGE_JKS" ./android/app/happyexchange.jks

FULL_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
VERSION_NAME=$(echo "$FULL_VERSION" | cut -d+ -f1)
NEW_VERSION="${VERSION_NAME}+${BUILD_NUMBER}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/version: ${FULL_VERSION}/version: ${NEW_VERSION}/" pubspec.yaml
else
  sed -i "s/version: ${FULL_VERSION}/version: ${NEW_VERSION}/" pubspec.yaml
fi

flutter pub run icons_launcher:create
flutter pub run flutter_native_splash:create

DART_DEFINE_FLAG="--dart-define=APP_BUILD=${APP_TYPE}"

if [ "$H_PLATFORM" == "ios" ]; then
  echo "--> 解锁登录 Keychain"
  security unlock-keychain -p "$KEYCHAIN_PASSWORD" ~/Library/Keychains/login.keychain-db

  echo "--> 导入 iOS p12 证书"
  security import "$IOS_P12_PATH" -k ~/Library/Keychains/login.keychain-db -P "$IOS_P12_PWD" -T /usr/bin/codesign

  echo "--> 执行 Flutter iOS 构建"
  flutter build ios --release $DART_DEFINE_FLAG --verbose
else
  echo "--> 执行 Flutter $H_PLATFORM 构建"
  flutter build "$H_PLATFORM" --release $DART_DEFINE_FLAG --verbose
fi

mkdir -p artifacts

if [ "$H_PLATFORM" == "apk" ]; then
  SOURCE_PATH="build/app/outputs/flutter-apk/app-release.apk"
  FINAL_NAME="happy_${APP_TYPE}_V${VERSION_NAME}_${BUILD_NUMBER}.apk"
elif [ "$H_PLATFORM" == "ios" ]; then
  SOURCE_PATH="build/ios/ipa/Runner.ipa"
  FINAL_NAME="happy_${APP_TYPE}_V${VERSION_NAME}_${BUILD_NUMBER}.ipa"
else
  echo "Unsupported platform: $H_PLATFORM"
  exit 1
fi

DEST_PATH="./artifacts/$FINAL_NAME"

if [ ! -f "$SOURCE_PATH" ]; then
  echo "Error: 构建产物未找到: $SOURCE_PATH"
  exit 1
fi

mv "$SOURCE_PATH" "$DEST_PATH"

echo "Build artifact ready: $DEST_PATH"

send_telegram "✅ 构建成功！

Job: $JOB_NAME #$BUILD_NUMBER
平台: $H_PLATFORM
应用类型: $APP_TYPE
版本: $NEW_VERSION
产物文件: $FINAL_NAME
任务链接: $BUILD_URL"

echo "========================================="
echo "Flutter Build Script Finished Successfully!"
echo "========================================="
