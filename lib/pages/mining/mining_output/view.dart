import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class MiningOutputPage extends GetView<MiningOutputController> {
  const MiningOutputPage({super.key});

  // 主视图
  Widget _buildView() {
    if (controller.items.isEmpty) {
      return EmptyState(message: '暂无产出记录'.tr);
    }
    return ListView.builder(
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return <Widget>[
          <Widget>[
            ImgWidget(
              path: 'assets/images/mining11.png',
              width: 60.w,
              height: 60.w,
            ),
            SizedBox(
              width: 20.w,
            ),
            <Widget>[
              TextWidget.body('每日结算'.tr, size: 26.sp, color: AppTheme.color000),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body('${'产出日期'.tr} ${item.date ?? ''}', size: 24.sp, color: AppTheme.color999),
            ].toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ].toRow(),
          TextWidget.body(item.produceNum ?? '0', size: 28.sp, color: AppTheme.color000),
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
    return GetBuilder<MiningOutputController>(
      init: MiningOutputController(),
      id: "mining_output",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '矿机产出'.tr,
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
            enablePullUp: true,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            footer: const SmartRefresherFooterWidget(),
            header: const SmartRefresherHeaderWidget(),
            child: _buildView(),
          ),
        );
      },
    );
  }
}
