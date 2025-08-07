import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class SubscribeRecordPage extends GetView<SubscribeRecordController> {
  const SubscribeRecordPage({super.key});

  // 暂无数据
  Widget _buildEmpty() {
    return EmptyState(message: '暂无数据'.tr);
  }

  // 主视图
  Widget _buildView() {
    return ListView.builder(
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        var item = controller.items[index];
        return <Widget>[
          <Widget>[
            <Widget>[
              <Widget>[
                TextWidget.body(item.subscriptionCurrencyName ?? '', size: 26.sp, color: AppTheme.color000),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(DateCommonUtils.formatYMDHMS(DateTime.fromMillisecondsSinceEpoch(item.subscriptionTime! * 1000)),
                    size: 24.sp, color: AppTheme.color999),
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ].toRow(),
            TextWidget.body('成功'.tr, size: 28.sp, color: AppTheme.colorGreen),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          TDDivider(
            height: 1,
            color: AppTheme.dividerColor,
          ).marginOnly(top: 20.w),
          <Widget>[
            TextWidget.body('申购币种'.tr, size: 26.sp, color: AppTheme.color999),
            TextWidget.body(item.subscriptionCurrencyName ?? '', size: 24.sp, color: AppTheme.color000),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 10.w),
          <Widget>[
            TextWidget.body('支付金额'.tr, size: 26.sp, color: AppTheme.color999),
            TextWidget.body(item.paymentAmount ?? '', size: 24.sp, color: AppTheme.color000),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 10.w),
          <Widget>[
            TextWidget.body('到账数量'.tr, size: 26.sp, color: AppTheme.color999),
            TextWidget.body(item.subscriptionCurrencyAmount ?? '', size: 24.sp, color: AppTheme.color000),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 10.w),
        ]
            .toColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .paddingAll(30.w)
            .decorated(
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(16.w),
            )
            .marginOnly(left: 30.w, right: 30.w, top: 20.w);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscribeRecordController>(
      init: SubscribeRecordController(),
      id: "subscribe_record",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '申购记录'.tr,
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
            child: controller.items.isEmpty ? _buildEmpty() : _buildView(),
          ),
        );
      },
    );
  }
}
