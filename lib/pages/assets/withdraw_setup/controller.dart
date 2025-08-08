import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class WithdrawSetupController extends GetxController {
  WithdrawSetupController();
  // 提现验证方式：邮箱/谷歌
  bool withdrawVerifyIsEmail = true;

  // 修改验证方式
  changeWithdrawVerify() {
    withdrawVerifyIsEmail = !withdrawVerifyIsEmail;
    Storage().setBool('withdrawVerifyIsEmail', withdrawVerifyIsEmail);
    update(["withdraw_setup"]);
  }

  _initData() {
    withdrawVerifyIsEmail = Storage().getBool('withdrawVerifyIsEmail');
    update(["withdraw_setup"]);
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
