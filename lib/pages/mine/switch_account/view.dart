import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class SwitchAccountPage extends GetView<SwitchAccountController> {
  const SwitchAccountPage({super.key});

  // 表单
  Widget _buildForm() {
    return <Widget>[
      // 当前登录
      for (var item in controller.loginHistoryList)
        <Widget>[
          <Widget>[
            TDImage(
              imgUrl: item.avatar,
              width: 80.w,
              height: 80.w,
              type: TDImageType.circle,
            ),
            SizedBox(width: 20.w),
            TextWidget.body(
              item.account ?? '',
              size: 28.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
          if (item.account == controller.userInfo.account)
            TextWidget.body(
              '当前登录'.tr,
              size: 28.sp,
              color: AppTheme.primary,
            )
          else
            <Widget>[
              TextWidget.body(
                !controller.isManage ? '切换'.tr : '删除'.tr,
                size: 28.sp,
                color: AppTheme.colorfff,
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                .tight(width: 120.w, height: 60.w)
                .backgroundColor(controller.isManage ? AppTheme.colorRed : AppTheme.primary)
                .clipRRect(all: 10.w)
                .onTap(() {
              if (controller.isManage) {
                controller.onDel(item);
              } else {
                controller.onSwitch(item);
              }
            }),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(120.w)
            .backgroundColor(AppTheme.blockBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 25.w),

      // 添加账号
      if (!controller.isManage)
        <Widget>[
          <Widget>[
            TDImage(
              assetUrl: 'assets/images/mine14.png',
              width: 80.w,
              height: 80.w,
              type: TDImageType.circle,
            ),
            SizedBox(width: 20.w),
            TextWidget.body(
              '添加账号'.tr,
              size: 28.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(120.w)
            .backgroundColor(AppTheme.blockBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 25.w)
            .onTap(() {
          Get.toNamed(AppRoutes.login, arguments: {
            'isSwitch': true,
          });
        }),
    ].toColumn();
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 30.w),
      controller.loginHistoryList.isNotEmpty ? _buildForm() : const EmptyState(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).tight(width: 750.w).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwitchAccountController>(
      init: SwitchAccountController(),
      id: "switch_account",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '切换账号'.tr,
            titleColor: AppTheme.color000,
            backgroundColor: AppTheme.navBgColor,
            screenAdaptation: true,
            useDefaultBack: true,
            rightBarItems: [
              TDNavBarItem(
                iconWidget: TextWidget.body(
                  controller.isManage ? '取消'.tr : '管理'.tr,
                  size: 28.sp,
                  color: AppTheme.color000,
                ),
                action: () {
                  controller.onManage();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
