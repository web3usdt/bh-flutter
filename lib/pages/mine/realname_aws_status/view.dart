import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class RealnameAwsStatusPage extends GetView<RealnameAwsStatusController> {
  const RealnameAwsStatusPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 100.w),
      if (controller.status == '2')
        <Widget>[
          ImgWidget(path: 'assets/images/home16.png', width: 200.w, height: 200.w),
          SizedBox(height: 60.w),
          TextWidget.body('审核成功'.tr, size: 32.sp, color: AppTheme.colorGreen, weight: FontWeight.w600),
        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      if (controller.status == '3')
        <Widget>[
          ImgWidget(path: 'assets/images/home17.png', width: 200.w, height: 200.w),
          SizedBox(height: 60.w),
          TextWidget.body('审核失败'.tr, size: 32.sp, color: AppTheme.colorRed, weight: FontWeight.w600),
          SizedBox(height: 20.w),
          TextWidget.body(
            '${'失败原因'.tr}：${controller.cause}',
            size: 24.sp,
            color: AppTheme.colorRed,
          ),
        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      SizedBox(height: 250.w),
      if (controller.status == '3')
        ButtonWidget(
            text: '重新提交信息'.tr,
            width: 690,
            height: 74,
            borderRadius: 37,
            backgroundColor: AppTheme.color000,
            textColor: AppTheme.colorfff,
            onTap: () {
              Get.until((route) => route.settings.name == AppRoutes.realName);
            }),
      SizedBox(height: 20.w),
      ButtonWidget(
          text: '返回首页'.tr,
          width: 690,
          height: 74,
          borderRadius: 37,
          backgroundColor: AppTheme.primary,
          textColor: AppTheme.colorfff,
          onTap: () {
            Get.until((route) => route.settings.name == AppRoutes.home);
          }),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RealnameAwsStatusController>(
      init: RealnameAwsStatusController(),
      id: "realname_aws_status",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '人脸识别结果'.tr,
            titleColor: Colors.black,
            titleFontWeight: FontWeight.w600,
            backgroundColor: AppTheme.navBgColor,
            screenAdaptation: true,
            useDefaultBack: false,
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
