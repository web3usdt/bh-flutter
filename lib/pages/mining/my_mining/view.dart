import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class MyMiningPage extends GetView<MyMiningController> {
  const MyMiningPage({super.key});
  // 新统计
  Widget _buildNewStatistics() {
    return <Widget>[
      // 标题
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mining34.png',
            width: 68.w,
            height: 68.w,
          ),
          SizedBox(
            width: 20.w,
          ),
          TextWidget.body('矿机'.tr, size: 32.sp, color: AppTheme.color000),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ButtonWidget(
          text: '购买'.tr,
          height: 54,
          borderRadius: 27,
          backgroundColor: AppTheme.color000,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          onTap: () {
            controller.buyMining();
          },
        )
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      TDDivider(
        height: 1,
        color: AppTheme.borderLine,
      ).marginOnly(top: 30.w, bottom: 40.w),

      // 统计
      <Widget>[
        <Widget>[
          TextWidget.body('正式矿机'.tr, size: 24.sp, color: AppTheme.color8D9094),
          <Widget>[
            TextWidget.body('${controller.miningUserinfo.minerCount ?? 0}', size: 24.sp, color: AppTheme.color000),
            TextWidget.body('(台)'.tr, size: 24.sp, color: AppTheme.color000),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body('新手矿机'.tr, size: 24.sp, color: AppTheme.color8D9094),
          <Widget>[
            TextWidget.body('${controller.miningUserinfo.isNews! > 0 ? 1 : 0}', size: 24.sp, color: AppTheme.color000),
            TextWidget.body('(台)'.tr, size: 24.sp, color: AppTheme.color000),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body('已激活'.tr, size: 24.sp, color: AppTheme.color8D9094),
          <Widget>[
            TextWidget.body('${controller.miningUserinfo.minerCount! > 0 ? 1 : 0}', size: 24.sp, color: AppTheme.color000),
            TextWidget.body('(台)'.tr, size: 24.sp, color: AppTheme.color000),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body('未激活'.tr, size: 24.sp, color: AppTheme.color8D9094),
          <Widget>[
            TextWidget.body('${controller.miningUserinfo.minerNoactiveCount ?? 0}', size: 24.sp, color: AppTheme.color000),
            TextWidget.body('(台)'.tr, size: 24.sp, color: AppTheme.color000),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body('已转让'.tr, size: 24.sp, color: AppTheme.color8D9094),
          <Widget>[
            TextWidget.body(
                '${controller.miningUserinfo.minerCount! > 0 ? controller.miningUserinfo.minerCount! - controller.miningUserinfo.minerNoactiveCount! - 1 : 0}',
                size: 24.sp,
                color: AppTheme.color000),
            TextWidget.body('(台)'.tr, size: 24.sp, color: AppTheme.color000),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      ].toColumn(),
    ].toColumn();
  }

  // 划转记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          return <Widget>[
            <Widget>[
              ImgWidget(
                path: 'assets/images/mining35.png',
                width: 50.w,
                height: 50.w,
              ),
              SizedBox(
                width: 20.w,
              ),
              TextWidget.body(item.purchaseTime ?? '', size: 28.sp, color: AppTheme.color000),
            ].toRow(),
            SizedBox(
              height: 40.w,
            ),
            <Widget>[
              <Widget>[
                TextWidget.body('矿机类型'.tr, size: 24.sp, color: AppTheme.color999),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(item.orderType == 1 ? 'Buy' : "Sell", size: 24.sp, color: AppTheme.color000),
              ]
                  .toColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                  .width(210.w),
              <Widget>[
                TextWidget.body('矿机数量(台)'.tr, size: 24.sp, color: AppTheme.color999),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body('${item.num ?? 0}', size: 24.sp, color: AppTheme.color000),
              ]
                  .toColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                  .width(210.w),
              <Widget>[
                TextWidget.body('交易人'.tr, size: 24.sp, color: AppTheme.color999),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(item.inviterId == 0 ? "System" : (item.related != null ? item.related!.account ?? '' : ''),
                    size: 24.sp, color: AppTheme.color000),
              ]
                  .toColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                  .width(180.w),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ]
              .toColumn()
              .padding(left: 30.w, right: 30.w, bottom: 30.w, top: 30.w)
              .decorated(
                border: Border.all(color: AppTheme.borderLine),
                borderRadius: BorderRadius.circular(16.w),
              )
              .marginOnly(top: 20.w);
        },
        childCount: controller.items.length,
      ),
    );
  }

  // 暂无数据
  Widget _buildEmpty() {
    return EmptyState(message: '暂无数据'.tr).paddingVertical(200.w);
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(slivers: [
      SizedBox(
        height: 30.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      _buildNewStatistics().sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 30.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      TextWidget.body('我的矿机'.tr, size: 28.sp, color: AppTheme.color000).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.items.isEmpty) _buildEmpty().sliverToBoxAdapter(),
      _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyMiningController>(
      init: MyMiningController(),
      id: "my_mining",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '我的矿机'.tr,
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
          body: SmartRefresher(
            controller: controller.refreshController,
            enablePullUp: true, // 启用上拉加载
            onRefresh: controller.onRefresh, // 下拉刷新回调
            onLoading: controller.onLoading, // 上拉加载回调
            footer: const SmartRefresherFooterWidget(), // 底部加载更多组件
            header: const SmartRefresherHeaderWidget(), // 头部刷新组件
            child: _buildView(),
          ),
        );
      },
    );
  }
}
