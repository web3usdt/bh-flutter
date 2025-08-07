import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class RealnamePage extends GetView<RealnameController> {
  const RealnamePage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 30.w),
      if (controller.type == 'realname')
        <Widget>[
          // 国籍
          <Widget>[
            TextWidget.body('国籍'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            <Widget>[
              <Widget>[
                TextWidget.body(
                  controller.country.isNotEmpty ? controller.country : '请选择国籍'.tr,
                  size: 28.sp,
                  color: controller.country.isNotEmpty ? AppTheme.color000 : AppTheme.color999,
                ),
              ].toRow(),
              Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color000),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                .paddingHorizontal(30.w)
                .height(90.w)
                .backgroundColor(AppTheme.blockTwoBgColor)
                .clipRRect(all: 10.w)
                .marginOnly(bottom: 30.w)
                .onTap(() {
              controller.goCountrySetting();
            }),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

          // 姓名
          <Widget>[
            TextWidget.body('姓名'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            <Widget>[
              InputWidget(
                placeholder: "请输入姓名".tr,
                controller: controller.realNameController,
              ).expanded(),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                .paddingHorizontal(30.w)
                .height(90.w)
                .backgroundColor(AppTheme.blockTwoBgColor)
                .clipRRect(all: 10.w)
                .marginOnly(bottom: 30.w),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

          // 身份证号
          <Widget>[
            TextWidget.body('身份证号'.tr, size: 30.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            <Widget>[
              InputWidget(
                placeholder: "请输入身份证号".tr,
                controller: controller.idCardController,
              ).expanded(),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                .paddingHorizontal(30.w)
                .height(90.w)
                .backgroundColor(AppTheme.blockTwoBgColor)
                .clipRRect(all: 10.w),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ].toColumn().paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w),

      // 头像
      if (controller.type != 'realname')
        <Widget>[
          <Widget>[
            TextWidget.body('头像面'.tr, size: 28.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            TextWidget.body('上传您的身份证头像面'.tr, size: 24.sp, color: AppTheme.color999),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          <Widget>[
            ImgWidget(
              path: controller.idCardFrontFile != null ? controller.idCardFrontFile! : 'assets/images/mine15.png',
              width: 292.w,
              height: 202.w,
            ),
          ].toStack().tight(width: 292.w, height: 202.w).onTap(() {
            controller.changeIdCardFront(1);
          })
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingAll(30.w)
            .tight(width: 690.w, height: 262.w)
            .backgroundColor(AppTheme.blockBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 20.w, top: 20.w),

      // 国徽
      if (controller.type != 'realname')
        <Widget>[
          <Widget>[
            TextWidget.body('国徽面'.tr, size: 28.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            TextWidget.body('上传您的身份证国徽面'.tr, size: 24.sp, color: AppTheme.color999),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          <Widget>[
            ImgWidget(
              path: controller.idCardBackFile != null ? controller.idCardBackFile! : 'assets/images/mine15.png',
              width: 292.w,
              height: 202.w,
            ),
          ].toStack().tight(width: 292.w, height: 202.w).onTap(() {
            controller.changeIdCardFront(2);
          })
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingAll(30.w)
            .tight(width: 690.w, height: 262.w)
            .backgroundColor(AppTheme.blockBgColor)
            .clipRRect(all: 10.w),

      // 面部照片
      if (controller.type != 'realname')
        <Widget>[
          <Widget>[
            TextWidget.body('面部照片'.tr, size: 28.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
            TextWidget.body('上传您的面部照片'.tr, size: 24.sp, color: AppTheme.color999),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          <Widget>[
            ImgWidget(
              path: controller.idCardHandFile != null ? controller.idCardHandFile! : 'assets/images/mine15.png',
              width: 292.w,
              height: 202.w,
            ),
          ].toStack().tight(width: 292.w, height: 202.w).onTap(() {
            controller.changeIdCardFront(3);
          })
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingAll(30.w)
            .tight(width: 690.w, height: 262.w)
            .backgroundColor(AppTheme.blockBgColor)
            .clipRRect(all: 10.w),

      SizedBox(height: 100.w),
      // 确认按钮
      ButtonWidget(
        text: '完成'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: () {
          controller.submit();
        },
      ),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RealnameController>(
      init: RealnameController(),
      id: "realname",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: controller.type == 'realname' ? '实名认证'.tr : '高级认证'.tr,
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
