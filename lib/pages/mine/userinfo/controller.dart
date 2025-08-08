import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/common/services/logout.dart';

class UserinfoController extends GetxController {
  UserinfoController();
  // 用户信息
  User userInfo = User();

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  Future<void> _initData() async {
    update(["userInfo"]);
  }

  // 加载缓存数据
  Future<void> _loadCacheData() async {
    final stringUserInfo = Storage().getString('userInfo');
    userInfo = stringUserInfo != "" ? User.fromJson(jsonDecode(stringUserInfo)) : User();
    update(["userInfo"]);
  }

  // 处理谷歌验证器点击
  void handleGoogleAuthClick() async {
    try {
      final res = await UserApi.getUserInfo();
      debugPrint('获取到的用户谷歌状态: ${res.googleStatus}');
      if (res.googleStatus == 1) {
        Get.toNamed(AppRoutes.googleUnbind);
      } else {
        Get.toNamed(AppRoutes.google);
      }
    } catch (e) {
      debugPrint('检查谷歌状态时出错: $e');
      Loading.toast('检查用户状态失败，请稍后重试'.tr);
    }
  }

  // 跳转到修改密码页面
  void navigateToEditPassword(String type) async {
    try {
      // Loading.show();
      // final userInfo = await UserApi.getUserInfo();
      // Loading.dismiss();
      Get.toNamed(AppRoutes.editPassword, arguments: {
        'type': type,
        // 'isGoogleAuthEnabled': userInfo.googleStatus == 1,
        'isGoogleAuthEnabled': false,
      });
    } catch (e) {
      Loading.dismiss();
    }
  }

  // 退出登录
  void onLogout() {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
            title: '退出登录'.tr,
            description: '确定退出登录吗？'.tr,
            confirmText: '确定'.tr,
            cancelText: '取消'.tr,
            onConfirm: () async {
              LogoutService.logout();
            });
      },
    );
  }
}
