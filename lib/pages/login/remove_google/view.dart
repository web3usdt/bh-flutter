import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'index.dart';

class RemoveGooglePage extends GetView<RemoveGoogleController> {
  const RemoveGooglePage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 40.w),
      TextWidget.body(
        '解绑谷歌验证'.tr,
        size: 44.sp,
        color: AppTheme.color000,
        weight: FontWeight.w600,
      ),
      SizedBox(height: 20.w),
      TextWidget.body(
        '验证邮箱'.tr,
        size: 28.sp,
        color: AppTheme.color000,
      ),
      SizedBox(height: 80.w),
      <Widget>[
        // TextWidget.body(
        //   '邮箱号'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 15.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入邮箱号".tr,
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
            type: 'remove',
            onRequestCode: (mobile, type) async {
              return await controller.sendPhoneCode();
            },
          )
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 100.w),

      ButtonWidget(
        text: '确认'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        margin: const EdgeInsets.all(0),
        onTap: controller.unbindGoogle,
      ).marginOnly(bottom: 30.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RemoveGoogleController>(
      init: RemoveGoogleController(),
      id: "remove_google",
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
          ),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
