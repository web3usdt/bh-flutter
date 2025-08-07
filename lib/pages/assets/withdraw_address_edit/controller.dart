import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';

class WithdrawAddressEditController extends GetxController {
  WithdrawAddressEditController();
  // 类型
  String type = '';
  // 地址
  TextEditingController addressController = TextEditingController(text: '');
  // 备注
  TextEditingController remarkController = TextEditingController(text: '');
  // 交易密码
  TextEditingController passwordController = TextEditingController(text: '');
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

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    type = Get.arguments['type'] ?? '';
    if (type == 'edit') {
      selectedCoin = Get.arguments['item'].coinName ?? '';
      selectedCoinId = Get.arguments['item'].id ?? 0;
      addressController.text = Get.arguments['item'].address ?? '';
      remarkController.text = Get.arguments['item'].addressNote ?? '';
      update(["withdraw_address_edit"]);
    }
    coinList = await AssetsApi.getFundAccountList();
    // 从coinList中筛选出coinName == BTC  ETH  USDT 的选项
    coinList = coinList.where((e) => e.coinName == 'BTC' || e.coinName == 'ETH' || e.coinName == 'USDT' || e.coinName == 'HPY').toList();
    // 再排序
    const order = ['USDT', 'BTC', 'ETH', 'HPY'];
    coinList.sort((a, b) => order.indexOf(a.coinName ?? '') - order.indexOf(b.coinName ?? ''));
    Storage().setJson('fundAccountCoinList', coinList);
    // 如果是新增地址，默认选中的币种为coinList的第一项
    if (type == 'create') {
      if (coinList.isNotEmpty) {
        selectedCoin = coinList[0].coinName ?? '';
        selectedCoinId = coinList[0].coinId ?? 0;
      }
    }

    update(["withdraw_address_edit"]);
  }

  @override
  void onClose() {
    super.onClose();
    addressController.dispose();
    remarkController.dispose();
    passwordController.dispose();
  }

  // 显示币种选择器
  void showCoinPicker(BuildContext context) {
    SelectCoin.showPicker(
      context: context,
      title: '选择币种'.tr,
      items: coinList.map((e) => {'id': e.coinId, 'name': e.coinName, 'icon': ImgWidget(path: e.image ?? '')}).toList(),
      onConfirm: (selected) {
        selectedCoin = selected['name'];
        selectedCoinId = selected['id'];
        update(['withdraw_address_edit']);
      },
      onCancel: () {},
    );
  }

  // 提交
  void submit() async {
    if (selectedCoinId == 0) return Loading.toast('请选择币种'.tr);
    if (addressController.text.isEmpty) return Loading.toast('请输入地址'.tr);
    if (remarkController.text.isEmpty) return Loading.toast('请输入备注'.tr);
    if (passwordController.text.isEmpty) return Loading.toast('请输入交易密码'.tr);
    Loading.show();
    if (type == 'create') {
      var res = await AssetsApi.addWithdrawAddress(AssetsWithdrawAddReq(
          coinName: selectedCoin, addressNote: remarkController.text, address: addressController.text, pwd: passwordController.text));
      if (res) {
        Loading.success('添加成功'.tr);
        Get.back();
      }
    } else {
      var res = await AssetsApi.editWithdrawAddress(AssetsWithdrawAddReq(
          coinName: selectedCoin,
          addressNote: remarkController.text,
          address: addressController.text,
          id: Get.arguments['item'].id,
          pwd: passwordController.text));
      if (res) {
        Loading.success('编辑成功'.tr);
        Get.back();
      }
    }
  }
}
