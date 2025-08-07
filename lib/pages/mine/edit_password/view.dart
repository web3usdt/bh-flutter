import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class EditPasswordPage extends GetView<EditPasswordController> {
  const EditPasswordPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 30.w),
      <Widget>[
        // 新密码
        <Widget>[
          TextWidget.body('新密码'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
          <Widget>[
            InputWidget(
              key: const ValueKey('edit_password_new'),
              placeholder: "请输入新密码".tr,
              controller: controller.newPasswordController,
              obscureText: true,
            ).expanded(),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingHorizontal(30.w)
              .height(90.w)
              .backgroundColor(AppTheme.blockTwoBgColor)
              .clipRRect(all: 10.w)
              .marginOnly(bottom: 30.w),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

        // 确认密码
        <Widget>[
          TextWidget.body('确认密码'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
          <Widget>[
            InputWidget(
              key: const ValueKey('edit_password_confirm'),
              placeholder: "请输入确认密码".tr,
              controller: controller.confirmPasswordController,
              obscureText: true,
            ).expanded(),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingHorizontal(30.w)
              .height(90.w)
              .backgroundColor(AppTheme.blockTwoBgColor)
              .clipRRect(all: 10.w),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

        // 邮箱验证码 显示 60s 倒计时
        <Widget>[
          TextWidget.body('邮箱验证码'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
          <Widget>[
            InputWidget(
              key: const ValueKey('edit_password_email_code'),
              placeholder: "请输入邮箱验证码".tr,
              controller: controller.emailCodeController,
            ).expanded(),
            ButtonWidget(
              text: controller.countDown > 0 ? '${controller.countDown}s后获取'.tr : '获取验证码'.tr,
              backgroundColor: AppTheme.color666,
              textColor: Colors.white,
              fontSize: 30.sp,
              borderRadius: 10.w,
              borderWidth: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              onTap: () {
                // 获取邮箱验证码
                controller.getEmailCode();
              },
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingHorizontal(30.w)
              .height(90.w)
              .backgroundColor(AppTheme.blockTwoBgColor)
              .clipRRect(all: 10.w),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingTop(30.w),

        if (controller.isGoogleAuthEnabled)
          <Widget>[
            TextWidget.body('谷歌验证码'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            <Widget>[
              InputWidget(
                key: const ValueKey('edit_password_google_code'),
                placeholder: "请输入谷歌验证码".tr,
                controller: controller.googleCodeController,
              ).expanded(),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                .paddingHorizontal(30.w)
                .height(90.w)
                .backgroundColor(AppTheme.blockTwoBgColor)
                .clipRRect(all: 10.w),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingTop(30.w),
      ].toColumn().paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w),

      SizedBox(height: 100.w),
      // 确认按钮
      ButtonWidget(
        text: '确认'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: () {
          if (controller.type == 'login') {
            controller.submit();
          } else {
            controller.submitTradePassword();
          }
        },
      ),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPasswordController>(
      init: EditPasswordController(),
      id: "edit_password",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: controller.type == 'login' ? '修改登录密码'.tr : '修改交易密码'.tr,
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
