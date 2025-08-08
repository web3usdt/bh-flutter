import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class WithdrawAddressEditPage extends GetView<WithdrawAddressEditController> {
  const WithdrawAddressEditPage({super.key});
  // 顶部
  Widget _buildTop(BuildContext context) {
    return <Widget>[
      // 选择币种
      <Widget>[
        TextWidget.body('选择币种'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body(controller.selectedCoin, size: 30.sp, color: AppTheme.color000),
          Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color000)
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .height(96.w)
            .paddingHorizontal(30.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .onTap(() {
          controller.showCoinPicker(context);
        })
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 地址
      <Widget>[
        TextWidget.body('地址'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入或粘贴地址".tr,
            controller: controller.addressController,
          ).expanded(),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 备注
      <Widget>[
        TextWidget.body('备注'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请填写备注".tr,
            controller: controller.remarkController,
          ).expanded(),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 交易密码
      <Widget>[
        TextWidget.body('交易密码'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入交易密码".tr,
            controller: controller.passwordController,
            obscureText: true,
          ).expanded(),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      SizedBox(
        height: 30.w,
      ),
      _buildTop(context),
      SizedBox(
        height: 100.w,
      ),
      ButtonWidget(
        text: '确认'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: controller.submit,
      ),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawAddressEditController>(
      init: WithdrawAddressEditController(),
      id: "withdraw_address_edit",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: controller.type == 'create' ? '添加提币地址'.tr : '编辑提币地址'.tr,
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
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
