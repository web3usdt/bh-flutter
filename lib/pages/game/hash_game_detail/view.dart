import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class HashGameDetailPage extends GetView<HashGameDetailController> {
  const HashGameDetailPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      <Widget>[
        // 编号
        <Widget>[
          TextWidget.body('编号'.tr, color: AppTheme.color999, size: 24.sp),
          SizedBox(width: 20.w),
          TextWidget.body(controller.item?.serialNumber ?? '', color: AppTheme.color000, size: 24.sp),
        ].toRow().marginOnly(bottom: 40.w),

        // 中奖结果
        <Widget>[
          <Widget>[
            TextWidget.body('中奖情况'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            <Widget>[
              TextWidget.body(controller.item?.result == controller.item?.expect ? '中奖'.tr : '未中奖'.tr, color: AppTheme.color000, size: 28.sp),
              SizedBox(width: 20.w),
              <Widget>[
                TextWidget.body(
                  controller.item?.result == 1 ? '单' : '双',
                  color: AppTheme.colorfff,
                  size: 24.sp,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.center)
                  .tight(width: 52.w, height: 52.w)
                  .backgroundColor(controller.item?.result == 1 ? AppTheme.colorRed : AppTheme.colorGreen)
                  .clipRRect(all: 26.w),
            ].toRow()
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .paddingAll(20.w)
              .tight(
                width: 300.w,
              )
              .backgroundColor(AppTheme.blockBgColor)
              .clipRRect(all: 10.w),
          SizedBox(width: 20.w),
          <Widget>[
            TextWidget.body('投注区域'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            <Widget>[
              <Widget>[
                TextWidget.body(
                  controller.item?.expect == 1 ? '单' : '双',
                  color: AppTheme.colorfff,
                  size: 24.sp,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.center)
                  .tight(width: 52.w, height: 52.w)
                  .backgroundColor(controller.item?.expect == 1 ? AppTheme.colorRed : AppTheme.colorGreen)
                  .clipRRect(all: 26.w),
            ].toRow()
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .paddingAll(20.w)
              .tight(
                width: 300.w,
              )
              .backgroundColor(AppTheme.blockBgColor)
              .clipRRect(all: 10.w),
        ].toRow().marginOnly(bottom: 30.w),

        <Widget>[
          <Widget>[
            TextWidget.body('游戏类型'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            TextWidget.body(controller.item?.type == 1 ? '哈希单双3秒钟' : '哈希单双1分钟', color: AppTheme.color000, size: 24.sp),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(330.w),
          <Widget>[
            TextWidget.body('投注时间'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            TextWidget.body(controller.item?.createdAt ?? '', color: AppTheme.color000, size: 24.sp),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ].toRow().marginOnly(bottom: 30.w),

        <Widget>[
          <Widget>[
            TextWidget.body('投注金额'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            TextWidget.body('${controller.item?.amount.toString() ?? ''} ${controller.item?.coinName ?? ''}', color: AppTheme.color000, size: 24.sp),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(330.w),
          <Widget>[
            TextWidget.body('返还金额'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            TextWidget.body('${controller.item?.win.toString() ?? ''} ${controller.item?.coinName ?? ''}', color: AppTheme.color000, size: 24.sp),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ].toRow().marginOnly(bottom: 30.w),

        <Widget>[
          <Widget>[
            TextWidget.body('投注区块'.tr, color: AppTheme.color999, size: 24.sp),
            SizedBox(height: 10.w),
            TextWidget.body(controller.item?.blockId.toString() ?? '', color: AppTheme.color000, size: 24.sp),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(330.w),
          <Widget>[
            <Widget>[
              TextWidget.body('区块哈希'.tr, color: AppTheme.color999, size: 24.sp),
              SizedBox(width: 10.w),
              <Widget>[
                TextWidget.body(
                  '验证'.tr,
                  color: AppTheme.colorfff,
                  size: 24.sp,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.center)
                  .tight(width: 80.w, height: 40.w)
                  .backgroundColor(AppTheme.primary)
                  .clipRRect(all: 20.w)
                  .onTap(() {
                controller.verifyBlock();
              }),
            ].toRow(),
            SizedBox(height: 10.w),
            TextWidget.body(controller.modifyHash(controller.item?.hash ?? ''), color: AppTheme.color000, size: 24.sp),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ].toRow(),
      ].toColumn().paddingOnly(left: 30.w, right: 0, top: 30.w, bottom: 100.w).decorated(
            border: Border.all(color: AppTheme.borderLine, width: 1),
            borderRadius: BorderRadius.circular(10.w),
          )
    ].toColumn().paddingAll(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HashGameDetailController>(
      init: HashGameDetailController(),
      id: "hash_game_detail",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '投注详情'.tr,
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
                  icon: TDIcons.share,
                  iconSize: 24,
                  iconColor: AppTheme.color000,
                  action: () {
                    controller.shareInviteUrl();
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
