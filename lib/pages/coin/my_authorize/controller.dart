import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MyAuthorizeController extends GetxController with GetSingleTickerProviderStateMixin {
  MyAuthorizeController();
  // 当前委托
  List<CoinMyAuthorizeModel> currentAuthorizeItems = [];
  // 历史委托
  List<CoinMyAuthorizeModel> historyListItems = [];

  // tab 控制器
  late TabController tabController;
  // tab 索引
  int tabIndex = 0;
  // tab 名称
  List<String> tabNames = [
    '全部委托'.tr,
    '历史委托'.tr,
  ];

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化时设置当前索引
    tabController = TabController(
      length: tabNames.length,
      vsync: this,
      initialIndex: tabIndex, // 设置初始索引
    );
    // 监听 tab 切换
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        tabIndex = tabController.index;
        update(["my_authorize"]);
      }
    });
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringCurrentAuthorizeItems = Storage().getString('currentAuthorizeItems');
    currentAuthorizeItems = stringCurrentAuthorizeItems != ""
        ? jsonDecode(stringCurrentAuthorizeItems).map<CoinMyAuthorizeModel>((item) {
            return CoinMyAuthorizeModel.fromJson(item);
          }).toList()
        : [];

    var stringHistoryListItems = Storage().getString('historyListItems');
    historyListItems = stringHistoryListItems != ""
        ? jsonDecode(stringHistoryListItems).map<CoinMyAuthorizeModel>((item) {
            return CoinMyAuthorizeModel.fromJson(item);
          }).toList()
        : [];
    update(["notice_list"]);
  }

  // 订单状态改变
  changeTabIndex(int index) {
    tabIndex = index;
    // 刷新订单列表
    refreshController.requestRefresh();
    update(["my_authorize"]);
  }

  // 撤销
  void onCancel(CoinMyAuthorizeModel item) {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '撤销'.tr,
          description: '确定撤销委托吗？'.tr,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var req = CoinCancelAuthorizeReq(
              entrustId: item.id,
              entrustType: item.entrustType,
              symbol: item.symbol,
            );
            var res = await CoinApi.cancelAuthorize(req);
            if (res) {
              Loading.success('撤销成功'.tr);
              refreshController.requestRefresh();
            }
          },
        );
      },
    );
  }

  // 格式化数字
  String formatNumber(num value, {int decimalLength = 10}) {
    // 先将 value 转为 double
    double numValue = value.toDouble();

    // 判断是否为科学计数法（极大或极小的数）
    if (numValue.abs() >= 1e21 || (numValue != 0 && numValue.abs() < 1e-6)) {
      // 转换为普通小数表示，保留指定小数位数
      return numValue.toStringAsFixed(decimalLength);
    } else {
      return numValue.toString();
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
    var result1 = <CoinMyAuthorizeModel>[];
    var result2 = <CoinMyAuthorizeModel>[];
    if (tabIndex == 0) {
      result1 = await CoinApi.myAuthorizeList(PageListReq(
        page: isRefresh ? 1 : _page,
      ));
    } else {
      result2 = await CoinApi.historyAuthorizeList(PageListReq(
        page: isRefresh ? 1 : _page,
      ));
    }
    if (isRefresh) {
      _page = 1;
      if (tabIndex == 0) {
        currentAuthorizeItems.clear();
      } else {
        historyListItems.clear();
      }
    }
    if (tabIndex == 0) {
      if (result1.isNotEmpty) {
        _page++;
        currentAuthorizeItems.addAll(result1);
        if (_page <= 2) {
          Storage().setJson('currentAuthorizeItems', currentAuthorizeItems);
        }
      } else {
        Storage().remove('currentAuthorizeItems');
      }
    } else {
      if (result2.isNotEmpty) {
        _page++;
        historyListItems.addAll(result2);
        if (_page <= 2) {
          Storage().setJson('historyListItems', historyListItems);
        }
      } else {
        Storage().remove('historyListItems');
      }
    }

    // 是否是空
    return tabIndex == 0 ? currentAuthorizeItems.isEmpty : historyListItems.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (tabIndex == 0 ? currentAuthorizeItems.isNotEmpty : historyListItems.isNotEmpty) {
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
    update(["my_authorize"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["my_authorize"]);
  }
}
