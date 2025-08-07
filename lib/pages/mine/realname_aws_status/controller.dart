import 'package:get/get.dart';

class RealnameAwsStatusController extends GetxController {
  RealnameAwsStatusController();
  String status = '';
  String cause = '';
  _initData() {
    status = Get.arguments['status'];
    cause = Get.arguments['cause'];
    update(["realname_aws_status"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
