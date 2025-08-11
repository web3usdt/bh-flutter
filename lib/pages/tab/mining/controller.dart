import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class MiningController extends GetxController {
  MiningController();
  // 挖矿信息
  MiningUserinfoModel miningUserinfo = MiningUserinfoModel();
  // 更多功能
  List<Map<String, dynamic>> moreList = [
    // {'title': '我的矿机'.tr, 'icon': 'assets/images/mining27.png', 'route': AppRoutes.myMining},
    {'title': '矿机产出'.tr, 'icon': 'assets/images/mining28.png', 'route': AppRoutes.miningOutput},
    {
      'title': '算力明细'.tr,
      'icon': 'assets/images/mining29.png',
      'route': AppRoutes.miningRecord,
      'arguments': {'type': 'power'}
    },
    {'title': '团队数据'.tr, 'icon': 'assets/images/mining30.png', 'route': AppRoutes.team},
    {'title': '全网矿池'.tr, 'icon': 'assets/images/mining31.png', 'route': AppRoutes.network},
    {'title': '获取算力'.tr, 'icon': 'assets/images/mining32.png', 'route': AppRoutes.getPower},
  ];

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    miningUserinfo = await MiningApi.getMiningUserinfo();
    Storage().setJson('miningUserinfo', miningUserinfo);
    update(["mining"]);
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
    update(["mining"]);
  }

  // 新人首次领取矿机
  getMiningNewUserPower() async {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
            title: '激活矿机'.tr,
            description: miningUserinfo.minerCount == 0 ? '激活矿机需要扣除10USDT，是否继续？'.tr : '激活矿机需要扣除50USDT，是否继续？'.tr,
            confirmText: '确定'.tr,
            cancelText: '取消'.tr,
            onConfirm: () async {
              Loading.show();
              var res = await MiningApi.activateMining();
              Get.back();
              if (res) {
                Loading.success('激活成功'.tr);
                _initData();
              }
            });
      },
    );
  }
}
