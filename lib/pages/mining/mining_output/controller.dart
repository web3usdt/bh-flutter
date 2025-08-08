import 'dart:convert';

import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/common/models/mining/mining_coin_record_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MiningOutputController extends GetxController {
  MiningOutputController();
  List<MiningCoinRecordModel> items = [];
  String _cacheKey = ''; // 动态缓存 Key

  void _generateCacheKey() {
    var stringUserInfo = Storage().getString('userInfo');
    if (stringUserInfo.isNotEmpty) {
      try {
        var userInfo = User.fromJson(jsonDecode(stringUserInfo));
        if (userInfo.id != null) {
          _cacheKey = 'miningOutputItems_${userInfo.id}';
        } else {
          _cacheKey = 'miningOutputItems_guest'; // 未登录或无ID时的备用Key
        }
      } catch (e) {
        _cacheKey = 'miningOutputItems_guest';
      }
    } else {
      _cacheKey = 'miningOutputItems_guest';
    }
  }

  _initData() {
    update(["mining_output"]);
  }

  @override
  void onInit() {
    super.onInit();
    _generateCacheKey(); // 初始化时生成缓存 Key
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    if (_cacheKey.isEmpty) return;
    var stringMiningOutputItems = Storage().getString(_cacheKey);
    items = stringMiningOutputItems != ""
        ? jsonDecode(stringMiningOutputItems).map<MiningCoinRecordModel>((item) {
            return MiningCoinRecordModel.fromJson(item);
          }).toList()
        : [];
    update(["mining_output"]);
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
    var result = await MiningApi.getMiningCoinRecordList(PageListReq(
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
        if (_cacheKey.isNotEmpty) {
          Storage().setJson(_cacheKey, items);
        }
      }
    } else {
      if (_cacheKey.isNotEmpty) {
        Storage().remove(_cacheKey);
      }
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
    update(["mining_output"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["mining_output"]);
  }
}
