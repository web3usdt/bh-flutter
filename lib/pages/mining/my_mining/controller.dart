import 'dart:convert';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MyMiningController extends GetxController {
  MyMiningController();
  // 挖矿信息
  MiningUserinfoModel miningUserinfo = MiningUserinfoModel();
  // 矿机列表
  List<MiningRecordModel> items = [];
  // 购买矿机数量
  TextEditingController buyMiningNumController = TextEditingController();

  _initData() async {
    miningUserinfo = await MiningApi.getMiningUserinfo();
    Storage().setJson('miningUserinfo', miningUserinfo);
    update(["my_mining"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringMiningRecordList = Storage().getString('miningRecordList');
    items = stringMiningRecordList != ""
        ? jsonDecode(stringMiningRecordList).map<MiningRecordModel>((item) {
            return MiningRecordModel.fromJson(item);
          }).toList()
        : [];

    // 挖矿信息
    var stringMiningUserinfo = Storage().getString('miningUserinfo');
    miningUserinfo = stringMiningUserinfo != "" ? MiningUserinfoModel.fromJson(jsonDecode(stringMiningUserinfo)) : MiningUserinfoModel();
    update(["my_mining"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }

  // 购买矿机
  buyMining() async {
    DialogWidget.show(
      title: '购买矿机'.tr,
      confirmText: '确定'.tr,
      cancelText: '取消'.tr,
      content: <Widget>[
        InputWidget(
          placeholder: '请输入购买矿机数量'.tr,
          controller: buyMiningNumController,
        ).expanded(),
      ]
          .toRow(crossAxisAlignment: CrossAxisAlignment.center)
          .paddingHorizontal(30.w)
          .backgroundColor(AppTheme.blockBgColor)
          .height(88.w)
          .clipRRect(all: 20.w)
          .marginOnly(top: 20.w),
      backgroundColor: AppTheme.pageBgColor,
      onConfirm: () async {
        // 确认操作
        if (buyMiningNumController.text.isEmpty) return Loading.toast('请输入购买矿机数量'.tr);
        Get.back();
        Loading.show();
        var res = await MiningApi.buyMining(int.parse(buyMiningNumController.text));
        if (res) {
          Loading.success('购买成功'.tr);
          _initData();
          refreshController.requestRefresh();
        }
      },
    );
  }

  /*
  * 分页
  * */
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );
  int _page = 1;
  Future<bool> _loadNewsSell(bool isRefresh) async {
    var result = await MiningApi.getMiningRecordList(PageListReq(
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
        Storage().setJson('miningRecordList', items);
      }
    } else {
      Storage().remove('miningRecordList');
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
    update(["my_mining"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["my_mining"]);
  }
}
