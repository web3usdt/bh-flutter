import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class OptionPage extends GetView<OptionController> {
  const OptionPage({super.key});

  // 格式化倒计时显示
  String _formatCountdown(int seconds) {
    if (seconds <= 0) return '00:00:00';

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // tab切换
  Widget _buildTab() {
    if (controller.tabKeys.isEmpty) {
      return Container(
        width: 750.w,
        height: 84.w,
        color: AppTheme.pageBgColor,
      );
    }

    return <Widget>[
      <Widget>[
        for (var i = 0; i < controller.tabKeys.length; i++)
          TextWidget.body(
            controller.tabKeys[i],
            size: 26.sp,
            color: controller.tabIndex == i ? Colors.black : AppTheme.color8D9094,
            weight: FontWeight.bold,
            textAlign: TextAlign.center,
          )
          .paddingVertical(15.w)
          .tight(
            width: 120.w,
          )
          .decorated(
            border: Border.all(color: controller.tabIndex == i ? Colors.black : AppTheme.borderLine),
            borderRadius: BorderRadius.circular(16.w),
          )
          .onTap(() {
            controller.onTapTabIndex(i);
          }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).tight(width: 750.w, height: 84.w),
      <Widget>[]
          .toRow()
          .tight(width: 750.w, height: 40.w)
          .backgroundColor(AppTheme.colorfff)
          .clipRRect(topLeft: 40.w, topRight: 40.w)
          .positioned(left: 0, right: 0, bottom: -1),
    ].toStack().width(750.w).height(128.w).backgroundColor(AppTheme.pageBgColor);
  }

  // 头部渲染
  Widget _buildHeader(OptionIndexListModelScenePairList item) {
    return <Widget>[
      // 币种
      <Widget>[
        <Widget>[
          ImgWidget(
            path: item.coinIcon ?? '',
            width: 44.w,
            height: 44.w,
          ),
          SizedBox(
            width: 12.w,
          ),
          TextWidget.body(
            item.pairName ?? '',
            size: 24.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            '${item.increaseStr}',
            size: 20.sp,
            color: item.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
            weight: FontWeight.bold,
          ),
        ].toRow(),
        <Widget>[
          <Widget>[
            TextWidget.body(
              '距离交割'.tr,
              size: 20.sp,
              color: AppTheme.color8B8B8B,
            ),
            controller.showCountdown
                ? TextWidget.body(
                    _formatCountdown(item.lotteryTime ?? 0),
                    size: 20.sp,
                    color: AppTheme.color000,
                  )
                : const SizedBox.shrink(),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.end)
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.end)
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(
        height: 50.w,
      ),
      // 看多、看空
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/option1.png',
            width: 267.w,
            height: 78.w,
          ),
          <Widget>[
            TextWidget.body(
              '看多'.tr,
              size: 26.sp,
              color: AppTheme.colorGreen,
            ).paddingHorizontal(30.w),
          ].toRow(crossAxisAlignment: CrossAxisAlignment.center).height(78.w)
        ].toStack().tight(width: 267.w, height: 78.w),
        ImgWidget(
          path: 'assets/images/option3.png',
          width: 67.w,
          height: 76.w,
        ),
        <Widget>[
          ImgWidget(
            path: 'assets/images/option2.png',
            width: 267.w,
            height: 78.w,
          ),
          <Widget>[
            TextWidget.body(
              '看空'.tr,
              size: 26.sp,
              color: AppTheme.colorRed,
            ).paddingOnly(right: 30.w),
          ].toRow(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center).height(78.w)
        ].toStack().tight(width: 267.w, height: 78.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      // 收益率
      SizedBox(
        height: 50.w,
      ),
      <Widget>[
        TextWidget.body(
          '${item.upodds}',
          size: 26.sp,
          color: AppTheme.colorGreen,
        ),
        TextWidget.body(
          '收益率'.tr,
          size: 22.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '${item.downodds}',
          size: 26.sp,
          color: AppTheme.colorGreen,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w),
      SizedBox(
        height: 20.w,
      ),
      ImgWidget(
        path: 'assets/images/option4.png',
        width: 606.w,
        height: 7.w,
      ),
      SizedBox(
        height: 40.w,
      ),

      // 进度对比
      <Widget>[
        // 左边
        <Widget>[]
            .toRow()
            .width(690.w * (item.trendUp ?? 0) * 100 / 100)
            .backgroundColor(AppTheme.colorGreen)
            .clipRRect(
                topLeft: 20.w,
                bottomLeft: 20.w,
                topRight: (item.trendUp ?? 0) * 100 == 100 ? 20.w : 0,
                bottomRight: (item.trendUp ?? 0) * 100 == 100 ? 20.w : 0)
            .positioned(left: 0, top: 0, bottom: 0),
        // 右边
        <Widget>[]
            .toRow()
            .width(690.w * (item.trendDown ?? 0) * 100 / 100)
            .backgroundColor(AppTheme.colorRed)
            .clipRRect(
                topRight: 20.w,
                bottomRight: 20.w,
                topLeft: (item.trendDown ?? 0) * 100 == 100 ? 20.w : 0,
                bottomLeft: (item.trendDown ?? 0) * 100 == 100 ? 20.w : 0)
            .positioned(right: 0, top: 0, bottom: 0),
        TextWidget.body(
          '${((item.trendUp ?? 0) * 100).toStringAsFixed(1)}%',
          size: 18.sp,
          color: AppTheme.colorfff,
        ).positioned(left: 20.w, top: 8.w, bottom: 0),
        TextWidget.body(
          '${((item.trendDown ?? 0) * 100).toStringAsFixed(1)}%',
          size: 18.sp,
          color: AppTheme.colorfff,
        ).positioned(right: 20.w, top: 8.w, bottom: 0),
      ].toStack().tight(width: 690.w, height: 40.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 20.w),
      SizedBox(
        height: 40.w,
      ),

      // 购买按钮
      ButtonWidget(
        text: '购买'.tr,
        height: 64,
        borderRadius: 32,
        backgroundColor: Colors.black,
        onTap: () {
          controller.onTapDetail(item);
        },
      ),
      SizedBox(
        height: 40.w,
      ),
    ].toColumn()
    .paddingAll(30.w)
    .decorated(
      border: Border.all(color: AppTheme.borderLine),
      borderRadius: BorderRadius.circular(16.w),
    );
  }

  // 列表渲染
  Widget _buildListForIndex(List<OptionIndexListModelScenePairList> scenePairList) {
    return <Widget>[
      for (var i = 0; i < scenePairList.length; i++)
        if (i == 0)
          _buildHeader(scenePairList[i])
        else
          <Widget>[
            // 币种
            <Widget>[
              <Widget>[
                ImgWidget(
                  path: scenePairList[i].coinIcon ?? '',
                  width: 44.w,
                  height: 44.w,
                ),
                SizedBox(
                  width: 12 .w,
                ),
                TextWidget.body(
                  scenePairList[i].pairName ?? '',
                  size: 26.sp,
                  color: AppTheme.color000,
                ),
                SizedBox(
                  width: 10.w,
                ),
                TextWidget.body(
                  '${scenePairList[i].increaseStr}',
                  size: 20.sp,
                  color: scenePairList[i].increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
                  weight: FontWeight.bold,
                ),
              ].toRow(),
              <Widget>[
                
                SizedBox(
                  height: 10.w,
                ),
                <Widget>[
                  TextWidget.body(
                    '距离交割'.tr,
                    size: 20.sp,
                    color: AppTheme.color8B8B8B,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  controller.showCountdown
                      ? TextWidget.body(
                          _formatCountdown(scenePairList[i].lotteryTime ?? 0),
                          size: 20.sp,
                          color: AppTheme.color000,
                        )
                      : const SizedBox.shrink(),
                ].toColumn(crossAxisAlignment: CrossAxisAlignment.end)
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.end)
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

            // 多、空
            SizedBox(
              height: 30.w,
            ),
            <Widget>[
              <Widget>[
                TextWidget.body(
                  '多'.tr,
                  size: 24.sp,
                  color: AppTheme.colorGreen,
                ),
                TextWidget.body(
                  '${scenePairList[i].upodds}',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .paddingHorizontal(20.w)
                  .tight(width: 305.w, height: 52.w)
                  .backgroundColor(AppTheme.blockBgColor)
                  .clipRRect(all: 10.w),
              <Widget>[
                TextWidget.body(
                  '空'.tr,
                  size: 24.sp,
                  color: AppTheme.colorRed,
                ),
                TextWidget.body(
                  '${scenePairList[i].downodds}',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .paddingHorizontal(20.w)
                  .tight(width: 305.w, height: 52.w)
                  .backgroundColor(AppTheme.blockBgColor)
                  .clipRRect(all: 10.w),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ].toColumn()
          .paddingAll(30.w)
          .decorated(
            border: Border.all(color: AppTheme.borderLine),
            borderRadius: BorderRadius.circular(16.w),
          )
          .marginOnly(top: 20.w)
          .onTap(() {
            controller.onTapDetail(scenePairList[i]);
          }),
      SizedBox(
        height: 150.w,
      ),
    ].toColumn();
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildTab(),
      if (controller.pageController != null && controller.tabKeys.isNotEmpty)
        PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController!,
          onPageChanged: controller.onPageChanged,
          itemCount: controller.tabKeys.length,
          itemBuilder: (context, index) {
            // 获取对应index的数据
            final scenePairList =
                index < controller.allOptionList.length ? controller.allOptionList[index].scenePairList ?? [] : <OptionIndexListModelScenePairList>[];

            return SingleChildScrollView(
              child: _buildListForIndex(scenePairList).paddingHorizontal(30.w),
            );
          },
        ).expanded()
      else
        EmptyState(message: '数据加载中...'.tr).expanded(),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OptionController>(
      init: OptionController(),
      id: "option",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
              padding: EdgeInsets.only(left: 0, right: 30.w), // 重写左右内边距
              centerTitle: false, // 不显示标题
              height: 44, // 高度
              titleWidget: TextWidget.body(
                '期权'.tr,
                size: 30.sp,
                weight: FontWeight.bold,
                color: AppTheme.color000,
              ),
              backgroundColor: AppTheme.pageBgColor,
              screenAdaptation: true,
              useDefaultBack: false,
              rightBarItems: [
                TDNavBarItem(
                  padding: EdgeInsets.only(right: 20.w),
                  iconWidget: ImgWidget(
                    path: 'assets/images/option5.png',
                    width: 30.w,
                    height: 30.w,
                  ),
                  action: () {
                    controller.onViewProjectDetails();
                  },
                ),
              ]),
          body: _buildView(),
        );
      },
    );
  }
}
