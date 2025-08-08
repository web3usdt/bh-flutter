import 'package:BBIExchange/common/index.dart';
import 'package:BBIExchange/pages/tab/assets/index.dart';
import 'package:BBIExchange/pages/tab/coin/view.dart';
import 'package:BBIExchange/pages/tab/contract/index.dart';
import 'package:BBIExchange/pages/tab/home/index.dart';
import 'package:BBIExchange/pages/tab/mining/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/pages/tab/option/index.dart';

import 'index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX();

  // 主视图
  Widget _buildView(BuildContext context) {
    return PopScope(
      // 允许返回
      canPop: false,

      // 防止连续点击两次退出
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // 如果返回，则不执行退出请求
        if (didPop) {
          return;
        }

        // 退出请求
        if (controller.closeOnConfirm(context)) {
          SystemNavigator.pop(); // 系统级别导航栈 退出程序
        }
      },

      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        // 导航栏
        bottomNavigationBar: GetBuilder<MainController>(
          id: 'navigation',
          builder: (controller) {
            return BuildNavigation(
              currentIndex: controller.currentIndex,
              items: [
                NavigationItemModel(
                  count: 0,
                  label: '首页'.tr,
                  icon: Image(
                    image: AssetImage(Get.isDarkMode ? 'assets/img/navbar1.png' : 'assets/img/navbar1.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                  activeIcon: Image(
                    image: const AssetImage('assets/img/navbar1ac.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
                NavigationItemModel(
                  label: '币币'.tr,
                  icon: Image(
                    image: AssetImage(Get.isDarkMode ? 'assets/img/navbar2.png' : 'assets/img/navbar2.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                  activeIcon: Image(
                    image: const AssetImage('assets/img/navbar2ac.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
                NavigationItemModel(
                  label: '期权'.tr,
                  icon: Image(
                    image: AssetImage(Get.isDarkMode ? 'assets/img/navbar3.png' : 'assets/img/navbar3.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                  activeIcon: Image(
                    image: const AssetImage('assets/img/navbar3ac.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
                NavigationItemModel(
                  label: '挖矿'.tr,
                  icon: Image(
                    image: AssetImage(Get.isDarkMode ? 'assets/img/navbar4.png' : 'assets/img/navbar4.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                  activeIcon: Image(
                    image: const AssetImage('assets/img/navbar4ac.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
                NavigationItemModel(
                  label: '永续'.tr,
                  icon: Image(
                    image: AssetImage(Get.isDarkMode ? 'assets/img/navbar5.png' : 'assets/img/navbar5.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                  activeIcon: Image(
                    image: const AssetImage('assets/img/navbar5ac.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
                NavigationItemModel(
                  label: '资产'.tr,
                  icon: Image(
                    image: AssetImage(Get.isDarkMode ? 'assets/img/navbar6.png' : 'assets/img/navbar6.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                  activeIcon: Image(
                    image: const AssetImage('assets/img/navbar6ac.png'),
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
              ],
              onTap: controller.onJumpToPage, // 切换tab事件
            );
          },
        ),
        // 内容页
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onIndexChanged,
          children: const [
            // 加入空页面占位
            HomePage(),
            CoinPage(),
            OptionPage(),
            MiningPage(),
            ContinuousPage(),
            AssetsPage(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        // init: MainController(),
        id: "main",
        builder: (_) => _buildView(context));
  }
}
