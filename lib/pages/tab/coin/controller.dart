import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/pages/tab/main/controller.dart';

class CoinController extends GetxController {
  CoinController();

  // 订阅socket行情
  StreamSubscription? _socketSubscription;
  // 轮询定时器
  Timer? _authorizeTimer;

  // 当前委托
  List<CoinMyAuthorizeModel> currentAuthorizeItems = [];
  // 导航栏
  String pairName = '';
  // 当前币种
  String coinName = '';
  // 当前币种的比例
  String pairRatio = '';
  // 总值
  String total = '0.00000000';
  // 市场行情
  CoinMarketinfoModel marketinfo = CoinMarketinfoModel();
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
  // 买入价格
  String buyPrice = '0';
  // 卖出价格
  String sellPrice = '0';
  // 最新价格
  String latestPrice = '0';
  // 深度总价
  String depthTotal = '0.0';
  // 当前币种余额
  CoinBalanceModel? currentCoinBalance;
  // 目标币种余额
  CoinBalanceModel? targetCoinBalance;
  // 目标币种的币价
  String targetCoinPrice = '0';
  // 自定义限价总价
  String customTotal = '0';
  // 搜索栏
  TextEditingController searchController = TextEditingController();
  // 搜索关键词
  String searchKeyword = '';
  // tab 索引
  String tabIndex = '自选'.tr;
  // tab 名称
  List<String> tabNames = ['自选'.tr];
  // 切换tab
  onTapTabIndex(String tabName) {
    tabIndex = tabName;
    searchKeyword = '';
    searchController.clear();
    update(["buildCoinNav"]);
  }

  // 搜索币种
  void onSearch(String keyword) {
    searchKeyword = keyword.trim();
    update(["buildCoinNav"]);
  }

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

  // 修改当前币种和支付币种
  changeSymbol(MarketInfoListModel item) {
    // 取消旧频道
    if (pairName.isNotEmpty) {
      print('取消旧频道: $pairName');
      SocketService().unsubscribe("exchangeMarketList");
      SocketService().unsubscribe("tradeNew_${pairName.replaceAll('/', '').toLowerCase()}");
      SocketService().unsubscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
      SocketService().unsubscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
      SocketService().unsubscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");
    }
    print('修改当前币种和支付币种: ${item.pairName}');
    pairName = item.pairName ?? '';
    coinName = item.coinName ?? '';
    pairRatio = item.increaseStr ?? '';
    amountController.clear();
    total = '0';
    percent = 0;
    latestPrice = '';
    depthTotal = '0.0';
    selectedOrderType = '市价'.tr;
    selectedAmountUnit = '金额'.tr;

    // 订阅新频道
    // 订阅 tradeNew_xfbusdt 频道
    SocketService().subscribe("exchangeMarketList");
    SocketService().subscribe("tradeNew_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
    SocketService().subscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");

    _initData();
    update(["coin"]);
  }

  // 买入1、卖出2 状态
  int buySellStatus = 1;
  changeBuySellStatus(int status) {
    amountController.clear();
    total = '0';
    percent = 0;
    selectedOrderType = '市价'.tr;
    selectedAmountUnit = '金额'.tr;
    buySellStatus = status;
    limitPriceController.text = buyPrice;
    if (status == 2) {
      limitPriceController.text = sellPrice;
    }
    update(["coin"]);
  }

  // 限价、市价 状态
  final List<String> orderTypes = ['市价'.tr, '限价'.tr];
  String? selectedOrderType = '市价'.tr;
  changeOrderType(String type) {
    amountController.clear();
    total = '0';
    percent = 0;
    selectedOrderType = type;
    if (type == '市价'.tr) {
      selectedAmountUnit = '金额'.tr;
    } else {
      selectedAmountUnit = '单位'.tr;
    }
    update(["coin"]);
  }

  // 金额、单位 状态
  final List<String> amountUnits = ['金额'.tr, '单位'.tr];
  String? selectedAmountUnit = '金额'.tr;
  changeAmountUnit(String unit) {
    amountController.clear();
    total = '0';
    percent = 0;
    selectedAmountUnit = unit;
    update(["coin"]);
  }

  // 加减号，每次步进0.01
  void onLimitPriceStep(String type) {
    if (type == '+') {
      limitPriceController.text = MathUtils.addDecimal(limitPriceController.text, 0.01, 8);
    } else {
      limitPriceController.text = MathUtils.subtrDecimal(limitPriceController.text, 0.01, 8);
      // 如果limitPriceController.text小于0，则默认为0
      if (double.parse(limitPriceController.text) < 0) {
        limitPriceController.text = '0.00000000';
      }
    }
    onLimitPriceChange(limitPriceController.text);
  }

  // 限价输入框
  TextEditingController limitPriceController = TextEditingController();
  onLimitPriceChange(String value) {
    limitPriceController.text = value;
    percent = 0;
    if (value.isEmpty) {
      customTotal = '0';
      total = '0';
      update(["coin", "buildLeft"]);
      return;
    }
    customTotal = MathUtils.multipleDecimal(value, targetCoinPrice, 2);
    total = MathUtils.multipleDecimal(amountController.text, limitPriceController.text, 8);
    update(["coin", "buildLeft"]);
  }

  // 数量输入框
  TextEditingController amountController = TextEditingController();
  onAmountChange(String value) {
    percent = 0;
    if (value.isEmpty) {
      customTotal = '0';
      total = '0';
      update(["coin", "buildLeft"]);
      return;
    }
    // 市价模式，直接算总值
    if (selectedOrderType == '市价'.tr && value.isNotEmpty && double.parse(value) > 0) {
      total = MathUtils.multipleDecimal(value, latestPrice, 10);
    } else {
      total = MathUtils.multipleDecimal(value, limitPriceController.text, 8);
    }
    update(["buildLeft"]);
  }

  // 百分比
  int percent = 0;
  // 修改百分比
  void onPercentChange(int value) {
    print('onPercentChange: $value');
    percent = value;
    double percentValue = value / 100.0;
    double? available;
    // 买入
    if (buySellStatus == 1) {
      available = targetCoinBalance?.usableBalance ?? 0;
      print('available: $available');
      // 市价-金额模式，直接填金额
      if (selectedOrderType == '市价'.tr && selectedAmountUnit == '金额'.tr) {
        if (value == 100) {
          // available=377.725959  转整数 377，舍去小数位，不四舍五入
          amountController.text = available.truncate().toString();
        } else {
          amountController.text = (available * percentValue).toStringAsFixed(0);
        }
      } else {
        // 限价或市价-单位，需用价格算数量
        double price = double.tryParse(buyPrice) ?? 0;
        if (price > 0) {
          double qty = (available * percentValue) / price;
          amountController.text = qty.toStringAsFixed(0);
        }
      }
    } else {
      // 卖出
      available = currentCoinBalance?.usableBalance ?? 0;
      if (value == 100) {
        amountController.text = available.truncate().toString();
      } else {
        amountController.text = (available * percentValue).toStringAsFixed(0);
      }
    }
    // 触发数量变更，自动算总值
    if (buySellStatus == 1) {
      // 买入
      total = MathUtils.multipleDecimal(amountController.text, limitPriceController.text, 8);
    } else {
      // 卖出
      total = MathUtils.multipleDecimal(amountController.text, limitPriceController.text, 8);
    }
    update(["coin", "buildLeft"]);
  }

  // 是否已收藏币种
  bool isCollectCoin(String pairName) {
    return collectCoinList.any((item) => item.pairName == pairName);
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
    update(["coin"]);
  }

  // 下单买入/卖出
  void onStoreEntrust() async {
    if (amountController.text.isEmpty) return Loading.toast('请输入数量'.tr);
    Loading.show();
    var req = CoinStoreEntrustReq();
    if (buySellStatus == 1) {
      // 买入参数
      req = CoinStoreEntrustReq(
        direction: 'buy',
        type: selectedOrderType == '限价'.tr ? '1' : '2',
        symbol: pairName,
        entrustPrice: selectedOrderType == '市价'.tr ? '0' : limitPriceController.text,
        amount: amountController.text,
        total: selectedAmountUnit == '金额'.tr ? amountController.text : total,
        triggerPrice: null,
      );
    } else {
      // 卖出参数
      req = CoinStoreEntrustReq(
        direction: 'sell',
        type: selectedOrderType == '限价'.tr ? '1' : '2',
        symbol: pairName,
        entrustPrice: selectedOrderType == '限价'.tr ? limitPriceController.text : '0',
        amount: amountController.text,
        total: total,
        triggerPrice: null,
      );
    }

    final res = await CoinApi.storeEntrust(req);
    if (res) {
      Loading.success(buySellStatus == 1 ? '买入成功'.tr : '卖出成功'.tr);
      amountController.clear();
      getCoinBalance();
      getCurrentAuthorize();
      update(["coin"]);
    }
  }

  // 获取当前和目标：币种余额
  Future<void> getCoinBalance() async {
    final balanceMap = await CoinApi.coinBalance(pairName); // pairName 是当前交易对
    currentCoinBalance = balanceMap[coinName]; // 当前币种余额
    // print('当前币种余额=: ${currentCoinBalance?.coinName}');
    // pairName = 'XFB/USDT'
    // targetCoinBalance = USDT
    targetCoinBalance = balanceMap[pairName.split('/').last]; // 目标币种余额（如USDT，可根据实际业务调整）
    // print('目标币种余额=: ${targetCoinBalance?.coinName}');

    // 获取目标币种的币价
    var price = await CoinApi.targetCoinPrice(targetCoinBalance?.coinName ?? '');
    targetCoinPrice = price.toString();
    // print('目标币种币价=: $targetCoinPrice');
    depthTotal = MathUtils.multipleDecimal(buySellStatus == 1 ? buyPrice : sellPrice, targetCoinPrice, 2);

    update(["coin"]);
  }

  // 获取当前授权
  getCurrentAuthorize() async {
    currentAuthorizeItems = await CoinApi.myAuthorizeList(PageListReq(
      page: 1,
    ));
    // print('轮询currentAuthorizeItems: ${currentAuthorizeItems.length}');
    update(["coin"]);
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
              getCurrentAuthorize();
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

  // 查看K线
  void goKLine() async {
    // 暂停轮询定时器
    _stopAuthorizeTimer();

    var res = await Get.toNamed(AppRoutes.kChart, arguments: {'pairName': pairName});

    // 返回后重新启动轮询定时器
    _startAuthorizeTimer();

    if (res != null) {
      buySellStatus = res['type'];
      update(["coin", "buildCoinNav", "buildRight", "buildLeft"]);
      // 你需要先查到MarketInfoListModel
      final MarketInfoListModel? item = findMarketInfoByPairName(res['pairName']);
      if (item != null) {
        changeSymbol(item);
      }
      _initData();
    }
  }

  // 查看我的授权页面
  void goMyAuthorizePage() async {
    // 暂停轮询定时器
    _stopAuthorizeTimer();

    await Get.toNamed(AppRoutes.myAuthorize);

    // 返回后重新启动轮询定时器
    _startAuthorizeTimer();
  }

  // 辅助方法
  MarketInfoListModel? findMarketInfoByPairName(String pairName) {
    for (var market in coinList) {
      for (var item in market.marketInfoList ?? []) {
        if (item.pairName == pairName) return item;
      }
    }
    return null;
  }

  // 点击深度
  void onTapDepth(dynamic item) {
    // 如果是限价，赋值给输入框
    if (selectedOrderType == '限价'.tr) {
      limitPriceController.text = item.price ?? '';
      onLimitPriceChange(limitPriceController.text);
    }
    print('onTapDepth: ${item.price}');
    update(["coin"]);
  }

  @override
  void onInit() {
    super.onInit();

    // 监听socket数据
    _socketSubscription = SocketService().messageStream.listen((data) {
      if (pairName.isEmpty) return; // 如果pairName为空，不处理socket数据

      if (data is Map && data['sub'] == 'exchangeMarketList') {
        coinList = (data['data'] as List).map((item) => MarketList.fromJson(item)).toList();
        // 查找当前pairName对应的涨跌幅
        for (var market in coinList) {
          for (var item in market.marketInfoList ?? []) {
            if (item.pairName == pairName) {
              pairRatio = item.increaseStr ?? '';
              break;
            }
          }
        }
        update(["coin", "buildCoinNav"]);
      } else if (data is Map && data['sub'] == 'buyList_${pairName.replaceAll('/', '').toLowerCase()}') {
        buyList = (data['data'] as List).map((item) => BuyList.fromJson(item)).toList();
        // 取0-8的数据
        buyList = buyList?.sublist(0, 8) ?? [];
        update(["coin"]);
      } else if (data is Map && data['sub'] == 'sellList_${pairName.replaceAll('/', '').toLowerCase()}') {
        sellList = (data['data'] as List).map((item) => SellList.fromJson(item)).toList();
        // 取0-8的数据
        sellList = sellList?.sublist(0, 8) ?? [];
        update(["coin"]);
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
        update(["coin"]);
      } else if (data is Map && data['sub'] == 'tradeNew_${pairName.replaceAll('/', '').toLowerCase()}') {
        // 新增 tradeNew_xfbusdt 频道处理
        var price = data['data']['price'];
        latestPrice = price;
        // print('latestPrice: $latestPrice');
        if (selectedOrderType == '市价'.tr && amountController.text.isNotEmpty && double.parse(amountController.text) > 0) {
          total = MathUtils.multipleDecimal(amountController.text, latestPrice, 10);
        }
        if (targetCoinPrice.isNotEmpty && latestPrice.isNotEmpty) {
          depthTotal = MathUtils.multipleDecimal(latestPrice, targetCoinPrice, 2);
        } else {
          depthTotal = '0.0';
        }
        update(["coin", "buildLeft", "buildRight"]);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
    // 启动轮询定时器，每5秒获取一次当前授权
    _startAuthorizeTimer();
  }

  @override
  void onClose() {
    super.onClose();
    // 取消订阅
    if (pairName.isNotEmpty) {
      SocketService().unsubscribe("exchangeMarketList");
      SocketService().unsubscribe("tradeNew_${pairName.replaceAll('/', '').toLowerCase()}");
      SocketService().unsubscribe("buyList_${pairName.replaceAll('/', '').toLowerCase()}");
      SocketService().unsubscribe("sellList_${pairName.replaceAll('/', '').toLowerCase()}");
      SocketService().unsubscribe("tradeList_${pairName.replaceAll('/', '').toLowerCase()}");
    }
    _socketSubscription?.cancel();
    // 清除轮询定时器
    _authorizeTimer?.cancel();
    amountController.dispose();
    limitPriceController.dispose();
    print('onClose 关闭轮询');
  }

  // 初始化数据
  /* 如果mainController中包含pairName ：说明是从首页进入K线，K线点击买入/卖出后，跳转到币币页面。
   * 设置默认pairName，并重置mainController中的pairName
   * 重新触发切换币种changeSymbol(item)，重新触发取消订阅+订阅新币种
   */
  _initData() async {
    coinList = await CoinApi.coinList();
    collectCoinList = await CoinApi.collectCoinList();
    // 获取主控制器
    final mainController = Get.find<MainController>();
    // 获取分类ID
    if (mainController.pairName.isNotEmpty) {
      pairName = mainController.pairName;
      buySellStatus = mainController.type;
      // 重置ID
      mainController.pairName = '';
      mainController.type = 0;
      // 你需要先查到MarketInfoListModel
      final MarketInfoListModel? item = findMarketInfoByPairName(pairName);
      if (item != null) {
        changeSymbol(item);
      }
    } else {
      if (pairName.isEmpty) {
        // 循环coinList，将coinName添加到tabNames中
        for (var item in coinList) {
          tabNames.add(item.coinName ?? '');
        }
        changeSymbol(coinList.first.marketInfoList?.first ?? MarketInfoListModel());
      } else {
        marketinfo = await CoinApi.coinMarketinfo(pairName);
      }
      // 取0-8的数据
      if (marketinfo.buyList?.isNotEmpty == true) {
        buyList = marketinfo.buyList?.sublist(0, 8) ?? [];
      } else {
        buyList = [];
      }
      if (marketinfo.sellList?.isNotEmpty == true) {
        sellList = marketinfo.sellList?.sublist(0, 8) ?? [];
      } else {
        sellList = [];
      }
      tradeList = marketinfo.tradeList ?? [];
      buyPrice = marketinfo.min ?? '0';
      sellPrice = marketinfo.max ?? '0';
      // 数量默认买入价
      limitPriceController.text = buyPrice;
      // 获取币种余额
      getCoinBalance();
      // 获取当前授权
      getCurrentAuthorize();
      update(["coin", "buildCoinNav", "buildRight", "buildLeft"]);
    }
  }

  // 计算深度最大数量
  double getDepthMaxAmountForDisplay({int max = 8}) {
    final displaySellList = sellList?.take(max).toList() ?? [];
    final displayBuyList = buyList?.take(max).toList() ?? [];
    final all = [...displaySellList, ...displayBuyList];
    if (all.isEmpty) return 1;
    return all.map((e) => double.tryParse((e as dynamic).amount ?? '0') ?? 0).reduce((a, b) => a > b ? a : b);
  }

  // 启动轮询定时器，每5秒获取一次当前授权
  void _startAuthorizeTimer() {
    _authorizeTimer?.cancel(); // 先取消之前的定时器
    _authorizeTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      getCurrentAuthorize();
    });
  }

  // 停止轮询定时器
  void _stopAuthorizeTimer() {
    print('停止轮询定时器');
    _authorizeTimer?.cancel();
    _authorizeTimer = null;
  }
}
