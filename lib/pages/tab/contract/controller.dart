import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/pages/tab/main/index.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'package:tdesign_flutter/tdesign_flutter.dart';

class ContinuousController extends GetxController {
  ContinuousController();
  // 活动列表
  List<UserShareActiveListModel> activeList = [];
  // 活动信息
  UserShareActiveInfoModel activeInfo = UserShareActiveInfoModel();
  // 海报
  String poster = '';

  // 风险说明
  String riskInfo = '';
  // 订阅socket行情
  StreamSubscription? _socketSubscription;
  // 导航栏
  String pairName = '';
  // 当前币种
  String coinName = '';
  // 当前币种的比例
  String pairRatio = '';
  // 总值
  String total = '0.00000000';
  // 轮询定时器
  Timer? pollingTimer;
  // 当前持有仓位/当前委托tab切换
  String currentTab = 'currentPosition';
  // 当前持有仓位，是否仅显示当前合约
  bool isOnlyCurrentPosition = false;
  // 当前持有仓位
  List<ContractCurrentPositionModel> currentPosition = [];
  // 当前委托
  List<ContractMyAuthorizeModel> currentEntrust = [];
  // 用户合约收益
  ContractUserMoneyModel userMoney = ContractUserMoneyModel();
  // 合约详情
  ContractDetailModel contractDetail = ContractDetailModel();
  // 市场行情
  ContractMarketinfoModel marketinfo = ContractMarketinfoModel();
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
  // 普通委托单价
  String limitPrice = '0';
  // 最新价格
  String latestPrice = '0';
  // 可开张数
  String canOpen = '0';
  // 预估保证金：
  String estimateMargin = '0';
  // 限价、市价 状态
  final List<String> orderTypes = ['普通委托'.tr, '市价委托'.tr];
  String? selectedOrderType = '市价委托'.tr;
  // 杠杆
  List<String> leverages = [];
  String? selectedLeverage = '';
  // 限价输入框
  TextEditingController limitPriceController = TextEditingController();
  // 数量输入框
  TextEditingController amountController = TextEditingController();
  // 止盈触发价输入框
  TextEditingController stopProfitController = TextEditingController();
  // 止损触发价输入框
  TextEditingController stopLossController = TextEditingController();
  // 止盈止损弹窗输入框
  TextEditingController popStopProfitController = TextEditingController();
  TextEditingController popstopLossController = TextEditingController();
  // 平仓弹窗输入框
  TextEditingController popClosePriceController = TextEditingController();
  TextEditingController popCloseAmountController = TextEditingController();
  // 平仓弹窗输入框 百分比
  int popClosePercent = 0;
  // 平仓可平数量
  int popCloseNum = 0;
  // 百分比
  int percent = 0;
  // tab 索引
  String tabIndex = '自选'.tr;
  // tab 名称
  List<String> tabNames = [
    '自选'.tr,
    '永续'.tr,
  ];
  // 搜索币种
  TextEditingController searchController = TextEditingController();
  // 标记是否是通过百分比按钮设置的数量
  bool isPercentChange = false;

  _initData() async {
    coinList = await ContractApi.coinList();

    // 获取主控制器
    final mainController = Get.find<MainController>();
    // 获取分类ID
    if (mainController.pairName.isNotEmpty) {
      pairName = mainController.pairName;
      coinName = mainController.coinName;
      // 重置ID
      mainController.pairName = '';
      mainController.coinName = '';
      mainController.type = 0;
      // 你需要先查到MarketInfoListModel
      final MarketInfoListModel? item = findMarketInfoByPairName(pairName);
      if (item != null) {
        changeSymbol(item);
      }
    } else {
      if (pairName.isEmpty) {
        changeSymbol(coinList.first.marketInfoList?.first ?? MarketInfoListModel());
      } else {
        collectCoinList = await CoinApi.collectCoinList();
        marketinfo = await ContractApi.coinMarketinfo(coinName);
        // 对买单列表进行排序，价格从高到低排序
        if (marketinfo.swapBuyList?.isNotEmpty == true) {
          buyList = marketinfo.swapBuyList?.sublist(0, 7) ?? [];
          buyList?.sort((a, b) => double.parse(b.price ?? '0').compareTo(double.parse(a.price ?? '0')));
        } else {
          buyList = [];
        }

        // 对卖单列表进行排序，数量从高到低排序
        if (marketinfo.swapSellList?.isNotEmpty == true) {
          sellList = marketinfo.swapSellList?.sublist(0, 7) ?? [];
          sellList?.sort((a, b) => double.parse(b.amount ?? '0').compareTo(double.parse(a.amount ?? '0')));
        } else {
          sellList = [];
        }
        tradeList = marketinfo.swapTradeList ?? [];
        limitPrice = (tradeList?.isNotEmpty == true) ? tradeList!.first.price.toString() : '0';
        // 数量默认买入价
        limitPriceController.text = limitPrice;
        // 获取合约详情
        contractDetail = await ContractApi.coinDetail(coinName);
        // 获取杠杆
        var leverageValues = contractDetail.leverRage ?? [];
        leverages = leverageValues.map((e) => e.toString()).toList();
        if (leverages.isNotEmpty) {
          selectedLeverage = leverages.first;
          // 获取可开张数
          getMaxOpenAmount();
        }
        // 获取用户合约收益
        getUserMoney();
        // 获取当前持有仓位
        getCurrentPosition();
        // 获取当前委托
        getCurrentEntrust();
        // 轮询接口，每隔五秒获取用户合约收益和当前持有仓位
        startPolling();

        // 获取风险说明
        riskInfo = await ContractApi.riskInfo();
        update(["continuous", "buildCoinNav", "buildRight", "buildLeft"]);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    // 添加数量输入框监听
    amountController.addListener(() {
      onAmountChange(amountController.text);
    });

    // 初始化并连接WebSocket2
    SocketService2().init();
    SocketService2().connect();

    // 监听socket数据
    _socketSubscription = SocketService2().messageStream.listen((data) {
      if (data is Map) {
        // 处理swapMarketList频道数据
        if (data['sub'] == 'swapMarketList') {
          try {
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
            update(["continuous", "buildCoinNav"]);
          } catch (e) {
            print('处理swapMarketList数据出错: $e');
          }
        }
        // 处理swapTradeList_币种 频道数据
        else if (data['sub']?.toString().startsWith('swapTradeList_') == true && data['sub']?.toString().contains(coinName) == true) {
          try {
            final newItem = SwapTradeList.fromJson(data['data']);

            // 更新最新价格
            latestPrice = newItem.price?.toString() ?? '0';

            // 将新数据添加到tradeList
            if (tradeList == null) {
              tradeList = [];
            }
            tradeList!.insert(0, newItem);
            // 保持列表不要太长
            if (tradeList!.length > 20) {
              tradeList = tradeList!.sublist(0, 20);
            }

            update(["continuous", "buildRight"]);
          } catch (e) {
            print('处理swapTradeList数据出错: $e');
          }
        }
        // 处理swapBuyList_币种 频道数据
        else if (data['sub']?.toString().startsWith('swapBuyList_') == true && data['sub']?.toString().contains(coinName) == true) {
          try {
            buyList = (data['data'] as List).map((item) => SwapBuyList.fromJson(item)).toList();
            // 取前7条数据
            buyList = buyList?.sublist(0, buyList!.length > 7 ? 7 : buyList!.length);
            // 对买单列表进行排序，价格从高到低排列
            buyList?.sort((a, b) => double.parse(b.price ?? '0').compareTo(double.parse(a.price ?? '0')));
            update(["continuous", "buildRight"]);
          } catch (e) {
            print('处理swapBuyList数据出错: $e');
          }
        }
        // 处理swapSellList_币种 频道数据
        else if (data['sub']?.toString().startsWith('swapSellList_') == true && data['sub']?.toString().contains(coinName) == true) {
          try {
            sellList = (data['data'] as List).map((item) => SwapSellList.fromJson(item)).toList();
            // 取前7条数据
            sellList = sellList?.sublist(0, sellList!.length > 7 ? 7 : sellList!.length);
            // 对卖单列表进行排序，价格从高到低排列
            sellList?.sort((a, b) => double.parse(b.price ?? '0').compareTo(double.parse(a.price ?? '0')));
            update(["continuous", "buildRight"]);
          } catch (e) {
            print('处理swapSellList数据出错: $e');
          }
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
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
    }
    // 取消监听
    _socketSubscription?.cancel();
    amountController.dispose();

    // 清除轮询定时器
    if (pollingTimer != null && pollingTimer!.isActive) {
      pollingTimer!.cancel();
      pollingTimer = null;
      print('onClose 关闭轮询');
    }
  }

  // 轮询接口，每隔五秒获取用户合约收益和当前持有仓位
  startPolling() {
    pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      getUserMoney(shouldToast: false);
      getCurrentPosition(shouldToast: false);
      getCurrentEntrust(shouldToast: false);
    });
  }

  // 获取用户合约收益
  getUserMoney({bool shouldToast = true}) async {
    print('轮训1 ： 获取用户合约收益');
    userMoney = await ContractApi.userMoney(coinName, shouldToast: shouldToast);
    update(["continuous"]);
  }

  // 获取当前持有仓位
  getCurrentPosition({bool shouldToast = true}) async {
    print('轮训2 ： 获取当前持有仓位');
    currentPosition = await ContractApi.currentPosition(isOnlyCurrentPosition ? coinName : '', shouldToast: shouldToast);
    update(["continuous"]);
  }

  // 获取当前委托
  getCurrentEntrust({bool shouldToast = true}) async {
    print('轮训3 ： 获取当前委托');
    currentEntrust = await ContractApi.myAuthorizeList(PageListReq(page: 1), shouldToast: shouldToast);
    update(["continuous"]);
  }

  // 切换是否仅显示当前合约
  changeIsOnlyCurrentPosition() {
    isOnlyCurrentPosition = !isOnlyCurrentPosition;
    getCurrentPosition();
    update(["continuous"]);
  }

  // 切换当前持有仓位/当前委托tab
  changeCurrentTab(String tab) {
    currentTab = tab;
    if (tab == 'currentPosition') {
      getCurrentPosition();
    } else {
      getCurrentEntrust();
    }
    update(["continuous"]);
  }

  String cals(int side, int orderType) {
    // side - order_type
    Map<String, String> map = {
      "1-1": '开多'.tr,
      "1-2": '平空'.tr,
      "2-1": '开空'.tr,
      "2-2": '平多'.tr,
    };
    return map['$side-$orderType'] ?? '';
  }

  changeOrderType(String type) {
    selectedOrderType = type;
    update(["continuous"]);
  }

  changeLeverage(String leverage) {
    selectedLeverage = leverage;
    // 杠杆变化时，获取可开张数
    getMaxOpenAmount();
    // 重新计算预估保证金
    calculateOpenAndMargin();
    update(["continuous"]);
  }

  onLimitPriceChange(String value) {
    limitPriceController.text = value;
    percent = 0;
    if (value.isEmpty) {
      total = '0';
      update(["continuous"]);
      return;
    }
    total = MathUtils.multipleDecimal(amountController.text, limitPriceController.text, 8);
    // 价格变化时重新计算预估保证金
    calculateOpenAndMargin();
    update(["continuous"]);
  }

  // 点击深度
  void onTapDepth(dynamic item) {
    // 如果是限价，赋值给输入框
    if (selectedOrderType == '普通委托'.tr) {
      limitPriceController.text = item.price ?? '';
      onLimitPriceChange(limitPriceController.text);
    }
    print('onTapDepth: ${item.price}');
    update(["continuous"]);
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

  // 计算可开张数和预估保证金
  void calculateOpenAndMargin() {
    if (amountController.text.isEmpty) {
      estimateMargin = '0';
      update(["continuous"]);
      return;
    }

    // 可开张数 = 账户权益 * 杠杆倍数 / 单位面值 / 当前价格
    double amount = double.tryParse(amountController.text) ?? 0;
    double leverage = double.tryParse(selectedLeverage ?? '1') ?? 1;
    double price = double.tryParse(limitPrice) ?? 0;
    double? unitAmount = double.tryParse(contractDetail.unitAmount?.toString() ?? '1');

    // 预估保证金 = 数量 * 单位面值 / 杠杆倍数
    if (price > 0 && leverage > 0) {
      estimateMargin = (amount * (unitAmount ?? 1) / leverage).toStringAsFixed(4);
    }

    update(["continuous"]);
  }

  // 数量输入框变化监听
  void onAmountChange(String value) {
    // 数量变化时重新计算预估保证金
    calculateOpenAndMargin();

    // 如果不是通过百分比按钮设置的，则重置百分比
    if (!isPercentChange && value.isNotEmpty) {
      percent = 0;
      update(["continuous"]);
    }
    // 重置标志位
    isPercentChange = false;
  }

  // 获取可开张数
  Future<void> getMaxOpenAmount() async {
    if (selectedLeverage == null || selectedLeverage!.isEmpty) return;

    try {
      final data = {
        'symbol': coinName,
        'lever_rate': selectedLeverage,
      };

      // 这里调用API获取可开张数，根据实际API调整
      final result = await ContractApi.openNum(data);
      canOpen = result.toString();
      update(["continuous"]);
    } catch (e) {
      print('获取可开张数失败: $e');
    }
  }

  // 修改百分比
  void onPercentChange(int value) {
    percent = value;

    // 设置标志位，表示是通过百分比按钮设置的数量
    isPercentChange = true;

    // 根据百分比设置数量
    if (canOpen != '0') {
      double maxAmount = double.tryParse(canOpen) ?? 0;
      double amount = maxAmount * value / 100;
      amountController.text = amount.toStringAsFixed(0);
      calculateOpenAndMargin();
    }

    update(["continuous"]);
  }

  // 确认
  onConfirm(String type, int side) {
    if (amountController.text.isEmpty) return Loading.toast('请输入数量'.tr);
    if (stopProfitController.text.isEmpty) return Loading.toast('请输入止盈价格'.tr);
    if (stopLossController.text.isEmpty) return Loading.toast('请输入止损价格'.tr);
    var desc = '';
    if (selectedOrderType == '普通委托'.tr) {
      desc = '${'是否以'.tr}${limitPriceController.text}${'的价格'.tr}$selectedLeverage${'倍'.tr}${'杠杆'.tr}开仓$canOpen${'张'.tr}$type？';
    } else {
      desc = '${'是否以'.tr}市价的价格$selectedLeverage${'倍'.tr}${'杠杆'.tr}开仓$canOpen${'张'.tr}$type？';
    }
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '温馨提示'.tr,
          description: desc,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var res = await ContractApi.open(ContractOpenReq(
              side: side.toString(),
              symbol: coinName,
              type: selectedOrderType == '普通委托'.tr ? '1' : '2',
              entrustPrice: limitPriceController.text,
              amount: amountController.text,
              leverRate: selectedLeverage,
              tpTriggerPrice: stopProfitController.text,
              slTriggerPrice: stopLossController.text,
            ));
            if (res) {
              Loading.success('委托成功'.tr);
              getCurrentPosition();
              getCurrentEntrust();
            }
          },
        );
      },
    );
  }

  // 切换tab
  onTapTabIndex(String tabName) {
    tabIndex = tabName;
    searchKeyword = '';
    searchController.clear();
    update(["buildCoinNav"]);
  }

  // 搜索关键词
  String searchKeyword = '';
  void onSearch(String keyword) {
    searchKeyword = keyword.trim();
    update(["buildCoinNav"]);
  }

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

  // 修改当前币种和支付币种
  changeSymbol(MarketInfoListModel item) {
    // 取消旧频道订阅
    if (coinName.isNotEmpty) {
      SocketService2().unsubscribe("swapMarketList");
      SocketService2().unsubscribe("swapTradeList_${coinName}");
      SocketService2().unsubscribe("swapBuyList_${coinName}");
      SocketService2().unsubscribe("swapSellList_${coinName}");
    }

    // 设置新币种
    pairName = item.pairName ?? '';
    coinName = item.symbol ?? '';
    pairRatio = item.increaseStr ?? '';
    amountController.clear();
    total = '0';
    percent = 0;
    latestPrice = '';

    // 订阅新频道
    if (coinName.isNotEmpty) {
      SocketService2().subscribe("swapMarketList");
      SocketService2().subscribe("swapTradeList_${coinName}");
      SocketService2().subscribe("swapBuyList_${coinName}");
      SocketService2().subscribe("swapSellList_${coinName}");
    }

    _initData();
    update(["continuous"]);
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
    update(["continuous"]);
  }

  // 查看K线
  void goKLine() async {
    pollingTimer?.cancel();
    var res = await Get.toNamed(AppRoutes.contractKChart, arguments: {'pairName': pairName});
    if (res != null) {
      update(["continuous", "buildCoinNav", "buildRight", "buildLeft"]);
      // 你需要先查到MarketInfoListModel
      final MarketInfoListModel? item = findMarketInfoByPairName(res['pairName']);
      if (item != null) {
        print('item: $item');
        changeSymbol(item);
      }
    }
  }

  // 查看全部委托记录
  void goAllEntrust() {
    pollingTimer?.cancel();
    Get.toNamed(AppRoutes.myAuthorizeContract);
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

  // 计算深度最大数量
  double getDepthMaxAmountForDisplay({int max = 8}) {
    final displaySellList = sellList?.take(max).toList() ?? [];
    final displayBuyList = buyList?.take(max).toList() ?? [];
    final all = [...displaySellList, ...displayBuyList];
    if (all.isEmpty) return 1;
    return all.map((e) => double.tryParse((e as dynamic).amount ?? '0') ?? 0).reduce((a, b) => a > b ? a : b);
  }

  // 查看风险说明
  void onViewRiskInfo() {
    Get.dialog(
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 弹窗内容
            <Widget>[
              <Widget>[
                TextWidget.body('风险说明'.tr, size: 32.sp, color: Colors.black, weight: FontWeight.w600),
                const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.black,
                ).onTap(() {
                  Get.back();
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 30.w),

              // 内部可滚动的区域
              Container(
                width: 530.w,
                height: 600.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppTheme.blockBgColor,
                  borderRadius: BorderRadius.circular(30.w),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlWidget(
                        riskInfo,
                        // 设置渲染模式
                        renderMode: RenderMode.column,
                        // 设置文本样式
                        textStyle: TextStyle(
                          fontSize: 28.sp,
                          color: AppTheme.color000,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.w),
              // 底部按钮
              <Widget>[
                TextWidget.body(
                  '知道了'.tr,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.center)
                  .tight(width: 530.w, height: 80.w)
                  .backgroundColor(AppTheme.color000)
                  .clipRRect(all: 30.w)
                  .onTap(() {
                Get.back();
              }),
            ].toColumn().paddingAll(30.w),
          ].toColumn().tight(width: 590.w, height: 860.w).backgroundColor(AppTheme.pageBgColor).clipRRect(all: 20.w)),
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  // 止盈止损
  void onStopProfit(ContractCurrentPositionModel item) {
    popStopProfitController.text = item.tpPrice?.toString() ?? '';
    popstopLossController.text = item.slPrice?.toString() ?? '';
    Get.dialog(
      barrierColor: Colors.black.withOpacity(0.7),
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 标题
            <Widget>[
              <Widget>[
                ButtonWidget(
                  text: item.side == 1 ? '多'.tr : '空'.tr,
                  height: 38,
                  borderRadius: 19,
                  backgroundColor: item.side == 1 ? const Color(0xffFDEBEB) : const Color(0xffE5F7FF),
                  textColor: item.side == 1 ? AppTheme.colorRed : AppTheme.colorGreen,
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                ),
                SizedBox(
                  width: 16.w,
                ),
                TextWidget.body(
                  '${item.symbol}/USDT',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
                SizedBox(
                  width: 16.w,
                ),
                TextWidget.body(
                  '${item.leverRate}X',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
              ].toRow(),
              const Icon(
                Icons.close,
                size: 24,
                color: Colors.black,
              ).onTap(() {
                Get.back();
              }),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w),
            TDDivider(
              height: 1,
              color: AppTheme.dividerColor,
            ),
            <Widget>[
              <Widget>[
                TextWidget.body(
                  '空：'.tr,
                  size: 24.sp,
                  color: AppTheme.color999,
                ),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(
                  '${item.avgPrice}',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
              <Widget>[
                TextWidget.body(
                  '最新成交价：'.tr,
                  size: 24.sp,
                  color: AppTheme.color999,
                ),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(
                  latestPrice,
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w),

            // 触发价
            <Widget>[
              TextWidget.body(
                '止盈触发价'.tr,
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              <Widget>[
                InputWidget(
                  placeholder: "请输入止盈触发价".tr,
                  controller: popStopProfitController,
                ).expanded(),
              ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(color: AppTheme.borderLine, width: 1),
                  ),
              SizedBox(
                height: 20.w,
              ),
              TextWidget.body(
                '止损触发价'.tr,
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              <Widget>[
                InputWidget(
                  placeholder: "请输入止损触发价".tr,
                  controller: popstopLossController,
                ).expanded(),
              ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(color: AppTheme.borderLine, width: 1),
                  ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w),
            // 操作按钮
            <Widget>[
              ButtonWidget(
                text: '撤销'.tr,
                width: 250,
                height: 70,
                borderRadius: 10,
                backgroundColor: AppTheme.dividerColor,
                textColor: Colors.black,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                onTap: () async {
                  Loading.show();
                  var ress = await ContractApi.setStrategy(ContracrSetstragetyReq(
                    symbol: item.symbol,
                    positionSide: item.side,
                    tpTriggerPrice: int.parse(popStopProfitController.text.isEmpty ? '0' : popStopProfitController.text),
                    slTriggerPrice: int.parse(popstopLossController.text.isEmpty ? '0' : popstopLossController.text),
                    iscanel: '1',
                  ));
                  if (ress) {
                    Get.back();
                    Loading.success('撤销成功'.tr);
                    getCurrentPosition();
                  }
                },
              ),
              ButtonWidget(
                text: '确定'.tr,
                width: 250,
                height: 70,
                borderRadius: 10,
                backgroundColor: AppTheme.color000,
                textColor: Colors.white,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                onTap: () async {
                  if (popStopProfitController.text.isEmpty || popstopLossController.text.isEmpty) {
                    Loading.error('请输入止盈止损触发价'.tr);
                    return;
                  }
                  Loading.show();
                  var res = await ContractApi.setStrategy(ContracrSetstragetyReq(
                    symbol: item.symbol,
                    positionSide: item.side,
                    tpTriggerPrice: int.parse(popStopProfitController.text),
                    slTriggerPrice: int.parse(popstopLossController.text),
                    iscanel: '0',
                  ));
                  if (res) {
                    Get.back();
                    Loading.success('止盈止损成功'.tr);
                    getCurrentPosition();
                  }
                },
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w)
          ].toColumn().tight(width: 590.w, height: 680.w).backgroundColor(AppTheme.pageBgColor).clipRRect(all: 20.w)),
    );
  }

  // 一键反向
  void onReverse(int side) {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '一键反向'.tr,
          description: '确定一键反向吗？'.tr,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var res = await ContractApi.reverse(coinName, side);
            if (res) {
              Loading.success('反向成功'.tr);
              getCurrentPosition();
            }
          },
        );
      },
    );
  }

  final List<String> popOrderTypes = ['市价'.tr, '限价'.tr];
  String? popSelectedOrderType = '市价'.tr;
  changePopOrderType(String type) {
    popSelectedOrderType = type;
    update(["buildPopClosePrice"]);
  }

  // 平仓
  void onClosePosition(ContractCurrentPositionModel item) {
    popClosePriceController.text = latestPrice;
    popCloseAmountController.text = item.availPosition?.toString() ?? '';
    popClosePercent = 0;
    popCloseNum = item.availPosition ?? 0;

    Get.dialog(
      barrierColor: Colors.black.withOpacity(0.7),
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 标题
            <Widget>[
              <Widget>[
                ButtonWidget(
                  text: item.side == 1 ? '平多'.tr : '平空'.tr,
                  height: 38,
                  borderRadius: 19,
                  backgroundColor: item.side == 1 ? const Color(0xffFDEBEB) : const Color(0xffE5F7FF),
                  textColor: item.side == 1 ? AppTheme.colorRed : AppTheme.colorGreen,
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                ),
                SizedBox(
                  width: 16.w,
                ),
                TextWidget.body(
                  '${item.symbol}/USDT',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
                SizedBox(
                  width: 16.w,
                ),
                TextWidget.body(
                  '${item.leverRate}X',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
              ].toRow(),
              const Icon(
                Icons.close,
                size: 24,
                color: Colors.black,
              ).onTap(() {
                Get.back();
              }),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w),
            TDDivider(
              height: 1,
              color: AppTheme.dividerColor,
            ),

            // 平仓价格
            <Widget>[
              TextWidget.body(
                '平仓价格'.tr,
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              GetBuilder<ContinuousController>(
                  id: "buildPopClosePrice",
                  builder: (_) {
                    return <Widget>[
                      if (popSelectedOrderType == '市价'.tr)
                        TextWidget.body(
                          '市价平仓'.tr,
                          size: 24.sp,
                          color: AppTheme.color000,
                        ).expanded()
                      else
                        InputWidget(
                          placeholder: "请输入平仓价格".tr,
                          controller: popClosePriceController,
                        ).expanded(),
                      <Widget>[
                        TextWidget.body(
                          popSelectedOrderType ?? '',
                          size: 24.sp,
                          color: AppTheme.color000,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        // 转换图标
                        Icon(
                          Icons.cached,
                          size: 32.sp,
                          color: AppTheme.color000,
                        ),
                      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).onTap(() {
                        changePopOrderType(popSelectedOrderType == '市价'.tr ? '限价'.tr : '市价'.tr);
                      })
                    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
                          borderRadius: BorderRadius.circular(10.w),
                          border: Border.all(color: AppTheme.borderLine, width: 1),
                        );
                  }),
              SizedBox(
                height: 20.w,
              ),
              TextWidget.body(
                '平仓数量'.tr,
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              <Widget>[
                InputWidget(
                  placeholder: "请输入平仓数量".tr,
                  controller: popCloseAmountController,
                ).expanded(),
              ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(color: AppTheme.borderLine, width: 1),
                  ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w),
            TextWidget.body(
              '可平$popCloseNum张',
              size: 24.sp,
            ).paddingHorizontal(30.w).paddingVertical(20.w),
            // 百分比
            GetBuilder<ContinuousController>(
                id: "buildPopPercent",
                builder: (_) {
                  return <Widget>[
                    ButtonWidget(
                      text: '25%',
                      height: 44,
                      borderRadius: 6,
                      backgroundColor: popClosePercent == 25 ? AppTheme.color000 : Colors.transparent,
                      textColor: popClosePercent == 25 ? Colors.white : AppTheme.color999,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      showBorder: true,
                      borderColor: popClosePercent == 25 ? AppTheme.color000 : AppTheme.color999,
                      onTap: () {
                        onPopPercentChange(25);
                      },
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonWidget(
                      text: '50%',
                      height: 44,
                      borderRadius: 6,
                      backgroundColor: popClosePercent == 50 ? AppTheme.color000 : Colors.transparent,
                      textColor: popClosePercent == 50 ? Colors.white : AppTheme.color999,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      showBorder: true,
                      borderColor: popClosePercent == 50 ? AppTheme.color000 : AppTheme.color999,
                      onTap: () {
                        onPopPercentChange(50);
                      },
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonWidget(
                      text: '75%',
                      height: 44,
                      borderRadius: 6,
                      backgroundColor: popClosePercent == 75 ? AppTheme.color000 : Colors.transparent,
                      textColor: popClosePercent == 75 ? Colors.white : AppTheme.color999,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      showBorder: true,
                      borderColor: popClosePercent == 75 ? AppTheme.color000 : AppTheme.color999,
                      onTap: () {
                        onPopPercentChange(75);
                      },
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonWidget(
                      text: '100%',
                      height: 44,
                      borderRadius: 6,
                      backgroundColor: popClosePercent == 100 ? AppTheme.color000 : Colors.transparent,
                      textColor: popClosePercent == 100 ? Colors.white : AppTheme.color999,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      showBorder: true,
                      borderColor: popClosePercent == 100 ? AppTheme.color000 : AppTheme.color999,
                      onTap: () {
                        onPopPercentChange(100);
                      },
                    ),
                  ].toRow().paddingHorizontal(30.w);
                }),
            // 操作按钮
            <Widget>[
              ButtonWidget(
                text: '平仓'.tr,
                width: 530,
                height: 70,
                borderRadius: 10,
                backgroundColor: AppTheme.color000,
                textColor: Colors.white,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                onTap: () async {
                  if (popClosePriceController.text.isEmpty || popCloseAmountController.text.isEmpty) {
                    Loading.error('请输入平仓价格和数量'.tr);
                    return;
                  }
                  Loading.show();
                  var res = await ContractApi.closePosition({
                    'symbol': item.symbol,
                    'side': item.side == 1 ? 2 : 1, // 平仓时side需要反向
                    'type': popSelectedOrderType == '市价' ? 2 : 1, // 限价平仓
                    'entrust_price': popClosePriceController.text,
                    'amount': popCloseAmountController.text,
                  });
                  if (res) {
                    Get.back();
                    Loading.success('平仓成功'.tr);
                    getCurrentPosition();
                  }
                },
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w)
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .tight(width: 590.w, height: 650.w)
              .backgroundColor(AppTheme.pageBgColor)
              .clipRRect(all: 20.w)),
    );
  }

  // 修改平仓百分比
  void onPopPercentChange(int value) {
    popClosePercent = value;

    // 根据百分比设置平仓数量
    if (popCloseNum > 0) {
      double amount = (popCloseNum * value / 100).roundToDouble();
      popCloseAmountController.text = amount.toStringAsFixed(0);
    }

    update(["buildPopPercent"]);
  }

  // 一键全平
  void onCloseAll() {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '一键全平'.tr,
          description: '确定一键全平吗？'.tr,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var res = await ContractApi.reverseAll();
            if (res) {
              Loading.success('全平成功'.tr);
              getCurrentPosition();
            }
          },
        );
      },
    );
  }

  // 邀请助力弹窗
  void showInviteFriendDialog() async {
    if (poster.isEmpty) {
      Loading.show();
      activeList = await UserApi.getUserShareActiveList();
      var batchNo = activeList.first.batchNo;
      activeInfo = await UserApi.getUserShareActiveInfo(batchNo ?? '');
      poster = await UserApi.getUserShareActive(activeInfo.batchNo ?? '');
      Loading.dismiss();
    }

    Get.dialog(
      barrierColor: Colors.black.withOpacity(0.7),
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 弹窗内容
            <Widget>[
              ImgWidget(
                path: poster,
                width: 590.w,
                height: 1080.w,
              ),
              SizedBox(height: 30.w),
              <Widget>[
                ButtonWidget(
                  text: '保存海报分享'.tr,
                  width: 240,
                  height: 88,
                  borderRadius: 44,
                  backgroundColor: AppTheme.colorfff,
                  textColor: AppTheme.color000,
                  onTap: () {
                    saveQrCode();
                  },
                ),
                ButtonWidget(
                  text: '复制活动邀请链接'.tr,
                  width: 240,
                  height: 88,
                  borderRadius: 44,
                  backgroundColor: AppTheme.colorfff,
                  textColor: AppTheme.color000,
                  onTap: () {
                    ClipboardUtils.copy(activeInfo.inviteUrl ?? '');
                  },
                ),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 60.w),
              const Icon(
                Icons.close,
                size: 32,
                color: Colors.white,
              ).onTap(() {
                Get.back();
              }),
            ].toColumn().paddingAll(30.w),
          ].toColumn()),
    );
  }

  // 长按保存二维码
  Future<void> saveQrCode() async {
    await ImageSaverHelper.saveNetworkImage(poster, fileName: "poster_${DateTime.now().millisecondsSinceEpoch}");
  }
}
