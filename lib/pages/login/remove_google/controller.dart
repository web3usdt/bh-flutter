import 'package:BBIExchange/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveGoogleController extends GetxController {
  RemoveGoogleController();
  // 手机号
  TextEditingController phoneController = TextEditingController();
  // 验证码
  TextEditingController codeController = TextEditingController();

  _initData() async {
    // 获取国家列表
    update(["remove_google"]);
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
  }

  // 解绑谷歌验证器
  void unbindGoogle() async {
    if (phoneController.text.isEmpty) return Loading.toast('请输入邮箱号'.tr);
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(phoneController.text)) return Loading.toast('请输入正确的邮箱格式'.tr);
    if (codeController.text.isEmpty) return Loading.toast('请输入验证码'.tr);
    Loading.show();
    var res = await UserApi.unbindGoogle2(phoneController.text, codeController.text);
    if (res) {
      Loading.success('提交成功'.tr);
      Storage().setBool('withdrawVerifyIsEmail', true);
      Get.back();
    }
  }

  // 发送手机验证码
  Future<bool> sendPhoneCode() async {
    if (phoneController.text.isEmpty) {
      Loading.toast('请输入邮箱号'.tr);
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(phoneController.text)) {
      Loading.toast('请输入正确的邮箱格式'.tr);
      return false;
    }
    Loading.show();
    var res = await UserApi.getUnbindGoogleCode(phoneController.text);
    if (res) {
      Loading.success('发送成功'.tr);
      return true;
    } else {
      return false;
    }
  }
}
