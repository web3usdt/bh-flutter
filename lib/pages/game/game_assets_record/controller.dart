import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class GameAssetsRecordController extends GetxController with GetTickerProviderStateMixin {
  GameAssetsRecordController();
  // 投注记录
  List<GameAssetsRecordModel> items = [];

  // tab 控制器
  TabController? tabController;
  // 币种索引
  int tabIndex = 0;
  // 币种列表
  List<Coin> tabNames = [];

  // 是否已初始化
  bool isInitialized = false;

  void onTapTabItem(int index) {
    if (tabController != null && index < tabNames.length) {
      tabIndex = index;
      tabController!.animateTo(index);
      refreshController.requestRefresh();
      update(["gameAssetsRecord"]);
    }
  }

  _initData() async {
    try {
      // 获取游戏配置
      final gameConfig = await GameApi.gameConfig();
      tabNames = gameConfig.coins ?? [];
      // 确保有数据后再初始化tabController
      if (tabNames.isNotEmpty) {
        tabController = TabController(length: tabNames.length, vsync: this);
        isInitialized = true;
        // 刷新一下列表，确保数据正常显示
        refreshController.requestRefresh(needMove: false);
      }
      update(["gameAssetsRecord"]);
    } catch (e) {
      // 设置默认值
      tabNames = [];
      tabController = TabController(length: tabNames.length, vsync: this);
      isInitialized = true;
      update(["gameAssetsRecord"]);
    }
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
    tabController?.dispose();
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
    // 确保已初始化且有选中的币种
    if (!isInitialized || tabNames.isEmpty || tabIndex >= tabNames.length) {
      return true; // 返回空数据
    }
    List<GameAssetsRecordModel> result = [];
    final coinId = tabNames[tabIndex].coinId ?? 0;
    result = await GameApi.gameRecord(coinId, PageListReq(page: isRefresh ? 1 : _page));
    if (isRefresh) {
      _page = 1;
      items.clear();
    }
    if (result.isNotEmpty) {
      _page++;
      items.addAll(result);
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
    update(["gameAssetsRecord"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["gameAssetsRecord"]);
  }
}
