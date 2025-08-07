import 'package:happy/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slider_captcha/slider_captcha.dart';

class RegisterController extends GetxController {
  RegisterController();
  // 语言
  String language = '';
  // 注册类型
  String registerType = 'email';
  // 手机区域
  String phoneArea = '+86';
  // 手机区域id
  int phoneAreaId = 0;
  // 手机号
  TextEditingController phoneController = TextEditingController(text: '');
  // 验证码
  TextEditingController codeController = TextEditingController();
  // 密码
  TextEditingController passwordController = TextEditingController(text: '');
  // 确认密码
  TextEditingController confirmPasswordController = TextEditingController(text: '');
  // 推荐人
  TextEditingController recommendController = TextEditingController(text: '');
  // 是否同意
  bool isAgree = false;
  List<UserCountrylistModel> countryList = [];
  // 滑块验证控制器
  SliderController sliderController = SliderController();
  // 滑块验证状态
  bool isSliderVerified = false;

  _initData() async {
    // 获取国家列表
    countryList = await UserApi.getCountryList();
    phoneAreaId = countryList.first.id ?? 0;
    update(["register"]);
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
    recommendController.dispose();
  }

  // 切换注册类型
  void switchRegisterType() {
    registerType = registerType == 'phone' ? 'email' : 'phone';
    phoneController.clear();
    codeController.clear();
    update(["register"]);
  }

  // 同意用户协议
  void agreeUserProtocol() {
    isAgree = !isAgree;
    update(["register"]);
  }

  // 注册
  void register() async {
    if (registerType == 'phone' && phoneController.text.isEmpty) return Loading.toast('请输入手机号'.tr);
    if (registerType == 'phone' && !RegExp(r'^1[3-9]\d{9}$').hasMatch(phoneController.text)) return Loading.toast('请输入正确的手机号'.tr);
    if (registerType == 'email' && phoneController.text.isEmpty) return Loading.toast('请输入邮箱号'.tr);
    if (registerType == 'email' && !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(phoneController.text))
      return Loading.toast('请输入正确的邮箱格式'.tr);
    if (passwordController.text.isEmpty) return Loading.toast('请输入密码'.tr);
    if (confirmPasswordController.text.isEmpty) return Loading.toast('请输入确认密码'.tr);
    if (confirmPasswordController.text != passwordController.text) return Loading.toast('密码不一致'.tr);
    if (isAgree == false) return Loading.toast('请先同意用户协议'.tr);

    // 如果还未进行滑块验证，显示滑块验证弹窗
    if (!isSliderVerified) {
      Get.dialog(
        buildSliderCaptcha(Get.context!),
        barrierDismissible: true,
      );
      return;
    }

    // 滑块验证通过后执行注册
    await _performRegister();
  }

  // 执行实际注册逻辑
  Future<void> _performRegister() async {
    Loading.show();
    var res = await LoginApi.register(UserRegisterReq(
        type: registerType == 'phone' ? 1 : 2,
        countryId: phoneAreaId,
        account: phoneController.text,
        code: codeController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        inviteCode: recommendController.text));
    if (res) {
      Loading.success('注册成功'.tr);
      isSliderVerified = false;
      Get.back();
    } else {
      Loading.error('注册失败'.tr);
      isSliderVerified = false;
    }
  }

  // 构建滑块验证弹窗
  Widget buildSliderCaptcha(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        child: SliderCaptcha(
          controller: sliderController,
          title: '请滑动滑块完成验证'.tr,
          image: Image.asset(
            'assets/images/captcha.png', // 使用项目中现有的图片
            fit: BoxFit.fitWidth,
          ),
          colorBar: const Color(0xffffffff), // 使用项目主题色
          colorCaptChar: const Color(0xffffffff), // 拼图块颜色
          onConfirm: (value) async {
            if (value) {
              Loading.success("验证通过".tr);
              Get.back();
              isSliderVerified = true;
              // 验证通过后继续执行注册
              await _performRegister();
            } else {
              // 验证失败，重新生成验证码
              Future.delayed(const Duration(seconds: 1)).then((_) {
                sliderController.create();
              });
              Loading.error("请重试".tr);
            }
          },
        ),
      ),
    );
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
      var res = await LoginApi.sendEmailCode(phoneController.text, 2);
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
      var res = await LoginApi.sendCode(phoneController.text, phoneAreaId, 1);
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
        update(['register']);
      },
      onCancel: () {},
    );
  }

  // 切换语言
  void setLanguageSetting() async {
    final List<Map<String, dynamic>> languageList = [
      {'id': 0, 'name': '简体中文', 'icon': Image.asset('assets/img/home3.png')},
      {'id': 1, 'name': '繁体中文', 'icon': Image.asset('assets/img/home3.png')},
      {'id': 2, 'name': 'English', 'icon': Image.asset('assets/img/home3.png')},
    ];
    PickerUtils.showPicker(
      context: Get.context!,
      title: '选择语言'.tr,
      items: languageList,
      alignment: MainAxisAlignment.center,
      onConfirm: (selected) {
        language = selected['name'] ?? '';
        var zh = Translation.supportedLocales[0];
        var tw = Translation.supportedLocales[1];
        var en = Translation.supportedLocales[2];
        if (language == "简体中文") {
          ConfigService.to.setLanguage(zh);
        } else if (language == "繁体中文") {
          ConfigService.to.setLanguage(tw);
        } else if (language == "English") {
          ConfigService.to.setLanguage(en);
        }
        update(['mine']);
      },
      onCancel: () {},
    );
  }
}
