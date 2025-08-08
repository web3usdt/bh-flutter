import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class GoogleUnbindController extends GetxController {
  GoogleUnbindController();

  User userInfo = User();

  // 谷歌验证码
  final TextEditingController codeController = TextEditingController();
  // 邮箱验证码
  final TextEditingController emailCodeController = TextEditingController();

  int countDown = 0;
  Timer? _timer;
  // 用于持久化存储倒计时过期时间戳的 Key
  static const String _kCountdownExpiryKey = 'google_unbind_code_expiry';

  _initData() async {
    var stringUserInfo = Storage().getString('userInfo');
    userInfo = stringUserInfo != "" ? User.fromJson(jsonDecode(stringUserInfo)) : User();
    _initCountdown();
    update(["google_unbind"]);
  }

  // 获取邮箱验证码, 300s后才能再次获取
  void getEmailCode() async {
    if (countDown > 0) return;

    Loading.show();
    var res = await UserApi.getEmailCode();
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
      update(["google_unbind"]);
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

  // 解绑谷歌验证器
  void unbindGoogle() async {
    if (codeController.text.isEmpty) return Loading.toast('请输入谷歌验证码'.tr);
    if (emailCodeController.text.isEmpty) return Loading.toast('请输入邮箱验证码'.tr);
    Loading.show();
    var res = await UserApi.unbindGoogle(UserGoogleUnbindReq(
      googleCode: codeController.text,
      emailCode: emailCodeController.text,
    ));
    if (res) {
      Loading.success('解绑成功'.tr);
      Storage().setBool('withdrawVerifyIsEmail', true);
      Get.back();
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    codeController.dispose();
    emailCodeController.dispose();
  }
}
