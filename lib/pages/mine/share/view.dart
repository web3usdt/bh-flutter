import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class SharePage extends GetView<ShareController> {
  const SharePage({super.key});

  // 顶部
  Widget _buildTop(BuildContext context) {
    return <Widget>[
      // 进度条
      Stack(
        alignment: Alignment.center,
        children: [
          // 背景圆环
          SizedBox(
            width: 300.w,
            height: 300.w,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 16.w,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.color8D9094),
            ),
          ),
          // 进度圆环
          SizedBox(
            width: 300.w,
            height: 300.w,
            child: CircularProgressIndicator(
              value: controller.progress / 100.0, // 将 progress 转换为 0-1 之间的值
              strokeWidth: 16.w,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.colorGreen),
            ),
          ),
          // 中间显示进度文字
          TextWidget.body(
            '${controller.progress}%',
            size: 48.sp,
            color: AppTheme.color000,
            weight: FontWeight.w600,
          ),
        ],
      ).tight(width: 690.w, height: 400.w),
      TextWidget.body('${'助力时间截止于'.tr} ${controller.activeInfo.endTime}', size: 28.sp, color: AppTheme.color999).marginOnly(top: 20.w, bottom: 40.w),
      TextWidget.body('我的邀请码'.tr, size: 24.sp, color: AppTheme.color000),
      <Widget>[
        TextWidget.body('${controller.shareInfo.inviteCode}', size: 48.sp, color: AppTheme.color000),
        SizedBox(
          width: 10.w,
        ),
        Icon(Icons.copy, size: 32.sp, color: AppTheme.color000),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).onTap(() {
        ClipboardUtils.copy(controller.shareInfo.inviteCode ?? '');
      }).marginOnly(top: 30.w, bottom: 50.w),
      ButtonWidget(
        text: '邀请助力'.tr,
        height: 88,
        borderRadius: 44,
        onTap: () {
          controller.showInviteFriendDialog();
        },
      )
    ].toColumn();
  }

  // 助力统计
  Widget _buildStatistics(BuildContext context) {
    return <Widget>[
      <Widget>[
        TextWidget.body(
          '${controller.shareInfo.inviteUserNum}',
          size: 32.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
        TextWidget.body('助力总人数'.tr, size: 24.sp, color: AppTheme.color999),
      ]
          .toColumn()
          .paddingOnly(top: 30.w, bottom: 30.w)
          .tight(
            width: 220.w,
          )
          .decorated(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: AppTheme.borderLine, width: 1),
          ),
      <Widget>[
        TextWidget.body(
          '${controller.shareInfo.inviteDirectUserNum}',
          size: 32.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
        TextWidget.body('直接邀请'.tr, size: 24.sp, color: AppTheme.color999),
      ]
          .toColumn()
          .paddingOnly(top: 30.w, bottom: 30.w)
          .tight(
            width: 220.w,
          )
          .decorated(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: AppTheme.borderLine, width: 1),
          ),
      <Widget>[
        TextWidget.body(
          '${controller.shareInfo.inviteIndirectNum}',
          size: 32.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
        TextWidget.body('间接邀请'.tr, size: 24.sp, color: AppTheme.color999),
      ]
          .toColumn()
          .paddingOnly(top: 30.w, bottom: 30.w, left: 10.w, right: 10.w)
          .tight(
            width: 220.w,
          )
          .decorated(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: AppTheme.borderLine, width: 1),
          ),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start);
  }

  // 记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          return <Widget>[
            <Widget>[
              TextWidget.body('${item.account}', size: 28.sp, color: AppTheme.color000),
              <Widget>[
                TextWidget.body(item.referralType == 'direct' ? '直接邀请'.tr : '间接邀请'.tr,
                    size: 24.sp, color: item.referralType == 'direct' ? AppTheme.colorGreen : AppTheme.colorRed),
              ]
                  .toRow()
                  .paddingHorizontal(20.w)
                  .height(40.w)
                  .backgroundColor(item.referralType == 'direct' ? const Color(0xffE3F1E8) : const Color(0xffFDECEC))
                  .clipRRect(topLeft: 20.w, bottomLeft: 20.w),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            TextWidget.body('${item.createdAt}', size: 26.sp, color: AppTheme.color999),
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .paddingOnly(top: 30.w, bottom: 30.w, left: 30.w, right: 0)
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
      SizedBox(
        height: 30.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      _buildTop(context).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      TDDivider(
        height: 1,
        color: AppTheme.dividerColor,
      ).sliverToBoxAdapter(),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      _buildStatistics(context).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      TDDivider(
        height: 16.w,
        color: AppTheme.dividerColor,
      ).sliverToBoxAdapter(),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      TextWidget.body(
        '助力记录'.tr,
        size: 28.sp,
        color: AppTheme.color000,
        weight: FontWeight.w600,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.items.isEmpty) _buildEmpty().sliverToBoxAdapter(),
      _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareController>(
      init: ShareController(),
      id: "share",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '推广助力'.tr,
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
