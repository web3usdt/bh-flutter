import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:happy/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController();
  // 语言
  String language = '';
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController googleCodeController = TextEditingController();
  // 登录历史
  List<LoginHistoryModel> loginHistoryList = [];
  // 账号历史
  List<String> accountHistory = [];
  // 是否切换
  bool isSwitch = false;

  // 用户信息
  User userInfo = User();
  // token
  String token = '';
  // signature
  String signature = '';

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    accountController.dispose();
    passwordController.dispose();
    googleCodeController.dispose();
  }

  _initData() async {
    // 获取参数
    try {
      // 先判断 Get.arguments 是否为 null
      final args = Get.arguments;
      isSwitch = args != null ? args['isSwitch'] ?? false : false;
      // print('isSwitch:----- $isSwitch');
    } catch (e) {
      // 如果出现异常，设置默认值
      isSwitch = false;
    }
    // 获取登录历史
    final stringLoginHistoryList = Storage().getString('loginHistoryList');
    loginHistoryList = stringLoginHistoryList != ""
        ? jsonDecode(stringLoginHistoryList).map<LoginHistoryModel>((item) {
            return LoginHistoryModel.fromJson(item);
          }).toList()
        : [];
    accountHistory = loginHistoryList.map((e) => e.account ?? "").toSet().toList();
    // 延迟1秒设置系统样式
    Future.delayed(const Duration(seconds: 1), () {
      AppTheme.setSystemStyle();
    });
    update(["login"]);
  }

  // 登录
  void submit() async {
    if (accountController.text.isEmpty) return Loading.toast('请输入账号'.tr);
    if (passwordController.text.isEmpty) return Loading.toast('请输入登录密码'.tr);
    // 1手机号，2邮箱
    int type = accountController.text.contains('@') ? 2 : 1;
    Loading.show();
    try {
      var res = await LoginApi.login(
        LoginReq(
          account: accountController.text,
          password: passwordController.text,
          type: type,
        ),
        showErrorToast: false,
      );
      _handleLoginSuccess(res);
    } on DioException catch (e) {
      _handleLoginError(e);
    }
    update(["login"]);
  }

  void _handleLoginError(DioException e) async {
    final errorData = e.response?.data;

    if (errorData != null && errorData is Map && errorData['code'] == 1021) {
      signature = errorData['data']['signature'];
      Loading.dismissImmediately();
      _showGoogleAuthDialog();
    } else if (errorData != null && errorData is Map && errorData['code'] == 1001) {
      Loading.dismissImmediately();
    } else {
      final String message = e.error ?? (errorData != null ? errorData['message'] : '登陆失败');
      Loading.error(message);
    }
  }

  // 二次验证弹窗
  void _showGoogleAuthDialog() {
    DialogWidget.show(
      title: '谷歌验证'.tr,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InputWidget(
            placeholder: '请输入谷歌验证码'.tr,
            controller: googleCodeController,
          ),
        ],
      ),
      onConfirm: _loginWith2FA,
    );
  }

  // 二次验证登录
  void _loginWith2FA() async {
    if (googleCodeController.text.isEmpty) {
      return Loading.toast('请输入谷歌验证码'.tr);
    }
    Loading.show();
    try {
      var res = await LoginApi.loginConfirm(LoginConfirmReq(
        code: googleCodeController.text,
        codeType: 3,
        signature: signature,
      ));
      _handleLoginSuccess(res);
    } finally {
      googleCodeController.clear();
      Loading.dismiss();
    }
  }

  // 处理登录成功
  void _handleLoginSuccess(LoginModel res) async {
    if (res.token!.isNotEmpty) {
      token = res.token!;
      userInfo = res.user!;
      await Storage().setString('token', token);
      await Storage().setJson('userInfo', userInfo);

      // 登录成功后初始化并连接WebSocket
      await SocketService().init();
      SocketService().connect();

      // 同时初始化并连接WebSocket2
      await SocketService2().init();
      SocketService2().connect();

      // 同时初始化并连接WebSocket3
      await SocketService3().init();
      SocketService3().connect();

      // 如果登录历史不为空，筛选account是否有重复的则删除，否则正常添加
      if (loginHistoryList.isNotEmpty) {
        loginHistoryList.removeWhere((element) => element.account == accountController.text);
      }
      // 本地存入登录历史
      loginHistoryList.add(LoginHistoryModel(
        password: passwordController.text,
        account: accountController.text,
        avatar: userInfo.avatar,
      ));
      await Storage().setJson('loginHistoryList', loginHistoryList);

      Loading.success('登录成功'.tr);
      if (isSwitch) {
        Get.until((route) => route.settings.name == AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  // 切换语言
  void setLanguageSetting() async {
    final List<Map<String, dynamic>> languageList = [
      {
        'id': 0,
        'name': '简体中文',
      },
      {'id': 1, 'name': '繁体中文'},
      {'id': 2, 'name': 'English'},
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
