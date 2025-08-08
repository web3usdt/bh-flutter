import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AssetsRecordController extends GetxController {
  AssetsRecordController();
  String image = '';
  String coinName = '';
  String title = '';
  List<AssetsRecordListModel> items = [];
  AssetsRecordBalanceModel balance = AssetsRecordBalanceModel();

  _initData() async {
    if (Get.arguments != null) {
      coinName = Get.arguments['coinName'] ?? '';
      image = Get.arguments['image'] ?? '';
      title = Get.arguments['title'] ?? '';
      print('title: $title');
      if (title == '合约账户') {
        coinName = '合约账户'.tr;
      } else if (title == '挖矿账户') {
        coinName = '挖矿账户'.tr;
      } else if (title == '理财账户') {
        coinName = '理财账户'.tr;
      } else if (title == '资金账户') {
        coinName = '资金账户'.tr;
      }
    }
    update(["assetsRecord"]);
    if (title != '合约账户' && title != '挖矿账户' && title != '理财账户') {
      balance = await AssetsApi.getRecordBalance(coinName);
    }
    update(["assetsRecord"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

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
    List<AssetsRecordListModel> result = [];
    if (title == '合约账户') {
      result = await AssetsApi.getContractRecordList(PageListReq(
        page: isRefresh ? 1 : _page,
      ));
    } else if (title == '挖矿账户') {
      result = await AssetsApi.getRecordList(PageListReq(
        page: isRefresh ? 1 :  _page, 
        coinName: 'XFB', 
        accountType: '5'
      ));
    } else if (title == '理财流水') {
      result = await AssetsApi.getLicaiRecordList(PageListReq(
        page: isRefresh ? 1 : _page,
        coinName: coinName,
      ));
    } else if (title == '资金流水') {
      result = await AssetsApi.getRecordList(PageListReq(
        page: isRefresh ? 1 : _page,
        coinName: coinName,
      ));
    }
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
    update(["assetsRecord"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["assetsRecord"]);
  }
}
