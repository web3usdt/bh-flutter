import 'dart:convert';

import 'package:BBIExchange/common/index.dart';
import 'package:get/get.dart';

class MiningDataController extends GetxController {
  MiningDataController();
  // 挖矿信息
  MiningUserinfoModel miningUserinfo = MiningUserinfoModel();
  // 挖矿数据
  Performance? performance;

  initData() async {
    miningUserinfo = await MiningApi.getMiningUserinfo();
    performance = miningUserinfo.performance;
    print('performance: $performance');
    Storage().setJson('miningUserinfo', miningUserinfo);
    update(["mining_data"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringMiningUserinfo = Storage().getString('miningUserinfo');
    miningUserinfo = stringMiningUserinfo != "" ? MiningUserinfoModel.fromJson(jsonDecode(stringMiningUserinfo)) : MiningUserinfoModel();
    update(["mining_data"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
  // 弹出文案提示
  showTextDialog(String text) {
    Loading.toast(text);
  }
}
