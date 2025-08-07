import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class GetPowerPage extends GetView<GetPowerController> {
  const GetPowerPage({super.key});

  // 顶部
  Widget _buildTop(BuildContext context) {
    return <Widget>[
      // 选择币种
      <Widget>[
        <Widget>[
          TextWidget.body('选择账户'.tr, size: 26.sp, color: AppTheme.color000),
          TextWidget.body('${'余额:'.tr}${controller.currentCoinBalance}', size: 24.sp, color: AppTheme.color999),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
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

      // 获取算力
      <Widget>[
        TextWidget.body('获取算力'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body(controller.getPower.toString(), size: 26.sp, color: AppTheme.color000),
          TextWidget.body('算力'.tr, size: 26.sp, color: AppTheme.color000),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

      // 滑块选择：总进度为100，当前进度为0
      Slider(
        value: controller.progress.toDouble(),
        min: 0,
        max: 100,
        divisions: 100,
        label: controller.progress.toString(),
        activeColor: AppTheme.colorGreen,
        inactiveColor: AppTheme.color999,
        onChanged: (double value) {
          controller.onSliderChange(value);
        },
      ),

      // 销毁
      <Widget>[
        TextWidget.body('您将销毁大约'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body(controller.usedCoin.toString(), size: 26.sp, color: AppTheme.color000),
          TextWidget.body('XFB', size: 26.sp, color: AppTheme.color000),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 30.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

      TextWidget.body('${'汇率参考：1算力≈'.tr}${controller.miningGetpower.peToPower}XFB', size: 24.sp, color: AppTheme.color000),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      _buildTop(context),
      SizedBox(
        height: 30.w,
      ),
      ButtonWidget(
        text: '确定'.tr,
        height: 88,
        borderRadius: 44,
        onTap: controller.submit,
      ),
    ].toColumn().paddingAll(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetPowerController>(
      init: GetPowerController(),
      id: "get_power",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '获取算力'.tr,
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
            rightBarItems: [
              TDNavBarItem(
                  iconWidget: ImgWidget(
                    path: 'assets/images/mining15.png',
                    width: 36.w,
                    height: 36.w,
                  ),
                  action: () {
                    Get.toNamed(AppRoutes.miningRecord);
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
