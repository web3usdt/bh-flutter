import 'dart:async';
import 'package:BBIExchange/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  MainController();
  // 分页管理
  final PageController pageController = PageController();
  String pairName = '';
  String coinName = '';
  int type = 0;

  // 当前的 tab index
  int currentIndex = 0;

  // 退出请求时间
  DateTime? currentBackPressTime;

  // 在MainController类中添加
  late Worker _themeWorker;

  // 初始化WebSocket
  void _initWebSocket() {
    if (Storage().getString('token').isNotEmpty) {
      // 连接socket
      SocketService().connect();

      // 初始化并连接WebSocket2
      SocketService2().connect();

      // 初始化并连接WebSocket3
      SocketService3().connect();
    }
  }

  // 导航栏切换
  void onIndexChanged(int index) {
    currentIndex = index;
    update(['navigation']);
  }

  // 切换页面
  void onJumpToPage(int page) {
    pageController.jumpToPage(page);
  }

  // 返回键退出
  bool closeOnConfirm(BuildContext context) {
    DateTime now = DateTime.now();
    // 物理键，两次间隔大于4秒, 退出请求无效
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 4)) {
      currentBackPressTime = now;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     behavior: SnackBarBehavior.floating,
      //     content: Center(child: Text('Press again to exit the application.')),
      //     duration: Duration(seconds: 4),
      //   ),
      // );
      Loading.toast('再按一次，退出程序');
      return false;
    }

    // 退出请求有效
    Storage().setBool('hasShownInviteDialog', false);
    currentBackPressTime = null;
    return true;
  }

  _initData() async {
    // 初始化WebSocket
    _initWebSocket();

    update(["main"]);
  }

  @override
  void onInit() {
    super.onInit();

    // 监听主题变化
    _themeWorker = ever(ConfigService.to.themeChanged, (_) {
      // 更新MainController
      update(['main', 'navigation']);

      // 延迟执行以确保主题切换完成
      Future.delayed(const Duration(milliseconds: 100), () {
        // 保存当前页面索引
        int currentTab = currentIndex;
        // 强制重建所有页面
        update(['main', 'navigation']);
        // 如果不在首页，先跳转到首页再跳回
        if (currentTab != 0) {
          pageController.jumpToPage(0);
          Future.delayed(const Duration(milliseconds: 50), () {
            pageController.jumpToPage(currentTab);
            update(['navigation']);
          });
        }
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    _themeWorker.dispose(); // 释放监听器
    pageController.dispose();
    super.onClose();
  }
}
