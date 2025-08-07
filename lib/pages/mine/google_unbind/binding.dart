import 'package:get/get.dart';

import 'controller.dart';

class GoogleUnbindBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleUnbindController>(() => GoogleUnbindController());
  }
}
