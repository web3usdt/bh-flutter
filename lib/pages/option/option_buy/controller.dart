import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'dart:async';

class OptionBuyController extends GetxController with GetTickerProviderStateMixin {
  OptionBuyController();
  // 交割记录
  List<OptionIndexListModelScenePairList> deliveryRecordList = [];
  // 期权币种列表
  List<OptionCoinListModel> optionCoinList = [];
  // 选择币种名称
  String selectedCoin = '';
  // 选择币种ID
  int selectedCoinId = 0;
  // 期权币种余额
  OptionCoinBalanceModel? optionCoinBalance;
  // 期权导航数据
  List<OptionDetailNavModel> optionDetailNavList = [];
  // 期权折线数据
  List<OptionChartModel> optionChartList = [];
  // 当前交易期权
  OptionIndexListModelScenePairList? currentItem;
  // 下一个交易期权
  OptionIndexListModelScenePairList? nextItem;
  // 期权详情数据
  OptionIndexListModelScenePairList? item;
  // 购买数量
  TextEditingController buyNumberController = TextEditingController();

  // 期权赔率数据
  OptionIndexListModelScenePairList? optionOddsData;
  // 交易类型：1-看多，2-看平，3-看空
  int tradeType = 1;
  // 选中的赔率UUID
  String selectedOddsUuid = '';
  // 选中的赔率对象
  dynamic selectedOddsItem;
  // 快速选择金额
  List<int> quickAmounts = [100, 200, 300, 1000];
  // 倒计时定时器
  Timer? _countdownTimer;
  // 订阅socket推送
  StreamSubscription? _socketSubscription;

  // 时间 tab 控制器
  late TabController tabTimeController;
  // 时间 tab 索引
  int tabTimeIndex = 0;
  // 时间 tab 名称
  List<String> tabTimeNames = ['1M', '5M', '15M', '30M', '1H', '1天', '1月'];
  // 时间状态改变
  onTapTimeTabIndex(int index) {
    tabTimeIndex = index;
    update(["option_buy"]);
  }

  // 功能 tab 控制器
  late TabController tabFunctionController;
  // 功能 tab 索引
  int tabFunctionIndex = 0;
  // 功能 tab 名称
  List<String> tabFunctionNames = ['购买期权'.tr, '等待交割'.tr, '我的交割'.tr, '交割记录'.tr];

  // 功能状态改变
  onTapFunctionTabIndex(int index) {
    deliveryRecordList.clear();
    tabFunctionIndex = index;
    refreshController.requestRefresh();
    update(["option_buy"]);
  }

  // 切换交易对
  onTapOptionNav(ScenePairList value) {
    Get.back();
    // 取消旧订阅
    final channelName = "newPrice_${item?.pairName?.replaceAll('/', '').toLowerCase() ?? ''}";
    SocketService().unsubscribe(channelName);
    print('取消订阅频道: $channelName');

    // 订阅新频道
    item?.pairId = value.pairId;
    item?.timeId = value.timeId;
    item?.pairTimeName = value.pairTimeName;
    item?.pairName = value.pairName;

    // 获取新数据
    _getOptionChart();
    _getCurrentItem();

    // 订阅新频道
    final channelNewName = "newPrice_${item?.pairName?.replaceAll('/', '').toLowerCase()}";
    SocketService().subscribe(channelNewName);
    print('订阅频道: $channelNewName');

    // sceneListNewPrice是全局频道，不需要重新订阅

    update(["option_buy"]);
  }

  // 倒计时结束更新
  void countdownTimerEnd() {
    _getCurrentItem();
    _getOptionOdds();
  }

  // 显示币种选择器
  void showCoinPicker(BuildContext context) async {
    PickerUtils.showPicker(
      context: context,
      title: '选择币种'.tr,
      items: optionCoinList.map((e) => {'id': e.coinId, 'name': e.coinName}).toList(),
      onConfirm: (selected) async {
        selectedCoin = selected['name'];
        selectedCoinId = selected['id'];
        optionCoinBalance = await OptionApi.getOptionCoinBalance(selectedCoinId.toString());
        print('optionCoinBalance: ${optionCoinBalance}');
        update(['option_buy', 'option_buy_bottom']);
      },
      onCancel: () {},
    );
  }

  // 获取期权赔率数据
  void _getOptionOdds() async {
    try {
      optionOddsData = await OptionApi.getOptionOdds(item?.pairId ?? 0, item?.timeId ?? 0);
      // 初始化选中的赔率
      _initSelectedOdds();
      update(['option_buy_bottom']);
    } catch (e) {
      print('获取期权赔率数据失败: $e');
    }
  }

  // 初始化选中的赔率
  void _initSelectedOdds() {
    List<dynamic> oddsRangeList = getCurrentOddsRangeList();
    if (oddsRangeList.isNotEmpty) {
      selectedOddsUuid = oddsRangeList[0].uuid ?? '';
      selectedOddsItem = oddsRangeList[0];
      print('初始化赔率: 类型=$tradeType, 涨幅=${selectedOddsItem?.range}%, 收益率=${selectedOddsItem?.odds}');
    } else {
      selectedOddsUuid = '';
      selectedOddsItem = null;
      print('无可用赔率数据');
    }
  }

  // 获取当前交易类型的赔率列表
  List<dynamic> getCurrentOddsRangeList() {
    if (optionOddsData == null) return [];

    switch (tradeType) {
      case 1: // 看多
        return optionOddsData?.upOdds ?? [];
      case 2: // 看平
        return optionOddsData?.drawOdds ?? [];
      case 3: // 看空
        return optionOddsData?.downOdds ?? [];
      default:
        return [];
    }
  }

  // 获取交易类型配置
  Map<String, dynamic> getTradeTypeConfig() {
    switch (tradeType) {
      case 1:
        return {
          'typeText': '涨'.tr,
          'direction': '看多'.tr,
          'color': AppTheme.colorGreen,
          'backgroundColor': AppTheme.colorGreen,
        };
      case 2:
        return {
          'typeText': '平'.tr,
          'direction': '看平'.tr,
          'color': AppTheme.colorYellow,
          'backgroundColor': AppTheme.colorYellow,
        };
      case 3:
        return {
          'typeText': '跌'.tr,
          'direction': '看空'.tr,
          'color': AppTheme.colorRed,
          'backgroundColor': AppTheme.colorRed,
        };
      default:
        return {
          'typeText': '涨'.tr,
          'direction': '看多'.tr,
          'color': AppTheme.colorGreen,
          'backgroundColor': AppTheme.colorGreen,
        };
    }
  }

  // 设置交易类型
  void setTradeType(int type) {
    // 获取期权赔率数据
    _getOptionOdds();
    tradeType = type;
    _initSelectedOdds();
    update(['option_buy_bottom']);
  }

  // 选择赔率
  void selectOdds(String uuid) {
    selectedOddsUuid = uuid;
    List<dynamic> oddsRangeList = getCurrentOddsRangeList();
    if (oddsRangeList.isNotEmpty) {
      try {
        selectedOddsItem = oddsRangeList.firstWhere(
          (item) => item.uuid == uuid,
        );
        print('选中赔率: ${selectedOddsItem?.range}%, 收益率: ${selectedOddsItem?.odds}');
      } catch (e) {
        print('未找到匹配的赔率项: $uuid');
        selectedOddsItem = null;
      }
    }
    update(['option_buy_bottom']);
  }

  // 快速设置购买数量
  void setQuickAmount(int amount) {
    buyNumberController.text = amount.toString();
    update(['option_buy_bottom']);
  }

  // 计算预期收益
  double calculateExpectedProfit() {
    double amount = double.tryParse(buyNumberController.text) ?? 0;
    double odds = double.tryParse(selectedOddsItem?.odds?.toString() ?? '0') ?? 0;
    double result = amount * odds;
    return result;
  }

  // 购买期权
  void buyOption() async {
    if (buyNumberController.text.isEmpty) return Loading.toast('请输入购买数量'.tr);
    Loading.show();
    var res = await OptionApi.buyScene(OptionBuyReq(
      betAmount: buyNumberController.text,
      betCoinId: selectedCoinId.toString(),
      oddsUuid: selectedOddsUuid,
      sceneId: nextItem?.sceneId.toString(),
    ));
    if (res) {
      Get.back();
      Loading.toast('购买成功'.tr);
      buyNumberController.clear();
      refreshController.requestRefresh();
      optionCoinBalance = await OptionApi.getOptionCoinBalance(selectedCoinId.toString());
      update(['option_buy', 'option_buy_bottom']);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化时设置当前索引
    tabTimeController = TabController(
      length: tabTimeNames.length,
      vsync: this,
      initialIndex: tabTimeIndex, // 设置初始索引
    );
    tabFunctionController = TabController(
      length: tabFunctionNames.length,
      vsync: this,
      initialIndex: tabFunctionIndex, // 设置初始索引
    );

    // 监听购买数量输入变化
    buyNumberController.addListener(() {
      update(['option_buy_bottom']);
    });

    // 监听socket数据
    _socketSubscription = SocketService().messageStream.listen((data) {
      if (data is Map) {
        final sub = data['sub'] as String?;
        if (sub != null && sub.startsWith('newPrice_')) {
          _handleNewPriceUpdate(data['data']);
        } else if (sub == 'sceneListNewPrice') {
          _handleSceneListNewPrice(data['data']);
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    item = Get.arguments['item'];
    // 获取期权折线数据
    _getOptionChart();
    // 获取当前交易期权
    _getCurrentItem();
    // 获取期权币种列表
    optionCoinList = await OptionApi.getOptionCoinList();
    if (optionCoinList.isNotEmpty) {
      selectedCoin = optionCoinList[0].coinName ?? '';
      selectedCoinId = optionCoinList[0].coinId ?? 0;
      optionCoinBalance = await OptionApi.getOptionCoinBalance(selectedCoinId.toString());
    }
    // 获取期权导航数据
    optionDetailNavList = await OptionApi.getOptionDetailNav();

    // 订阅新价格推送
    if (item?.pairName != null) {
      final pairName = item!.pairName!;
      final channelName = "newPrice_${pairName.replaceAll('/', '').toLowerCase()}";
      SocketService().subscribe(channelName);
      print('订阅频道: $channelName');
    }

    // 订阅sceneListNewPrice推送
    SocketService().subscribe("sceneListNewPrice");
    print('订阅sceneListNewPrice频道');

    // 启动倒计时定时器
    _startCountdownTimer();
    update(["option_buy", "option_buy_bottom"]);
  }

  // 处理新价格推送数据
  void _handleNewPriceUpdate(dynamic data) {
    if (data == null) return;
    if (optionChartList.isEmpty) return;

    try {
      if (data is Map) {
        // 创建新的图表数据点
        final newChartData = OptionChartModel(
          id: DataUtils.toInt(data['id']),
          price: DataUtils.toDouble(data['price']),
          ts: DataUtils.toInt(data['ts']),
          tradeId: DataUtils.toInt(data['tradeId']),
          amount: DataUtils.toDouble(data['amount']),
          direction: DataUtils.toStr(data['direction']),
          increase: DataUtils.toDouble(data['increase']),
          increaseStr: DataUtils.toStr(data['increaseStr']),
        );

        // 添加到折线图数据列表
        if (newChartData.price != null && newChartData.ts != null) {
          optionChartList.add(newChartData);

          // 保持数据量合理，只保留最新的1000个数据点
          if (optionChartList.length > 1000) {
            optionChartList.removeAt(0);
          }
          update(["option_buy", "option_buy_bottom"]);
        }
      }
    } catch (e) {
      print('处理newPrice推送数据时出错: $e');
    }
  }

  // 处理sceneListNewPrice推送数据
  void _handleSceneListNewPrice(dynamic data) {
    if (data == null) return;
    if (item?.pairId == null) return;

    try {
      if (data is Map) {
        // 如果推送的是单个更新项，查找并更新对应项
        final pairId = data['pair_id'];
        final trendUp = data['trend_up'];
        final trendDown = data['trend_down'];

        if (pairId != null && pairId == item?.pairId) {
          item?.trendUp = trendUp;
          item?.trendDown = trendDown;
          update(["option_buy", "option_buy_bottom"]);
        }
      }
    } catch (e) {
      print('处理sceneListNewPrice推送数据时出错: $e');
    }
  }

  // 获取当前交易期权
  void _getCurrentItem() async {
    var res = await OptionApi.getCurrentItem(item?.pairId ?? 0, item?.timeId ?? 0);
    currentItem = OptionIndexListModelScenePairList.fromJson(res['current_scene']);
    nextItem = OptionIndexListModelScenePairList.fromJson(res['next_scene']);
    print('currentItem: ${currentItem}');
    print('nextItem: ${nextItem?.sceneId}');
    update(["option_buy", "option_buy_bottom"]);
  }

  // 获取期权折线数据
  void _getOptionChart() async {
    optionChartList = await OptionApi.getOptionChart(item?.pairName ?? '');
    print('optionChartList: ${optionChartList.length}');
    update(["option_buy"]);
  }

  // 启动倒计时定时器
  void _startCountdownTimer() {
    _countdownTimer?.cancel(); // 先取消之前的定时器
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      bool needUpdate = false;
      bool needRefreshData = false;

      // 更新当前期倒计时
      if (currentItem?.lotteryTime != null && currentItem!.lotteryTime! > 0) {
        currentItem!.lotteryTime = currentItem!.lotteryTime! - 1;
        needUpdate = true;

        // 如果当前期倒计时结束，标记需要重新拉取数据
        if (currentItem!.lotteryTime! <= 0) {
          needRefreshData = true;
        }
      }

      // 更新下期倒计时
      if (nextItem?.lotteryTime != null && nextItem!.lotteryTime! > 0) {
        nextItem!.lotteryTime = nextItem!.lotteryTime! - 1;
        needUpdate = true;
      }

      // 遍历导航栏期权数据，更新倒计时
      for (var navItem in optionDetailNavList) {
        if (navItem.scenePairList != null) {
          for (var sceneItem in navItem.scenePairList!) {
            if (sceneItem.lotteryTime != null && sceneItem.lotteryTime! > 0) {
              sceneItem.lotteryTime = sceneItem.lotteryTime! - 1;
              needUpdate = true;
            }
          }
        }
      }

      // 如果当前期倒计时结束，重新获取数据
      if (needRefreshData) {
        countdownTimerEnd();
        return;
      }

      // 如果有数据更新，刷新UI
      if (needUpdate) {
        update(["option_buy", "option_buy_bottom"]);
      }
    });
  }

  // 格式化倒计时显示
  String formatCountdown(int seconds) {
    if (seconds <= 0) return '00:00:00';

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    super.onClose();
    // 取消订阅
    if (item?.pairName != null) {
      final pairName = item!.pairName!;
      final channelName = "newPrice_${pairName.replaceAll('/', '').toLowerCase()}";
      SocketService().unsubscribe(channelName);
      print('取消订阅频道: $channelName');
    }

    // 取消订阅sceneListNewPrice推送
    SocketService().unsubscribe("sceneListNewPrice");
    print('取消订阅sceneListNewPrice频道');

    _socketSubscription?.cancel();
    // 取消倒计时定时器
    _countdownTimer?.cancel();
    tabTimeController.dispose();
    tabFunctionController.dispose();
    buyNumberController.dispose();
  }

// 查看K线
  void goKLine() async {
    Get.toNamed(AppRoutes.contractKChart, arguments: {'pairName': item?.pairName, 'router': 'option'});
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
    List<OptionIndexListModelScenePairList> result;
    if (tabFunctionIndex == 0 || tabFunctionIndex == 1 || tabFunctionIndex == 2) {
      result = await OptionApi.getDeliveryRecordList(
          PageListReq(
            page: isRefresh ? 1 : _page,
          ),
          item?.pairId ?? 0,
          item?.timeId ?? 0,
          tabFunctionIndex);
    } else {
      result = await OptionApi.getDeliveryRecordList(
          PageListReq(
            page: isRefresh ? 1 : _page,
          ),
          item?.pairId ?? 0,
          item?.timeId ?? 0,
          tabFunctionIndex);
    }
    if (isRefresh) {
      _page = 1;
      deliveryRecordList.clear();
    }
    if (result.isNotEmpty) {
      _page++;
      deliveryRecordList.addAll(result);
    }
    // 是否是空
    return result.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (deliveryRecordList.isNotEmpty) {
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
    update(["option_buy"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["option_buy"]);
  }
}
