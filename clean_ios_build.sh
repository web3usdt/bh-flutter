# 1. 清理 Flutter 缓存
flutter clean

# 2. 进入ios目录
cd ios

# 3.清理 CocoaPods 缓存
rm -rf Pods/
rm -rf Podfile.lock
rm -rf .symlinks/
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# 4. 重新获取依赖
flutter pub get

# 5. 进入ios目录
cd ios

# 6. 重新安装 CocoaPods 依赖
pod repo update
pod install --repo-update

# 7. 返回项目根目录
cd ..

# 8. 清理完成
flutter build ipa --release