import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class TeamPage extends GetView<TeamController> {
  const TeamPage({super.key});
  // 新统计
  Widget _buildNewStatistics() {
    return <Widget>[
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/team1.png', width: 68.w, height: 68.w),
          SizedBox(
            width: 20.w,
          ),
          <Widget>[
            TextWidget.body(
              '${controller.miningTeamInfo.inviteUserNum ?? 0}',
              size: 28.sp,
              color: AppTheme.color000,
              weight: FontWeight.w600,
            ),
            SizedBox(
              height: 10.w,
            ),
            TextWidget.body('团队总人数'.tr, size: 20.sp, color: AppTheme.color8D9094),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        ].toRow(),
        <Widget>[
          TextWidget.body('${'有效'.tr}：${controller.miningTeamStat.validRef ?? 0}', size: 18.sp, color: AppTheme.color000),
        ]
            .toRow()
            .paddingHorizontal(12.w)
            .tight(height: 38.w)
            .backgroundColor(const Color(0xffA7F757))
            .clipRRect(topLeft: 20.w, topRight: 20.w, bottomRight: 20.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(
        height: 50.w,
      ),
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/team2.png', width: 28.w, height: 28.w),
          SizedBox(
            width: 20.w,
          ),
          TextWidget.body('直接邀请'.tr, size: 20.sp, color: AppTheme.color8D9094),
        ].toRow(),
        TextWidget.body('${controller.miningTeamStat.validRef ?? 0} ${'人'.tr}', size: 20.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/team3.png', width: 28.w, height: 28.w),
          SizedBox(
            width: 20.w,
          ),
          TextWidget.body('间接邀请'.tr, size: 20.sp, color: AppTheme.color8D9094),
        ].toRow(),
        TextWidget.body('${controller.miningTeamStat.inviteIndirectNum ?? 0} ${'人'.tr}', size: 20.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/team4.png', width: 28.w, height: 28.w),
          SizedBox(
            width: 20.w,
          ),
          TextWidget.body('日销毁'.tr, size: 20.sp, color: AppTheme.color8D9094),
        ].toRow(),
        <Widget>[
          TextWidget.body('${controller.miningTeamInfo.destroyDayXfb ?? 0} BB', size: 20.sp, color: AppTheme.color000),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body('${controller.miningTeamInfo.destroyDayU ?? 0} USDT', size: 20.sp, color: AppTheme.color8D9094),
        ].toColumn()
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w),
      <Widget>[
        <Widget>[
          ImgWidget(path: 'assets/images/team5.png', width: 28.w, height: 28.w),
          SizedBox(
            width: 20.w,
          ),
          TextWidget.body('月销毁'.tr, size: 20.sp, color: AppTheme.color8D9094),
        ].toRow(),
        <Widget>[
          TextWidget.body('${controller.miningTeamInfo.destroyMonthXfb ?? 0} BB', size: 20.sp, color: AppTheme.color000),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body('${controller.miningTeamInfo.destroyMonthU ?? 0} USDT', size: 20.sp, color: AppTheme.color8D9094),
        ].toColumn()
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start),
    ]
        .toColumn()
        .paddingAll(30.w)
        .decorated(
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: AppTheme.borderLine),
        )
        .padding(left: 30.w, right: 30.w, bottom: 30.w, top: 30.w);
  }

  // 划转记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          return <Widget>[
            <Widget>[
              <Widget>[
                ImgWidget(
                  path: 'assets/images/team6.png',
                  width: 50.w,
                  height: 50.w,
                ),
                SizedBox(
                  width: 20.w,
                ),
                TextWidget.body(item.username ?? '', size: 26.sp, color: AppTheme.color000),
                SizedBox(
                  width: 10.w,
                ),
                <Widget>[
                  TextWidget.body(
                      item.level == 1
                          ? '新手矿工'.tr
                          : item.level == 2
                              ? '正式矿工'.tr
                              : item.level == 3
                                  ? '节点矿池'.tr
                                  : item.level == 4
                                      ? '蜂窝矿池'.tr
                                      : item.level == 5
                                          ? '超级矿池'.tr
                                          : item.level == 6
                                              ? '创世矿池'.tr
                                              : '',
                      size: 18.sp,
                      color: AppTheme.color000),
                ]
                    .toRow()
                    .paddingHorizontal(12.w)
                    .tight(height: 32.w)
                    .backgroundColor(const Color(0xffA7F757))
                    .clipRRect(topLeft: 16.w, topRight: 16.w, bottomRight: 16.w),
              ].toRow(),
              TextWidget.body('${item.createdAt}', size: 18.sp, color: AppTheme.color999),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(
              height: 40.w,
            ),
            <Widget>[
              <Widget>[
                TextWidget.body('我的矿机(台)'.tr, size: 24.sp, color: AppTheme.color999),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body('${item.minerCount}', size: 24.sp, color: AppTheme.color000),
              ]
                  .toColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                  .width(210.w),
              <Widget>[
                TextWidget.body('我的算力值'.tr, size: 24.sp, color: AppTheme.color999),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body('${item.totalPower}', size: 24.sp, color: AppTheme.color000),
              ]
                  .toColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                  .width(210.w),
              <Widget>[
                TextWidget.body('昨日收益'.tr, size: 24.sp, color: AppTheme.color999),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body('${item.produceNum}', size: 24.sp, color: AppTheme.color000),
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
                borderRadius: BorderRadius.circular(16.w),
                border: Border.all(color: AppTheme.borderLine),
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
  Widget _buildView(BuildContext context) {
    return CustomScrollView(slivers: [
      _buildNewStatistics().sliverToBoxAdapter(),
      SizedBox(
        height: 30.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      <Widget>[
        TextWidget.body('团队矿机'.tr, size: 28.sp, color: AppTheme.color000),
        SizedBox(
          width: 20.w,
        ),
        <Widget>[
          TextWidget.body('${controller.miningTeamInfo.teamMiner ?? 0} ${'台'.tr}', size: 18.sp, color: AppTheme.color000),
        ]
            .toRow()
            .paddingHorizontal(12.w)
            .tight(height: 32.w)
            .backgroundColor(const Color(0xffA7F757))
            .clipRRect(topLeft: 16.w, topRight: 16.w, bottomRight: 16.w),
      ].toRow().sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      controller.items.isEmpty ? _buildEmpty().sliverToBoxAdapter() : _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeamController>(
      init: TeamController(),
      id: "team",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '团队数据'.tr,
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
