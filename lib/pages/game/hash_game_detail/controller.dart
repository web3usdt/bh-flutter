import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

class HashGameDetailController extends GetxController {
  HashGameDetailController();
  GameRecordModel? item;
  final GlobalKey qrKey = GlobalKey();

  _initData() {
    item = Get.arguments['item'];
    print(item?.toJson());
    update(["hash_game_detail"]);
  }

  void onTap() {}

  // 验证区块
  void verifyBlock() async {
    if (item?.blockId != null) {
      final Uri _url = Uri.parse('https://tronscan.org/#/block/${item?.blockId}');
      launchUrl(_url);
    }
  }

  // 修改哈希长短，去前4和后4位，中间展示...
  String modifyHash(String hash) {
    if (hash.length < 8) {
      return hash;
    }
    return '${hash.substring(0, 4)}...${hash.substring(hash.length - 4)}';
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // 分享邀请链接
  void shareInviteUrl() {
    if (item?.inviteUrl != null) {
      Get.dialog(
        Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
            child: <Widget>[
              <Widget>[
                TextWidget.body('分享'.tr, size: 32.sp, color: AppTheme.color000),
                ImgWidget(path: 'assets/images/game11.png', width: 40.w, height: 40.w).onTap(() {
                  Get.back();
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 30.w),
              RepaintBoundary(
                  key: qrKey,
                  child: <Widget>[
                    ImgWidget(path: 'assets/images/game10.png', width: 690.w, height: 880.w),
                    <Widget>[
                      TextWidget.body(item?.type == 1 ? '哈希单双3秒钟'.tr : '哈希单双1分钟'.tr, size: 24.sp, color: AppTheme.color000),
                      TextWidget.body(item?.result == item?.expect ? '胜'.tr : '负'.tr, size: 48.sp, color: AppTheme.color000, weight: FontWeight.w600),
                      SizedBox(height: 60.w),
                      <Widget>[
                        <Widget>[
                          <Widget>[
                            TextWidget.body('+${item?.amount ?? ''} ${item?.coinName ?? ''}', size: 28.sp, color: AppTheme.colorGreen),
                            SizedBox(height: 10.w),
                            TextWidget.body('下单金额'.tr, size: 24.sp, color: AppTheme.color999),
                          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(270.w),
                          <Widget>[
                            TextWidget.body('${item?.win ?? ''} ${item?.coinName ?? ''}', size: 28.sp, color: AppTheme.color000),
                            SizedBox(height: 10.w),
                            TextWidget.body('返还金额'.tr, size: 24.sp, color: AppTheme.color999),
                          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
                        ].toRow(),
                        SizedBox(height: 30.w),
                        <Widget>[
                          <Widget>[
                            <Widget>[
                              TextWidget.body(
                                item?.expect == 1 ? '单' : '双',
                                color: AppTheme.colorfff,
                                size: 24.sp,
                              ),
                            ]
                                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                                .tight(width: 52.w, height: 52.w)
                                .backgroundColor(item?.expect == 1 ? AppTheme.colorRed : AppTheme.colorGreen)
                                .clipRRect(all: 26.w),
                            SizedBox(height: 10.w),
                            TextWidget.body('投注区域'.tr, size: 24.sp, color: AppTheme.color999),
                          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(270.w),
                          <Widget>[
                            TextWidget.body('${item?.blockId ?? ''}', size: 28.sp, color: AppTheme.color000),
                            SizedBox(height: 10.w),
                            TextWidget.body('下单区块'.tr, size: 24.sp, color: AppTheme.color999),
                          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
                        ].toRow(),
                        SizedBox(height: 30.w),
                        <Widget>[
                          <Widget>[
                            TextWidget.body(modifyHash(item?.hash ?? ''), size: 28.sp, color: AppTheme.color000),
                            SizedBox(height: 10.w),
                            TextWidget.body('区块哈希'.tr, size: 24.sp, color: AppTheme.color999),
                          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(270.w),
                        ].toRow(),
                      ]
                          .toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                          .paddingOnly(left: 30.w, right: 30.w, top: 50.w, bottom: 30.w)
                          .tight(width: 690.w)
                          .decorated(
                            color: AppTheme.blockBgColor,
                            border: Border.all(color: AppTheme.borderLine, width: 1),
                            borderRadius: BorderRadius.circular(20.w),
                          ),

                      // 二维码
                      SizedBox(height: 40.w),
                      <Widget>[
                        <Widget>[
                          ImgWidget(path: 'assets/icons/ic_logo.png', width: 72.w, height: 72.w),
                          SizedBox(width: 20.w),
                          <Widget>[
                            TextWidget.body('HAPPY', size: 30.sp, color: AppTheme.color000, weight: FontWeight.w600),
                            SizedBox(height: 10.w),
                            TextWidget.body('数字资产交易平台'.tr, size: 20.sp, color: AppTheme.color000),
                          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                        ].toRow(),
                        <Widget>[
                          QrImageView(
                            data: item?.inviteUrl ?? '',
                            version: QrVersions.auto,
                            size: 180.w,
                            gapless: false,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(180.w, 180.w),
                            ),
                          ),
                        ].toRow().backgroundColor(AppTheme.pageBgColor)
                      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, right: 30.w, top: 70.w),
                  ].toStack().tight(width: 690.w)),

              // 保存图片
              SizedBox(height: 30.w),
              <Widget>[
                TextWidget.body('保存分享'.tr, size: 24.sp, color: AppTheme.color000),
                ImgWidget(path: 'assets/images/game12.png', width: 52.w, height: 52.w).onTap(() {
                  saveImage();
                  Get.back();
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            ]
                .toColumn()
                .paddingOnly(
                  left: 30.w,
                  right: 30.w,
                  top: 30.w,
                )
                .tight(height: 1130.w)
                .backgroundColor(AppTheme.pageBgColor)
                .clipRRect(all: 30.w)),
      );
    }
  }

  // 保存图片
  void saveImage() async {
    // 获取 RenderRepaintBoundary
    final boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    print('boundary: $boundary');

    // 等待一下确保UI已经完全渲染
    await Future.delayed(const Duration(milliseconds: 20));

    // 将 Widget 转换成图片
    final image = await boundary.toImage(pixelRatio: 3.0);
    print('image: $image');

    // 将图片转换成字节数据
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print('byteData: $byteData');

    if (byteData != null) {
      final success = await ImageSaverHelper.saveUint8ListImage(byteData.buffer.asUint8List());
      print('success: $success');
    }
  }
}
