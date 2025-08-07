import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class UserinfoPage extends GetView<UserinfoController> {
  const UserinfoPage({super.key});

  // 头像
  Widget _buildAvatar() {
    return <Widget>[
      <Widget>[
        ImgWidget(
          path: 'assets/images/home1.png',
          width: 100.w,
          height: 100.w,
          radius: 50.w,
        ),
        SizedBox(
          width: 30.w,
        ),
        <Widget>[
          TextWidget.body(
            '${controller.userInfo.username}',
            size: 32.sp,
          ),
          SizedBox(
            height: 20.w,
          ),
          <Widget>[
            TextWidget.body(
              'UID:${controller.userInfo.userId}',
              size: 24.sp,
              color: AppTheme.color999,
            ),
            SizedBox(
              width: 10.w,
            ),
            Icon(
              Icons.copy,
              size: 24.sp,
              color: AppTheme.color999,
            )
          ].toRow().onTap(() {
            ClipboardUtils.copy(controller.userInfo.userId.toString());
          })
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
      ].toRow(),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingVertical(40.w).paddingHorizontal(30.w);
  }

  // 安全中心
  Widget _buildSecurityCenter() {
    return <Widget>[
      TextWidget.body(
        '安全中心'.tr,
        size: 32.sp,
        color: AppTheme.color000,
      ).padding(left: 30.w),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine1.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '实名认证'.tr,
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed(AppRoutes.realNameList);
        }),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine2.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '登录密码'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          controller.navigateToEditPassword('login');
        }),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine3.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '交易密码'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          controller.navigateToEditPassword('pay');
        }),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine4.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '谷歌验证器'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          controller.handleGoogleAuthClick();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 40.w),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine3.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '提现安全'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed('/withdrawSetupPage');
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 40.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  // 更多功能
  Widget _buildMoreFunction() {
    return <Widget>[
      TextWidget.body(
        '更多功能'.tr,
        size: 32.sp,
        color: AppTheme.color000,
      ).padding(left: 30.w),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine5.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '我的委托'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed(AppRoutes.myAuthorize);
        }),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine6.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '提币地址'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed(AppRoutes.withdrawAddress);
        }),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine7.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '消息通知'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed(AppRoutes.noticeList);
        }),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine8.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '联系客服'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed(AppRoutes.customerService);
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 40.w),
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine7.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            '关于APP'.tr,
            size: 24.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.center,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w),
        <Widget>[
          ImgWidget(
            path: 'assets/images/mine8.png',
            width: 48.w,
            height: 48.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body('设置'.tr, size: 24.sp, color: AppTheme.color000, textAlign: TextAlign.center),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).onTap(() {
          Get.toNamed(AppRoutes.setup);
        }),
        switch (ConfigService.buildMode) {
          BuildMode.dev => <Widget>[
              TextWidget.body('开发模式'.tr, size: 30.sp, color: AppTheme.color000, textAlign: TextAlign.center),
              SizedBox(height: 20.w),
              TextWidget.body(ConfigService.to.curEnv.value.name)
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(170.w).clipRRect(all: 10.w).onTap(() {
              Get.toNamed(AppRoutes.developMode);
            }),
          BuildMode.prod || BuildMode.test => <Widget>[].toColumn().width(170.w),
        },
        SizedBox(width: 170.w)
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 40.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  // 退出登录
  Widget _buildLogout() {
    return <Widget>[
      ButtonWidget(
        text: '退出登录'.tr,
        width: 690,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        textColor: Colors.white,
        onTap: () {
          controller.onLogout();
        },
      )
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildAvatar(),
      TDDivider(
        height: 16.w,
        color: AppTheme.dividerColor,
      ),
      SizedBox(
        height: 40.w,
      ),
      _buildSecurityCenter(),
      SizedBox(
        height: 60.w,
      ),
      _buildMoreFunction(),
      SizedBox(
        height: 160.w,
      ),
      _buildLogout(),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserinfoController>(
      init: UserinfoController(),
      id: "userinfo",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '个人中心'.tr,
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
