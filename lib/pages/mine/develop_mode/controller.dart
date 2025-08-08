import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/common/services/logout.dart';
import 'package:BBIExchange/common/utils/action_sheet_util.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class DevelopModeController extends GetxController {
  DevelopModeController();

  int clickCount = 0;

  void switchEnv() {
    final List<Env> envList = EnvConfig.envList;
    final items = envList;
    ActionSheetUtil.showActionSheet(
      context: Get.context!,
      title: '切换通道'.tr,
      // items: PlatformUtils().isWeb
      //     ? items.map((e) => {'id': e.tag, 'title': e.name + ' ' + e.apiBaseUrl}).toList()
      //     : items.map((e) => {'id': e.tag, 'title': e.name}).toList(),
      items: items.map((e) => {'id': e.tag, 'title': e.name}).toList(),
      onConfirm: (item) async {
        var curEnv = ConfigService.to.curEnv.value;
        if (curEnv.tag == item['id']) {
          TDToast.showText('当前环境未切换'.tr, context: Get.context!);
          return;
        }

        await ConfigService.to.setEnv(item['id']);
        update(['develop_mode']);
        update(['loginPage']);

        LogoutService.logout();
      },
    );
  }

  // 获取测试环境列表
  void switchTestEnv() {
    clickCount++;
    // 设置连点5次，弹出提示
    if (clickCount < 7) {
      return;
    }

    final List<Env> envList = EnvConfig.getTestEnvList();
    final items = envList;
    ActionSheetUtil.showActionSheet(
      context: Get.context!,
      title: '切换通道'.tr,
      // items: PlatformUtils().isWeb
      //     ? items.map((e) => {'id': e.tag, 'title': e.name + ' ' + e.apiBaseUrl}).toList()
      //     : items.map((e) => {'id': e.tag, 'title': e.name}).toList(),
      items: items.map((e) => {'id': e.tag, 'title': e.name}).toList(),
      onConfirm: (item) async {
        var curEnv = ConfigService.to.curEnv.value;
        if (curEnv.tag == item['id']) {
          TDToast.showText('当前环境未切换'.tr, context: Get.context!);
          return;
        }

        await ConfigService.to.setTestEnv(item['id']);
        update(['develop_mode']);
        update(['loginPage']);

        LogoutService.logout();
      },
    );
  }

  _initData() {
    update(["develop_mode"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
