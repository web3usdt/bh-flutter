import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/pages/tab/main/index.dart';

class HomeController extends GetxController {
  HomeController();
  // 节点名称
  String nodeName = '';
  // 申购列表
  List<HomeSubscribeListModel> subscribeList = [];
  // 当前选中的申购信息
  HomeSubscribeListModel? selectedSubscribe;
  // 总资产折合显示/隐藏
  bool isShowTotalAssetsBtc = true;
  // 个人账户
  AssetsPersonalAccountModel personalAccount = AssetsPersonalAccountModel();
  // 用户信息
  User userInfo = User();
  // 语言
  String language = '';
  // 当前版本号
  String currentVersion = '';
  // 页码
  int currentIndex = 0;

  // 轮播图
  List<BannerListModel> bannerList = [];
  // 公告
  List<NoticeListModel> noticeList = [];
  // 市场
  List<MarketList> marketList = [];
  // 订阅socket行情
  StreamSubscription? _socketSubscription;
  // 活动信息
  UserShareActiveInfoModel appActivity = UserShareActiveInfoModel();
  // 控制邀请弹窗是否已显示（每次APP启动时重置）
  bool hasShownInviteDialog = false;

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();

    // 监听数据
    _socketSubscription = SocketService().messageStream.listen((data) {
      if (data is Map && data['sub'] == 'indexMarketList') {
        final List<MarketList> newMarketList = (data['data'] as List).map((item) => MarketList.fromJson(item)).toList();
        marketList = newMarketList;

        update(["home"]);
      }
    });

    SocketService().subscribe("indexMarketList");
  }

  @override
  void onClose() {
    super.onClose();
    SocketService().unsubscribe("indexMarketList");
    _socketSubscription?.cancel();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
    // 延迟1秒设置系统样式
    Future.delayed(const Duration(seconds: 1), () {
      AppTheme.setSystemStyle();
    });
  }

  // 初始化数据
  void _initData() async {
    nodeName = Storage().getString('nodeName');
    isShowTotalAssetsBtc = Storage().getBool('isShowTotalAssetsBtc');
    update(["home"]);
    currentVersion = ConfigService.to.version;
    onVersionUpdate();

    // 获取申购列表
    subscribeList = await HomeApi.subscribeList();
    // 当前选中的申购信息
    selectedSubscribe = subscribeList.first;
    Storage().setJson('selectedSubscribe', selectedSubscribe!);

    // 获取app活动
    // appActivity = await UserApi.getAppActivity();
    // if (appActivity.id != null) {
    //   Storage().setJson('appActivity', appActivity);
    //   hasShownInviteDialog = Storage().getBool('hasShownInviteDialog');
    //   print('hasShownInviteDialog: $hasShownInviteDialog');
    //   if (!hasShownInviteDialog) {
    //     showInviteFriendDialog();
    //     hasShownInviteDialog = true;
    //     Storage().setBool('hasShownInviteDialog', hasShownInviteDialog);
    //   }
    // }

    final res = await HomeApi.homeDatainfo();
    // 从res.marketList中筛选出coinName == USDT的marketInfoList
    marketList = res.marketList ?? [];
    Storage().setJson('marketList', marketList);
    bannerList = res.bannerList ?? [];
    Storage().setJson('bannerList', bannerList);
    noticeList = res.noticeList ?? [];
    Storage().setJson('noticeList', noticeList);

    update(["home"]);

    // 获取个人账户
    personalAccount = await AssetsApi.getPersonalAccount();
    Storage().setJson('personalAccount', personalAccount);

    // 创建钱包地址
    await UserApi.createWalletAddress();

    // 最新公告弹窗
    // showLatestNotice();
    update(["home"]);
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringUserInfo = Storage().getString('userInfo');
    userInfo = stringUserInfo != "" ? User.fromJson(jsonDecode(stringUserInfo)) : User();

    var stringPersonalAccount = Storage().getString('personalAccount');
    personalAccount =
        stringPersonalAccount != "" ? AssetsPersonalAccountModel.fromJson(jsonDecode(stringPersonalAccount)) : AssetsPersonalAccountModel();

    var stringBannerList = Storage().getString('bannerList');
    bannerList = stringBannerList != ""
        ? jsonDecode(stringBannerList).map<BannerListModel>((item) {
            return BannerListModel.fromJson(item);
          }).toList()
        : [];

    var stringNoticeList = Storage().getString('noticeList');
    noticeList = stringNoticeList != ""
        ? jsonDecode(stringNoticeList).map<NoticeListModel>((item) {
            return NoticeListModel.fromJson(item);
          }).toList()
        : [];

    var stringMarketList = Storage().getString('marketList');
    marketList = stringMarketList != ""
        ? jsonDecode(stringMarketList).map<MarketList>((item) {
            return MarketList.fromJson(item);
          }).toList()
        : [];

    var stringSelectedSubscribe = Storage().getString('selectedSubscribe');
    selectedSubscribe =
        stringSelectedSubscribe != "" ? HomeSubscribeListModel.fromJson(jsonDecode(stringSelectedSubscribe)) : HomeSubscribeListModel();

    // 获取app活动
    // var stringAppActivity = Storage().getString('appActivity');
    // appActivity = stringAppActivity != "" ? UserShareActiveInfoModel.fromJson(jsonDecode(stringAppActivity)) : UserShareActiveInfoModel();

    update(["home"]);
  }

  // 获取USDT市场列表下的BTC/USDT、ETH/USDT、XAUT/USDT
  List<MarketInfoListModel> get filteredMarketInfoList {
    final result = <MarketInfoListModel>[];
    for (var parentItem in marketList) {
      if (parentItem.coinName == 'USDT') {
        final list = parentItem.marketInfoList ?? [];
        result.addAll(list.where((item) => item.pairName == 'BB/USDT' || item.pairName == 'ETH/USDT' || item.pairName == 'XAUT/USDT'));
      }
    }
    return result;
  }

  List<MarketInfoListModel> get filteredMarketInfoList2 {
    return marketList.where((item) => item.coinName == 'USDT').map((e) => e.marketInfoList ?? []).expand((x) => x).toList();
  }

  // 获取所有USDT市场
  List<MarketInfoListModel> allUsdtMarketList({String? source}) {
    // final result = <MarketInfoListModel>[];
    // for (var parentItem in marketList) {
    //   if (parentItem.coinName == 'USDT') {
    //     final list = parentItem.marketInfoList ?? [];
    //     result.addAll(list);
    //   }
    // }

    // final coinList = result.map((e) => e.coinName).toList();
    // log.d('usdtMarketList: [${result.length}] $coinList');
    final result = filteredMarketInfoList2;
    // log.d('UsdtMarketPair-display: [UI-Update] [${result.length}] ${result.map((e) => e.coinName).toList()}');
    return result;
  }

  // 切换总资产折合显示/隐藏
  changeShowTotalAssetsBtc() {
    isShowTotalAssetsBtc = !isShowTotalAssetsBtc;
    Storage().setBool('isShowTotalAssetsBtc', isShowTotalAssetsBtc);
    update(["home"]);
  }

  // 切换页码
  void onPageChanged(int index, CarouselPageChangedReason reason) {
    currentIndex = index;
    update(["home"]);
  }

  // 进入公告列表
  void goNoticeList() {
    Get.toNamed(AppRoutes.noticeList);
  }

  // 进入公告详情
  void goNoticeDetail(int id) {
    Get.toNamed(AppRoutes.noticeDetail, arguments: {
      'notice_id': id,
      'type': 'notice',
    });
  }

  // 进入交易页面
  void goCoinPage() {
    // 获取主控制器
    MainController mainController = Get.find();
    // 跳转到分类页
    mainController.pageController.jumpToPage(1);
  }

  // 查看K线
  void goKLine(String pairName) async {
    var res = await Get.toNamed(AppRoutes.kChart, arguments: {'pairName': pairName});
    if (res != null) {
      print('res: $res');
      // 获取主控制器
      MainController mainController = Get.find();
      // 存储ID到主控制器
      mainController.pairName = res['pairName'];
      mainController.type = res['type'];
      // 跳转到分类页
      mainController.pageController.jumpToPage(1);
      update(["home"]);
    }
  }

  // 显示最新公告弹窗
  void showLatestNotice() {
    Get.dialog(
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 弹窗内容
            <Widget>[
              <Widget>[
                TextWidget.body('最新公告', size: 32.sp, color: Colors.white, weight: FontWeight.w600),
                const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.white,
                ).onTap(() {
                  Get.back();
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 30.w),

              // 内部可滚动的区域
              Container(
                width: 530.w,
                height: 600.w,
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: AppTheme.blockBgColor,
                  borderRadius: BorderRadius.circular(30.w),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget.body(
                        '公告标题',
                        size: 28.sp,
                        color: AppTheme.colorfff,
                      ),
                      SizedBox(height: 10.w),
                      TextWidget.body('2024.12.28 12:00', size: 28.sp, color: AppTheme.color666),
                      SizedBox(height: 20.w),
                      HtmlWidget(
                        '这是公告内容',
                        // 设置渲染模式
                        renderMode: RenderMode.column,
                        // 设置文本样式
                        textStyle: TextStyle(
                          fontSize: 28.sp,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.w),
              // 底部按钮
              <Widget>[
                TextWidget.body(
                  '知道了',
                  size: 24.sp,
                  color: Colors.white,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.center)
                  .tight(width: 530.w, height: 80.w)
                  .backgroundColor(AppTheme.primary)
                  .clipRRect(all: 30.w)
                  .onTap(() {
                Get.back();
              }),
            ].toColumn().paddingAll(30.w),
          ].toColumn().tight(width: 590.w, height: 880.w).decorated(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Get.isDarkMode
                      ? const [
                          Color(0xff0094FF),
                          Color(0xff000000),
                        ]
                      : const [
                          Color(0xff0094FF),
                          Color(0xffffffff),
                        ],
                ),
              )),
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  // 显示邀请好友弹窗
  void showInviteFriendDialog() {
    Get.dialog(
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 弹窗内容
            <Widget>[
              ImgWidget(
                path: 'assets/images/home12.png',
                width: 470.w,
                height: 470.w,
              ),
              SizedBox(height: 30.w),
              TextWidget.body('邀请好友尊享交易返佣'.tr, size: 32.sp, color: AppTheme.colorfff),
              SizedBox(height: 20.w),
              <Widget>[
                TextWidget.body('共同解锁'.tr, size: 32.sp, color: AppTheme.colorfff),
                TextWidget.body('${appActivity.reward} USDT', size: 48.sp, color: AppTheme.colorGreen, weight: FontWeight.w600),
                TextWidget.body('奖励'.tr, size: 32.sp, color: AppTheme.colorfff),
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 40.w),
              ButtonWidget(
                text: '邀请好友'.tr,
                width: 690,
                height: 88,
                borderRadius: 44,
                backgroundColor: AppTheme.colorfff,
                textColor: AppTheme.color000,
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.share);
                },
              ),
              SizedBox(height: 60.w),
              const Icon(
                Icons.close,
                size: 32,
                color: Colors.white,
              ).onTap(() {
                Get.back();
              }),
            ].toColumn().paddingAll(30.w),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center)),
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  // 版本更新
  void onVersionUpdate() async {
    // 接口拿到更新数据
    // var res = await  UserApi.versionUpdate(VersionUpdateReq(version: currentVersion, device: 'android'));
    var res = VersionUpdateModel(
      version: '1.0.0',
      content: '这是公告内容',
      url: 'https://www.baidu.com',
      isForce: 0,
    );
    // print('版本更新: ${res.toJson()}');
    // 使用工具类检查更新，为了方便展示，把更新数据写死测试安装
    if (res.version != null && res.version!.isNotEmpty) {
      VersionUpdateUtil.checkUpdate(
        currentVersion: currentVersion,
        latestVersion: res.version ?? '',
        description: res.content ?? '',
        apkUrl: res.url ?? '',
        isForce: res.isForce ?? 0,
      );
    }
    update(["mine"]);
  }

  // 切换语言
  void setLanguageSetting() async {
    final List<Map<String, dynamic>> languageList = [
      {'id': 0, 'name': '简体中文', 'icon': Image.asset('assets/img/home3.png')},
      {'id': 1, 'name': '繁体中文', 'icon': Image.asset('assets/img/home3.png')},
      {'id': 2, 'name': 'English', 'icon': Image.asset('assets/img/home3.png')},
    ];
    PickerUtils.showPicker(
      context: Get.context!,
      title: '选择语言'.tr,
      items: languageList,
      alignment: MainAxisAlignment.center,
      onConfirm: (selected) {
        language = selected['name'] ?? '';
        var zh = Translation.supportedLocales[0];
        var tw = Translation.supportedLocales[1];
        var en = Translation.supportedLocales[2];
        if (language == "简体中文") {
          ConfigService.to.setLanguage(zh);
        } else if (language == "繁体中文") {
          ConfigService.to.setLanguage(tw);
        } else if (language == "English") {
          ConfigService.to.setLanguage(en);
        }
        update(['mine']);
      },
      onCancel: () {},
    );
  }

  // 跳转到节点页
  void goNodePage() async {
    await Get.toNamed(AppRoutes.node);
    nodeName = Storage().getString('nodeName');
    update(["home"]);
  }
}
