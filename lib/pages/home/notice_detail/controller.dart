import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class NoticeDetailController extends GetxController {
  NoticeDetailController();

  String type = '';
  int noticeId = 0;
  String systemId = '';
  String title = '';
  String content = '';
  String time = '';

  _initData() async {
    noticeId = Get.arguments['notice_id'] ?? 0;
    systemId = Get.arguments['system_id'] ?? '';
    type = Get.arguments['type'] ?? '';
    if (type == 'notice') {
      var res = await HomeApi.noticeDetail(noticeId);
      title = res.title ?? '';
      time = res.updatedAt ?? '';
      content = res.body ?? '';
    } else {
      var res = await HomeApi.systemMessageDetail(systemId);
      title = res.data?.title ?? '';
      time = res.createdAt ?? '';
      content = res.data?.content ?? '';
    }
    update(["notice_detail"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
