import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class SetupPage extends GetView<SetupController> {
  const SetupPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(
        height: 60.w,
      ),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/home1.png',
            width: 180.w,
            height: 180.w,
            radius: 90.w,
          ),
          // ImgWidget(path: 'assets/images/mine12.png',width: 70.w,height: 70.w,).positioned(right: 0,bottom: 0),
        ].toStack().tight(width: 180.w, height: 180.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).onTap(() {
        controller.changeAvatar();
      }),
      SizedBox(
        height: 60.w,
      ),
      <Widget>[
        TextWidget.body('昵称'.tr, size: 30.sp, color: AppTheme.color000),
        <Widget>[
          TextWidget.body(controller.userInfo.username ?? '', size: 30.sp, color: AppTheme.color000),
        ].toRow(),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(90.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 10.w)
          .marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body('主账号'.tr, size: 30.sp, color: AppTheme.color000),
        <Widget>[
          TextWidget.body(controller.userInfo.account ?? '', size: 30.sp, color: AppTheme.color000),
        ].toRow(),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(90.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 10.w)
          .marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body('语言'.tr, size: 30.sp, color: AppTheme.color000),
        <Widget>[
          TextWidget.body(
            ConfigService.to.locale.toLanguageTag() == 'zh-CN'
                ? '简体中文'
                : ConfigService.to.locale.toLanguageTag() == 'zh-TW'
                    ? '繁体中文'
                    : ConfigService.to.locale.toLanguageTag() == 'en-US'
                        ? 'English'
                        : '',
            size: 24.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 10.w,
          ),
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
        controller.setLanguageSetting();
      }),
      <Widget>[
        TextWidget.body('切换账号'.tr, size: 30.sp, color: AppTheme.color000),
        <Widget>[
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
        Get.toNamed(AppRoutes.switchAccount);
      }),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      init: SetupController(),
      id: "setup",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '设置'.tr,
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
          body: Stack(
            children: [
              SingleChildScrollView(
                child: _buildView(),
              ),

              // 版本号信息
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextWidget.body(
                    '${ConfigService.to.appName} V${ConfigService.to.version}(${ConfigService.to.buildNumber})',
                    size: 24.sp,
                    color: AppTheme.color999,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
