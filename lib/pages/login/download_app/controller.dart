import 'package:get/get.dart';

class DownloadAppController extends GetxController {
  DownloadAppController();

  _initData() {
    update(["download_app"]);
  }

  // 下载APP
  void downloadApp(String type) {
    if (type == "ios") {
      // 下载IOS APP
    } else {
      // 下载安卓APP
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
