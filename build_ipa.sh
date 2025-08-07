#!/bin/bash

echo "🚀 开始构建 iOS IPA 包..."

# 检查是否在 Flutter 项目根目录
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 错误：请在 Flutter 项目根目录运行此脚本"
    exit 1
fi

# 1. 清理缓存（可选，根据需要启用）
read -p "是否清理缓存？(y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 清理缓存中..."
    ./clean_ios_build.sh
fi

# 2. 检查 Flutter 版本
echo "📱 检查 Flutter 版本..."
flutter --version

# 3. 检查 iOS 开发环境
echo "🍎 检查 iOS 开发环境..."
flutter doctor --verbose

# 4. 获取最新依赖
echo "⬇️ 获取最新依赖..."
flutter pub get

# 5. 构建 iOS Release 版本
echo "🔨 构建 iOS Release 版本..."
flutter build ios --release --no-codesign

# 6. 构建 IPA
echo "📦 构建 IPA 包..."
flutter build ipa --release

# 7. 显示构建结果
if [ $? -eq 0 ]; then
    echo "✅ IPA 构建成功！"
    echo "📁 IPA 文件位置："
    echo "   build/ios/ipa/*.ipa"
    
    # 显示 IPA 文件详细信息
    IPA_PATH=$(find build/ios/ipa -name "*.ipa" | head -1)
    if [ -f "$IPA_PATH" ]; then
        echo "📋 IPA 文件信息："
        echo "   文件名: $(basename "$IPA_PATH")"
        echo "   大小: $(du -h "$IPA_PATH" | cut -f1)"
        echo "   完整路径: $(realpath "$IPA_PATH")"
        
        # 可选：打开 IPA 文件所在目录
        read -p "是否打开 IPA 文件所在目录？(y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open "$(dirname "$IPA_PATH")"
        fi
    fi
else
    echo "❌ IPA 构建失败！"
    echo "请检查上面的错误信息并解决后重试。"
    exit 1
fi

echo "🎉 构建流程完成！" 