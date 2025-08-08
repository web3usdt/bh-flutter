import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:BBIExchange/common/index.dart';
import 'package:k_chart/flutter_k_chart.dart';

class ContractKChartController extends GetxController with GetSingleTickerProviderStateMixin {
  ContractKChartController();

  // 订阅socket行情
  StreamSubscription? _socketSubscription;
  // 路由
  String router = '';

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
  List<SwapBuyList>? buyList;
  // 市场行情：卖
  List<SwapSellList>? sellList;
  // 市场行情：交易记录
  List<SwapTradeList>? tradeList;
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
    print('changeSymbol: $newPairName');
    // 取消旧频道订阅
    if (coinName.isNotEmpty) {
      SocketService2().unsubscribe("swapMarketList");
      SocketService2().unsubscribe("swapTradeList_${coinName}");
      SocketService2().unsubscribe("swapBuyList_${coinName}");
      SocketService2().unsubscribe("swapSellList_${coinName}");
      // 取消K线频道
      SocketService2().unsubscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    }

    pairName = newPairName;
    print('pairName: $pairName');

    // 从pairName中提取coinName (例如 BTC/USDT -> BTC)
    coinName = pairName.split('/').first;
    print('coinName: $coinName');

    // 订阅新频道
    SocketService2().subscribe("swapMarketList");
    SocketService2().subscribe("swapTradeList_${coinName}");
    SocketService2().subscribe("swapBuyList_${coinName}");
    SocketService2().subscribe("swapSellList_${coinName}");
    // 订阅K线频道
    SocketService2().subscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    print('重新初始化');
    _initData();
    update(["contract_k_chart"]);
  }

  // 币种 pairName 格式：'BTC/USDT'
  String pairName = '';
  // 币种名称 例如：BTC
  String coinName = '';
  // 涨跌幅
  String pairRatio = '';
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
    update(["contract_k_chart"]);
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
  List<String> tabNames = [
    '自选'.tr,
    '永续'.tr,
  ];

  // 获取指定币种的所有市场
  List<MarketInfoListModel> getMarketList(String coinName) {
    final result = <MarketInfoListModel>[];
    List<MarketInfoListModel> sourceList = [];

    // 获取永续列表
    for (var parentItem in coinList) {
      if (parentItem.coinName == 'USDT') {
        sourceList = parentItem.marketInfoList ?? [];
        break;
      }
    }

    // 根据选择的tab返回不同的列表
    if (coinName == '自选'.tr) {
      // 自选：只返回收藏列表和永续列表中pairName相同的项目
      for (var item in sourceList) {
        if (collectCoinList.any((collectItem) => collectItem.pairName == item.pairName)) {
          result.add(item);
        }
      }
    } else {
      // 永续：直接使用永续列表
      result.addAll(sourceList);
    }

    // 搜索过滤
    if (searchKeyword.isNotEmpty) {
      return result.where((item) => (item.pairName ?? '').toLowerCase().contains(searchKeyword.toLowerCase())).toList();
    }

    return result;
  }

  // 初始化数据
  @override
  void onInit() {
    super.onInit();
    pairName = Get.arguments?['pairName'] ?? '';
    router = Get.arguments?['router'] ?? '';
    if (pairName.isNotEmpty) {
      coinName = pairName.split('/').first;
    }
    _initData();

    // 初始化并连接WebSocket2
    SocketService2().init();
    SocketService2().connect();

    // 订阅频道
    if (coinName.isNotEmpty) {
      SocketService2().subscribe("swapMarketList");
      SocketService2().subscribe("swapTradeList_${coinName}");
      SocketService2().subscribe("swapBuyList_${coinName}");
      SocketService2().subscribe("swapSellList_${coinName}");
      // 订阅K线频道
      SocketService2().subscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    }

    // 监听socket数据
    _socketSubscription = SocketService2().messageStream.listen((data) {
      if (data is Map) {
        // 处理swapMarketList频道数据
        if (data['sub'] == 'swapMarketList') {
          try {
            coinList = (data['data'] as List).map((item) => MarketList.fromJson(item)).toList();
            // 查找当前pairName对应的涨跌幅和当前币种
            for (var market in coinList) {
              for (var item in market.marketInfoList ?? []) {
                if (item.pairName == pairName) {
                  pairRatio = item.increaseStr ?? '';
                  currentCoin = item;
                  break;
                }
              }
            }
            update(["contract_k_chart", "buildCoinNav"]);
          } catch (e) {
            print('处理swapMarketList数据出错: $e');
          }
        }
        // 处理swapTradeList_币种 频道数据
        else if (data['sub']?.toString().startsWith('swapTradeList_') == true && data['sub']?.toString().contains(coinName) == true) {
          try {
            final newItem = SwapTradeList.fromJson(data['data']);

            // 将新数据添加到tradeList
            if (tradeList == null) {
              tradeList = [];
            }
            tradeList!.insert(0, newItem);
            // 保持列表不要太长
            if (tradeList!.length > 20) {
              tradeList = tradeList!.sublist(0, 20);
            }

            update(["contract_k_chart"]);
          } catch (e) {
            print('处理swapTradeList数据出错: $e');
          }
        }
        // 处理swapBuyList_币种 频道数据
        else if (data['sub']?.toString().startsWith('swapBuyList_') == true && data['sub']?.toString().contains(coinName) == true) {
          try {
            buyList = (data['data'] as List).map((item) => SwapBuyList.fromJson(item)).toList();
            // 不截取数据，使用全部数据
            // 买盘按价格从高到低排列
            buyList?.sort((a, b) => double.parse(b.price ?? '0').compareTo(double.parse(a.price ?? '0')));
            // print('buyList socket: ${buyList?.map((e) => e.price)}');
            update(["contract_k_chart"]);
          } catch (e) {
            print('处理swapBuyList数据出错: $e');
          }
        }
        // 处理swapSellList_币种 频道数据
        else if (data['sub']?.toString().startsWith('swapSellList_') == true && data['sub']?.toString().contains(coinName) == true) {
          try {
            sellList = (data['data'] as List).map((item) => SwapSellList.fromJson(item)).toList();
            // 不截取数据，使用全部数据
            // 卖盘按价格从低到高排列
            sellList?.sort((a, b) => double.parse(a.price ?? '0').compareTo(double.parse(b.price ?? '0')));
            // print('sellList socket: ${sellList?.map((e) => e.price)}');
            update(["contract_k_chart"]);
          } catch (e) {
            print('处理swapSellList数据出错: $e');
          }
        }
        // 处理K线数据
        else if (data['sub']?.toString().startsWith('Kline_') == true &&
            data['sub']?.toString().contains(pairName.replaceAll('/', '').toLowerCase()) == true) {
          try {
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
            double open = newModel.open ?? 0;
            double close = newModel.close ?? 0;
            double change = close - open;
            double ratio = (change / open) * 100;
            KLineEntity entity = KLineEntity.fromCustom(
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
            update(["contract_k_chart"]);
          } catch (e) {
            print('处理K线数据出错: $e');
          }
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    // 取消订阅
    if (coinName.isNotEmpty) {
      SocketService2().unsubscribe("swapMarketList");
      SocketService2().unsubscribe("swapTradeList_${coinName}");
      SocketService2().unsubscribe("swapBuyList_${coinName}");
      SocketService2().unsubscribe("swapSellList_${coinName}");
      // 取消K线频道
      SocketService2().unsubscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    }
    _socketSubscription?.cancel();
  }

  // 初始化数据
  void _initData() async {
    coinList = await ContractApi.coinList();
    if (pairName.isEmpty) {
      print('_initData的pairName 是空吗？');
      pairName = coinList.first.marketInfoList?.first.pairName ?? '';
      coinName = pairName.split('/').first;
    }

    // 查找当前币种信息
    for (var element in coinList) {
      for (var item in element.marketInfoList ?? []) {
        if (item.pairName == pairName) {
          currentCoin = item;
          pairRatio = item.increaseStr ?? '';
          break;
        }
      }
    }

    fetchKLineData();
    // 收藏币种列表
    collectCoinList = await CoinApi.collectCoinList();
    // 市场行情
    print('市场行情: $coinName');
    var marketinfo = await ContractApi.coinMarketinfo(coinName);
    // 获取全部买卖盘数据，不截取
    buyList = marketinfo.swapBuyList ?? [];
    // 买盘按价格从高到低排序
    // buyList?.sort((a, b) => double.parse(b.price ?? '0').compareTo(double.parse(a.price ?? '0')));
    // print('buyList: ${buyList?.map((e) => e.price)}');

    sellList = marketinfo.swapSellList ?? [];
    // 卖盘按价格从低到高排序（与买盘相反）
    // sellList?.sort((a, b) => double.parse(a.price ?? '0').compareTo(double.parse(b.price ?? '0')));
    // print('sellList: ${sellList?.map((e) => e.price)}');

    tradeList = marketinfo.swapTradeList ?? [];

    // 币种信息
    print('币种信息: $coinName');
    coinInfo = await CoinApi.coinCoinInfomsg(coinName);
    update(["contract_k_chart", "buildCoinNav"]);
  }

  fetchKLineData() async {
    currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    oneDayAgoTime = currentTime - 24 * 60 * 60;
    // 获取K线数据
    kLineData = await CoinApi.coinKline(CoinKlineReq(symbol: pairName, period: period, form: oneDayAgoTime, to: currentTime, size: 500));
    datas = kLineData.map((item) {
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
    update(["contract_k_chart"]);
  }

  // 切换时间周期
  void changePeriod(String newPeriod) {
    if (period == newPeriod) return;
    // 取消K线频道
    SocketService2().unsubscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$period");
    period = newPeriod;
    // 订阅K线频道
    SocketService2().subscribe("Kline_${pairName.replaceAll('/', '').toLowerCase()}_$newPeriod");
    fetchKLineData();
    update(["contract_k_chart"]);
  }

  // 切换主图指标
  void changeMainState(MainState state) {
    mainState = state;
    update(["contract_k_chart"]);
  }

  // 切换副图指标
  void changeSecondaryState(SecondaryState state) {
    secondaryState = state;
    update(["contract_k_chart"]);
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
    update(["contract_k_chart"]);
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
    // 使用全部数据计算最大深度
    final all = [...(sellList ?? []), ...(buyList ?? [])];
    if (all.isEmpty) return 1;
    return all.map((e) => double.tryParse((e as dynamic).amount ?? '0') ?? 0).reduce((a, b) => a > b ? a : b);
  }
}
