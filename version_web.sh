#!/bin/bash
# Flutter Web 加版本号（main.dart.js + flutter_bootstrap.js）

set -e

WEB_DIR="./build/web"

if [ ! -d "$WEB_DIR" ]; then
  echo "❌ 请先执行: flutter build web"
  exit 1
fi

VERSION=$(date +%Y%m%d%H%M%S)

# 重命名 main.dart.js
MAIN_OLD="$WEB_DIR/main.dart.js"
MAIN_NEW="$WEB_DIR/main.$VERSION.dart.js"

if [ ! -f "$MAIN_OLD" ]; then
  echo "❌ main.dart.js 不存在!"
  exit 1
fi

mv "$MAIN_OLD" "$MAIN_NEW"
echo "✅ main.dart.js -> $MAIN_NEW"

# 重命名 flutter_bootstrap.js
BOOTSTRAP_OLD="$WEB_DIR/flutter_bootstrap.js"
BOOTSTRAP_NEW="$WEB_DIR/flutter_bootstrap.$VERSION.js"

if [ ! -f "$BOOTSTRAP_OLD" ]; then
  echo "❌ flutter_bootstrap.js 不存在!"
  exit 1
fi

mv "$BOOTSTRAP_OLD" "$BOOTSTRAP_NEW"
echo "✅ flutter_bootstrap.js -> $BOOTSTRAP_NEW"

# 替换 bootstrap 内部对 main.dart.js 的引用
sed -i '' "s/main.dart.js/main.$VERSION.dart.js/g" "$BOOTSTRAP_NEW"

# 替换 index.html
INDEX_HTML="$WEB_DIR/index.html"
# 用版本化后的 bootstrap 名称替换
sed -i '' "s/flutter_bootstrap.js/flutter_bootstrap.$VERSION.js/g" "$INDEX_HTML"

echo "✅ index.html 中已替换 <script> 引用"

echo "🎉 所有文件版本号已处理: $VERSION"
