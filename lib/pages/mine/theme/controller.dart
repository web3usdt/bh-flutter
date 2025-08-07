import 'package:happy/common/index.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  ThemeController();

  // 当前主题
  String currentTheme = '';

  _initData() {
    currentTheme = ConfigService.to.themeMode.name;
    update(["theme"]);
  }

  // 切换主题
  void onThemeSelected(String theme) async {
    await ConfigService.to.setThemeMode(theme);
    Get.back();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
