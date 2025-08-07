import 'package:decimal/decimal.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class AssetsRecordPage extends GetView<AssetsRecordController> {
  const AssetsRecordPage({super.key});

  // 选择账户
  Widget _buildAccount(BuildContext context) {
    return <Widget>[
      <Widget>[
        if (controller.image.isNotEmpty) ImgWidget(path: controller.image, width: 56.w, height: 56.w, radius: 28.w).marginOnly(right: 14.w),
        TextWidget.body(controller.coinName, size: 26.sp, color: AppTheme.color000),
      ].toRow(),
      <Widget>[
        TextWidget.body('${'总额'.tr}: ${formatDecimal(controller.balance.totalAssets)}', size: 26.sp, color: AppTheme.color000),
        TextWidget.body('${'可用'.tr}: ${formatDecimal(controller.balance.usableBalance)}', size: 26.sp, color: AppTheme.color000),
        TextWidget.body('${'冻结'.tr}: ${formatDecimal(controller.balance.freezeBalance)}', size: 26.sp, color: AppTheme.color000),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingOnly(left: 30.w, right: 30.w).tight(width: 690.w, height: 150.w).decorated(
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(color: AppTheme.borderLine),
        );
  }

  // 划转记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          final after = Decimal.tryParse(item.afterBalance ?? '0') ?? Decimal.zero;
          final before = Decimal.tryParse(item.beforeBalance ?? '0') ?? Decimal.zero;
          final diff = after - before;
          final isNegative = diff < Decimal.zero;

          return <Widget>[
            <Widget>[
              Expanded(
                child: TextWidget.body(
                  item.logTypeText ?? '',
                  size: 26.sp,
                  color: AppTheme.color666,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 20.w),
              TextWidget.body(
                '${isNegative ? '-' : '+'}${formatDecimal(item.amount)}',
                size: 26.sp,
                color: isNegative ? AppTheme.colorRed : AppTheme.colorGreen,
                textAlign: TextAlign.end,
              ),
            ].toRow(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w),
            TextWidget.body(item.createdAt ?? '', size: 26.sp, color: AppTheme.color000),
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .paddingAll(30.w)
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
    return EmptyState(message: '暂无数据'.tr);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return CustomScrollView(slivers: [
      if (controller.coinName != '合约账户' && controller.coinName != '挖矿账户')
        <Widget>[
          SizedBox(
            height: 30.w,
          ),
          _buildAccount(context),
          SizedBox(
            height: 40.w,
          ),
          TextWidget.body('流水记录'.tr, size: 28.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.items.isEmpty) _buildEmpty().sliverToBoxAdapter(),
      _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssetsRecordController>(
      init: AssetsRecordController(),
      id: "assetsRecord",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: controller.coinName,
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
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
