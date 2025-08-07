import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerServerController extends GetxController {
  CustomerServerController();

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('操作失败'.tr, '无法打开链接，请检查是否已安装相应应用。'.tr);
    }
  }
}
