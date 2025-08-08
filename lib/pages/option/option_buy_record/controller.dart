import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class OptionBuyRecordController extends GetxController {
  OptionBuyRecordController();
  // 订单ID
  int orderId = 0;
  // 订单数据
  OptionIndexListModelScenePairList? orderData;

  _initData() async {
    orderId = Get.arguments['id'];
    orderData = await OptionApi.getOptionBuyRecord(orderId);
    print('orderData: ${orderData}');
    update(["option_buy_record"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
