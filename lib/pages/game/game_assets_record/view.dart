import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class GameAssetsRecordPage extends GetView<GameAssetsRecordController> {
  const GameAssetsRecordPage({super.key});

  // tab切换
  Widget _buildTab() {
    return controller.tabNames.isEmpty
        ? const SizedBox.shrink()
        : TDTabBar(
            isScrollable: true,
            controller: controller.tabController,
            tabs: controller.tabNames.map((e) => TDTab(text: e.coinName ?? '')).toList(),
            onTap: (index) => controller.onTapTabItem(index),
            backgroundColor: Colors.white,
            showIndicator: true,
            indicatorColor: AppTheme.color000,
            labelColor: AppTheme.color000,
            unselectedLabelColor: AppTheme.color999,
            labelPadding: EdgeInsets.symmetric(horizontal: 30.w),
          );
  }

  // 分页
  Widget _buildPage() {
    return SmartRefresher(
      controller: controller.refreshController,
      enablePullUp: true, // 启用上拉加载
      onRefresh: controller.onRefresh, // 下拉刷新回调
      onLoading: controller.onLoading, // 上拉加载回调
      footer: const SmartRefresherFooterWidget(), // 底部加载更多组件
      header: const SmartRefresherHeaderWidget(), // 头部刷新组件
      child: controller.items.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                var item = controller.items[index];
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
                      '${item.afterBalance! > item.beforeBalance! ? '+' : '-'} ${item.amount}',
                      size: 26.sp,
                      // color: isNegative ? AppTheme.colorRed : AppTheme.colorGreen,
                      color: item.afterBalance! > item.beforeBalance! ? AppTheme.colorGreen : AppTheme.colorRed,
                      textAlign: TextAlign.end,
                    ),
                  ].toRow(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w),
                  <Widget>[
                    TextWidget.body(item.createdAt ?? '', size: 26.sp, color: AppTheme.color999),
                    TextWidget.body('${'余额:'.tr} ${item.afterBalance}', size: 26.sp, color: AppTheme.color000),
                  ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                ]
                    .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                    .paddingAll(30.w)
                    .decorated(
                      border: Border.all(color: AppTheme.borderLine),
                      borderRadius: BorderRadius.circular(16.w),
                    )
                    .marginOnly(top: 20.w)
                    .paddingHorizontal(30.w);
              },
            ),
    );
  }

  // 暂无数据
  Widget _buildEmpty() {
    return EmptyState(message: '暂无数据'.tr);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      _buildTab(),
      _buildPage().expanded(),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameAssetsRecordController>(
      init: GameAssetsRecordController(),
      id: "gameAssetsRecord",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '资产流水'.tr,
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
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
