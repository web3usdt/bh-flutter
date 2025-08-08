import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class RealnameListPage extends GetView<RealnameListController> {
  const RealnameListPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(
        height: 60.w,
      ),
      <Widget>[
        ImgWidget(
          path: 'assets/images/mine18.png',
          width: 266.w,
          height: 282.w,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      SizedBox(
        height: 80.w,
      ),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine19.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body('实名认证'.tr, size: 30.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        if (controller.userAuthInfo.primaryStatus == 0) TextWidget.body('未认证'.tr, size: 26.sp, color: AppTheme.color999),
        if (controller.userAuthInfo.primaryStatus == 1) TextWidget.body('已认证'.tr, size: 26.sp, color: AppTheme.colorGreen),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(30.w)
          .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
          .marginOnly(
            bottom: 20.w,
          )
          .onTap(() {
        controller.onRealname();
      }),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine1.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body('高级认证'.tr, size: 30.sp, color: AppTheme.color000),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        <Widget>[
          if (controller.userAuthInfo.status == 0) TextWidget.body('未认证'.tr, size: 26.sp, color: AppTheme.color999),
          if (controller.userAuthInfo.status == 1) TextWidget.body('审核中'.tr, size: 26.sp, color: AppTheme.color999),
          if (controller.userAuthInfo.status == 2) TextWidget.body('已认证'.tr, size: 26.sp, color: AppTheme.colorGreen),
          if (controller.userAuthInfo.status == 3) TextWidget.body('认证失败'.tr, size: 26.sp, color: AppTheme.colorRed),
          if (controller.userAuthInfo.status == 4) TextWidget.body('人工审核中'.tr, size: 26.sp, color: AppTheme.color000),
          SizedBox(
            height: 25.w,
          ),
          if (controller.userAuthInfo.status == 3)
            TextWidget.body(
              '${'驳回原因'.tr}：${controller.userAuthInfo.remark}',
              textAlign: TextAlign.right,
              size: 24.sp,
              color: AppTheme.colorRed,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ).width(400.w),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.end),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(30.w)
          .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
          .marginOnly(bottom: 20.w)
          .onTap(() {
        controller.onAdvanced();
      }),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RealnameListController>(
      init: RealnameListController(),
      id: "realnameList",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '实名认证'.tr,
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
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
