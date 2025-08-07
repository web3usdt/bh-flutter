import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class UrlUtils {
  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(url);
    } else {
      Get.snackbar('操作失败', '无法打开链接，请检查是否已安装相应应用。');
    }
  }
}
