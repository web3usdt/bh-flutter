import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class DownloadAppPage extends GetView<DownloadAppController> {
  const DownloadAppPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      <Widget>[
        TDImage(
          assetUrl: "assets/img/downBg.png",
          width: 750.sp,
          height: 1070.sp,
          type: TDImageType.square,
        ),
        <Widget>[
          TextWidget.body(
            '开启挖矿之旅，坐享丰厚财富',
            size: 24.sp,
            color: Colors.white,
          ),
        ]
            .toRow(
              mainAxisAlignment: MainAxisAlignment.center,
            )
            .paddingTop(790.w),
      ].toStack().tight(width: 750.w, height: 1070.w),
      SizedBox(height: 160.w),
      TDImage(
        assetUrl: "assets/img/down-ios.png",
        width: 420.w,
        height: 102.w,
        type: TDImageType.square,
      ).onTap(() {
        controller.downloadApp("ios");
      }),
      SizedBox(height: 30.w),
      TDImage(
        assetUrl: 'assets/img/down-android.png',
        width: 420.w,
        height: 102.w,
        type: TDImageType.square,
      ).onTap(() {
        controller.downloadApp("android");
      }),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadAppController>(
      init: DownloadAppController(),
      id: "download_app",
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _buildView(),
        );
      },
    );
  }
}
