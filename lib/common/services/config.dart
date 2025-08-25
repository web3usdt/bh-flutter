import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:BBIExchange/common/values/env.dart';

/// 编译模式
enum BuildMode {
  prod,
  dev,
  test,
}

/// 配置服务
class ConfigService extends GetxService {
  // 这是一个单例写法
  static ConfigService get to => Get.find();

  // 编译模式
  static final BuildMode buildMode = _getBuildMode();

  static BuildMode _getBuildMode() {
    const mode = String.fromEnvironment('APP_BUILD', defaultValue: 'prod');
    switch (mode) {
      case 'dev':
        return BuildMode.dev;
      case 'test':
        return BuildMode.test;
      case 'prod':
      default:
        return BuildMode.prod;
    }
  }

  // App 名称
  String get appName {
    switch (buildMode) {
      case BuildMode.dev:
        return 'BBICEX';
      case BuildMode.test:
        return 'BBICEX';
      case BuildMode.prod:
      default:
        return 'BBICEX';
    }
  }

  // 当前环境
  final Rx<Env> curEnv = Rx<Env>(EnvConfig.curEnv);

  // 主题变化通知
  final RxBool themeChanged = false.obs;

  // 是否首次打开app
  bool get isAlreadyOpen => Storage().getBool('already_open');
  // 标记已打开app
  void setAlreadyOpen() {
    Storage().setBool('already_open', true);
  }

  // 包信息
  PackageInfo? _platform;
  // 获取包信息
  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  // 版本号
  String get version => _platform?.version ?? '-';

  // 构建号
  String get buildNumber => _platform?.buildNumber ?? '-';

  // 多语言
  Locale locale = PlatformDispatcher.instance.locale;
  // 初始 语言
  void initLocale() {
    var langCode = Storage().getString(Constants.storageLanguageCode);
    if (langCode.isEmpty) {
      // 如果本地为空，设置个默认的语言
      setLanguage(const Locale('zh', 'CN'));
    }
    if (langCode.isEmpty) return;
    var index = Translation.supportedLocales.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = Translation.supportedLocales[index];
  }

  // 切换 语言
  void setLanguage(Locale value) {
    locale = value;
    Get.updateLocale(value);
    Storage().setString(Constants.storageLanguageCode, value.languageCode);
  }

  // 初始 环境
  void initEnv() {
    // 先读取本地缓存的环境
    var envTag = Storage().getString(Constants.storageEnv);
    // 如果本地缓存的环境不为空，则直接使用
    if (envTag.isNotEmpty) {
      curEnv.value = EnvConfig.getEnvByTag(envTag);
      return;
    }

    // 如果本地缓存的环境为空，则根据编译模式决定环境
    switch (buildMode) {
      case BuildMode.prod: // 生产构建，强制使用生产环境
        curEnv.value = EnvConfig.getEnvByTag('prod');
        break;
      case BuildMode.test: // 测试构建，强制使用测试环境
        curEnv.value = EnvConfig.getEnvByTag('test');
        break;
      case BuildMode.dev:
      default:
        curEnv.value = EnvConfig.getEnvByTag('test1');
        break;
    }

    // 使用测试节点
    // curEnv.value = EnvConfig.getEnvByTagTest('ceshi');
  }

  // 切换 环境
  Future<void> setEnv(String envName) async {
    curEnv.value = EnvConfig.getEnvByTag(envName);
    await Storage().setString(Constants.storageEnv, envName);

    // 更新网络请求服务的 baseUrl
    WPHttpService.to.updateBaseUrl(curEnv.value.apiBaseUrl);

    // 重新连接 WebSocket，但前提是用户已登录
    if (Storage().getString('token').isNotEmpty) {
      SocketService().reconnect();
      SocketService2().reconnect();
      SocketService3().reconnect();
    }
  }

  // 切换 测试环境
  Future<void> setTestEnv(String envName) async {
    curEnv.value = EnvConfig.getEnvByTagTest(envName);
    await Storage().setString(Constants.storageEnv, envName);

    // 更新网络请求服务的 baseUrl
    WPHttpService.to.updateBaseUrl(curEnv.value.apiBaseUrl);

    // 重新连接 WebSocket，但前提是用户已登录
    if (Storage().getString('token').isNotEmpty) {
      SocketService().reconnect();
      SocketService2().reconnect();
      SocketService3().reconnect();
    }
  }

  // 主题
  AdaptiveThemeMode themeMode = AdaptiveThemeMode.light;
  // 初始 主题
  Future<void> initTheme() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    themeMode = savedThemeMode ?? AdaptiveThemeMode.light;
  }

  // 切换 主题
  Future<void> setThemeMode(String themeKey) async {
    // 保存之前，先更新本地变量
    switch (themeKey) {
      case "light":
        themeMode = AdaptiveThemeMode.light;
        AdaptiveTheme.of(Get.context!).setLight();
        break;
      case "dark":
        themeMode = AdaptiveThemeMode.dark;
        AdaptiveTheme.of(Get.context!).setDark();
        break;
      case "system":
        themeMode = AdaptiveThemeMode.system;
        AdaptiveTheme.of(Get.context!).setSystem();
        break;
    }

    // 设置系统样式
    AppTheme.setSystemStyle();

    // 添加一个主题变化通知
    themeChanged.toggle();

    // 强制刷新整个应用
    Get.forceAppUpdate();
  }

  // 集中初始化
  Future<ConfigService> init() async {
    await getPlatform();
    initEnv(); // 初始化环境配置
    await initTheme();
    initLocale();
    return this;
  }
}
