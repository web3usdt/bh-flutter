import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'dart:ui' as ui;

class GameDetailController extends GetxController with GetTickerProviderStateMixin {
  GameDetailController();
  final GlobalKey qrKey = GlobalKey();
  // 币种列表
  List<Map<String, dynamic>> coinList = [
    // {'id': 1, 'name': 'USDT'},
    // {'id': 2, 'name': 'BTC'},
    // {'id': 3, 'name': 'ETH'},
  ];
  // 选中的币种
  String selectedCoin = '';
  // 选中的币种ID
  int selectedCoinId = 0;

  // 战绩总览统计
  GameDetailModel gameDetail = GameDetailModel();

  // tab 控制器
  late TabController tabController;
  // tab 索引
  int tabIndex = 0;
  // tab 名称
  List<String> tabNames = ['哈希单双3秒钟'.tr, '哈希单双1分钟'.tr];

  // 时间控制器
  late TabController timeController;
  // 时间索引
  int timeIndex = 0;
  // 时间名称
  List<String> timeNames = ['今日'.tr, '昨日'.tr];

  void _initData() async {
    // 获取币种列表
    final value = await GameApi.coinList();
    coinList = value.map((e) => {'id': e.id, 'name': e.coinName}).toList();
    selectedCoin = coinList.first['name'] ?? '';
    selectedCoinId = coinList.first['id'] ?? 0;
    getGameDetail();
    update(["game_detail"]);
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabNames.length, vsync: this);
    timeController = TabController(length: timeNames.length, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    timeController.dispose();
  }

  // 获取战绩总览统计
  void getGameDetail() async {
    final value = await GameApi.gameDetail(tabIndex + 1, selectedCoinId, timeIndex == 0 ? 'today' : 'yesterday');
    gameDetail = value;
    update(["game_detail"]);
  }

  void onTapTimeItem(int index) {
    timeIndex = index;
    getGameDetail();
    update(["game_detail"]);
  }

  void onTapTabItem(int index) {
    tabIndex = index;
    getGameDetail();
    update(["game_detail"]);
  }

  // 显示币种选择器
  void showCoinPicker(BuildContext context) {
    PickerUtils.showPicker(
      context: context,
      title: '选择币种'.tr,
      items: coinList.map((e) => {'id': e['id'], 'name': e['name']}).toList(),
      onConfirm: (selected) {
        selectedCoin = selected['name'];
        selectedCoinId = selected['id'];
        getGameDetail();
        update(['game_detail']);
      },
      onCancel: () {},
    );
  }

  // 保存图片
  void saveImage() async {
    // 获取 RenderRepaintBoundary
    final boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    print('boundary: $boundary');

    // 等待一下确保UI已经完全渲染
    await Future.delayed(const Duration(milliseconds: 20));

    // 将 Widget 转换成图片
    final image = await boundary.toImage(pixelRatio: 3.0);
    print('image: $image');

    // 将图片转换成字节数据
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print('byteData: $byteData');

    if (byteData != null) {
      final success = await ImageSaverHelper.saveUint8ListImage(byteData.buffer.asUint8List());
      print('success: $success');
    }
  }
}
