import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'index.dart';

class MiningPage extends GetView<MiningController> {
  const MiningPage({super.key});

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
            color: AppTheme.color8D9094,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("销毁平台的3倍");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.destroyPowerU ?? 0}',
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
            color: AppTheme.color8D9094,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("已经产出平台");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.totalIncome ?? 0}',
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
            color: AppTheme.color8D9094,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("推广奖励算力");
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
            color: AppTheme.color8D9094,
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

      // 大区业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '大区业绩'.tr,
            size: 20.sp,
            color: AppTheme.color8D9094,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("最大一条线的业绩");
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
            color: AppTheme.color8D9094,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("团队排出最大一条线其他线业绩总和");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.xiaoquDestoryCoinU ?? 0}',
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
            color: AppTheme.color8D9094,
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
            color: AppTheme.color8D9094,
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

      // 团队总业绩
      <Widget>[
        <Widget>[
          TextWidget.body(
            '团队总业绩'.tr,
            size: 20.sp,
            color: AppTheme.color8D9094,
          ),
          ImgWidget(
            path: 'assets/images/home13.png',
            width: 24.w,
            height: 24.w,
          ).marginOnly(left: 10.w).onTap(() {
            controller.showTextDialog("团队总业绩");
          })
        ].toRow(),
        TextWidget.body(
          '${controller.performance?.teamDestroyAllU ?? 0}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 630.w, height: 80.w),
    ].toColumn().paddingAll(30.w).tight(width: 690.w).decorated(
          border: Border.all(width: 1, color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(16.w),
        );
  }

  // 新人矿机
  Widget _buildNewMining() {
    return <Widget>[
      <Widget>[
        TextWidget.body(
          '矿机算力'.tr,
          size: 36.sp,
          weight: FontWeight.bold,
          color: AppTheme.color000,
        ),
        SizedBox(
          height: 20.w,
        ),
        if (controller.miningUserinfo.minerCount == 0 || controller.miningUserinfo.minerCount == -1)
          ButtonWidget(
            text: '激活矿机'.tr,
            height: 64,
            borderRadius: 32,
            width: 630,
            backgroundColor: const Color(0xff303236),
            onTap: () {
              controller.getMiningNewUserPower();
            },
          )
        else
          ButtonWidget(
            text: '已激活'.tr,
            height: 64,
            borderRadius: 32,
            width: 630,
            backgroundColor: const Color(0xff303236),
          ).opacity(0.5),
      ]
          .toColumn()
          .paddingOnly(top: 210.w)
          .tight(width: 690.w, height: 380.w)
          .decorated(
            border: Border.all(width: 1, color: AppTheme.borderLine),
            borderRadius: BorderRadius.circular(16.w),
            color: AppTheme.blockTwoBgColor,
          )
          .positioned(top: 40.w),
      ImgWidget(
        path: 'assets/images/mining25.gif',
        width: 280.w,
        height: 230.w,
      ).positioned(left: 205.w),
    ].toStack().tight(width: 690.w, height: 420.w);
  }

  // 更多功能
  Widget _buildMore() {
    return <Widget>[
      SizedBox(
        height: 25.w,
      ),
      // 标题
      <Widget>[
        TDImage(
          assetUrl: "assets/images/mining26.png",
          width: 36.w,
          height: 36.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        TextWidget.body(
          '更多功能',
          size: 28.sp,
          color: AppTheme.color000,
        ),
      ].toRow().paddingHorizontal(30.w),
      SizedBox(
        height: 50.w,
      ),

      // 爆款商品可左右滑动查看
      <Widget>[
        SizedBox(
          width: 30.w,
        ),
        for (var item in controller.moreList)
          <Widget>[
            TDImage(
              assetUrl: item['icon'],
              width: 60.w,
              height: 60.w,
            ),
            SizedBox(
              height: 20.w,
            ),
            TextWidget.body(
              item['title'],
              size: 20.sp,
              color: AppTheme.color000,
            ),
            SizedBox(
              height: 20.w,
            ),
            TDImage(
              assetUrl: "assets/images/mining33.png",
              width: 20.w,
              height: 20.w,
            ),
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center)
              .tight(width: 130.w, height: 196.w)
              .backgroundColor(AppTheme.blockTwoBgColor)
              .clipRRect(all: 16.w)
              .marginOnly(right: 20.w)
              .onTap(() {
            controller.jumpRoute(item['route']);
          }),
      ]
          .toListView(
            scrollDirection: Axis.horizontal,
          )
          .expanded(),
    ].toColumn().tight(height: 320.w);
  }

  // 主视图
  Widget _buildView() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.initData();
      },
      child: CustomScrollView(slivers: [
        _buildNewHeader().sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
        SizedBox(
          height: 30.w,
        ).sliverToBoxAdapter(),
        _buildNewMining().sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
        SizedBox(
          height: 50.w,
        ).sliverToBoxAdapter(),
        _buildMore().sliverToBoxAdapter(),
        SizedBox(
          height: 250.w,
        ).sliverToBoxAdapter(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MiningController>(
      init: MiningController(),
      id: "mining",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            centerTitle: false, // 不显示标题
            height: 0, // 高度
            backgroundColor: AppTheme.navBgColor,
            screenAdaptation: true,
            useDefaultBack: false,
          ),
          body: _buildView(),
        );
      },
    );
  }
}
