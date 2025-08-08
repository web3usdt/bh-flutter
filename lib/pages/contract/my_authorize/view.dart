import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class MyAuthorizeContractPage extends GetView<MyAuthorizeContractController> {
  const MyAuthorizeContractPage({super.key});

  // tab切换
  Widget _buildTab() {
    return TDTabBar(
      controller: controller.tabController,
      tabs: controller.tabNames.map((e) => TDTab(text: e)).toList(),
      onTap: (index) {
        controller.changeTabIndex(index);
      },
      backgroundColor: Colors.transparent,
      showIndicator: true,
      indicatorColor: AppTheme.color000,
      labelColor: AppTheme.color000,
      unselectedLabelColor: AppTheme.color000,
    );
  }

  // list 列表
  Widget _buildList() {
    return SmartRefresher(
      controller: controller.refreshController,
      enablePullUp: true, // 启用上拉加载
      onRefresh: controller.onRefresh, // 下拉刷新回调
      onLoading: controller.onLoading, // 上拉加载回调
      footer: const SmartRefresherFooterWidget(), // 底部加载更多组件
      header: const SmartRefresherHeaderWidget(), // 顶部下拉刷新组件
      child: controller.tabIndex == 0 && controller.currentAuthorizeItems.isEmpty || controller.tabIndex == 1 && controller.historyListItems.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              itemCount: controller.tabIndex == 0 ? controller.currentAuthorizeItems.length : controller.historyListItems.length,
              itemBuilder: (context, index) {
                return _buildItem(controller.tabIndex == 0 ? controller.currentAuthorizeItems[index] : controller.historyListItems[index]);
              },
            ),
    );
  }

  // 历史委托item
  Widget _buildItem(ContractMyAuthorizeModel item) {
    return <Widget>[
      <Widget>[
        <Widget>[
          <Widget>[
            ButtonWidget(
              text: controller.cals(item.side ?? 0, item.orderType ?? 0),
              height: 38,
              borderRadius: 10,
              backgroundColor: item.side == 1 ? const Color(0xffE5F7FF) : const Color(0xffFDEBEB),
              textColor: item.side == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
            ),
            SizedBox(
              width: 16.w,
            ),
            TextWidget.body(
              '${item.symbol}/USDT ${item.leverRate}X',
              size: 24.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
          SizedBox(
            height: 16.w,
          ),
          TextWidget.body(
            '${item.createdAt}',
            size: 24.sp,
            color: AppTheme.color999,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        if (controller.tabIndex == 0)
          ButtonWidget(
            text: '撤单'.tr,
            height: 60,
            borderRadius: 10,
            backgroundColor: AppTheme.primary,
            textColor: Colors.white,
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            onTap: () {
              // 确定
              controller.onCancel(item);
            },
          ),
        if (controller.tabIndex == 1 && item.profit != null && item.profit.isNotEmpty)
          ImgWidget(
            path: 'assets/images/continuous1.png',
            width: 24.w,
            height: 24.w,
          ).onTap(() {
            controller.showInviteFriendDialog();
          }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      SizedBox(
        height: 40.w,
      ),
      // 数据统计
      <Widget>[
        <Widget>[
          TextWidget.body(
            '已成交'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.tradedAmount}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '委托总量'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.amount}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '成交均价'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.avgPrice}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '委托价格'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.entrustPrice}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '保证金'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.margin}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '手续费'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.fee}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        if (controller.tabIndex == 1)
          <Widget>[
            TextWidget.body(
              '盈亏'.tr,
              size: 24.sp,
              color: AppTheme.color999,
            ),
            SizedBox(
              height: 14.w,
            ),
            TextWidget.body(
              '${item.profit}',
              size: 26.sp,
              color: AppTheme.color000,
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '状态'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.statusText}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .paddingHorizontal(30.w)
        .marginOnly(bottom: 16.w);
  }

  // 暂无数据
  Widget _buildEmpty() {
    return EmptyState(message: '暂无数据'.tr);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildTab(),
      Expanded(child: _buildList()),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAuthorizeContractController>(
      init: MyAuthorizeContractController(),
      id: "my_authorize_contract",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '我的委托'.tr,
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
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
