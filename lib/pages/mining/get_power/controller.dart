import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class GetPowerController extends GetxController {
  GetPowerController();
  // 算力信息
  MiningGetpowerModel miningGetpower = MiningGetpowerModel();
  // 获得算力
  double getPower = 0;
  // 销毁数量
  double usedCoin = 0;
  // 滑块进度
  int progress = 0;
  // 滑动触发
  void onSliderChange(double value) {
    progress = value.round();
    if (selectedCoin == '钱包余额'.tr) {
      usedCoin = double.parse(MathUtils.multipleDecimal(miningGetpower.wallet?.usableBalance ?? 0, progress / 100, 6));
    } else {
      usedCoin = double.parse(MathUtils.multipleDecimal(miningGetpower.minerAccount, progress / 100, 6));
    }
    getPower = double.parse(MathUtils.multipleDecimal(usedCoin, miningGetpower.currentPrice ?? 0, 6));
    update(['get_power']);
  }

  // 选择币种
  String selectedCoin = '';
  // 当前币种余额
  String currentCoinBalance = '0';
  // 币种列表
  final List<Map<String, dynamic>> coinList = [
    {'id': 1, 'name': '钱包余额'.tr, 'balance': 0},
    {'id': 2, 'name': '挖矿账户'.tr, 'balance': 0},
  ];

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    miningGetpower = await MiningApi.getMiningGetpower();
    Storage().setJson('miningGetpower', miningGetpower);
    coinList[0]['balance'] = miningGetpower.wallet?.usableBalance ?? '0';
    coinList[1]['balance'] = miningGetpower.minerAccount ?? '0';
    selectedCoin = coinList[0]['name'];
    currentCoinBalance = coinList[0]['balance'];
    update(["get_power"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存
  _loadCacheData() {
    var stringMiningGetpower = Storage().getString('miningGetpower');
    miningGetpower = stringMiningGetpower != "" ? MiningGetpowerModel.fromJson(jsonDecode(stringMiningGetpower)) : MiningGetpowerModel();
    update(["get_power"]);
  }

  // 显示币种选择器
  void showCoinPicker(BuildContext context) {
    SelectCoin.showPicker(
      context: context,
      title: '选择币种'.tr,
      items: coinList.map((e) => {'id': e['id'], 'name': e['name'], 'balance': e['balance']}).toList(),
      onConfirm: (selected) {
        selectedCoin = selected['name'];
        currentCoinBalance = selected['balance'];
        usedCoin = 0;
        getPower = 0;
        progress = 0;
        update(['get_power']);
      },
      onCancel: () {},
    );
  }

  // 提交
  void submit() async {
    if (progress == 0) return Loading.toast('请选择销毁比例'.tr);
    if (usedCoin == 0) return Loading.toast('请选择销毁数量'.tr);
    Loading.show();
    var res = await MiningApi.destroyMiningPower(MiningDestoryPowerReq(
      amount: usedCoin,
      coinId: '1099',
      coinType: '2',
      accountType: selectedCoin == '钱包余额'.tr ? 'wallet' : 'miner_account',
    ));
    if (res) {
      Loading.success('销毁成功'.tr);
      progress = 0;
      usedCoin = 0;
      getPower = 0;
      _initData();
      update(['get_power']);
    }
  }
}
