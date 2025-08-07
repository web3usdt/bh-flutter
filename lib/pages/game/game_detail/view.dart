import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class GameDetailPage extends GetView<GameDetailController> {
  const GameDetailPage({super.key});
  // tab切换
  Widget _buildTab() {
    return TDTabBar(
      isScrollable: true,
      controller: controller.tabController,
      tabs: controller.tabNames.map((e) => TDTab(text: e)).toList(),
      onTap: (index) => controller.onTapTabItem(index),
      backgroundColor: Colors.white,
      showIndicator: true,
      indicatorColor: AppTheme.color000,
      labelColor: AppTheme.color000,
      unselectedLabelColor: AppTheme.color999,
    );
  }

  // 更新提示
  Widget _buildUpdateTip() {
    return <Widget>[
      ImgWidget(path: 'assets/images/game5.png', width: 24.w, height: 24.w),
      SizedBox(width: 12.w),
      TextWidget.body('每日6点更新数据(UTC+8)'.tr, size: 20.sp, color: AppTheme.color000),
    ].toRow().paddingHorizontal(30.w).tight(width: 690.w, height: 64.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 币种选择
  Widget _buildCoinSelect() {
    return <Widget>[
      TextWidget.body('总览'.tr, size: 28.sp, color: AppTheme.color000),
      <Widget>[
        TextWidget.body(controller.selectedCoin, size: 26.sp, color: AppTheme.color000),
        SizedBox(width: 6.w),
        Icon(Icons.arrow_forward_ios, size: 24.w, color: AppTheme.color999),
      ]
          .toRow()
          .paddingHorizontal(20.w)
          .tight(height: 56.w)
          .decorated(
            border: Border.all(color: AppTheme.borderLine, width: 1),
            borderRadius: BorderRadius.circular(28.w),
          )
          .onTap(() => controller.showCoinPicker(Get.context!)),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  // 时间切换
  Widget _buildTimeSwitch() {
    return TDTabBar(
      isScrollable: true,
      controller: controller.timeController,
      tabs: controller.timeNames.map((e) => TDTab(text: e)).toList(),
      onTap: (index) => controller.onTapTimeItem(index),
      backgroundColor: Colors.white,
      showIndicator: true,
      indicatorColor: AppTheme.color000,
      labelColor: AppTheme.color000,
      unselectedLabelColor: AppTheme.color999,
      labelPadding: EdgeInsets.only(right: 60.w),
      indicatorPadding: EdgeInsets.only(right: 60.w),
    );
  }

  // 数据总览
  Widget _buildDataOverview() {
    return <Widget>[
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/game6.png', width: 32.w, height: 32.w),
          SizedBox(height: 20.w),
          TextWidget.body('下单总额'.tr, size: 22.sp, color: AppTheme.color999),
          SizedBox(height: 10.w),
          TextWidget.body(controller.gameDetail.amount.toString(), size: 32.sp, color: AppTheme.color000, weight: FontWeight.w600),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, top: 30.w).tight(width: 335.w, height: 208.w).decorated(
              color: AppTheme.blockBgColor,
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(20.w),
            ),
        <Widget>[
          ImgWidget(path: 'assets/images/game9.png', width: 32.w, height: 32.w),
          SizedBox(height: 20.w),
          TextWidget.body('总盈亏'.tr, size: 22.sp, color: AppTheme.color999),
          SizedBox(height: 10.w),
          TextWidget.body(controller.gameDetail.profitAndLoss.toString(), size: 32.sp, color: AppTheme.colorGreen, weight: FontWeight.w600),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, top: 30.w).tight(width: 335.w, height: 208.w).decorated(
              color: AppTheme.blockBgColor,
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(20.w),
            ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(height: 20.w),
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/game7.png', width: 32.w, height: 32.w),
          SizedBox(height: 20.w),
          TextWidget.body('下单笔数'.tr, size: 22.sp, color: AppTheme.color999),
          SizedBox(height: 10.w),
          TextWidget.body(controller.gameDetail.num.toString(), size: 32.sp, color: AppTheme.color000, weight: FontWeight.w600),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, top: 30.w).tight(width: 335.w, height: 208.w).decorated(
              color: AppTheme.blockBgColor,
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(20.w),
            ),
        <Widget>[
          ImgWidget(path: 'assets/images/game8.png', width: 32.w, height: 32.w),
          SizedBox(height: 20.w),
          TextWidget.body('胜率'.tr, size: 22.sp, color: AppTheme.color999),
          SizedBox(height: 10.w),
          TextWidget.body(controller.gameDetail.winRate.toString(), size: 32.sp, color: AppTheme.color000, weight: FontWeight.w600),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, top: 30.w).tight(width: 335.w, height: 208.w).decorated(
              color: AppTheme.blockBgColor,
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(20.w),
            ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ].toColumn();
  }

  // 分享按钮
  Widget _buildShare() {
    return ButtonWidget(
      text: '分享'.tr,
      width: 690,
      height: 74,
      borderRadius: 37,
      backgroundColor: AppTheme.color000,
      onTap: () {
        // 弹出分享弹窗
        Get.dialog(
          Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
              child: <Widget>[
                <Widget>[
                  TextWidget.body('分享'.tr, size: 32.sp, color: AppTheme.color000),
                  ImgWidget(path: 'assets/images/game11.png', width: 40.w, height: 40.w).onTap(() {
                    Get.back();
                  }),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                SizedBox(height: 30.w),
                RepaintBoundary(
                    key: controller.qrKey,
                    child: <Widget>[
                      ImgWidget(path: 'assets/images/game10.png', width: 690.w, height: 768.w),
                      <Widget>[
                        TextWidget.body('哈希单双3秒钟'.tr, size: 24.sp, color: AppTheme.color000),
                        TextWidget.body('战绩总览'.tr, size: 48.sp, color: AppTheme.color000, weight: FontWeight.w600),
                        SizedBox(height: 60.w),
                        <Widget>[
                          <Widget>[
                            <Widget>[
                              TextWidget.body('+${controller.gameDetail.profitAndLoss.toString()} ${controller.selectedCoin}',
                                  size: 34.sp, color: AppTheme.colorGreen),
                              SizedBox(height: 10.w),
                              TextWidget.body('总盈亏'.tr, size: 24.sp, color: AppTheme.color999),
                            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(250.w),
                            <Widget>[
                              TextWidget.body('${controller.gameDetail.amount.toString()} ${controller.selectedCoin}',
                                  size: 34.sp, color: AppTheme.color000),
                              SizedBox(height: 10.w),
                              TextWidget.body('下单总额'.tr, size: 24.sp, color: AppTheme.color999),
                            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(250.w),
                          ].toRow(),
                          <Widget>[
                            <Widget>[
                              TextWidget.body('${controller.gameDetail.num.toString()}', size: 34.sp, color: AppTheme.color000),
                              SizedBox(height: 10.w),
                              TextWidget.body('下单笔数'.tr, size: 24.sp, color: AppTheme.color999),
                            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(250.w),
                            <Widget>[
                              TextWidget.body('${controller.gameDetail.winRate.toString()}%', size: 34.sp, color: AppTheme.color000),
                              SizedBox(height: 10.w),
                              TextWidget.body('胜负率'.tr, size: 24.sp, color: AppTheme.color999),
                            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(250.w),
                          ].toRow(),
                        ]
                            .toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                            .paddingOnly(left: 30.w, right: 30.w, top: 50.w, bottom: 30.w)
                            .tight(width: 690.w, height: 300.w)
                            .decorated(
                              color: AppTheme.blockBgColor,
                              border: Border.all(color: AppTheme.borderLine, width: 1),
                              borderRadius: BorderRadius.circular(20.w),
                            ),

                        // 二维码
                        SizedBox(height: 40.w),
                        <Widget>[
                          <Widget>[
                            ImgWidget(path: 'assets/icons/ic_logo.png', width: 72.w, height: 72.w),
                            SizedBox(width: 20.w),
                            <Widget>[
                              TextWidget.body('HAPPY', size: 30.sp, color: AppTheme.color000, weight: FontWeight.w600),
                              SizedBox(height: 10.w),
                              TextWidget.body('数字资产交易平台'.tr, size: 20.sp, color: AppTheme.color000),
                            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                          ].toRow(),
                          <Widget>[
                            QrImageView(
                              data: controller.gameDetail.inviteUrl ?? '',
                              version: QrVersions.auto,
                              size: 180.w,
                              gapless: false,
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(180.w, 180.w),
                              ),
                            ),
                          ].toRow().backgroundColor(AppTheme.pageBgColor)
                        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, right: 30.w, top: 70.w),
                    ].toStack().tight(width: 690.w, height: 768.w)),

                // 保存图片
                SizedBox(height: 30.w),
                <Widget>[
                  TextWidget.body('保存分享'.tr, size: 24.sp, color: AppTheme.color000),
                  ImgWidget(path: 'assets/images/game12.png', width: 52.w, height: 52.w).onTap(() {
                    controller.saveImage();
                    Get.back();
                  }),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ]
                  .toColumn()
                  .paddingOnly(
                    left: 30.w,
                    right: 30.w,
                    top: 30.w,
                  )
                  .tight(height: 980.w)
                  .backgroundColor(AppTheme.pageBgColor)
                  .clipRRect(all: 30.w)),
        );
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildTab(),
      SizedBox(height: 30.w),
      _buildUpdateTip(),
      SizedBox(height: 60.w),
      _buildCoinSelect(),
      SizedBox(height: 30.w),
      _buildTimeSwitch(),
      SizedBox(height: 30.w),
      _buildDataOverview(),
      SizedBox(height: 60.w),
      _buildShare(),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameDetailController>(
      init: GameDetailController(),
      id: "game_detail",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '战绩总览'.tr,
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
