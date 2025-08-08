import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TransferController extends GetxController {
  TransferController();
  // 提币数量
  TextEditingController withdrawAmountController = TextEditingController();
  // 提币余额
  AssetsTransferBalanceModel transferBalance = AssetsTransferBalanceModel();
  // 提币记录
  List<AssetsTransferRecordModel> items = [];
  // 选择币种
  String selectedCoin = '';
  int selectedCoinId = 0;
  // 币种列表
  List<AssetsTransferCoinlistModel> coinList = [
    // {'id': 1, 'name': 'USDT'},
    // {'id': 2, 'name': 'BTC'},
    // {'id': 3, 'name': 'ETH'},
  ];
  // 原始账户列表
  List<AssetsTransferAccountsModel> originalAccountList = [];
  // 路由
  String router = '';

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    // 获取转账账户
    router = Get.arguments['router'] ?? '';
    var res = await AssetsApi.getTransferAccounts();
    // 如果路由是game 则toAccountList=[游戏账户]
    if (router != null && router == 'game') {
      // 过滤originalAccountList，只返回资金账户和游戏账户
      originalAccountList = res.where((e) => e.id == 1 || e.id == 11).toList();
      toAccountList = originalAccountList.map((e) => {'id': e.id, 'name': e.name}).toList();
      toAccount = toAccountList.first['name'];
      toAccountId = toAccountList.first['id'];
    } else {
      // 如果不是game，则过滤掉游戏账户
      originalAccountList = res.where((e) => e.id != 11).toList();
      toAccountList = originalAccountList.map((e) => {'id': e.id, 'name': e.name}).toList();
      toAccount = toAccountList.first['name'];
      toAccountId = toAccountList.first['id'];
    }

    fromAccountList = originalAccountList;
    fromAccount = fromAccountList.first.name ?? '';
    fromAccountId = fromAccountList.first.id ?? 0;
    _updateToAccountList();
    update(["transfer"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  Future<void> _loadCacheData() async {
    final stringTransferItems = Storage().getString('transferItems');
    items = stringTransferItems != ""
        ? jsonDecode(stringTransferItems).map<AssetsTransferRecordModel>((item) {
            return AssetsTransferRecordModel.fromJson(item);
          }).toList()
        : [];
    update(["transfer"]);
  }

  @override
  void onClose() {
    super.onClose();
    withdrawAmountController.dispose();
    refreshController.dispose();
  }

  // 显示币种选择器
  void showCoinPicker(BuildContext context) {
    PickerUtils.showPicker(
      context: context,
      title: '选择币种'.tr,
      items: coinList.map((e) => {'id': e.coinId, 'name': e.coinName}).toList(),
      onConfirm: (selected) {
        selectedCoin = selected['name'];
        selectedCoinId = selected['id'];
        getTransferBalance();
        update(['transfer']);
      },
      onCancel: () {},
    );
  }

  /**
   * 选择从账户或者到账户的逻辑，或者点旋转按钮
   * 1、如果从账户选中：合约账户(ID=2)，则到账 toAccountList=[资金账户(ID=1)]  toAccount=资金账户
   * 2、如果从账户选中：资金账户(ID=1)，则到账 toAccountList=[合约账户(ID=2),挖矿账户(ID=3)]  toAccount=合约账户
   * 3、如果从账户选中：挖矿账户(ID=3)，则到账 toAccountList=[资金账户(ID=1)]  toAccount=资金账户
   * 
   * 注意旋转按钮可以改变账户位置，改变位置后按最新的从账户 去筛选 到账户列表
   * 账户ID固定：1=资金账户，2=合约账户，3=挖矿账户
   */

  // 从账户
  String fromAccount = '';
  int fromAccountId = 0;
  List<AssetsTransferAccountsModel> fromAccountList = [
    // {'id': 1, 'name': '资金账户'},
    // {'id': 2, 'name': '合约账户'},
    // {'id': 5, 'name': '挖矿账户'},
  ];
  // 到账户
  String toAccount = '';
  int toAccountId = 0;
  List<Map<String, dynamic>> toAccountList = [
    // {'id': 1, 'name': '资金账户'},
  ];

  // 更新到账户列表
  void _updateToAccountList() {
    switch (fromAccountId) {
      case 2: // 合约账户
        // 从原始账户列表originalAccountList中找出资金账户
        toAccountList = originalAccountList.where((e) => e.id == 1).toList().map((e) => {'id': e.id, 'name': e.name}).toList();
        toAccount = toAccountList.first['name'];
        toAccountId = toAccountList.first['id'];
        getTransferCoinlist();
        break;
      case 1: // 资金账户
        // 从原始账户列表originalAccountList中找出合约账户、挖矿账户和游戏账户
        toAccountList =
            originalAccountList.where((e) => e.id == 2 || e.id == 3 || e.id == 11).toList().map((e) => {'id': e.id, 'name': e.name}).toList();
        toAccount = toAccountList.first['name'];
        toAccountId = toAccountList.first['id'];
        getTransferCoinlist();
        break;
      case 5: // 挖矿账户
        // 从原始账户列表originalAccountList中找出资金账户
        toAccountList = originalAccountList.where((e) => e.id == 1).toList().map((e) => {'id': e.id, 'name': e.name}).toList();
        toAccount = toAccountList.first['name'];
        toAccountId = toAccountList.first['id'];
        getTransferCoinlist();
        break;
      case 11: // 游戏账户
        // 从原始账户列表originalAccountList中找出资金账户
        toAccountList = originalAccountList.where((e) => e.id == 1).toList().map((e) => {'id': e.id, 'name': e.name}).toList();
        toAccount = toAccountList.first['name'];
        toAccountId = toAccountList.first['id'];
        getTransferCoinlist();
        break;
    }
  }

  // 选择从账户
  void showFromAccountPicker(BuildContext context) {
    PickerUtils.showPicker(
      context: context,
      title: '选择账户'.tr,
      items: fromAccountList.map((e) => {'id': e.id, 'name': e.name}).toList(),
      onConfirm: (selected) {
        fromAccount = selected['name'];
        fromAccountId = selected['id'];
        print('fromAccount: $fromAccount, fromAccountId: $fromAccountId');
        _updateToAccountList();
        update(['transfer']);
      },
      onCancel: () {},
    );
  }

  // 选择到账户
  void showToAccountPicker(BuildContext context) {
    PickerUtils.showPicker(
      context: context,
      title: '选择账户'.tr,
      items: toAccountList,
      onConfirm: (selected) {
        toAccount = selected['name'];
        toAccountId = selected['id'];
        getTransferCoinlist();
        update(['transfer']);
      },
      onCancel: () {},
    );
  }

  // 旋转按钮，切换账户
  void switchAccount() {
    var temp = fromAccount;
    fromAccount = toAccount;
    toAccount = temp;
    var tempId = fromAccountId;
    fromAccountId = toAccountId;
    toAccountId = tempId;
    _updateToAccountList();
    update(['transfer']);
  }

  // 获取转账币种列表
  void getTransferCoinlist() async {
    withdrawAmountController.clear();
    coinList.clear();
    selectedCoin = '';
    selectedCoinId = 0;
    transferBalance.usableBalance = '0';
    coinList = await AssetsApi.getTransferCoinlist(AssetsTransferCoinlistReq(
      fromAccount: fromAccountId.toString(),
      toAccount: toAccountId.toString(),
    ));
    print('coinList: ${coinList.first.coinName}');
    selectedCoin = coinList.first.coinName ?? '';
    selectedCoinId = coinList.first.coinId ?? 0;
    getTransferBalance();
    update(['transfer']);
  }

  // 获取转账余额
  void getTransferBalance() async {
    print('getTransferBalance: $fromAccountId, $selectedCoin');
    transferBalance = await AssetsApi.getTransferBalance(AssetsTransferBalanceReq(
      account: fromAccountId.toString(),
      coinName: selectedCoin,
    ));
    update(['transfer']);
  }

  // 提交
  void submit() async {
    if (withdrawAmountController.text.isEmpty) return Loading.toast('请输入划转数量'.tr);
    if (transferBalance.usableBalance == 0) return Loading.toast('余额不足'.tr);
    Loading.show();
    var res = false;
    // 如果有任意一个账户id==11  则需要调用游戏账户转账接口
    if (fromAccountId == 11 || toAccountId == 11) {
      res = await GameApi.gameTransfer(GameTransferReq(
        from: fromAccountId.toString(),
        to: toAccountId.toString(),
        amount: withdrawAmountController.text,
        coinId: selectedCoinId.toString(),
      ));
    } else {
      res = await AssetsApi.transfer(AssetsTransferReq(
        fromAccount: fromAccountId.toString(),
        toAccount: toAccountId.toString(),
        amount: withdrawAmountController.text,
        coinName: selectedCoin,
      ));
    }

    if (res) {
      Loading.success('划转成功'.tr);
      withdrawAmountController.clear();
      getTransferBalance();
      refreshController.requestRefresh();
      update(['transfer']);
    }
  }

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
    var result = await AssetsApi.getTransferRecord(PageListReq(
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
        Storage().setJson('transferItems', items);
      }
    } else {
      Storage().remove('transferItems');
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
    update(["transfer"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["transfer"]);
  }
}
