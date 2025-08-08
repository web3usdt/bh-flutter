import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'index.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 40.w),
      TextWidget.body(
        '注册'.tr,
        size: 44.sp,
        color: AppTheme.color000,
        weight: FontWeight.w600,
      ),
      SizedBox(height: 20.w),
      TextWidget.body(
        'Hello!欢迎来到BBI Exchange'.tr,
        size: 28.sp,
        color: AppTheme.color000,
      ),
      SizedBox(height: 80.w),

      // 注册类型
      // <Widget>[
      // TextWidget.body('手机注册',size: 28.sp,color: controller.registerType == 'phone' ? AppTheme.color000 : AppTheme.color999,).onTap(()=>controller.switchRegisterType()),
      // SizedBox(width: 50.w),
      // TextWidget.body('邮箱注册',size: 28.sp,color: controller.registerType == 'email' ? AppTheme.color000 : AppTheme.color999,).onTap(()=>controller.switchRegisterType()),
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
            placeholder: controller.registerType == 'phone' ? "请输入手机号".tr : "请输入邮箱号".tr,
            controller: controller.phoneController,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 验证码
      <Widget>[
        // TextWidget.body(
        //   '验证码'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入验证码".tr,
            controller: controller.codeController,
          ).expanded(),
          VerificationCodeWidget(
            mobile: controller.phoneController.text,
            type: 'register',
            onRequestCode: (mobile, type) async {
              return await controller.sendPhoneCode();
            },
          )
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 登陆密码
      <Widget>[
        // TextWidget.body(
        //   '登陆密码'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入登陆密码".tr,
            controller: controller.passwordController,
            obscureText: true,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
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
            placeholder: "请输入确认密码".tr,
            controller: controller.confirmPasswordController,
            obscureText: true,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 推荐人
      <Widget>[
        // TextWidget.body(
        //   '推荐人'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入推荐人".tr,
            controller: controller.recommendController,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      <Widget>[
        <Widget>[
          Icon(
            Icons.check_circle,
            size: 32.sp,
            color: controller.isAgree ? AppTheme.primary : AppTheme.color999,
          ),
          SizedBox(width: 10.w),
          TextWidget.body(
            '您已同意'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
        ].toRow().onTap(() => controller.agreeUserProtocol()),
        TextWidget.body(
          '《用户协议》'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '并了解我们的'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '《隐私协议》'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).marginOnly(bottom: 20.w, top: 80.w),
      ButtonWidget(
        text: '立即注册'.tr,
        height: 74,
        borderRadius: 37,
        margin: const EdgeInsets.all(0),
        backgroundColor: AppTheme.color000,
        onTap: controller.register,
      ).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '已有帐号？'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '立即登录'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).onTap(() => Get.back()),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      id: "register",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
              padding: EdgeInsets.only(left: 30.w, right: 30.w), // 重写左右内边距
              centerTitle: false, // 不显示标题
              height: 44, // 高度
              backgroundColor: AppTheme.navBgColor,
              screenAdaptation: true,
              useDefaultBack: true,
              rightBarItems: [
                // TDNavBarItem(
                //   padding: EdgeInsets.only(right: 20.w),
                //   iconWidget: <Widget>[
                //     TextWidget.body(
                //       ConfigService.to.locale.toLanguageTag() == 'zh-CN' ? '简体中文'
                //       : ConfigService.to.locale.toLanguageTag() == 'zh-TW' ? '繁体中文'
                //       : ConfigService.to.locale.toLanguageTag() == 'en-US' ? 'English' : '',
                //       size: 24.sp,color: AppTheme.color000,
                //     ),
                //     Icon(Icons.arrow_drop_down,size: 32.sp,color: AppTheme.color8B8B8B,),
                //   ].toRow()
                //   .height(60.w)
                //   .padding(left:  30.w,right: 20.w)
                //   .decorated(
                //     border: Border.all(width: 1,color: AppTheme.borderLine),
                //     borderRadius: BorderRadius.circular(80.w)
                //   ),
                //   action: (){
                //     controller.setLanguageSetting();
                //   },
                // ),
              ]),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
