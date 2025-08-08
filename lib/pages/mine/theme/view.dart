import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class ThemePage extends GetView<ThemeController> {
  const ThemePage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 30.w),
      <Widget>[
        TextWidget.body('暗色', size: 28.sp, color: AppTheme.colorfff),
        Icon(Icons.check_circle, size: 24, color: controller.currentTheme == 'dark' ? AppTheme.primary : AppTheme.color999),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .height(100.w)
          .paddingHorizontal(30.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 30.w)
          .padding(bottom: 20.w)
          .onTap(() {
        controller.onThemeSelected('dark');
      }),
      <Widget>[
        TextWidget.body('亮色', size: 28.sp, color: AppTheme.colorfff),
        Icon(Icons.check_circle, size: 24, color: controller.currentTheme == 'light' ? AppTheme.primary : AppTheme.color999),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .height(100.w)
          .paddingHorizontal(30.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 30.w)
          .padding(bottom: 20.w)
          .onTap(() {
        controller.onThemeSelected('light');
      }),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      id: "theme",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '主题',
            titleColor: AppTheme.colorfff,
            titleFontWeight: FontWeight.w600,
            backgroundColor: AppTheme.navBgColor,
            screenAdaptation: true,
            useDefaultBack: false,
            leftBarItems: [
              TDNavBarItem(
                  icon: TDIcons.chevron_left,
                  iconSize: 24,
                  iconColor: AppTheme.colorfff,
                  action: () {
                    Get.back();
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
