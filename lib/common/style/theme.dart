import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'colors.dart';

/// 主题
class AppTheme {
  /////////////////////////////////////////////////
  /// 共享颜色（亮暗主题相同）
  static const primary = Color(0xff0067FF); // 主题色
  static const color999 = Color(0xFF999999); // 灰色
  static const color666 = Color(0xFF666666); // 灰色
  static const color989898 = Color(0xff989898); // 灰色
  static const color8B8B8B = Color(0xff8B8B8B); // 灰色
  static const colorGreen = Color(0xff32BE67); // 绿色
  static const colorRed = Color(0xffED3C3E); // 红色
  static const colorYellow = Color(0xffFF9900); // 黄色
  static const color8D9094 = Color(0xff8D9094); // 灰色

  // 动态颜色
  static Color get pageBgColor => Get.isDarkMode ? const Color(0xff231816) : const Color(0xffffffff); // 页面背景
  static Color get navBgColor => Get.isDarkMode ? const Color(0xff231816) : const Color(0xffffffff); // 导航背景
  static Color get blockBgColor => Get.isDarkMode ? const Color(0xff342421) : const Color(0xffF2F3F8); // 块背景1
  static Color get blockTwoBgColor => Get.isDarkMode ? const Color(0xff191110) : const Color(0xffFAFAFA); // 块背景2
  static Color get colorfff => Get.isDarkMode ? const Color(0xff000000) : const Color(0xFFFFFFFF); // 白色
  static Color get color000 => Get.isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xff000000); // 白色
  static Color get dividerColor => Get.isDarkMode ? const Color(0xff231816) : const Color(0xffEDEDED); // 分割线1
  static Color get borderLine => Get.isDarkMode ? const Color(0xff231816) : const Color(0xffEDEDED); // 分割线2

  /// 主题
  /////////////////////////////////////////////////

  /// 亮色主题
  static ThemeData get light {
    ColorScheme scheme = MaterialTheme.lightScheme().copyWith(
      primary: primary, // 主色调
    );
    return _getTheme(scheme, isLightMode: true);
  }

  /// 暗色主题
  static ThemeData get dark {
    ColorScheme scheme = MaterialTheme.darkScheme().copyWith(
      primary: primary, // 主色调保持一致
    );
    return _getTheme(scheme, isLightMode: false);
  }

  /// 获取主题
  static ThemeData _getTheme(ColorScheme scheme, {required bool isLightMode}) {
    return ThemeData(
      // fontFamily: 'Montserrat',
      useMaterial3: false,
      colorScheme: scheme,

      // 卡片样式
      cardTheme: CardTheme(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: isLightMode ? Colors.white : blockBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.w))),

      // 导航栏
      appBarTheme: AppBarTheme(
        backgroundColor: isLightMode ? navBgColor : navBgColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 56.w,
        iconTheme: IconThemeData(
          color: isLightMode ? colorfff : colorfff,
          size: 22.w,
        ),
        titleTextStyle: TextStyle(
          color: isLightMode ? colorfff : colorfff,
          fontSize: 24.w,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }

  /////////////////////////////////////////////////
  /// 系统样式
  /////////////////////////////////////////////////

  /// 系统样式
  static SystemUiOverlayStyle get systemStyle => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 状态栏颜色
        statusBarBrightness: Brightness.light, // 状态栏亮度
        statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
        systemNavigationBarDividerColor: Colors.transparent, // 系统导航栏分隔线颜色
        systemNavigationBarColor: Colors.white, // 系统导航栏颜色
        systemNavigationBarIconBrightness: Brightness.dark, // 系统导航栏图标亮度
      );

  /// 亮色系统样式
  static SystemUiOverlayStyle get systemStyleLight => systemStyle.copyWith(
        statusBarBrightness: Brightness.light, // 状态栏亮度
        statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
        systemNavigationBarIconBrightness: Brightness.dark, // 系统导航栏图标亮度
      );

  /// 暗色系统样式
  static SystemUiOverlayStyle get systemStyleDark => systemStyle.copyWith(
        statusBarBrightness: Brightness.dark, // 状态栏亮度
        statusBarIconBrightness: Brightness.light, // 状态栏图标亮度
        systemNavigationBarColor: const Color(0xFF0D0D0D), // 系统导航栏颜色
        systemNavigationBarIconBrightness: Brightness.light, // 系统导航栏图标亮度
      );
  static void setSystemStyle() {
    // 获取系统亮度
    Brightness platformBrightness = Get.context?.theme.brightness ?? Brightness.light;

    // 获取当前模式
    ThemeMode mode = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    print('获取当前模式$mode');
    switch (mode) {
      case ThemeMode.system:
        if (platformBrightness == Brightness.dark) {
          // 暗色模式
          SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
        } else {
          // 亮色模式
          SystemChrome.setSystemUIOverlayStyle(systemStyleLight);
        }
        break;
      case ThemeMode.dark:
        // 暗色模式
        SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
        break;
      case ThemeMode.light:
        // 亮色模式
        SystemChrome.setSystemUIOverlayStyle(systemStyleLight);
        break;
    }
  }
}
