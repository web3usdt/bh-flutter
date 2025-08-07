import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class MyAuthorizePage extends GetView<MyAuthorizeController> {
  const MyAuthorizePage({super.key});

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
                return controller.tabIndex == 0
                    ? _buildAllItem(controller.currentAuthorizeItems[index])
                    : _buildHistoryItem(controller.historyListItems[index]);
              },
            ),
    );
  }

  // 全部委托item
  Widget _buildAllItem(CoinMyAuthorizeModel item) {
    return <Widget>[
      <Widget>[
        <Widget>[
          ImgWidget(
            path: item.entrustType == 1 ? 'assets/images/coin5.png' : 'assets/images/coin6.png',
            width: 38.w,
            height: 38.w,
          ),
          SizedBox(
            width: 16.w,
          ),
          TextWidget.body(
            item.symbol ?? '',
            size: 24.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 16.w,
          ),
          ButtonWidget(
            text: item.entrustType == 1 ? '买入'.tr : '卖出'.tr,
            height: 38,
            borderRadius: 10,
            backgroundColor: item.entrustType == 1 ? const Color(0xffE5F7FF) : const Color(0xffFDEBEB),
            textColor: item.entrustType == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
          ),
        ].toRow(),
        ButtonWidget(
          text: '撤销'.tr,
          height: 48,
          borderRadius: 10,
          backgroundColor: AppTheme.colorRed,
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          onTap: () {
            controller.onCancel(item);
          },
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(
        height: 20.w,
      ),
      TextWidget.body(
        '2024-04-07 11:45',
        size: 24.sp,
        color: AppTheme.color999,
      ),
      SizedBox(
        height: 20.w,
      ),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '委托价'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(item.entrustPrice ?? '-', size: 26.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(210.w),
        <Widget>[
          TextWidget.body(
            '总计'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            item.amount.toString(),
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
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
            item.tradedAmount.toString(),
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '类型'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          if (item.type == 1)
            TextWidget.body(
              '全部成交'.tr,
              size: 26.sp,
              color: AppTheme.color000,
            ),
          if (item.type == 2)
            TextWidget.body(
              '市价交易'.tr,
              size: 26.sp,
              color: AppTheme.color000,
            ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(210.w),
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
            item.statusText ?? '',
            size: 26.sp,
            color: AppTheme.colorRed,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
        <Widget>[].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .paddingHorizontal(30.w)
        .marginOnly(top: 16.w);
  }

  // 历史委托item
  Widget _buildHistoryItem(CoinMyAuthorizeModel item) {
    return <Widget>[
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/coin5.png',
            width: 38.w,
            height: 38.w,
          ),
          SizedBox(
            width: 16.w,
          ),
          TextWidget.body(
            item.symbol ?? '',
            size: 24.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 16.w,
          ),
          ButtonWidget(
            text: item.entrustType == 1 ? '买入'.tr : '卖出'.tr,
            height: 38,
            borderRadius: 10,
            backgroundColor: item.entrustType == 1 ? const Color(0xffE5F7FF) : const Color(0xffFDEBEB),
            textColor: item.entrustType == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
          ),
        ].toRow(),
        ButtonWidget(
          text: item.statusText ?? '',
          height: 48,
          borderRadius: 10,
          backgroundColor: Colors.transparent,
          textColor: AppTheme.colorGreen,
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(
        height: 20.w,
      ),
      TextWidget.body(
        item.createdAt ?? '',
        size: 24.sp,
        color: AppTheme.color999,
      ),
      SizedBox(
        height: 20.w,
      ),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '委托价'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(item.entrustPrice ?? '-', size: 26.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(210.w),
        <Widget>[
          TextWidget.body(
            '类型'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          if (item.type == 1)
            TextWidget.body(
              '限价交易'.tr,
              size: 26.sp,
              color: AppTheme.color000,
            ),
          if (item.type == 2)
            TextWidget.body(
              '市价交易'.tr,
              size: 26.sp,
              color: AppTheme.color000,
            ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
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
            item.tradedAmount.toString(),
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '平均价格'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(item.avgPrice ?? '-', size: 26.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(210.w),
        <Widget>[
          TextWidget.body(
            '总计'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            item.amount.toString(),
            size: 26.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
        <Widget>[
          TextWidget.body(
            '总价金额'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(item.tradedMoney ?? '-', size: 26.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .paddingHorizontal(30.w)
        .marginOnly(top: 16.w);
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
    return GetBuilder<MyAuthorizeController>(
      init: MyAuthorizeController(),
      id: "my_authorize",
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
