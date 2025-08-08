import 'dart:async';

import 'package:BBIExchange/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/pages/login/login/index.dart';

class EditPasswordController extends GetxController {
  EditPasswordController();
  // 类型
  String type = '';
  // 新密码
  TextEditingController newPasswordController = TextEditingController();
  // 确认密码
  TextEditingController confirmPasswordController = TextEditingController();
  // 邮箱验证码
  TextEditingController emailCodeController = TextEditingController();
  // 谷歌验证码
  TextEditingController googleCodeController = TextEditingController();

  bool isGoogleAuthEnabled = false;

  int countDown = 0;
  Timer? _timer;
  // 用于持久化存储倒计时过期时间戳的 Key
  static const String _kCountdownExpiryKey = 'edit_password_code_expiry';

  // 获取邮箱验证码, 300s后才能再次获取
  void getEmailCode() async {
    if (countDown > 0) return;

    Loading.show();
    final res = await UserApi.getEmailCode();
    Loading.dismiss();
    if (!res) return; // 如果请求失败，则不开始倒计时
    Loading.success('验证码已发送'.tr);

    // 计算并存储过期时间戳 (转为字符串)
    final expiryTime = DateTime.now().add(const Duration(seconds: 90)).millisecondsSinceEpoch;
    Storage().setString(_kCountdownExpiryKey, expiryTime.toString());

    // 启动倒计时
    _startCountdown(90);
  }

  // 启动倒计时的方法
  void _startCountdown(int seconds) {
    if (seconds <= 0) return;
    countDown = seconds;
    _timer?.cancel(); // 先取消已有的定时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDown--;
      if (countDown <= 0) {
        _timer?.cancel();
        Storage().remove(_kCountdownExpiryKey); // 倒计时结束，清除存储
      }
      update(["edit_password"]);
    });
  }

  // 从本地存储恢复倒计时状态
  void _initCountdown() {
    final expiryTimeString = Storage().getString(_kCountdownExpiryKey);
    if (expiryTimeString.isEmpty) return;

    final expiryTime = int.tryParse(expiryTimeString);
    if (expiryTime == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (expiryTime > now) {
      final remainingSeconds = ((expiryTime - now) / 1000).round();
      _startCountdown(remainingSeconds);
    } else {
      // 如果已过期，清理一下
      Storage().remove(_kCountdownExpiryKey);
    }
  }

  // 修改登录密码
  void submit() async {
    if (newPasswordController.text.isEmpty) return Loading.toast('请输入新密码'.tr);
    if (confirmPasswordController.text.isEmpty) return Loading.toast('请输入确认密码'.tr);
    if (newPasswordController.text != confirmPasswordController.text) return Loading.toast('两次密码不一致'.tr);
    if (emailCodeController.text.isEmpty) return Loading.toast('请输入邮箱验证码'.tr);
    if (isGoogleAuthEnabled && googleCodeController.text.isEmpty) return Loading.toast('请输入谷歌验证码'.tr);
    Loading.show();
    final res = await UserApi.editLoginPassword(UserEditLoginPasswordReq(
      password: newPasswordController.text,
      passwordConfirmation: confirmPasswordController.text,
      email_code: emailCodeController.text,
      google_code: isGoogleAuthEnabled ? googleCodeController.text : null,
    ));
    Loading.dismiss();
    if (res) {
      Loading.success('修改成功，请重新登录'.tr);
      Get.offAll(() => const LoginPage());
    }
  }

  // 修改交易密码
  void submitTradePassword() async {
    if (newPasswordController.text.isEmpty) return Loading.toast('请输入新密码'.tr);
    if (confirmPasswordController.text.isEmpty) return Loading.toast('请输入确认密码'.tr);
    if (newPasswordController.text != confirmPasswordController.text) return Loading.toast('两次密码不一致'.tr);
    if (emailCodeController.text.isEmpty) return Loading.toast('请输入邮箱验证码'.tr);
    Loading.show();
    final res = await UserApi.editPayPassword(UserEditPayPasswordReq(
      payword: newPasswordController.text,
      paywordConfirmation: confirmPasswordController.text,
      email_code: emailCodeController.text,
    ));
    if (res) {
      Loading.success('修改成功'.tr);
      Get.back();
    }
  }

  Future<void> _initData() async {
    type = Get.arguments['type'];
    isGoogleAuthEnabled = Get.arguments['isGoogleAuthEnabled'] ?? false;
    _initCountdown(); // 初始化时恢复倒计时状态
    update(["edit_password"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel(); // 页面关闭时取消定时器
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    emailCodeController.dispose();
    googleCodeController.dispose();
  }
}
