import 'dart:convert';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class WithdrawController extends GetxController {
  WithdrawController();
  // 提现验证方式：邮箱/谷歌
  bool withdrawVerifyIsEmail = true;
  // 邮箱验证码
  TextEditingController emailCodeController = TextEditingController();
  // 二次验证
  TextEditingController secondaryVerificationController = TextEditingController();
  // 提币余额
  AssetsWdithdrawBalanceModel withdrawBalance = AssetsWdithdrawBalanceModel();
  // 提币地址
  TextEditingController withdrawAddressController = TextEditingController();
  // 提币数量
  TextEditingController withdrawAmountController = TextEditingController();
  // 交易密码
  TextEditingController payController = TextEditingController();
  // 提币code_type
  String withdrawCodeType = '1';
  List<AssetsWithdrawRecordModel> items = [];
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
  // 选择链id
  int selectedChainId = 1;
  // 链列表
  final List<Map<String, dynamic>> chainList = [
    {'id': 1, 'name': 'BEP20'},
    {'id': 2, 'name': 'ERC20'},
    {'id': 3, 'name': 'TRC20'},
  ];

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    withdrawVerifyIsEmail = Storage().getBool('withdrawVerifyIsEmail');
    update(["withdraw"]);
    coinList = await AssetsApi.getFundAccountList();
    // 从coinList中筛选出coinName == BTC  ETH  USDT 的选项
    coinList = coinList.where((e) => e.coinName == 'BTC' || e.coinName == 'ETH' || e.coinName == 'USDT' || e.coinName == 'HPY').toList();
    const order = ['USDT', 'BTC', 'ETH', 'HPY'];
    coinList.sort((a, b) => order.indexOf(a.coinName ?? '') - order.indexOf(b.coinName ?? ''));
    Storage().setJson('fundAccountCoinList', coinList);
    // 默认选中的币种为coinList的第一项
    if (coinList.isNotEmpty) {
      selectedCoin = coinList[0].coinName ?? '';
      selectedCoinId = coinList[0].coinId ?? 0;
    }
    getCoinBalance();
    update(["withdraw"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringWithdrawItems = Storage().getString('withdrawItems');
    items = stringWithdrawItems != ""
        ? jsonDecode(stringWithdrawItems).map<AssetsWithdrawRecordModel>((item) {
            return AssetsWithdrawRecordModel.fromJson(item);
          }).toList()
        : [];
    update(["withdraw"]);
  }

  @override
  void onClose() {
    super.onClose();
    withdrawAddressController.dispose();
    withdrawAmountController.dispose();
    emailCodeController.dispose();
    refreshController.dispose();
    payController.dispose();
    secondaryVerificationController.dispose();
  }

  // 获取币种余额
  void getCoinBalance() async {
    withdrawBalance = await AssetsApi.getWithdrawBalance(AssetsWidthdrawBalanceReq(coinName: selectedCoin, addressType: selectedChainId));
    print(withdrawBalance.toJson());
    withdrawBalance.withdrawalFeeRate = ((double.tryParse(withdrawBalance.withdrawalFeeRate?.toString() ?? '0') ?? 0) * 100).toString();
    if (withdrawBalance.googleStatus == 1) {
      withdrawCodeType = '3';
    } else if (withdrawBalance.phoneStatus == 1) {
      withdrawCodeType = '1';
    } else if (withdrawBalance.emailStatus == 1) {
      withdrawCodeType = '2';
    }
    update(['withdraw']);
  }

  // 跳转提币地址
  void jumpWithdrawAddress() async {
    var res = await Get.toNamed('/withdrawAddressPage', arguments: {
      'type': 'withdraw',
    });
    if (res != null) {
      withdrawAddressController.text = res;
      update(['withdraw']);
    }
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
                  radius: 20.w,
                ),
                'balance': e.usableBalance
              })
          .toList(),
      onConfirm: (selected) {
        selectedCoin = selected['name'];
        selectedCoinId = selected['id'];
        getCoinBalance();
        update(['withdraw']);
      },
      onCancel: () {},
    );
  }

  // 显示链选择器
  void showChainPicker(BuildContext context) {
    PickerUtils.showPicker(
      context: context,
      title: '选择链'.tr,
      items: chainList,
      onConfirm: (selected) {
        selectedChain = selected['name'];
        selectedChainId = selected['id'];
        getCoinBalance();
        update(['withdraw']);
      },
      onCancel: () {},
    );
  }

  // 提交
  void submit() async {
    print(emailCodeController.text);
    if (withdrawAddressController.text.isEmpty) return Loading.toast('请输入提币地址'.tr);
    if (withdrawAmountController.text.isEmpty) return Loading.toast('请输入提币数量'.tr);
    if (payController.text.isEmpty) return Loading.toast('请输入交易密码'.tr);
    if (withdrawVerifyIsEmail && emailCodeController.text.isEmpty) return Loading.toast('请输入邮箱验证码'.tr);

    // 如果不是邮箱验证
    if (!withdrawVerifyIsEmail) {
      handleSecondaryVerification();
    } else {
      handleWithdraw(emailCodeController.text, false);
    }
  }

  // 撤销提币
  void cancelWithdraw(int id) async {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '撤销提币'.tr,
          description: '确定撤销提币吗？'.tr,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var res = await AssetsApi.cancelWithdraw(id);
            if (res) {
              Loading.success('撤销成功'.tr);
              refreshController.requestRefresh();
            }
          },
        );
      },
    );
  }

  // 谷歌二次验证
  void handleSecondaryVerification() {
    DialogWidget.show(
      backgroundColor: AppTheme.pageBgColor,
      title: 'Google'.tr,
      content: <Widget>[
        InputWidget(
          placeholder: '请输入验证码'.tr,
          controller: secondaryVerificationController,
        ).expanded(),
      ]
          .toRow(crossAxisAlignment: CrossAxisAlignment.center)
          .paddingHorizontal(30.w)
          .backgroundColor(AppTheme.blockBgColor)
          .height(88.w)
          .clipRRect(all: 20.w)
          .marginOnly(top: 20.w),
      onConfirm: () async {
        if (secondaryVerificationController.text.isEmpty) return Loading.toast('请输入谷歌验证码'.tr);
        handleWithdraw(secondaryVerificationController.text, true);
      },
    );
  }

  // 提币
  void handleWithdraw(String? code, bool? isGoogle) async {
    Loading.show();
    var res = await AssetsApi.withdraw(AssetsWidthdrawReq(
      coinId: selectedCoinId.toString(),
      amount: withdrawAmountController.text,
      address: withdrawAddressController.text,
      addressType: selectedChainId.toString(),
      codeType: withdrawCodeType,
      // googleCode: secondaryVerificationController.text,
      pwd: payController.text,
      code: code,
    ));
    if (res) {
      Loading.success('提币成功'.tr);
      if (isGoogle == true) {
        Loading.dismiss();
        Get.back();
      }
      withdrawAddressController.clear();
      withdrawAmountController.clear();
      refreshController.requestRefresh();
    }
  }

  // 发送手机验证码
  Future<bool> sendPhoneCode() async {
    Loading.show();
    var res = await UserApi.getEmailCode();
    if (res) {
      Loading.success('发送成功'.tr);
      return true;
    } else {
      return false;
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
    var result = await AssetsApi.getWithdrawRecord(PageListReq(
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
        Storage().setJson('withdrawItems', items);
      }
    } else {
      Storage().remove('withdrawItems');
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
    update(["withdraw"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["withdraw"]);
  }
}
