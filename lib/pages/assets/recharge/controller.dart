import 'dart:convert';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class RechargeController extends GetxController {
  RechargeController();
  // 充值记录
  List<AssetsRechargeRecordModel> items = [];
  // 二维码key
  final GlobalKey qrKey = GlobalKey();
  // 二维码内容
  String qrCodeContent = '';
  // 选择币种
  String selectedCoin = '';
  // 选择币种id
  int selectedCoinId = 0;
  // 币种列表
  List<AssetsFundAccountListModel> coinList = [
    // {'id': 1, 'name': 'USDT','icon': ImgWidget(path: 'assets/images/btc.png'),'balance': '10000'},
    // {'id': 2, 'name': 'BTC','icon': ImgWidget(path: 'assets/images/btc.png'),'balance': '10000'},
    // {'id': 3, 'name': 'ETH','icon': ImgWidget(path: 'assets/images/btc.png'),'balance': '10000'},
  ];
  // 选择链
  String selectedChain = 'BEP20';
  // 链id
  int selectedChainId = 1;
  // 网络链列表
  List<AssetsRechargeNetworkListModel> chainList = [
    // {'id': 1, 'name': 'BEP20'},
    // {'id': 2, 'name': 'ERC20'},
    // {'id': 3, 'name': 'TRC20'},
  ];

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    coinList = await AssetsApi.getFundAccountList();
    // 从coinList中筛选出coinName == BTC  ETH  USDT 的选项
    coinList = coinList.where((e) => e.coinName == 'USDT' || e.coinName == 'HPY').toList();
    // 按照 USDT、BTC、ETH 顺序排序
    const order = ['USDT', 'HPY'];
    coinList.sort((a, b) => order.indexOf(a.coinName ?? '') - order.indexOf(b.coinName ?? ''));
    // log.i('coinList: ${coinList.map((e) => e.coinName).join(',')}');
    // 默认选中的币种为coinList的第一项
    if (coinList.isNotEmpty) {
      selectedCoin = coinList[0].coinName ?? '';
      selectedCoinId = coinList[0].coinId ?? 0;
    }

    chainList = await AssetsApi.getRechargeNetworkList();
    if (chainList.isNotEmpty) {
      selectedChain = chainList[0].name ?? '';
    }

    getRechargeAddress();
    update(["recharge"]);
  }

  // 获取充值地址
  void getRechargeAddress() async {
    final address = await AssetsApi.getRechargeAddress(AssetsRechargeAddressReq(
      coinId: selectedCoinId.toString(),
      addressType: selectedChainId,
    ));
    qrCodeContent = address ?? '';
    update(["recharge"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    final stringRechargeItems = Storage().getString('rechargeItems');
    items = stringRechargeItems != ""
        ? jsonDecode(stringRechargeItems).map<AssetsRechargeRecordModel>((item) {
            return AssetsRechargeRecordModel.fromJson(item);
          }).toList()
        : [];
    update(["recharge"]);
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }

  // 显示币种选择器
  void showCoinPicker(BuildContext context) {
    SelectCoin.showPicker(
      context: context,
      title: '选择币种'.tr,
      items: coinList
          .map((e) => {
                'id': e.coinId,
                'name': e.coinName,
                'icon': ImgWidget(
                  path: e.image ?? '',
                  width: 40.w,
                  height: 40.w,
                  radius: 20.w,
                )
              })
          .toList(),
      onConfirm: (selected) {
        selectedCoin = selected['name'];
        selectedCoinId = selected['id'];
        selectedChainId = 1;
        selectedChain = 'BEP20';
        getRechargeAddress();
        update(['recharge']);
      },
      onCancel: () {},
    );
  }

  // 显示链选择器
  void showChainPicker(BuildContext context) {
    SelectCoin.showPicker(
      context: context,
      title: '选择网络'.tr,
      items: chainList.map((e) => {'id': e.name, 'name': e.name, 'balance': '预计约 ${e.maxTime} 分钟内到账'}).toList(),
      onConfirm: (selected) {
        selectedChain = selected['name'];
        if (selectedChain == 'BEP20') {
          selectedChainId = 1;
        } else if (selectedChain == 'ERC20') {
          selectedChainId = 2;
        } else if (selectedChain == 'TRC20') {
          selectedChainId = 3;
        }
        getRechargeAddress();
        update(['recharge']);
      },
      onCancel: () {},
    );
  }

  // 提交
  void submit() {}

  /*
  * 分页
  * refreshController：分页控制器
  * _page：分页
  * _limit：每页条数
  * _loadNewsSell:拉取数据（是否刷新）
  * onLoading：上拉加载新商品
  * onRefresh：下拉刷新
  * */
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );
  int _page = 1;
  Future<bool> _loadNewsSell(bool isRefresh) async {
    var result = await AssetsApi.getRechargeRecord(PageListReq(
      page: isRefresh ? 1 : _page,
    ));
    if (isRefresh) {
      _page = 1;
      items.clear();
    }
    if (result.isNotEmpty) {
      _page++;
      items.addAll(result);
      if (_page <= 2) {
        Storage().setJson('rechargeItems', items);
      }
    } else {
      Storage().remove('rechargeItems');
    }
    // 是否是空
    return result.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (items.isNotEmpty) {
      try {
        // 拉取数据是否为空 ? 设置暂无数据 ： 加载完成
        var isEmpty = await _loadNewsSell(false);
        isEmpty ? refreshController.loadNoData() : refreshController.loadComplete();
      } catch (e) {
        refreshController.loadFailed(); // 加载失败
      }
    } else {
      refreshController.loadNoData(); // 设置无数据
    }
    update(["recharge"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["recharge"]);
  }
}
