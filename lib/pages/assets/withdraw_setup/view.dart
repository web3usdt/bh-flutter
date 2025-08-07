import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class WithdrawSetupPage extends GetView<WithdrawSetupController> {
  const WithdrawSetupPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(
        height: 60.w,
      ),
      <Widget>[
        TextWidget.body('邮箱验证'.tr, size: 30.sp, color: AppTheme.color000),
        Icon(
          Icons.check_circle,
          size: 38.sp,
          color: controller.withdrawVerifyIsEmail ? AppTheme.primary : AppTheme.color8B8B8B,
        )
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(90.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 10.w)
          .marginOnly(bottom: 20.w)
          .onTap(() {
        controller.changeWithdrawVerify();
      }),
      <Widget>[
        TextWidget.body('谷歌验证'.tr, size: 30.sp, color: AppTheme.color000),
        Icon(
          Icons.check_circle,
          size: 38.sp,
          color: controller.withdrawVerifyIsEmail ? AppTheme.color8B8B8B : AppTheme.primary,
        )
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(90.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 10.w)
          .marginOnly(bottom: 20.w)
          .onTap(() {
        controller.changeWithdrawVerify();
      }),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawSetupController>(
      init: WithdrawSetupController(),
      id: "withdraw_setup",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '提现设置'.tr,
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
