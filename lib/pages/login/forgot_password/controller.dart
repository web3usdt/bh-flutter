import 'package:BBIExchange/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController();
  // 注册类型
  String registerType = 'email';
  // 手机区域
  String phoneArea = '+86';
  // 手机区域id
  int phoneAreaId = 0;
  // 手机号
  TextEditingController phoneController = TextEditingController();
  // 验证码
  TextEditingController codeController = TextEditingController();
  // 谷歌验证码
  TextEditingController googleCodeController = TextEditingController();
  // 密码
  TextEditingController passwordController = TextEditingController();
  // 确认密码
  TextEditingController confirmPasswordController = TextEditingController();

  List<UserCountrylistModel> countryList = [];
  bool showGoogleAuth = false;

  _initData() async {
    // 获取国家列表
    countryList = await UserApi.getCountryList();
    phoneAreaId = countryList.first.id ?? 0;
    update(["forgot_password"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    phoneController.dispose();
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    googleCodeController.dispose();
  }

  // 切换注册类型
  void switchRegisterType() {
    registerType = registerType == 'phone' ? 'email' : 'phone';
    phoneController.clear();
    codeController.clear();
    googleCodeController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    showGoogleAuth = false;
    update(["forgot_password"]);
  }

  // 注册
  void onConfirm() async {
    if (registerType == 'phone' && phoneController.text.isEmpty) return Loading.toast('请输入手机号'.tr);
    if (registerType == 'phone' && !RegExp(r'^1[3-9]\d{9}$').hasMatch(phoneController.text)) return Loading.toast('请输入正确的手机号'.tr);
    if (registerType == 'email' && phoneController.text.isEmpty) return Loading.toast('请输入邮箱号'.tr);
    if (registerType == 'email' && !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(phoneController.text))
      return Loading.toast('请输入正确的邮箱格式'.tr);
    if (showGoogleAuth && googleCodeController.text.isEmpty) {
      return Loading.toast('请输入谷歌验证码'.tr);
    }
    if (passwordController.text.isEmpty) return Loading.toast('请输入密码'.tr);
    if (confirmPasswordController.text.isEmpty) return Loading.toast('请输入确认密码'.tr);
    if (confirmPasswordController.text != passwordController.text) return Loading.toast('密码不一致'.tr);
    Loading.show();
    try {
      await LoginApi.forgetPassword(
        phoneController.text,
        codeController.text,
        passwordController.text,
        false,
        googleCode: showGoogleAuth ? googleCodeController.text : null,
      );
      Loading.dismiss();
      Loading.success('修改成功'.tr);
      Get.back();
    } on DioException catch (e) {
      Loading.dismiss();
      final errorData = e.response?.data;
      if (errorData != null && errorData['code'] == 4001) {
        showGoogleAuth = true;
        update(['forgot_password']);
        Loading.toast(errorData['message'] ?? '请输入谷歌验证码'.tr);
      } else {
        Loading.error(errorData?['message'] ?? '操作失败'.tr);
      }
    } catch (e) {
      Loading.dismiss();
      Loading.error('未知错误'.tr);
    }
  }

  // 发送手机验证码
  Future<bool> sendPhoneCode() async {
    if (registerType == 'email') {
      if (phoneController.text.isEmpty) {
        Loading.toast('请输入邮箱号'.tr);
        return false;
      }
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(phoneController.text)) {
        Loading.toast('请输入正确的邮箱格式'.tr);
        return false;
      }
      Loading.show();
      var res = await LoginApi.sendEmailCodeForgetPassword(phoneController.text, 'yellow-plain');
      if (res) {
        Loading.success('发送成功'.tr);
        return true;
      } else {
        return false;
      }
    } else {
      if (phoneController.text.isEmpty) {
        Loading.toast('请输入手机号'.tr);
        return false;
      }
      if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(phoneController.text)) {
        Loading.toast('请输入正确的手机号'.tr);
        return false;
      }
      Loading.show();
      var res = await LoginApi.sendEmailCodeForgetPassword(phoneController.text, 'yellow-plain');
      if (res) {
        Loading.success('发送成功'.tr);
        return true;
      } else {
        return false;
      }
    }
  }

  // 切换手机区域
  void switchPhoneArea() {
    PickerUtils.showPicker(
      context: Get.context!,
      title: '请选择'.tr,
      items: countryList.map((e) => {'id': e.id, 'name': '+${e.countryCode ?? ''}'}).toList(),
      alignment: MainAxisAlignment.center,
      onConfirm: (selected) {
        phoneAreaId = selected['id'] ?? 0;
        phoneArea = selected['name'] ?? '';
        update(['forgot_password']);
      },
      onCancel: () {},
    );
  }
}
