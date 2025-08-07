import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class GoogleBindPage extends GetView<GoogleBindController> {
  const GoogleBindPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 100.w),
      TextWidget.body(
        '谷歌验证器'.tr,
        size: 36.sp,
        color: AppTheme.color000,
      ),
      SizedBox(height: 40.w),
      <Widget>[
        InputWidget(
          placeholder: "请输入谷歌验证码".tr,
          controller: controller.codeController,
          obscureText: false,
          style: TextStyle(color: Colors.black, fontSize: 28.sp),
        ).expanded(),
      ].toRow().paddingHorizontal(30.w).tight(width: 690.w, height: 100.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 50.w),

      SizedBox(height: 30.w),
      TextWidget.body(
        '邮箱验证码'.tr,
        size: 36.sp,
        color: AppTheme.color000,
      ),
      SizedBox(height: 10.w),
      TextWidget.body(
        '为了您的资产安全，请输入邮箱验证码'.tr,
        size: 24.sp,
        color: AppTheme.color999,
      ),
      SizedBox(height: 40.w),
      <Widget>[
        InputWidget(
          placeholder: "请输入邮箱验证码".tr,
          controller: controller.emailCodeController,
          obscureText: false,
          style: TextStyle(color: Colors.black, fontSize: 28.sp),
        ).expanded(),
        ButtonWidget(
          text: controller.countDown > 0 ? '${controller.countDown}s' : '发送'.tr,
          onTap: () {
            controller.getEmailCode();
          },
          width: 150.w,
          height: 70.w,
          backgroundColor: AppTheme.colorYellow,
          textColor: AppTheme.color000,
          fontSize: 28.sp,
          borderRadius: 50.w,
        ).marginOnly(right: 15.w)
      ].toRow().paddingHorizontal(30.w).tight(width: 690.w, height: 100.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 50.w),

      SizedBox(height: 70.w),
      // 确认按钮
      ImgWidget(
        path: 'assets/images/mine17.png',
        width: 144.w,
        height: 144.w,
      ).onTap(() {
        controller.bindGoogle();
      }),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoogleBindController>(
      init: GoogleBindController(),
      id: "google_bind",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '绑定谷歌验证器'.tr,
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
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
