import 'dart:convert';

import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class NetworkController extends GetxController {
  NetworkController();
  // 挖矿信息
  MiningUserinfoModel miningUserinfo = MiningUserinfoModel();

  _initData() async {
    miningUserinfo = await MiningApi.getMiningUserinfo();
    Storage().setJson('miningUserinfo', miningUserinfo);
    update(["network"]);
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
    update(["network"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
