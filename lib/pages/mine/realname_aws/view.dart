import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:camera/camera.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class RealnameAwsPage extends GetView<RealnameAwsController> {
  const RealnameAwsPage({super.key});

  // 相机预览
  Widget _buildCameraPreview() {
    if (controller.cameraController == null || !controller.cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: controller.cameraController!.value.aspectRatio,
      child: CameraPreview(controller.cameraController!),
    );
  }

  // 状态显示
  Widget _buildStatus() {
    return <Widget>[
      TextWidget.body(controller.status, size: 24.sp, color: AppTheme.colorfff),
    ].toRow().paddingAll(30.w).decorated(
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(width: 1, color: AppTheme.colorGreen),
        );
  }

  // 检测详情
  Widget _buildDetectionDetails() {
    return <Widget>[
      TextWidget.body('检测详情'.tr, size: 24.sp, color: AppTheme.colorfff),
      SizedBox(height: 20.w),
      TextWidget.body(
        controller.detectionDetails,
        size: 24.sp,
        color: AppTheme.colorfff,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 20.w),
    ].toRow().paddingAll(30.w).decorated(
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(width: 1, color: AppTheme.colorGreen),
        );
  }

  // 操作按钮
  Widget _buildActionButtons() {
    return ButtonWidget(
      text: '开始检测'.tr,
      backgroundColor: AppTheme.colorGreen,
      borderRadius: 44,
      width: 690,
      height: 88,
      onTap: () {
        controller.startDetectionFlow();
      },
    );
  }

  // 结果展示
  Widget _buildResult() {
    if (!controller.isPassed) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 60.w,
          ),
          SizedBox(height: 10.w),
          Text(
            '活体检测通过'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.w),
          ButtonWidget(
            text: '完成'.tr,
            backgroundColor: AppTheme.colorGreen,
            borderRadius: 44,
            height: 88,
            onTap: () {
              Get.until((route) => route.settings.name == AppRoutes.userinfo);
            },
          ),
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildCameraPreview().tight(width: 500.w, height: 600.w).clipRRect(all: 250.w),
      <Widget>[
        _buildStatus().marginOnly(top: 40.w),
        _buildDetectionDetails().marginOnly(top: 20.w),
        _buildActionButtons().marginOnly(top: 20.w),
        _buildResult().marginOnly(top: 20.w),
      ].toColumn().paddingHorizontal(30.w)
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RealnameAwsController>(
      init: RealnameAwsController(),
      id: "realname_aws",
      builder: (_) {
        return Scaffold(
          appBar: TDNavBar(
            height: 44,
            title: '人脸识别'.tr,
            titleColor: Colors.white,
            titleFontWeight: FontWeight.w600,
            backgroundColor: Colors.black,
            screenAdaptation: true,
            useDefaultBack: false,
            leftBarItems: [
              TDNavBarItem(
                  icon: TDIcons.chevron_left,
                  iconSize: 24,
                  iconColor: AppTheme.colorfff,
                  action: () {
                    Get.back();
                  }),
            ],
            rightBarItems: [
              TDNavBarItem(
                  icon: Icons.flip_camera_ios,
                  iconSize: 24,
                  iconColor: AppTheme.colorfff,
                  action: () {
                    controller.switchCamera();
                  }),
            ],
          ),
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              child: _buildView(),
            ),
          ),
        );
      },
    );
  }
}
