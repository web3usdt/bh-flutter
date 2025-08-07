import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class MiningRecordPage extends GetView<MiningRecordController> {
  const MiningRecordPage({super.key});

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
              TextWidget.body(item.changeReason ?? '', size: 26.sp, color: AppTheme.color000),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body(item.changeTime ?? '', size: 24.sp, color: AppTheme.color999),
            ].toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ].toRow(),
          TextWidget.body(item.changeType == 2 ? "-${item.changeAmount ?? ''}" : "+${item.changeAmount ?? ''}",
              size: 28.sp, color: AppTheme.colorGreen),
        ]
            .toRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .paddingAll(30.w)
            .decorated(
              border: Border.all(color: AppTheme.borderLine),
              borderRadius: BorderRadius.circular(16.w),
            )
            .marginOnly(left: 30.w, right: 30.w, top: 20.w);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MiningRecordController>(
      init: MiningRecordController(),
      id: "mining_record",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: controller.type == 'lock' ? '锁仓算力明细'.tr : '算力明细'.tr,
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
