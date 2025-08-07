import 'package:happy/common/index.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class StartController extends GetxController {
  StartController();

  _jumpToPage() {
    // 延迟1秒
    // Future.delayed(const Duration(seconds: 1)).then((_) {
    // 是否首次打开app
    if (!ConfigService.to.isAlreadyOpen) {
      // 首次打开app
    }

    // 第一次打开app，标记已打开
    ConfigService().setAlreadyOpen();

    var token = Storage().getString('token');
    if (PlatformUtils().isWeb) {
      if (token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      if (token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    }

    // });
  }

  _initData() {
    update(["start"]);

    _jumpToPage();
  }

  @override
  void onReady() {
    super.onReady();
    FlutterNativeSplash.remove(); // 移除启动图
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
