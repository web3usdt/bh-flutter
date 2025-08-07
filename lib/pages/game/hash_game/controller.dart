import 'dart:async';
import 'dart:convert';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';

class HashGameController extends GetxController with GetTickerProviderStateMixin {
  HashGameController();
  // 推送的数据
  // 当前状态status
  int status = 0;
  // 下一个开奖区块
  int nextBlock = 0;
  // 已开奖区块
  int lastBlock = 0;
  // 已开奖单双
  int result = 0;
  // 剩余倒计时
  int timer = 0;
  // 上一次推送的lastBlock，用于判断是否需要创建新组
  int previousLastBlock = 0;

  // 订阅socket行情
  StreamSubscription? _socketSubscription;
  int type = 1; // 1 3秒钟版，2 1分钟版
  // 单数数量
  int singularCount = 0;
  // 双数数量
  int doubleCount = 0;
  // 走势数据
  List<List<int>> trendData = [];
  // 游戏配置
  GameConfigModel gameConfig = GameConfigModel();
  // 投注金额列表
  List<GameMoneyListModel> betAmountList = [];
  // 可编辑的投注金额列表
  List<GameMoneyListModel> editableBetAmountList = [];
  // 可编辑金额的控制器列表
  List<TextEditingController> editableControllers = [];
  // 投注记录
  List<GameRecordModel> betRecordList = [];
  // 币种列表
  List<Map<String, dynamic>> coinList = [
    // {'id': 1, 'name': 'USDT'},
    // {'id': 2, 'name': 'BTC'},
    // {'id': 3, 'name': 'ETH'},
  ];
  // 当前币种
  Coin? currentCoin;
  // 游戏介绍
  String intro = '';

  // tab 控制器
  late TabController tabController;
  // tab 索引
  int tabIndex = 0;
  // tab 名称
  List<String> tabNames = ['区块走势', '我的走势'];

  // 投注：1=单，2=双
  int betType = 1;

  // 投注金额
  TextEditingController betAmountController = TextEditingController();

  // 选中的金额列表项索引
  int selectedAmountIndex = -1;

  // 走势图滚动控制器
  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();

  _initData() async {
    type = Get.arguments['type'] ?? 1;
    trendData.clear();
    getRecentTrend();
    gameConfig = await GameApi.gameConfig();
    print('gameConfig: ${gameConfig.toJson()}');
    intro = gameConfig.intro ?? '';
    if (gameConfig.coins != null && coinList.isEmpty) {
      coinList = gameConfig.coins
              ?.map((e) => {'id': e.id, 'coinId': e.coinId, 'name': e.coinName, 'usableBalance': e.usableBalance, 'min': e.min, 'max': e.max})
              .toList() ??
          [];
      if (Storage().getString('gameCurrentCoin') != "") {
        var stringCurrentCoin = Storage().getString('gameCurrentCoin');
        currentCoin = stringCurrentCoin != "" ? Coin.fromJson(jsonDecode(stringCurrentCoin)) : Coin();
      } else {
        currentCoin = gameConfig.coins?.first;
        Storage().setJson('gameCurrentCoin', currentCoin!);
      }
      getBetAmountList();
    }
    update(["hash_game"]);
  }

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments['type'] ?? 1;
    tabController = TabController(length: tabNames.length, vsync: this);

    // 监听数据
    _socketSubscription = SocketService3().messageStream.listen((data) {
      // print('推送data: $data');
      if (data is Map && data['sub'] == 'game_hash_3s') {
        handleSocketData(data as Map<String, dynamic>);
      }
      if (data is Map && data['sub'] == 'game_hash_1min') {
        // print('收到数据：game_hash_1min');
        handleSocketData(data as Map<String, dynamic>);
      }
    });
    if (type == 1) {
      SocketService3().subscribe("game_hash_3s");
    } else {
      // print('推送：game_hash_1min');
      SocketService3().subscribe("game_hash_1min");
    }
  }

  // 处理socket数据
  void handleSocketData(Map<String, dynamic> data) {
    // print('已开奖区块：${data['data']['last']['block_id']}');
    // print('走势图单双数据：${data['data']['last']['result']}');
    status = data['data']['status'];
    nextBlock = data['data']['block_id'];
    timer = data['data']['timer'];
    update(["hash_game_timer"]);
    if (data['data']['last'] != null && data['data']['last']['block_id'] != null) {
      lastBlock = data['data']['last']['block_id']; // lastBlock 已开奖区块
      result = data['data']['last']['result']; // result 1 单 2 双
    }

    if (status == 2) {
      Loading.error('当前已封盘请稍后投注'.tr);
      return;
    } else if (status == 3) {
      Loading.error('当前已暂停请稍后投注'.tr);
      return;
    }

    if (lastBlock != 0 && tabIndex == 0 && trendData.isNotEmpty) {
      _updateTrendData(lastBlock, result);
      Future.delayed(Duration(milliseconds: 500), () {
        // _scrollToLastData();
      });
    } else {
      // 如果没有更新走势数据，也要触发视图更新
      update(["hash_game"]);
    }
  }

  // 更新走势数据
  void _updateTrendData(int blockId, int result) {
    // print('blockId: $blockId, result: $result');
    if (trendData.isEmpty) {
      trendData.add([result]);
      previousLastBlock = blockId;
      update(["hash_game"]); // 触发视图更新
      return;
    }

    // 检查当前blockId是否与上一次的blockId相同
    if (blockId == previousLastBlock) {
      // 如果相同，不追加数据（避免重复追加）
      return;
    } else {
      // 静默更新一次分页数据，不触发页面滚动
      refreshController.requestRefresh(needMove: false);
      // 如果blockId不同，检查结果是否与最后一组的第一个元素相同
      List<int> lastGroup = trendData.last;
      if (lastGroup.isNotEmpty && lastGroup.first == result) {
        // 如果结果相同，追加到当前组
        lastGroup.add(result);
      } else {
        // 如果结果不同，创建新的组
        trendData.add([result]);
      }
      previousLastBlock = blockId;
      update(["hash_game"]); // 触发视图更新
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
    tabController.dispose();
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    // 清理可编辑控制器
    for (var controller in editableControllers) {
      controller.dispose();
    }
    if (type == 1) {
      SocketService3().unsubscribe("game_hash_3s");
    } else {
      SocketService3().unsubscribe("game_hash_1min");
    }
    _socketSubscription?.cancel();
  }

  // 获取最近开奖走势
  void getRecentTrend() async {
    trendData.clear();
    GameApi.gameRecentTrend(type, tabIndex).then((value) {
      singularCount = value['singular'];
      doubleCount = value['dual'];
      // 处理走势数据
      if (value['trend'] != null && value['trend'] is List) {
        // 安全的数据转换方法
        try {
          List<dynamic> rawTrend = value['trend'];
          // print('=== API返回的原始走势数据 ===');
          // print('原始数据长度: ${rawTrend.length}');
          // for (int i = 0; i < rawTrend.length; i++) {
          //   print('原始第$i项: ${rawTrend[i]} (类型: ${rawTrend[i].runtimeType})');
          // }

          trendData = rawTrend.map((item) {
            if (item is List) {
              return item.map((subItem) => int.tryParse(subItem.toString()) ?? 0).toList();
            } else {
              return [int.tryParse(item.toString()) ?? 0];
            }
          }).toList();

          // print('=== 转换后的走势数据 ===');
          // print('转换后数据长度: ${trendData.length}');
          // for (int i = 0; i < trendData.length; i++) {
          //   print('转换后第$i项: ${trendData[i]}');
          // }

          // 过滤掉空数据
          trendData = trendData.where((row) => row.isNotEmpty).toList();

          // print('=== 过滤后的走势数据 ===');
          // print('过滤后数据长度: ${trendData.length}');
          // for (int i = 0; i < trendData.length; i++) {
          //   print('过滤后第$i项: ${trendData[i]}');
          // }

          // 数据加载完成后，自动滚动到最后一条数据
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // _scrollToLastData();
          });
        } catch (e) {
          print('数据处理错误: $e');
          trendData = []; // 确保出错时设置为空数组
        }
      }
      update(["hash_game"]);
    });
  }

  // 自动滚动到最后一条数据
  void _scrollToLastData() {
    if (trendData.isNotEmpty && horizontalScrollController.hasClients) {
      // 等待一帧确保布局完成
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (horizontalScrollController.hasClients) {
          double maxScrollExtent = horizontalScrollController.position.maxScrollExtent;

          // 滚动到最后，但留出一些边距避免溢出
          double targetOffset = maxScrollExtent > 20 ? maxScrollExtent - 20 : 0;

          horizontalScrollController.animateTo(
            targetOffset,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  // 验证区块
  void verifyBlock() async {
    if (lastBlock != 0) {
      final Uri _url = Uri.parse('https://tronscan.org/#/block/${lastBlock}');
      launchUrl(_url);
    }
  }

  // 切换投注类型
  void onTapBetType(int type) {
    betType = type;
    update(["hash_game"]);
  }

  // 切换区块走势tab
  void onTapTabItem(int index) {
    tabIndex = index;
    getRecentTrend();
    update(["hash_game"]);
  }

  // 选择投注金额列表项
  void onTapBetAmount(int index) {
    selectedAmountIndex = index;
    betAmountController.text = betAmountList[index].value.toString();
    update(["hash_game"]);
  }

  // 增加投注金额
  void increaseBetAmount() {
    int currentAmount = int.tryParse(betAmountController.text) ?? 0;
    currentAmount++;
    betAmountController.text = currentAmount.toString();
    // 清除选中状态
    selectedAmountIndex = -1;
    update(["hash_game"]);
  }

  // 减少投注金额
  void decreaseBetAmount() {
    int currentAmount = int.tryParse(betAmountController.text) ?? 0;
    if (currentAmount > 0) {
      currentAmount--;
      betAmountController.text = currentAmount.toString();
      // 清除选中状态
      selectedAmountIndex = -1;
      update(["hash_game"]);
    }
  }

  // 输入框内容变化
  void onBetAmountChanged(String value) {
    // 清除选中状态
    selectedAmountIndex = -1;
    update(["hash_game"]);
  }

  // 增加可编辑金额
  void increaseEditableAmount(int index) {
    if (index >= 0 && index < editableBetAmountList.length) {
      int currentAmount = editableBetAmountList[index].value ?? 0;
      currentAmount++;
      editableBetAmountList[index].value = currentAmount;
      editableControllers[index].text = currentAmount.toString();
      update(["hash_game"]);
    }
  }

  // 减少可编辑金额
  void decreaseEditableAmount(int index) {
    if (index >= 0 && index < editableBetAmountList.length) {
      int currentAmount = editableBetAmountList[index].value ?? 0;
      if (currentAmount > 0) {
        currentAmount--;
        editableBetAmountList[index].value = currentAmount;
        editableControllers[index].text = currentAmount.toString();
        update(["hash_game"]);
      }
    }
  }

  // 可编辑金额输入框变化
  void onEditableAmountChanged(int index, String value) {
    if (index >= 0 && index < editableBetAmountList.length) {
      int newValue = int.tryParse(value) ?? 0;
      editableBetAmountList[index].value = newValue;
      update(["hash_game"]);
    }
  }

  // 确认金额设置
  void confirmAmountSettings() async {
    Loading.show();
    // 后台接收的moneys需要时json格式，我这里写的对吗
    List<MoneyGameEditMoneyListReq> moneys = [];
    for (var item in editableBetAmountList) {
      moneys.add(MoneyGameEditMoneyListReq(label: item.label, value: item.value));
    }
    final value = await GameApi.gameEditMoneyList(
      type,
      currentCoin?.coinId ?? 0,
      moneys,
    );
    if (value) {
      Get.back();
      // 将可编辑金额列表深拷贝到投注金额列表
      betAmountList = editableBetAmountList
          .map((item) => GameMoneyListModel(
                label: item.label,
                value: item.value,
              ))
          .toList();
      Loading.success('编辑成功'.tr);
      update(["hash_game"]);
    } else {
      Loading.error('编辑失败'.tr);
    }
  }

  // 取消金额设置
  void cancelAmountSettings() {
    // 恢复默认的投注金额列表，使用深拷贝
    editableBetAmountList = betAmountList
        .map((item) => GameMoneyListModel(
              label: item.label,
              value: item.value,
            ))
        .toList();
    // 更新控制器
    _updateEditableControllers();
    Get.back();
    update(["hash_game"]);
  }

  // 更新可编辑控制器
  void _updateEditableControllers() {
    // 清理旧的控制器
    for (var controller in editableControllers) {
      controller.dispose();
    }
    editableControllers.clear();

    // 创建新的控制器
    for (var item in editableBetAmountList) {
      editableControllers.add(TextEditingController(text: item.value.toString()));
    }
  }

  // 获取投注金额列表
  void getBetAmountList() async {
    betAmountList = await GameApi.gameMoneyList(type, currentCoin?.coinId ?? 0);
    // 使用深拷贝，确保editableBetAmountList和betAmountList是独立的数据
    editableBetAmountList = betAmountList
        .map((item) => GameMoneyListModel(
              label: item.label,
              value: item.value,
            ))
        .toList();
    _updateEditableControllers();
    update(["hash_game"]);
  }

  // 提交投注
  void submitBet() async {
    if (status == 2) {
      Loading.error('当前已封盘请稍后投注'.tr);
      return;
    } else if (status == 3) {
      Loading.error('当前已暂停请稍后投注'.tr);
      return;
    }
    final value = await GameApi.gameSubmit(GameSubmitReq(
      type: type.toString(),
      coinId: currentCoin?.coinId.toString() ?? '',
      amount: betAmountController.text,
      expect: betType.toString(),
    ));
    if (value) {
      Loading.success('投注成功'.tr);
      refreshController.requestRefresh();
      _initData();
    } else {
      Loading.error('投注失败'.tr);
    }
  }

  // 显示币种选择器
  void showCoinPicker() {
    PickerUtils.showPicker(
      context: Get.context!,
      title: '选择币种'.tr,
      items: coinList.map((e) => {'id': e['id'], 'coinId': e['coinId'], 'name': e['name'], 'usableBalance': e['usableBalance']}).toList(),
      onConfirm: (selected) {
        currentCoin = gameConfig.coins?.firstWhere((e) => e.coinId == selected['coinId']);
        Storage().setJson('gameCurrentCoin', currentCoin!);
        getBetAmountList();
        refreshController.requestRefresh(needMove: false);
        update(['hash_game']);
      },
      onCancel: () {},
    );
  }

  // 查看介绍
  void onViewProjectDetails() {
    Get.dialog(
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 弹窗内容
            <Widget>[
              <Widget>[
                TextWidget.body('玩法介绍'.tr, size: 32.sp, color: Colors.black, weight: FontWeight.w600),
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
                        intro,
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
    List<GameRecordModel> result = [];
    result = await GameApi.gameBetRecord(type, currentCoin?.coinId ?? 0, PageListReq(page: isRefresh ? 1 : _page));
    if (isRefresh) {
      _page = 1;
      betRecordList.clear();
    }
    if (result.isNotEmpty) {
      _page++;
      betRecordList.addAll(result);
    }
    // 是否是空
    return result.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (betRecordList.isNotEmpty) {
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
    update(["hash_game"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["hash_game"]);
  }
}
