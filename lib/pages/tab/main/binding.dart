import 'package:BBIExchange/pages/tab/assets/index.dart';
import 'package:BBIExchange/pages/tab/coin/index.dart';
import 'package:BBIExchange/pages/tab/contract/index.dart';
import 'package:BBIExchange/pages/tab/home/index.dart';
import 'package:BBIExchange/pages/tab/main/index.dart';
import 'package:BBIExchange/pages/tab/mining/index.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/pages/tab/option/index.dart';

/// 主界面依赖
class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    // 首页
    Get.lazyPut<HomeController>(() => HomeController());
    // 币币
    Get.lazyPut<CoinController>(() => CoinController());
    // 期权
    Get.lazyPut<OptionController>(() => OptionController());
    // 挖矿中心
    Get.lazyPut<MiningController>(() => MiningController());
    // 永续
    Get.lazyPut<ContinuousController>(() => ContinuousController());
    // 资产
    Get.lazyPut<AssetsController>(() => AssetsController());
  }
}
