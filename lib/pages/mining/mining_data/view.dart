import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class MiningDataPage extends GetView<MiningDataController> {
  const MiningDataPage({super.key});
  // 新头部
  Widget _buildNewHeader() {
    return <Widget>[
      <Widget>[
        ImgWidget(
          path: 'assets/images/mining20.png',
          width: 64.w,
          height: 64.w,
        ),
        SizedBox(
          width: 20.w,
        ),
        <Widget>[
          TextWidget.body('HI'.tr, size: 20.sp, color: AppTheme.color8D9094),
          TextWidget.body(
            controller.miningUserinfo.levelName ?? '',
            size: 28.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toRow(),
      SizedBox(
        height: 40.w,
      ),

      // 预计今日收益
      // <Widget>[
      //   <Widget>[
      //     ImgWidget(
      //       path: 'assets/images/mining21.png',
      //       width: 28.w,
      //       height: 28.w,
      //     ),
      //     SizedBox(
      //       width: 20.w,
      //     ),
      //     TextWidget.body(
      //       '预计今日收益'.tr,
      //       size: 20.sp,
      //       color: AppTheme.color000,
      //     ),
      //   ].toRow(),
      //   TextWidget.body(
      //     '${controller.miningUserinfo.todayIncome ?? 0}',
      //     size: 24.sp,
      //     color: AppTheme.color000,
      //   ),
      // ]
      //     .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
      //     .paddingHorizontal(30.w)
      //     .tight(width: 630.w, height: 80.w)
      //     .backgroundColor(AppTheme.blockTwoBgColor)
      //     .clipRRect(all: 16.w),
      // SizedBox(
      //   height: 20.w,
      // ),

      // 释放收益
      if (controller.miningUserinfo.lockPower != null && controller.miningUserinfo.lockPower != '0' && controller.miningUserinfo.lockPower != '--')
        <Widget>[
          <Widget>[
            ImgWidget(
              path: 'assets/images/mining21.png',
              width: 28.w,
              height: 28.w,
            ),
            SizedBox(
              width: 20.w,
            ),
            TextWidget.body(
              '释放收益'.tr,
              size: 20.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
          TextWidget.body(
            '${controller.miningUserinfo.lockPower ?? 0}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .tight(width: 630.w, height: 80.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 16.w),

      // 总收益
      // <Widget>[
      //   <Widget>[
      //     ImgWidget(
      //       path: 'assets/images/mining22.png',
      //       width: 28.w,
      //       height: 28.w,
      //     ),
      //     SizedBox(
      //       width: 20.w,
      //     ),
      //     TextWidget.body(
      //       '总收益'.tr,
      //       size: 20.sp,
      //       color: AppTheme.color8D9094,
      //     ),
      //   ].toRow(),
      //   TextWidget.body(
      //     '${controller.miningUserinfo.totalIncome ?? 0}',
      //     size: 20.sp,
      //     color: AppTheme.color000,
      //   ),
      // ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 我的算力值
      // <Widget>[
      //   <Widget>[
      //     TextWidget.body(
      //       '我的算力值'.tr,
      //       size: 20.sp,
      //       color: AppTheme.color8D9094,
      //     ),
      //   ].toRow(),
      //   TextWidget.body(
      //     '${controller.miningUserinfo.myPower ?? 0}',
      //     size: 20.sp,
      //     color: AppTheme.color000,
      //   ),
      // ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 我的佣金
      // <Widget>[
      //   <Widget>[
      //     ImgWidget(
      //       path: 'assets/images/mining24.png',
      //       width: 28.w,
      //       height: 28.w,
      //     ),
      //     SizedBox(
      //       width: 20.w,
      //     ),
      //     TextWidget.body(
      //       '我的佣金(BB)'.tr,
      //       size: 20.sp,
      //       color: AppTheme.color8D9094,
      //     ),
      //   ].toRow(),
      //   TextWidget.body(
      //     '${controller.miningUserinfo.commisson ?? 0}',
      //     size: 20.sp,
      //     color: AppTheme.color000,
      //   ),
      // ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 昨日佣金收益
      // <Widget>[
      //   <Widget>[
      //     TextWidget.body(
      //       '昨日佣金收益'.tr,
      //       size: 20.sp,
      //       color: AppTheme.color8D9094,
      //     ),
      //   ].toRow(),
      //   TextWidget.body(
      //     '${controller.miningUserinfo.commissonYes ?? 0}',
      //     size: 20.sp,
      //     color: AppTheme.color000,
      //   ),
      // ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 个人销毁算力(x3)
      <Widget>[
        <Widget>[
          TextWidget.body(
            '我的预期收益'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("销毁平台币赠送的3倍算力");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.expectedIncomeU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 我已获得收益
      <Widget>[
        <Widget>[
          TextWidget.body(
            '我已获得收益'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("已经产出平台币所消耗算力");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.totalIncomeU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 推广奖励
      <Widget>[
        <Widget>[
          TextWidget.body(
            '推广奖励算力'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("推广奖励的算力");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.teamRewardU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 累计收益
      <Widget>[
        <Widget>[
          TextWidget.body(
            '累计收益'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("累计收益");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.teamIncomePowerU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 我的业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '我的业绩'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("我自己的销毁的算力");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.destroyPowerU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 大区业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '大区业绩'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("最大一条线的毁的算力");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.daquDestoryCoinU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 小区业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '小区业绩'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("团队中排除最大一条线其他线业绩总和");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.xiaoquDestoryCoinU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 团队总业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '团队总业绩'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("团队总业绩包含自己的业绩");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.teamDestroyAllU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 团队日业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '团队日业绩'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("团队今日业绩");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.teamDestroyDayU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),

      // 团队月业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '团队月业绩'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("团队本月业绩");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.teamDestroyMonthU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),
    ]
        .toColumn()
        .paddingAll(30.w)
        .tight(width: 690.w)
        .decorated(
          border: Border.all(width: 1, color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(16.w),
        )
        .paddingAll(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MiningDataController>(
      init: MiningDataController(),
      id: "mining_data",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '数据汇总'.tr,
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
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.initData();
            },
            child: _buildNewHeader(),
          ),
        );
      },
    );
  }
}
