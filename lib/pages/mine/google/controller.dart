import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class GoogleController extends GetxController {
  GoogleController();
  // 二维码key
  final GlobalKey qrKey = GlobalKey();
  // 谷歌验证器二维码
  UserGoogleTokenModel googleToken = UserGoogleTokenModel();
  // 二维码内容
  String qrCodeContent = '';
  // 是否保存密钥
  bool isSaveSecret = false;

  // 切换保存密钥
  void switchSaveSecret() {
    isSaveSecret = !isSaveSecret;
    update(["google"]);
  }

  _initData() async {
    googleToken = await UserApi.getGoogleToken();
    qrCodeContent = googleToken.qrcodeUrl ?? '';
    update(["google"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
