import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/pages/login/login/controller.dart';

class LogoutService {
  static Future<void> logout() async {
    // 获取所有存储键
    final keys = Storage().getKeys();
    // 需要保留的字段列
    final keepKeys = ['loginHistoryList'];
    // 删除不需要保留的字段
    for (String key in keys) {
      if (!keepKeys.contains(key)) {
        await Storage().remove(key);
      }
    }
    // 根据当前页面决定后续操作
    if (Get.currentRoute == AppRoutes.login) {
      // 如果当前就在登录页，说明是切换环境，给出提示即可
      // 无需跳转或销毁控制器
      Loading.success('环境已切换, 请重新登录');
      Get.forceAppUpdate();
      // 如果需要，可以清空输入框
      if (Get.isRegistered<LoginController>()) {
        final controller = Get.find<LoginController>();
        controller.accountController.clear();
        controller.passwordController.clear();
      }
    } else {
      // 如果在其他页面，则执行完整的登出流程
      Loading.success('安全退出');
      // 清除所有控制器
      Get.deleteAll();
      // 使用 Get.offAllNamed 跳转到登录页
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
