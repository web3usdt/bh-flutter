import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class OptionBuyRecordPage extends GetView<OptionBuyRecordController> {
  const OptionBuyRecordPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(
        height: 30.w,
      ),
      <Widget>[
        TextWidget.body(
          '${controller.orderData?.pairName}-${controller.orderData?.timeName}',
          size: 32.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '订单号'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.orderNo}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '开盘价'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.scene?['begin_price']}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '开盘时间'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.beginTimeText}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '收盘价'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.scene?['end_price']}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '收盘时间'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.updatedAt}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '买入时间'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.createdAt}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '买入数量'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.betAmount}(${controller.orderData?.betCoinName})',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '购买类型'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.upDown == 1 ? '涨' : controller.orderData?.upDown == 2 ? '跌' : '平'}${controller.orderData?.upDown == 3 ? '±' : '≥'}${controller.orderData?.range}%',
          size: 24.sp,
          color: controller.orderData?.upDown == 1
              ? AppTheme.colorGreen
              : controller.orderData?.upDown == 2
                  ? AppTheme.colorRed
                  : AppTheme.colorYellow,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '收益率'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${(double.parse(controller.orderData?.odds ?? '0') * 100).toStringAsFixed(0)}%',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '手续费'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.fee}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '状态'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.statusText}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '交割结果'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        <Widget>[
          TextWidget.body(
            '${controller.orderData?.scene?['delivery_range']}',
            size: 24.sp,
            color: AppTheme.color000,
            weight: FontWeight.w600,
          ),
          TextWidget.body(
            controller.orderData?.scene?['delivery_up_down'] == 1
                ? '(${'涨'.tr})'
                : controller.orderData?.scene?['delivery_up_down'] == 2
                    ? '(${'跌'.tr})'
                    : '(${'平'.tr})',
            size: 24.sp,
            color: controller.orderData?.scene?['delivery_up_down'] == 1
                ? AppTheme.colorGreen
                : controller.orderData?.scene?['delivery_up_down'] == 2
                    ? AppTheme.colorRed
                    : AppTheme.colorYellow,
          ),
        ].toRow(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '结算数量'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${controller.orderData?.deliveryAmount}',
          size: 24.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OptionBuyRecordController>(
      init: OptionBuyRecordController(),
      id: "option_buy_record",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '详情'.tr,
            titleColor: AppTheme.color000,
            titleFontWeight: FontWeight.w600,
            backgroundColor: AppTheme.navBgColor,
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
