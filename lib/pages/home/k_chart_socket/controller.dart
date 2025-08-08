import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart/flutter_k_chart.dart';

import 'package:BBIExchange/common/index.dart';

class KChartController extends GetxController with GetSingleTickerProviderStateMixin {
  KChartController();

  // 订阅socket行情
  StreamSubscription? _socketSubscription;

  // 获取K线数据
  List<CoinKlineModel> kLineData = [];
  // 当前时间的时间戳：秒
  int currentTime = 0;
  // 相对于当前时间，一天前的时间戳：秒
  int oneDayAgoTime = 0;
  // 当前选中的币种
  MarketInfoListModel currentCoin = MarketInfoListModel();
  // 币种信息
  CoinCoinInfomsgModel coinInfo = CoinCoinInfomsgModel();
  // 币种列表
  List<MarketList> coinList = [];
  // 收藏币种列表
  List<MarketInfoListModel> collectCoinList = [];
  // 市场行情：买
  List<BuyList>? buyList;
  // 市场行情：卖
  List<SellList>? sellList;
  // 市场行情：交易记录
  List<TradeList>? tradeList;
  // 搜索栏
  TextEditingController searchController = TextEditingController();
  // 搜索关键词
  String searchKeyword = '';
  // 搜索币种
  void onSearch(String keyword) {
    searchKeyword = keyword.trim();
    update(["buildCoinNav"]);
  }

  // 修改当前币种
  void changeSymbol(String newPairName) {
    // 取消旧频道
    SocketService().unsubscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().unsubscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().unsubscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().unsubscribe("exchangeMarketList");
    SocketService().unsubscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");

    pairName = newPairName;

    // 订阅新频道
    SocketService().subscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("exchangeMarketList");
    SocketService().subscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");

    _initData();
    update(["k_chart"]);
  }

  // 币种 pairName 格式：'BTC/USDT'
  String pairName = '';
  // 头部24小时数据
  HomeKlineHeadPriceModel headPrice = HomeKlineHeadPriceModel();
  // K线数据
  List<KLineEntity> datas = []; // 初始化为空列表
  // 主图指标
  MainState mainState = MainState.MA;
  // 副图指标
  SecondaryState secondaryState = SecondaryState.MACD;
  // 当前选中的时间周期
  String period = '1min'; // 默认1分钟

  //////////////////////////////////////////////////////////////////////////////
  // tab 相关
  // tab 控制器
  late TabController tabController;
  // tab 索引
  int bottomTabIndex = 0;
  // tab 名称
  List<String> bottomTabNames = ['买卖盘'.tr, '最新成交'.tr, '币种信息'.tr];
  onTapBottomTabIndex(int index) {
    bottomTabIndex = index;
    update(["k_chart"]);
  }

  // 切换tab
  onTapTabIndex(String tabName) {
    tabIndex = tabName;
    searchKeyword = '';
    searchController.clear();
    update(["buildCoinNav"]);
  }

  // tab 索引
  String tabIndex = '自选'.tr;
  // tab 名称
  List<String> tabNames = ['自选'.tr];

  // 获取指定币种的所有市场
  List<MarketInfoListModel> getMarketList(String coinName) {
    final result = <MarketInfoListModel>[];
    List<MarketInfoListModel> sourceList = [];
    if (coinName == '自选'.tr) {
      sourceList = collectCoinList;
    } else {
      for (var parentItem in coinList) {
        if (parentItem.coinName == coinName) {
          sourceList = parentItem.marketInfoList ?? [];
          break;
        }
      }
    }
    // 搜索过滤
    if (searchKeyword.isNotEmpty) {
      result.addAll(sourceList.where((item) => (item.pairName ?? '').toLowerCase().contains(searchKeyword.toLowerCase())));
    } else {
      result.addAll(sourceList);
    }
    return result;
  }

  // 初始化数据
  @override
  void onInit() {
    super.onInit();
    pairName = Get.arguments?['pairName'] ?? '';
    _initData();

    // 订阅频道
    SocketService().subscribe("exchangeMarketList");
    SocketService().subscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");
    // 订阅K线频道
    SocketService().subscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");

    // 监听socket数据
    _socketSubscription = SocketService().messageStream.listen((data) {
      if (data is Map && data['sub'] == 'exchangeMarketList') {
        coinList = (data['data'] as List).map((item) => MarketList.fromJson(item)).toList();
        for (var element in coinList) {
          for (var item in element.marketInfoList ?? []) {
            if (item.pairName == pairName) {
              currentCoin = item;
            }
          }
        }
        update(["k_chart", "buildCoinNav"]);
      } else if (data is Map && data['sub'] == 'buyList_${pairName.replaceAll('/', '').toLowerCase()}') {
        buyList = (data['data'] as List).map((item) => BuyList.fromJson(item)).toList();
        update(["k_chart"]);
      } else if (data is Map && data['sub'] == 'sellList_${pairName.replaceAll('/', '').toLowerCase()}') {
        sellList = (data['data'] as List).map((item) => SellList.fromJson(item)).toList();
        update(["k_chart"]);
      } else if (data is Map && data['sub'] == 'tradeList_${pairName.replaceAll('/', '').toLowerCase()}') {
        final newItem = TradeList.fromJson(data['data']);

        // 查找是否已存在相同 ts 的数据
        final index = tradeList?.indexWhere((item) => item.ts == newItem.ts) ?? -1;
        if (index != -1) {
          // 已存在，更新
          tradeList?[index] = newItem;
        } else {
          // 不存在，插入到头部（最新在前）
          tradeList ??= [];
          tradeList!.insert(0, newItem);
          // 如果只保留最新N条，可以加上 tradeList = tradeList.take(N).toList();
        }
        update(["k_chart"]);
      } else if (data is Map && data['sub'] == 'Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period') {
        // 处理K线推送
        var klineMap = data['data'];
        int id = klineMap['id'] ?? 0;
        int existIndex = kLineData.indexWhere((e) => e.id == id);
        CoinKlineModel newModel = CoinKlineModel.fromJson(klineMap);
        if (existIndex != -1) {
          // 已存在，更新
          kLineData[existIndex] = newModel;
        } else {
          // 不存在，追加
          kLineData.add(newModel);
        }
        // 同步到datas
        final double open = newModel.open ?? 0;
        final double close = newModel.close ?? 0;
        final double change = close - open;
        final double ratio = (change / open) * 100;
        final KLineEntity entity = KLineEntity.fromCustom(
          time: newModel.id! * 1000,
          open: open,
          high: newModel.high ?? 0,
          low: newModel.low ?? 0,
          close: close,
          vol: newModel.vol ?? 0,
          amount: newModel.amount ?? 0,
          change: change,
          ratio: ratio,
        );
        int entityIndex = datas.indexWhere((e) => e.time == entity.time);
        if (entityIndex != -1) {
          datas[entityIndex] = entity;
        } else {
          datas.add(entity);
        }
        DataUtil.calculate(datas);
        update(["k_chart"]);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    SocketService().unsubscribe("exchangeMarketList");
    SocketService().unsubscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().unsubscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().unsubscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");
    // 取消K线频道
    SocketService().unsubscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    _socketSubscription?.cancel();
  }

  // 初始化数据
  void _initData() async {
    coinList = await CoinApi.coinList();
    if (pairName.isEmpty) {
      pairName = coinList.first.marketInfoList?.first.pairName ?? '';
    }
    for (var element in coinList) {
      for (var item in element.marketInfoList ?? []) {
        if (item.pairName == pairName) {
          currentCoin = item;
          break;
        }
      }
    }

    // 循环coinList，将coinName添加到tabNames中
    if (tabNames.length == 1) {
      for (var item in coinList) {
        if (item.coinName != 'USDC') {
          tabNames.add(item.coinName ?? '');
        }
      }
    }
    fetchKLineData();
    // 收藏币种列表
    collectCoinList = await CoinApi.collectCoinList();
    // 市场行情
    var marketinfo = await CoinApi.coinMarketinfo(pairName);
    buyList = marketinfo.buyList ?? [];
    sellList = marketinfo.sellList ?? [];
    tradeList = marketinfo.tradeList ?? [];
    // 币种信息
    coinInfo = await CoinApi.coinCoinInfomsg(pairName.split('/').first);
    update(["k_chart", "buildCoinNav"]);
  }

  fetchKLineData() async {
    currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    oneDayAgoTime = currentTime - 24 * 60 * 60;
    // 获取K线数据
    kLineData = await CoinApi.coinKline(CoinKlineReq(symbol: pairName, period: period, form: oneDayAgoTime, to: currentTime, size: 500));
    datas = kLineData.map((item) {
      // print('item: ${item.toJson()}');
      double open = item.open ?? 0;
      double close = item.close ?? 0;
      double change = close - open; // change: 价格变化，通常是收盘价与开盘价的差值
      double ratio = (change / open) * 100; // ratio: 价格变化百分比

      return KLineEntity.fromCustom(
        time: item.id! * 1000,
        open: open,
        high: item.high ?? 0,
        low: item.low ?? 0,
        close: close,
        vol: item.vol ?? 0,
        amount: item.amount ?? 0,
        change: change,
        ratio: ratio,
      );
    }).toList();
    DataUtil.calculate(datas);
    update(["k_chart"]);
  }

  // 切换时间周期
  void changePeriod(String newPeriod) {
    if (period == newPeriod) return;
    // 取消K线频道
    SocketService().unsubscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    period = newPeriod;
    // 订阅K线频道
    SocketService().subscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$newPeriod");
    fetchKLineData();
    update(["k_chart"]);
  }

  // 切换主图指标
  void changeMainState(MainState state) {
    mainState = state;
    update(["k_chart"]);
  }

  // 切换副图指标
  void changeSecondaryState(SecondaryState state) {
    secondaryState = state;
    update(["k_chart"]);
  }

  // 获取价格变化颜色
  Color getPriceChangeColor(String? percent) {
    if (percent == null) return AppTheme.colorGreen;
    // 转换为 double 进行比较
    try {
      double value = double.parse(percent);
      return value < 0 ? AppTheme.colorRed : AppTheme.colorGreen;
    } catch (e) {
      return AppTheme.colorGreen; // 转换失败返回默认颜色
    }
  }

  // 收藏币种
  void onCollectCoin(String pairName) async {
    Loading.show();
    var res = await CoinApi.collectCoin(pairName);
    if (res) {
      Loading.success('收藏成功'.tr);
      collectCoinList = await CoinApi.collectCoinList();
    } else {
      Loading.error('取消收藏'.tr);
      collectCoinList.removeWhere((item) => item.pairName == pairName);
    }
    update(["k_chart"]);
  }

  // 是否已收藏币种
  bool isCollectCoin(String pairName) {
    return collectCoinList.any((item) => item.pairName == pairName);
  }

  // 买入/卖出
  void onBuySell(int type) {
    Get.back(result: {'pairName': pairName, 'type': type});
  }

  // 计算深度最大数量
  double getDepthMaxAmountForDisplay() {
    final displaySellList = sellList?.take(sellList?.length ?? 0).toList() ?? [];
    final displayBuyList = buyList?.take(buyList?.length ?? 0).toList() ?? [];
    final all = [...displaySellList, ...displayBuyList];
    if (all.isEmpty) return 1;
    return all.map((e) => double.tryParse((e as dynamic).amount ?? '0') ?? 0).reduce((a, b) => a > b ? a : b);
  }
}
