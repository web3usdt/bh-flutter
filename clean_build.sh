#!/bin/bash

echo "🧹 开始清理 Flutter iOS 构建缓存..."

# 清理 Flutter 缓存
echo "清理 Flutter 缓存..."
flutter clean
flutter pub cache clean

# 清理 iOS 缓存
echo "清理 iOS 缓存..."
rm -rf ios/build/
rm -rf ios/Pods/
rm -f ios/Podfile.lock

# 清理系统缓存
echo "清理系统缓存..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 重新获取依赖
echo "重新获取依赖..."
flutter pub get

# 重新安装 Pods
echo "重新安装 CocoaPods..."
cd ios
pod install --repo-update
cd ..

echo "✅ 清理完成！现在可以重新构建项目"
echo "运行: flutter build ios --release" 