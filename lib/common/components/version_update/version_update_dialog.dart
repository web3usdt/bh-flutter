import 'package:happy/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';

class VersionUpdateDialog extends StatelessWidget {
  final String? version;
  final String? description;
  final String? apkUrl;
  final int isForce;
  final VoidCallback? onCancel;
  final RxBool isDownloading;
  final RxDouble downloadProgress;
  final Function() onUpdate;

  const VersionUpdateDialog({
    super.key,
    this.version,
    this.description,
    this.apkUrl,
    this.isForce = 0,
    this.onCancel,
    required this.isDownloading,
    required this.downloadProgress,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.pageBgColor,
      elevation: 0,
      child: Container(
        width: 590.w,
        decoration: BoxDecoration(
          color: AppTheme.blockBgColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TDImage(
                  assetUrl: 'assets/img/update.png',
                  width: 590.w,
                  height: 280.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.w),
                TextWidget.body(
                  '发现新版本'.tr,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.w),
                TextWidget.body(
                  version ?? '',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.w),
                Container(
                  width: 530.w,
                  padding: EdgeInsets.all(30.w),
                  decoration: BoxDecoration(
                    color: AppTheme.blockTwoBgColor,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: TextWidget.body(
                    description ?? '',
                    size: 24.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.w),
                Obx(
                  () => isDownloading.value
                      ? Container(
                          width: 530.w,
                          height: 88.w,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          alignment: Alignment.center,
                          child: TextWidget.body(
                            '${'下载中'.tr} ${downloadProgress.value.toInt()}%',
                            color: Colors.black,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : TDButton(
                          text: '立即更新'.tr,
                          isBlock: true,
                          width: 530.w,
                          height: 88.w,
                          margin: const EdgeInsets.all(0),
                          style: TDButtonStyle(
                            backgroundColor: AppTheme.primary,
                            textColor: AppTheme.colorfff,
                            radius: BorderRadius.circular(20.w),
                          ),
                          onTap: onUpdate,
                        ),
                ),
                SizedBox(height: 30.w),
              ],
            ),
            if (isForce == 0)
              Positioned(
                right: 20.w,
                top: 20.w,
                child: GestureDetector(
                  onTap: () {
                    onCancel?.call();
                    Get.back();
                  },
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
