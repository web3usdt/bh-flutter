import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class SubscribeController extends GetxController {
  SubscribeController();
  // 申购列表
  List<HomeSubscribeListModel> subscribeList = [];
  // 当前选中的申购信息
  HomeSubscribeListModel? selectedSubscribe;
  // 申购数量
  final TextEditingController numberController = TextEditingController();
  // 当前选中的数量
  int currentNum = 0;
  // 当前周期
  int current = 0;
  // 滑块进度
  int progress = 100;
  // 滑动触发
  void onSliderChange(double value) {
    progress = value.round();
    // 同步更新输入框的值
    numberController.text = progress.toString();
    update(['subscribe']);
  }

  List<Map<String, dynamic>> timeList = [
    {
      'index': 1,
      'title': '项目预热'.tr,
      'time': '2025.00.00 00:00:00',
    },
    {
      'index': 2,
      'title': '开始申购'.tr,
      'time': '2025.00.00 00:00:00',
    },
    {
      'index': 3,
      'title': '结束申购'.tr,
      'time': '2025.00.00 00:00:00',
    },
    {
      'index': 4,
      'title': '公布结果'.tr,
      'time': '2025.00.00 00:00:00',
    },
  ];
  // 选择币种
  String selectedCoin = '';
  // 币种列表
  List<HomeSubscribeCoinlistModel> coinList = [
    // {'id': 1, 'name': 'USDT'},
    // {'id': 2, 'name': 'BTC'},
    // {'id': 3, 'name': 'ETH'},
  ];
  // 申购信息
  String? projectDetails = '';
  // 总价
  double total = 0;
  // 1U = *BB
  double proportionAmount = 0;

  _initData() async {
    // 获取申购列表
    subscribeList = await HomeApi.subscribeList();
    // 当前选中的申购信息
    selectedSubscribe = subscribeList.first;
    current = selectedSubscribe?.status ?? 0;
    projectDetails = selectedSubscribe?.projectDetails ?? '';
    onTimeChange(selectedSubscribe!);
    // 币种列表
    coinList.addAll(subscribeList.map((e) => HomeSubscribeCoinlistModel(coinName: e.coinName)).toList());
    selectedCoin = subscribeList.first.coinName ?? '';
    update(["subscribe"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    numberController.dispose();
  }

  // 初始化项目周期显示的时间
  void onTimeChange(HomeSubscribeListModel subscribe) {
    timeList[0]['time'] = subscribe.expectedTimeOnline;
    timeList[1]['time'] = subscribe.startSubscriptionTime;
    timeList[2]['time'] = subscribe.endSubscriptionTime;
    timeList[3]['time'] = subscribe.announceTime;
    update(["subscribe"]);
  }

  // 选择数量
  void onNumChange(int num) {
    currentNum = num;
    numberController.text = num.toString();
    update(["subscribe"]);
  }

  // 申购
  void submit() async {
    if (current == 4 || current == 3) return Loading.toast('申购已结束'.tr);
    if (numberController.text.isEmpty) return Loading.toast('请输入申购数量'.tr);
    Loading.show();
    var res = await HomeApi.confirmSubscribe(numberController.text, selectedSubscribe?.coinName ?? '');
    if (res) {
      Loading.success('申购成功'.tr);
    }
  }

  // 显示币种选择器
  void showCoinPicker() {
    PickerUtils.showPicker(
      context: Get.context!,
      title: '选择币种'.tr,
      items: coinList
          .map((e) => {
                'name': e.coinName,
              })
          .toList(),
      onConfirm: (selected) {
        currentNum = 0;
        selectedCoin = selected['name'];
        // 当前选中的申购信息
        selectedSubscribe = subscribeList.firstWhere((e) => e.coinName == selectedCoin);
        current = selectedSubscribe?.status ?? 0;
        numberController.text = '';
        onTimeChange(selectedSubscribe!);
        print(current);
        update(['subscribe']);
      },
      onCancel: () {},
    );
  }

  // 全部
  void onAll() {
    // 设置最大申购数量（3000）
    progress = 3000;
    numberController.text = progress.toString();
    total = double.parse(MathUtils.multiple(progress.toString(), proportionAmount, 2));
    update(["subscribe"]);
  }

  // 输入监听，自动计算total
  void onNumberChanged(String value) {
    double num = double.tryParse(value) ?? 0;
    // 限制输入范围在100-3000之间
    if (num < 100) {
      num = 100;
      numberController.text = '100';
    } else if (num > 3000) {
      num = 3000;
      numberController.text = '3000';
    }
    // 同步更新滑块进度
    progress = num.round();
    total = double.parse(MathUtils.multiple(num, proportionAmount, 2));
    update(["subscribe"]);
  }

  // 失去焦点时触发
  void onInputBlur() {
    String value = numberController.text;
    onNumberChanged(value);
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
                TextWidget.body('项目详情'.tr, size: 32.sp, color: Colors.black, weight: FontWeight.w600),
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
                      TextWidget.body(
                        projectDetails ?? '',
                        size: 28.sp,
                        color: AppTheme.color000,
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
}
