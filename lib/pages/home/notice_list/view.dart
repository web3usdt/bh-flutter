import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:happy/common/index.dart';
import 'index.dart';

class NoticeListPage extends GetView<NoticeListController> {
  const NoticeListPage({super.key});

  // tab 切换
  Widget _buildTab() {
    return <Widget>[
      TextWidget.body(
        '平台公告'.tr,
        size: 30.sp,
        color: controller.tabIndex == 0 ? AppTheme.color000 : AppTheme.color999,
      ).onTap(() {
        controller.changeTabIndex(0);
      }),
      SizedBox(
        width: 50.w,
      ),
      TextWidget.body(
        '系统消息'.tr,
        size: 30.sp,
        color: controller.tabIndex == 1 ? AppTheme.color000 : AppTheme.color999,
      ).onTap(() {
        controller.changeTabIndex(1);
      }),
    ].toRow().paddingHorizontal(30.w).height(88.w);
  }

  // 数据列表
  Widget _buildList() {
    return SmartRefresher(
      controller: controller.refreshController,
      enablePullUp: true,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      footer: const SmartRefresherFooterWidget(),
      header: const SmartRefresherHeaderWidget(),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return controller.tabIndex == 0 ? _buildNoticeItem(controller.noticeItems[index]) : _buildMessageItem(controller.messageItems[index]);
        },
        itemCount: controller.tabIndex == 0 ? controller.noticeItems.length : controller.messageItems.length,
      ),
    );
  }

  // 公告item
  Widget _buildNoticeItem(HomeNoticeListModel item) {
    return <Widget>[
      TextWidget.body(
        item.title ?? '',
        size: 28.sp,
        color: AppTheme.color000,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      SizedBox(
        height: 30.w,
      ),
      <Widget>[
        TextWidget.body(
          item.createdAt ?? '',
          size: 20.sp,
          color: AppTheme.color999,
        ),
        <Widget>[
          TextWidget.body(
            '查看全部'.tr,
            size: 20.sp,
            color: AppTheme.color999,
          ),
          Icon(
            TDIcons.chevron_right,
            size: 24.sp,
            color: AppTheme.color999,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .marginOnly(bottom: 20.w, left: 30.w, right: 30.w)
        .onTap(() {
      Get.toNamed(AppRoutes.noticeDetail, arguments: {'notice_id': item.id, 'type': 'notice'});
    });
  }

  // 消息item
  Widget _buildMessageItem(HomeSystemMessageListModel item) {
    return <Widget>[
      TextWidget.body(
        item.data?.title ?? '',
        size: 28.sp,
        color: AppTheme.color000,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      SizedBox(
        height: 20.w,
      ),
      TextWidget.body(
        item.data?.content ?? '',
        size: 24.sp,
        color: AppTheme.color999,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      SizedBox(
        height: 30.w,
      ),
      <Widget>[
        TextWidget.body(
          item.createdAt ?? '',
          size: 20.sp,
          color: AppTheme.color999,
        ),
        <Widget>[
          TextWidget.body(
            '查看全部'.tr,
            size: 20.sp,
            color: AppTheme.color999,
          ),
          Icon(
            TDIcons.chevron_right,
            size: 24.sp,
            color: AppTheme.color999,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .marginOnly(bottom: 20.w, left: 30.w, right: 30.w)
        .onTap(() {
      Get.toNamed(AppRoutes.noticeDetail, arguments: {
        'system_id': item.id,
        'type': 'system',
      });
    });
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
    return GetBuilder<NoticeListController>(
      init: NoticeListController(),
      id: "notice_list",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '消息通知'.tr,
            titleColor: AppTheme.color000,
            titleFontWeight: FontWeight.w600,
            backgroundColor: Colors.transparent,
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
