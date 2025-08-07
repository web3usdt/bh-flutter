import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'index.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  // 主视图
  Widget _buildView(ForgotPasswordController controller) {
    return <Widget>[
      SizedBox(height: 20.w),

      // // 注册类型
      // <Widget>[
      //   TextWidget.body('手机验证',size: 28.sp,color: controller.registerType == 'phone' ? AppTheme.color000 : AppTheme.color999,).onTap(()=>controller.switchRegisterType()),
      //   SizedBox(width: 50.w),
      //   TextWidget.body('邮箱验证',size: 28.sp,color: controller.registerType == 'email' ? AppTheme.color000 : AppTheme.color999,).onTap(()=>controller.switchRegisterType()),
      // ].toRow(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 50.w),

      <Widget>[
        // if (controller.registerType == 'phone')
        //   TextWidget.body(
        //     '手机号'.tr,
        //     size: 28.sp,
        //     color: AppTheme.color000,
        //   ).marginOnly(bottom: 15.w)
        // else
        //   TextWidget.body(
        //     '邮箱号'.tr,
        //     size: 28.sp,
        //     color: AppTheme.color000,
        //   ).marginOnly(bottom: 15.w),
        <Widget>[
          if (controller.registerType == 'phone')
            TextWidget.body(
              controller.phoneArea,
              size: 28.sp,
              color: AppTheme.color000,
            ).marginOnly(right: 20.w).onTap(() => controller.switchPhoneArea()),
          InputWidget(
            key: const ValueKey('forgot_password_account'),
            placeholder: controller.registerType == 'phone' ? "请输入手机号".tr : "请输入邮箱号".tr,
            controller: controller.phoneController,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 验证码
      <Widget>[
        // TextWidget.body(
        //   '邮箱验证码'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            key: const ValueKey('forgot_password_email_code'),
            placeholder: "请输入邮箱验证码".tr,
            controller: controller.codeController,
          ).expanded(),
          VerificationCodeWidget(
            mobile: controller.phoneController.text,
            type: 'forgot',
            onRequestCode: (mobile, type) async {
              return await controller.sendPhoneCode();
            },
          )
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      if (controller.showGoogleAuth)
        <Widget>[
          // TextWidget.body(
          //   '谷歌验证码'.tr,
          //   size: 28.sp,
          //   color: AppTheme.color000,
          // ).marginOnly(bottom: 15.w),
          <Widget>[
            InputWidget(
              key: const ValueKey('forgot_password_google_code'),
              placeholder: "请输入谷歌验证码".tr,
              controller: controller.googleCodeController,
            ).expanded(),
          ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(color: AppTheme.borderLine, width: 1),
                color: AppTheme.blockBgColor
              ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 登陆密码
      <Widget>[
        // TextWidget.body(
        //   '新密码'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            key: const ValueKey('forgot_password_password'),
            placeholder: "请输入新的登录密码".tr,
            controller: controller.passwordController,
            obscureText: true,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 确认密码
      <Widget>[
        // TextWidget.body(
        //   '确认密码'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            key: const ValueKey('forgot_password_confirm_password'),
            placeholder: "请输入确认密码".tr,
            controller: controller.confirmPasswordController,
            obscureText: true,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 80.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      id: "forgot_password",
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            title: '找回密码'.tr,
            titleFontWeight: FontWeight.w600,
            padding: EdgeInsets.only(left: 30.w, right: 30.w), // 重写左右内边距
            height: 44, // 高度
            backgroundColor: AppTheme.navBgColor,
            screenAdaptation: true,
            useDefaultBack: true,
          ),
          body: Stack(
            children: <Widget>[
              // 可滚动的内容区域
              SingleChildScrollView(
                child: _buildView(controller).paddingOnly(bottom: 120.w), // 增加底部padding为按钮留出空间
              ),

              // 定位到底部的按钮
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: ButtonWidget(
                    text: '确认修改'.tr,
                    height: 74,
                    borderRadius: 37,
                    backgroundColor: AppTheme.color000,
                    onTap: controller.onConfirm,
                  ).paddingHorizontal(30.w).paddingOnly(bottom: 20.w),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
