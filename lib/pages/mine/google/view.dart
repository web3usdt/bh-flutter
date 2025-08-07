import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class GooglePage extends GetView<GoogleController> {
  const GooglePage({super.key});

  // 二维码
  Widget _buildQrCode() {
    return <Widget>[
      <Widget>[
        QrImageView(
          data: controller.qrCodeContent,
          version: QrVersions.auto,
          size: 320.w,
          gapless: false,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).tight(width: 365.w, height: 365.w).backgroundColor(Colors.white).clipRRect(all: 30.w),
      SizedBox(height: 60.w),
      <Widget>[
        TextWidget.body(
          '密钥'.tr,
          size: 28.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          controller.googleToken.secret ?? '',
          size: 28.sp,
          color: AppTheme.color000,
          weight: FontWeight.w600,
        ),
        Icon(
          Icons.content_copy_rounded,
          size: 20,
          color: AppTheme.color000,
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(100.w)
          .backgroundColor(AppTheme.blockTwoBgColor)
          .clipRRect(all: 10.w)
          .marginOnly(bottom: 30.w)
          .onTap(() {
        ClipboardUtils.copy(controller.googleToken.secret ?? '');
        Loading.success('复制成功'.tr);
      }),
      TextWidget.body(
        '下载并打开谷歌验证器，扫描下方二维码或手动输入秘钥添加验证令牌。'.tr,
        size: 28.sp,
        color: AppTheme.colorRed,
      ),
    ].toColumn().width(690.w).paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 30.w),
      _buildQrCode(),
      SizedBox(height: 200.w),
      <Widget>[
        Icon(
          Icons.check_circle,
          size: 32.sp,
          color: controller.isSaveSecret ? AppTheme.primary : AppTheme.color999,
        ),
        TextWidget.body(
          '我已经妥善保存密钥，丢失后将不可找回'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center).onTap(() {
        controller.switchSaveSecret();
      }),
      SizedBox(height: 40.w),
      // 确认按钮
      ButtonWidget(
        text: '下一步'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        disabled: !controller.isSaveSecret,
        onTap: () {
          Get.toNamed(AppRoutes.googleBind, arguments: {
            'secret': controller.googleToken.secret,
          });
        },
      ),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoogleController>(
      init: GoogleController(),
      id: "google",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '谷歌验证器'.tr,
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
