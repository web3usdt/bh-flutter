import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'dart:async';

class OptionController extends GetxController {
  // 订阅socket推送
  StreamSubscription? _socketSubscription;
  // 倒计时定时器
  Timer? _countdownTimer;

  // 期权信息
  String optionInfo = '';
  // 期权列表 - 存储所有时间维度的数据
  List<OptionIndexListModel> allOptionList = [];
  // 动态时间tab - 从接口获取
  List<String> tabKeys = [];
  int tabIndex = 0;
  // 当前显示的场景对列表
  List<OptionIndexListModelScenePairList> currentScenePairList = [];
  bool showCountdown = true;
  // PageView控制器
  PageController? pageController;

  // 切换tab
  void onTapTabIndex(int index) {
    tabIndex = index;
    // 滑动到对应页面
    pageController?.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // 更新当前显示的数据
    _updateCurrentScenePairList();
    update(['option']);
  }

  // PageView切换回调
  void onPageChanged(int index) {
    tabIndex = index;
    _updateCurrentScenePairList();
    update(['option']);
  }

  // 更新当前显示的场景对列表
  void _updateCurrentScenePairList() {
    if (tabIndex < allOptionList.length) {
      currentScenePairList = allOptionList[tabIndex].scenePairList ?? [];
    } else {
      currentScenePairList = [];
    }
  }

  // 拉取所有tab数据
  Future<void> fetchAllData() async {
    showCountdown = false;
    update(['option']);

    // 获取所有期权数据
    var optionList = await OptionApi.getOptionList();

    // 从接口数据中提取tabKeys
    tabKeys.clear();
    allOptionList.clear();

    for (var optionData in optionList) {
      if (optionData.guessTimeName != null && optionData.guessTimeName!.isNotEmpty) {
        tabKeys.add(optionData.guessTimeName!);
        allOptionList.add(optionData);
      }
    }

    // 初始化或重置PageController
    if (pageController == null && tabKeys.isNotEmpty) {
      pageController = PageController(initialPage: tabIndex);
    } else if (pageController != null && tabIndex >= tabKeys.length) {
      // 如果当前索引超出范围，重置为0
      tabIndex = 0;
    }

    // 更新当前显示的数据
    _updateCurrentScenePairList();
    showCountdown = true;

    // 启动倒计时定时器
    _startCountdownTimer();
    update(['option']);
  }

  // 启动倒计时定时器
  void _startCountdownTimer() {
    _countdownTimer?.cancel(); // 先取消之前的定时器
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      bool needUpdate = false;
      bool needRefreshData = false;

      // 遍历所有时间维度的数据，更新倒计时
      for (var optionData in allOptionList) {
        if (optionData.scenePairList != null) {
          for (var sceneItem in optionData.scenePairList!) {
            if (sceneItem.lotteryTime != null && sceneItem.lotteryTime! > 0) {
              sceneItem.lotteryTime = sceneItem.lotteryTime! - 1;
              needUpdate = true;

              // 如果倒计时结束，标记需要重新拉取数据
              if (sceneItem.lotteryTime! <= 0) {
                needRefreshData = true;
              }
            }
          }
        }
      }

      // 如果需要重新拉取数据
      if (needRefreshData) {
        fetchAllData();
        return;
      }

      // 如果有数据更新，刷新UI
      if (needUpdate) {
        _updateCurrentScenePairList(); // 更新当前显示的数据
        update(['option']);
      }
    });
  }

  _initData() async {
    optionInfo = await OptionApi.getOptionInfo();
    update(["option"]);
  }

  @override
  void onInit() {
    super.onInit();

    // 监听socket数据
    _socketSubscription = SocketService().messageStream.listen((data) {
      if (data is Map && data['sub'] == 'sceneListNewPrice') {
        _handleSceneListNewPrice(data['data']);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    fetchAllData();
    _initData();

    // 订阅sceneListNewPrice推送
    SocketService().subscribe("sceneListNewPrice");
  }

  @override
  void onClose() {
    super.onClose();
    print('onClose取消订阅');
    // 取消订阅
    SocketService().unsubscribe("sceneListNewPrice");
    _socketSubscription?.cancel();
    // 取消倒计时定时器
    _countdownTimer?.cancel();
    // 释放PageController
    pageController?.dispose();
  }

  // 处理sceneListNewPrice推送数据
  void _handleSceneListNewPrice(dynamic data) {
    if (data == null) return;
    if (allOptionList.isEmpty) return;
    try {
      if (data is Map) {
        // 如果推送的是单个更新项，查找并更新对应项
        final pairId = data['pair_id'];
        final trendUp = data['trend_up'];
        final trendDown = data['trend_down'];
        final upOdds = data['up_odds'];
        final downOdds = data['down_odds'];
        final increaseStr = data['increaseStr'];

        if (pairId != null) {
          // 遍历所有时间维度的数据查找并更新
          bool found = false;
          for (var optionData in allOptionList) {
            if (optionData.scenePairList != null) {
              final index = optionData.scenePairList!.indexWhere((item) => item.pairId == pairId);
              if (index != -1) {
                // 更新现有项的价格信息
                var updatedItem = optionData.scenePairList![index];
                updatedItem.trendUp = trendUp;
                updatedItem.trendDown = trendDown;
                updatedItem.upOdds = upOdds;
                updatedItem.downOdds = downOdds;
                updatedItem.increaseStr = increaseStr;
                optionData.scenePairList![index] = updatedItem;
                found = true;
              }
            }
          }

          // 如果找到了数据，更新当前显示的列表
          if (found) {
            _updateCurrentScenePairList();
          }
        }
      }

      // 更新UI
      update(['option']);
    } catch (e) {
      print('处理sceneListNewPrice推送数据时出错: $e');
    }
  }

  // 跳转详情
  void onTapDetail(OptionIndexListModelScenePairList item) {
    Get.toNamed(AppRoutes.optionBuy, arguments: {
      'item': item,
    });
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
                TextWidget.body('期权说明'.tr, size: 32.sp, color: Colors.black, weight: FontWeight.w600),
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
                        optionInfo,
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
                  .tight(width: 530.w, height: 74.w)
                  .backgroundColor(AppTheme.color000)
                  .clipRRect(all: 37.w)
                  .onTap(() {
                Get.back();
              }),
            ].toColumn().paddingAll(30.w),
          ].toColumn().tight(width: 590.w, height: 860.w).backgroundColor(AppTheme.pageBgColor).clipRRect(all: 20.w)),
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }
}
