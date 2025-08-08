import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class WithdrawAddressController extends GetxController {
  WithdrawAddressController();
  // 类型
  String? type;
  // 管理
  bool isManage = false;
  // 是否选中全部
  bool isSelectAll = false;
  // 提币地址
  List<AssetsWithdrawAddressListModel> withdrawAddressList = [];
  // 当前选中的地址列表
  List<AssetsWithdrawAddressListModelList> currentSelectedAddressList = [];

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // 初始化数据
  _initData() async {
    withdrawAddressList = await AssetsApi.getWithdrawAddressList();
    Storage().setJson('withdrawAddressList', withdrawAddressList);
    update(["withdraw_address"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    type = Get.arguments['type'] ?? '';
    var stringWithdrawAddressList = Storage().getString('withdrawAddressList');
    withdrawAddressList = stringWithdrawAddressList != ""
        ? jsonDecode(stringWithdrawAddressList).map<AssetsWithdrawAddressListModel>((item) {
            return AssetsWithdrawAddressListModel.fromJson(item);
          }).toList()
        : [];
    update(["withdraw_address"]);
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  // 是否选中
  bool isSelected(AssetsWithdrawAddressListModelList item) {
    return currentSelectedAddressList.contains(item);
  }

  // 选中地址
  void onSelect(AssetsWithdrawAddressListModelList item) async {
    if (type == 'withdraw') {
      Get.back(result: item.address);
      return;
    }
    if (isManage) {
      if (currentSelectedAddressList.contains(item)) {
        currentSelectedAddressList.remove(item);
      } else {
        currentSelectedAddressList.add(item);
      }
    } else {
      await Get.toNamed(AppRoutes.withdrawAddressEdit, arguments: {
        'type': 'edit',
        'item': item,
      });
      _initData();
    }

    // 查看是否全部选中，改变isSelectAll
    isSelectAll = currentSelectedAddressList.length == withdrawAddressList.length;
    update(["withdraw_address"]);
  }

  // 切换管理
  void switchManage() {
    isManage = !isManage;
    update(["withdraw_address"]);
  }

  // 删除
  void delete(int id) async {
    // if (currentSelectedAddressList.isEmpty) return Loading.toast('请选择要删除的地址');
    // var ids = currentSelectedAddressList.map((e) => e.id).toList();
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '删除地址'.tr,
          description: '确定删除地址吗？'.tr,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var res = await AssetsApi.deleteWithdrawAddress(id);
            if (res) {
              Loading.success('删除成功'.tr);
              isManage = false;
              _initData();
            }
          },
        );
      },
    );
  }

  // 添加新地址
  goAddAddress() async {
    await Get.toNamed(AppRoutes.withdrawAddressEdit, arguments: {
      'type': 'create',
    });
    _initData();
  }
}
