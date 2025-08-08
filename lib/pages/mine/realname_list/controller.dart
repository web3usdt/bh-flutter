import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class RealnameListController extends GetxController {
  RealnameListController();
  // 用户信息
  UserAuthinfoModel userAuthInfo = UserAuthinfoModel();

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    userAuthInfo = await UserApi.getUserAuthInfo();
    print('用户认证信息: ${userAuthInfo.toJson()}');
    update(["realnameList"]);
  }

  // 跳转实名认证
  void onRealname() async {
    if (userAuthInfo.primaryStatus == 0) {
      await Get.toNamed(AppRoutes.realName, arguments: {'type': 'realname'});
      _initData();
    } else {
      return Loading.toast('已认证'.tr);
    }
  }

  // 跳转高级认证
  void onAdvanced() async {
    // 高级认证
    if (userAuthInfo.status == 0 || userAuthInfo.status == 3) {
      await Get.toNamed(AppRoutes.realName, arguments: {'type': 'advanced'});
      _initData();
    } else if (userAuthInfo.status == 1) {
      return Loading.toast('审核中'.tr);
    } else if (userAuthInfo.status == 2) {
      return Loading.toast('已认证'.tr);
    }
  }
}
