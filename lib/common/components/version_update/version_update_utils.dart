import 'dart:io';
import 'package:dio/dio.dart';
import 'package:happy/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_installer/app_installer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'version_update_dialog.dart';

class VersionUpdateUtil {
  static final RxDouble downloadProgress = 0.0.obs;
  static final RxBool isDownloading = false.obs;

  // 检查并显示更新
  static void checkUpdate({
    required String currentVersion,
    required String latestVersion,
    required String description,
    required String apkUrl,
    required int isForce,
  }) {
    if (_shouldUpdate(currentVersion, latestVersion)) {
      _showUpdateDialog(
        version: latestVersion,
        description: description,
        apkUrl: apkUrl,
        isForce: isForce,
      );
    }
  }

  // 显示更新弹窗
  static void _showUpdateDialog({
    required String version,
    required String description,
    required String apkUrl,
    required int isForce,
  }) {
    Get.dialog(
      VersionUpdateDialog(
        version: version,
        description: description,
        apkUrl: apkUrl,
        isForce: isForce,
        isDownloading: isDownloading,
        downloadProgress: downloadProgress,
        onUpdate: () => _downloadAndInstallApk(apkUrl),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      useSafeArea: true,
    );
  }

  // 下载并安装APK
  static Future<void> _downloadAndInstallApk(String apkUrl) async {
    if (isDownloading.value) return;

    try {
      isDownloading.value = true;

      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        Loading.error('无法获取存储目录');
        return;
      }

      final apkPath = '${dir.path}/app-update.apk';

      await Dio().download(
        apkUrl,
        apkPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = ((received / total) * 100).roundToDouble();
          }
        },
      );

      if (Platform.isAndroid) {
        await AppInstaller.installApk(apkPath);
      } else {
        Loading.error('仅支持Android设备');
      }

      isDownloading.value = false;
      Get.back();
    } catch (e) {
      isDownloading.value = false;
      downloadProgress.value = 0;
      Loading.error('下载失败：$e');
    }
  }

  // 比较版本号
  static bool _shouldUpdate(String currentVersion, String latestVersion) {
    List<int> current = currentVersion.split('.').map((e) => int.parse(e)).toList();
    List<int> latest = latestVersion.split('.').map((e) => int.parse(e)).toList();

    for (int i = 0; i < current.length && i < latest.length; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }

    return latest.length > current.length;
  }

  // 显示服务器返回的更新对话框
  static void showUpdateDialogFromServer({
    required String version,
    required String description,
    required String url,
    required int isForce,
  }) {
    Get.dialog(
      VersionUpdateDialog(
        version: version,
        description: description,
        apkUrl: url,
        isForce: isForce,
        isDownloading: isDownloading,
        downloadProgress: downloadProgress,
        onUpdate: () => _launchUpdateUrl(url),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      useSafeArea: true,
    );
  }

  // 打开更新链接
  static Future<void> _launchUpdateUrl(String url) async {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Loading.error('无法打开链接');
    }
  }
}
