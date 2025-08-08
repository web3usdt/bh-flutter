import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class DevelopModePage extends GetView<DevelopModeController> {
  const DevelopModePage({super.key});

  Widget _buildEnvSwitcher() {
    return <Widget>[
      TextWidget.body('切换环境'.tr, size: 30.sp, color: AppTheme.color000),
      <Widget>[
        TextWidget.body(
          ConfigService.to.curEnv.value.name,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        SizedBox(width: 10.w),
        Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color999),
      ].toRow(),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingHorizontal(30.w)
        .height(90.w)
        .backgroundColor(AppTheme.blockBgColor)
        .clipRRect(all: 10.w)
        .marginOnly(bottom: 20.w)
        .onTap(() {
      controller.switchEnv();
    });
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 20.w),
      _buildEnvSwitcher(),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DevelopModeController>(
      init: DevelopModeController(),
      id: "develop_mode",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '开发者模式'.tr,
            titleColor: AppTheme.color000,
            titleFontWeight: FontWeight.w600,
            backgroundColor: AppTheme.pageBgColor,
            screenAdaptation: true,
            useDefaultBack: false,
            leftBarItems: [
              TDNavBarItem(
                  icon: TDIcons.chevron_left,
                  iconSize: 24,
                  iconColor: AppTheme.color000,
                  action: () {
                    Get.back();
                  }),
            ],
          ),
          body: switch (ConfigService.buildMode) {
            BuildMode.dev => SingleChildScrollView(
                child: _buildView(),
              ),
            BuildMode.prod || BuildMode.test => Center(
                child: TextWidget.body(
                  '功能未开放'.tr,
                  size: 28.sp,
                  color: AppTheme.color999,
                ),
              ),
          },
        );
      },
    );
  }
}
