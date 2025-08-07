import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class NetworkPage extends GetView<NetworkController> {
  const NetworkPage({super.key});

  // 全网
  Widget _buildNetwork() {
    return <Widget>[
      <Widget>[
        <Widget>[
          TextWidget.body('总算力'.tr, size: 24.sp, color: AppTheme.color8D9094),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body(
            '${controller.miningUserinfo.miner?.allPower ?? 0}',
            size: 24.sp,
            color: AppTheme.color000,
            weight: FontWeight.w600,
          ),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
      SizedBox(
        height: 50.w,
      ),
      <Widget>[
        TextWidget.body('昨日新增算力'.tr, size: 24.sp, color: AppTheme.color8D9094),
        TextWidget.body('${controller.miningUserinfo.miner?.powerAdd ?? 0}', size: 24.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body('全网已产出'.tr, size: 24.sp, color: AppTheme.color8D9094),
        TextWidget.body('${controller.miningUserinfo.miner?.produceNum ?? 0}', size: 24.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body('昨日已产出'.tr, size: 24.sp, color: AppTheme.color8D9094),
        TextWidget.body('${controller.miningUserinfo.miner?.yesterdayProduce ?? 0}', size: 24.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ].toColumn()
    .paddingAll(30.w)
    .decorated(
      border: Border.all(color: AppTheme.borderLine),
      borderRadius: BorderRadius.circular(16.w),
    );
  }

  // 今日
  Widget _buildToday() {
    return <Widget>[
      <Widget>[
        <Widget>[
          TextWidget.body('已销毁总量'.tr, size: 24.sp, color: AppTheme.color8B8B8B),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body(
            '${controller.miningUserinfo.miner?.allDel ?? 0}',
            size: 32.sp,
            color: AppTheme.color000,
            weight: FontWeight.w600,
          ),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
      SizedBox(
        height: 50.w,
      ),
      <Widget>[
        TextWidget.body('昨日已销毁'.tr, size: 24.sp, color: AppTheme.color8D9094),
        TextWidget.body('${controller.miningUserinfo.miner?.yesterdayDel ?? 0}', size: 24.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
    ].toColumn()
    .paddingAll(30.w)
    .decorated(
      border: Border.all(color: AppTheme.borderLine),
      borderRadius: BorderRadius.circular(16.w),
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      TextWidget.body('全网算力'.tr, size: 32.sp, color: AppTheme.color000,weight: FontWeight.w600,).marginOnly(left: 30.w,top: 30.w),
      _buildNetwork().paddingAll(30.w),
      TDDivider(
        height: 1.w,
        color: AppTheme.dividerColor,
      ).marginOnly(top:20.w,left: 30.w,right: 30.w),
      TextWidget.body('全网已销毁'.tr, size: 32.sp, color: AppTheme.color000,weight: FontWeight.w600,).marginOnly(left: 30.w,top: 40.w),
      _buildToday().paddingAll(30.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkController>(
      init: NetworkController(),
      id: "network",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '全网矿池'.tr,
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
