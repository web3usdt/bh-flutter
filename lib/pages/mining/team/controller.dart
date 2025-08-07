import 'dart:convert';

import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TeamController extends GetxController {
  TeamController();
  // 矿机团队信息
  MiningTeamInfoModel miningTeamInfo = MiningTeamInfoModel();
  // 团队统计
  MiningTeamInfoModel miningTeamStat = MiningTeamInfoModel();
  List<MiningTeamListModel> items = [];

  _initData() async {
    miningTeamInfo = await MiningApi.getMiningTeamInfo();
    miningTeamStat = await MiningApi.getMiningTeamStat();

    Storage().setJson('miningTeamInfo', miningTeamInfo);
    update(["team"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    // 矿机团队信息
    var stringMiningTeamInfo = Storage().getString('miningTeamInfo');
    miningTeamInfo = stringMiningTeamInfo != "" ? MiningTeamInfoModel.fromJson(jsonDecode(stringMiningTeamInfo)) : MiningTeamInfoModel();

    var stringTeamItems = Storage().getString('teamItems');
    items = stringTeamItems != "" ? (jsonDecode(stringTeamItems) as List).map((e) => MiningTeamListModel.fromJson(e)).toList() : [];
    update(["team"]);
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
    var result = await MiningApi.getMiningTeamList(PageListReq(
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
        Storage().setJson('teamItems', items);
      }
    } else {
      Storage().remove('teamItems');
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
    update(["team"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["team"]);
  }
}
