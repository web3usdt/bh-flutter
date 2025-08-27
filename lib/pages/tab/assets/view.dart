import 'package:decimal/decimal.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'index.dart';

// 辅助函数，用于安全地格式化Decimal字符串
String formatDecimal(String? value, {int? toFixed}) {
  if (value == null) {
    return '--';
  }
  final decimalValue = Decimal.tryParse(value);
  if (decimalValue == null) {
    return '--';
  }
  if (toFixed != null) {
    return decimalValue.toStringAsFixed(toFixed);
  }
  return decimalValue.toString();
}

class AssetsPage extends GetView<AssetsController> {
  const AssetsPage({super.key});

  // 头部标题
  Widget _buildHeader() {
    return <Widget>[
      <Widget>[
        <Widget>[
          TextWidget.body(
            '总资产折合(BTC)'.tr,
            size: 24.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 14.w,
          ),
          ImgWidget(
            path: controller.isShowTotalAssetsBtc ? 'assets/images/home8.png' : 'assets/images/home9.png',
            width: 24.w,
            height: 24.w,
          ),
        ].toRow().onTap(() {
          controller.changeShowTotalAssetsBtc();
        }),
        SizedBox(
          height: 30.w,
        ),
        if (controller.isShowTotalAssetsBtc)
          <Widget>[
            TextWidget.body(
              formatDecimal(controller.personalAccount.totalAssetsBtc, toFixed: controller.personalAccount.qtyDecimals ?? 8),
              size: 48.sp,
              color: AppTheme.color000,
              weight: FontWeight.bold,
            ),
            SizedBox(
              height: 10.w,
            ),
            TextWidget.body(
              '≈ ${formatDecimal(controller.personalAccount.totalAssetsUsd, toFixed: controller.personalAccount.priceDecimals ?? 2)} USD',
              size: 24.sp,
              color: AppTheme.color8B8B8B,
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        else
          <Widget>[
            TextWidget.body(
              '******',
              size: 48.sp,
              color: AppTheme.color000,
              weight: FontWeight.bold,
            ),
            SizedBox(
              height: 10.w,
            ),
            TextWidget.body(
              '≈ ****** USD',
              size: 24.sp,
              color: AppTheme.color8B8B8B,
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  // 操作按钮
  Widget _buildOperation() {
    return <Widget>[
      <Widget>[
        ButtonWidget(
          text: '充币'.tr,
          width: 220,
          height: 64,
          borderRadius: 32,
          backgroundColor: AppTheme.primary,
          textColor: Colors.white,
          onTap: () {
            Get.toNamed(AppRoutes.recharge);
          },
        ),
        ButtonWidget(
          text: '提币'.tr,
          width: 220,
          height: 64,
          borderRadius: 32,
          backgroundColor: AppTheme.blockBgColor,
          textColor: Colors.black,
          onTap: () {
            Get.toNamed(AppRoutes.withdraw);
          },
        ),
        ButtonWidget(
          text: '划转'.tr,
          width: 220,
          height: 64,
          borderRadius: 32,
          backgroundColor: AppTheme.blockBgColor,
          textColor: Colors.black,
          onTap: () {
            Get.toNamed(AppRoutes.transfer, arguments: {
              'router': 'assets',
            });
          },
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).marginOnly(top: 20.w, bottom: 40.w),
      <Widget>[].toRow().tight(height: 1).backgroundColor(AppTheme.borderLine),
    ].toColumn();
  }

  // tab切换
  Widget _buildTab() {
    return <Widget>[
      TextWidget.body(
        '资金账户'.tr,
        size: 28.sp,
        color: controller.currentTab == 0 ? AppTheme.color000 : AppTheme.color8D9094,
      ).onTap(() => controller.changeTab(0)),
      SizedBox(
        width: 50.w,
      ),
      // TextWidget.body(
      //   '合约账户'.tr,
      //   size: 28.sp,
      //   color: controller.currentTab == 1 ? AppTheme.color000 : AppTheme.color8D9094,
      // ).onTap(() => controller.changeTab(1)),
      // SizedBox(
      //   width: 50.w,
      // ),
      TextWidget.body(
        '挖矿账户'.tr,
        size: 28.sp,
        color: controller.currentTab == 2 ? AppTheme.color000 : AppTheme.color8D9094,
      ).onTap(() => controller.changeTab(2)),
      SizedBox(
        width: 50.w,
      ),
      TextWidget.body(
        '理财账户'.tr,
        size: 28.sp,
        color: controller.currentTab == 3 ? AppTheme.color000 : AppTheme.color8D9094,
      ).onTap(() => controller.changeTab(3)),
    ].toRow().height(100.w);
  }

  // 资产统计
  Widget _buildAssetsStatistics() {
    return <Widget>[
      <Widget>[
        ImgWidget(path: 'assets/images/usdt.png', width: 60.w, height: 60.w),
        SizedBox(
          width: 20.w,
        ),
        <Widget>[
          TextWidget.body(
            '总资产折合(USDT)'.tr,
            size: 20.sp,
            color: AppTheme.color8D9094,
          ),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body(
            '≈ ${formatDecimal(controller.personalAccount.totalAssetsUsd, toFixed: controller.personalAccount.priceDecimals ?? 2)}',
            size: 24.sp,
            color: AppTheme.color000,
            weight: FontWeight.bold,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toRow(),
      if (controller.currentTab != 0)
        ImgWidget(path: 'assets/images/assets6.png', width: 48.w, height: 48.w).onTap(() {
          Get.toNamed(AppRoutes.transfer);
        }),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingAll(30.w)
        .tight(width: 690.w)
        .decorated(
          border: Border.all(color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(10.w),
        )
        .marginOnly(bottom: 30.w);
  }

  // 合约账户
  Widget _buildContractAccount() {
    return <Widget>[
      <Widget>[
        ImgWidget(path: 'assets/images/usdt.png', width: 60.w, height: 60.w),
        SizedBox(
          width: 20.w,
        ),
        <Widget>[
          <Widget>[
            TextWidget.body(
              '合约账户(USDT)'.tr,
              size: 20.sp,
              color: AppTheme.color999,
            ),
            SizedBox(
              width: 10.w,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.w,
              color: AppTheme.color999,
            ),
          ].toRow().onTap(() {
            Get.toNamed(AppRoutes.assetsRecord, arguments: {'title': '合约账户'});
          }),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body(
            formatDecimal(controller.personalAccount.contractAccountUsd, toFixed: controller.personalAccount.priceDecimals ?? 2),
            size: 24.sp,
            color: AppTheme.color000,
            weight: FontWeight.bold,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toRow(),
      ImgWidget(path: 'assets/images/assets6.png', width: 48.w, height: 48.w).onTap(() {
        Get.toNamed(AppRoutes.transfer, arguments: {'router': 'assets'});
      }),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingAll(30.w)
        .tight(width: 690.w)
        .decorated(
          border: Border.all(color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(10.w),
        )
        .marginOnly(bottom: 30.w);
  }

  // 挖矿账户
  Widget _buildMinerAccount() {
    return <Widget>[
      // for (var item in controller.minerAccountList)
      <Widget>[
        ImgWidget(
          path: controller.minerAccountList.first.image ?? '',
          width: 60.w,
          height: 60.w,
          radius: 30.w,
        ),
        SizedBox(
          width: 20.w,
        ),
        <Widget>[
          <Widget>[
            TextWidget.body(
              '${'挖矿账户'.tr}（BB）',
              size: 20.sp,
              color: AppTheme.color999,
            ),
            SizedBox(
              width: 10.w,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.w,
              color: AppTheme.color999,
            ),
          ].toRow(),
          SizedBox(
            height: 10.w,
          ),
          <Widget>[
            TextWidget.body(
              formatDecimal(controller.minerAccountList.first.usableBalance ?? '0', toFixed: controller.personalAccount.priceDecimals ?? 2),
              size: 24.sp,
              weight: FontWeight.bold,
              textAlign: TextAlign.left,
            ),
          ].toRow(mainAxisAlignment: MainAxisAlignment.start),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.start)
          .paddingAll(30.w)
          .tight(width: 690.w)
          .decorated(
            border: Border.all(color: AppTheme.borderLine),
            borderRadius: BorderRadius.circular(10.w),
          )
          .marginOnly(bottom: 30.w)
          .onTap(() {
        Get.toNamed(AppRoutes.assetsRecord, arguments: {'title': '挖矿账户'});
      }),
    ].toColumn();
  }

  // 理财账户
  Widget _buildlicai() {
    return <Widget>[
      <Widget>[
        ImgWidget(path: 'assets/images/usdt.png', width: 60.w, height: 60.w),
        SizedBox(
          width: 20.w,
        ),
        <Widget>[
          <Widget>[
            TextWidget.body(
              '理财账户(USDT)'.tr,
              size: 20.sp,
              color: AppTheme.color999,
            ),
            SizedBox(
              width: 10.w,
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   size: 18.w,
            //   color: AppTheme.color999,
            // ),
          ].toRow().onTap(() {
            // Get.toNamed(AppRoutes.assetsRecord, arguments: {'title': '理财账户'});
          }),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body(
            '≈ ${formatDecimal(controller.licaiBalance, toFixed: controller.personalAccount.priceDecimals ?? 2)}',
            size: 24.sp,
            color: AppTheme.color000,
            weight: FontWeight.bold,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toRow(),
      if (controller.currentTab != 0)
        ImgWidget(path: 'assets/images/assets6.png', width: 48.w, height: 48.w).onTap(() {
          Get.toNamed(AppRoutes.transfer);
        }),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingAll(30.w)
        .tight(width: 690.w)
        .decorated(
          border: Border.all(color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(10.w),
        )
        .marginOnly(bottom: 30.w);
  }

  // 资产列表
  Widget _buildAssetsList() {
    return <Widget>[
      <Widget>[
        <Widget>[
          Icon(
            Icons.check_circle,
            size: 32.w,
            color: controller.isHideAssetsPageBalance ? AppTheme.primary : AppTheme.color000,
          ),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            '隐藏零余额资产'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
        ].toRow().onTap(() {
          controller.hideAssetsPageBalance();
        }),
        if (!controller.isShowSearch)
          Icon(Icons.search, size: 32.sp, color: AppTheme.color000).onTap(() {
            controller.changeShowSearch(true);
          }),
        if (controller.isShowSearch)
          <Widget>[
            InputWidget(
              prefix: Icon(
                Icons.search,
                size: 32.sp,
                color: AppTheme.color999,
              ),
              placeholder: "请输入搜索关键词".tr,
              controller: controller.searchController,
            ).expanded(),
          ]
              .toRow(crossAxisAlignment: CrossAxisAlignment.center)
              .paddingHorizontal(20.w)
              .width(320.w)
              .backgroundColor(AppTheme.blockBgColor)
              .clipRRect(all: 10.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(height: 80.w),

      // 列表
      for (var item in controller.filteredCoinList)
        // 如果isHideAssetsPageBalance为true，则隐藏余额==0的资产，否则就全部显示
        if (!controller.isHideAssetsPageBalance || (double.tryParse(item.usableBalance?.toString() ?? '0') ?? 0) > 0)
          <Widget>[
            <Widget>[
              <Widget>[
                ImgWidget(
                  path: item.image ?? '',
                  width: 56.w,
                  height: 56.w,
                  radius: 28.w,
                ),
                SizedBox(
                  width: 20.w,
                ),
                TextWidget.body(
                  item.coinName ?? '',
                  size: 26.sp,
                  color: AppTheme.color000,
                )
              ].toRow(),
              <Widget>[
                TextWidget.body(
                  formatDecimal(item.usableBalance),
                  size: 26.sp,
                  color: AppTheme.color000,
                ),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(
                  '≈ ${formatDecimal(item.usdEstimate, toFixed: 2)}',
                  size: 24.sp,
                  color: AppTheme.color8B8B8B,
                ),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(
              height: 30.w,
            ),
            <Widget>[
              TextWidget.body(
                '冻结资产'.tr,
                size: 24.sp,
                color: AppTheme.color999,
                textAlign: TextAlign.right,
              ),
              TextWidget.body(
                item.freezeBalance.toString(),
                size: 24.sp,
                color: AppTheme.color000,
                textAlign: TextAlign.right,
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingVertical(30.w).border(bottom: 1, color: AppTheme.dividerColor).onTap(() {
            Get.toNamed(AppRoutes.assetsRecord, arguments: {'coinName': item.coinName, 'image': item.image, 'title': '资金流水'});
          })
    ].toColumn();
  }

  // 理财账户列表
  Widget _buildlicaiList() {
    return <Widget>[
      <Widget>[
        <Widget>[
          Icon(
            Icons.check_circle,
            size: 32.w,
            color: controller.isHideAssetsPageBalance ? AppTheme.primary : AppTheme.color000,
          ),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            '隐藏零余额资产'.tr,
            size: 20.sp,
            color: AppTheme.color000,
          ),
        ].toRow().onTap(() {
          controller.hideAssetsPageBalance();
        }),
        if (!controller.isShowSearch)
          Icon(Icons.search, size: 32.sp, color: AppTheme.color000).onTap(() {
            controller.changeShowSearch(true);
          }),
        if (controller.isShowSearch)
          <Widget>[
            InputWidget(
              prefix: Icon(
                Icons.search,
                size: 32.sp,
                color: AppTheme.color999,
              ),
              placeholder: "请输入搜索关键词".tr,
              controller: controller.searchController,
            ).expanded(),
          ]
              .toRow(crossAxisAlignment: CrossAxisAlignment.center)
              .paddingHorizontal(20.w)
              .width(320.w)
              .backgroundColor(AppTheme.blockBgColor)
              .clipRRect(all: 10.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(height: 80.w),

      // 列表
      for (var item in controller.licaiCoinList)
        // 如果isHideAssetsPageBalance为true，则隐藏余额==0的资产，否则就全部显示
        if (!controller.isHideAssetsPageBalance || (double.tryParse(item.usableBalance?.toString() ?? '0') ?? 0) > 0)
          <Widget>[
            <Widget>[
              <Widget>[
                ImgWidget(
                  path: item.image ?? '',
                  width: 56.w,
                  height: 56.w,
                  radius: 28.w,
                ),
                SizedBox(
                  width: 20.w,
                ),
                TextWidget.body(
                  item.coinName ?? '',
                  size: 26.sp,
                  color: AppTheme.color000,
                )
              ].toRow(),
              <Widget>[
                TextWidget.body(
                  formatDecimal(item.usableBalance),
                  size: 26.sp,
                  color: AppTheme.color000,
                ),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(
                  '≈ ${formatDecimal(item.usdEstimate, toFixed: 2)}',
                  size: 24.sp,
                  color: AppTheme.color8B8B8B,
                ),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(
              height: 30.w,
            ),
            <Widget>[
              TextWidget.body(
                '冻结资产'.tr,
                size: 24.sp,
                color: AppTheme.color999,
                textAlign: TextAlign.right,
              ),
              TextWidget.body(
                item.freezeBalance.toString(),
                size: 24.sp,
                color: AppTheme.color000,
                textAlign: TextAlign.right,
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingVertical(30.w).border(bottom: 1, color: AppTheme.dividerColor).onTap(() {
            Get.toNamed(AppRoutes.assetsRecord, arguments: {'coinName': item.coinName, 'image': item.image, 'title': '理财流水'});
          })
    ].toColumn();
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      // 资产模块
      if (!controller.isShowGame)
        <Widget>[
          _buildHeader().paddingAll(30.w),
          _buildOperation(),
          _buildTab().paddingHorizontal(30.w),
          if (controller.currentTab == 0) _buildAssetsStatistics().paddingHorizontal(30.w),
          if (controller.currentTab == 1) _buildContractAccount().paddingHorizontal(30.w),
          if (controller.currentTab == 2) _buildMinerAccount().paddingHorizontal(30.w),
          if (controller.currentTab == 3) _buildlicai().paddingHorizontal(30.w),
        ].toColumn(),

      // 游戏模块
      if (controller.isShowGame)
        <Widget>[
          // 游戏统计
          <Widget>[
            <Widget>[
              <Widget>[
                TextWidget.body(
                  '${'游戏账户估值'.tr}(USDT)',
                  size: 24.sp,
                  color: AppTheme.color000,
                ),
                SizedBox(
                  width: 14.w,
                ),
                ImgWidget(
                  path: controller.isShowTotalAssetsBtc ? 'assets/images/home8.png' : 'assets/images/home9.png',
                  width: 24.w,
                  height: 24.w,
                ),
              ].toRow().onTap(() {
                controller.changeShowTotalAssetsBtc();
              }),
              <Widget>[
                ImgWidget(path: 'assets/images/game1.png', width: 40.w, height: 40.w).onTap(() {
                  Get.toNamed(AppRoutes.gameDetail);
                }),
                SizedBox(
                  width: 30.w,
                ),
                ImgWidget(path: 'assets/images/game2.png', width: 40.w, height: 40.w).onTap(() {
                  Get.toNamed(AppRoutes.gameAssetRecord);
                }),
              ].toRow(),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(
              height: 20.w,
            ),
            if (controller.isShowTotalAssetsBtc)
              <Widget>[
                TextWidget.body(
                  '${controller.personalAccount.gameAccountUsd}',
                  size: 48.sp,
                  color: AppTheme.color000,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(
                  '≈ ${controller.personalAccount.gameAccountUsd}',
                  size: 24.sp,
                  color: AppTheme.color8B8B8B,
                ),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            else
              <Widget>[
                TextWidget.body(
                  '******',
                  size: 48.sp,
                  color: AppTheme.color000,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body(
                  '≈ ******',
                  size: 24.sp,
                  color: AppTheme.color8B8B8B,
                ),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
            SizedBox(
              height: 40.w,
            ),
            ButtonWidget(
              text: '划转'.tr,
              height: 64,
              borderRadius: 40,
              backgroundColor: const Color(0xff303236),
              textColor: Colors.white,
              onTap: () {
                Get.toNamed(AppRoutes.transfer, arguments: {
                  'router': 'game',
                });
              },
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, right: 30.w, top: 30.w, bottom: 40.w),

          TDDivider(height: 1, color: AppTheme.borderLine),
          SizedBox(
            height: 20.w,
          ),

          // 游戏入口
          <Widget>[
            <Widget>[
              ImgWidget(path: 'assets/images/game3.png', width: 92.w, height: 92.w).positioned(left: 30.w, top: 20.w),
              ImgWidget(path: 'assets/images/game15.png', width: 26.w, height: 26.w).positioned(right: 30.w, top: 60.w),
              <Widget>[
                <Widget>[
                  TextWidget.body('哈希单双'.tr, size: 28.sp, color: AppTheme.color000, weight: FontWeight.bold),
                  TextWidget.body('3秒钟'.tr, size: 28.sp, color: AppTheme.colorGreen, weight: FontWeight.bold),
                ].toRow(),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body('热血刺激，分秒必争'.tr, size: 20.sp, color: AppTheme.color999),
              ]
                  .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                  .paddingOnly(left: 30.w, right: 30.w, top: 110.w, bottom: 30.w)
                  .tight(height: 227.w, width: 335.w)
                  .decorated(
                    border: Border.all(color: AppTheme.borderLine),
                    borderRadius: BorderRadius.circular(16.w),
                  )
                  .positioned(top: 30.w)
            ].toStack().tight(width: 335.w, height: 300.w).onTap(() {
              Get.toNamed(AppRoutes.hashGame, arguments: {'type': 1});
            }),
            <Widget>[
              ImgWidget(path: 'assets/images/game4.png', width: 92.w, height: 92.w).positioned(left: 30.w, top: 20.w),
              ImgWidget(path: 'assets/images/game15.png', width: 26.w, height: 26.w).positioned(right: 30.w, top: 60.w),
              <Widget>[
                <Widget>[
                  TextWidget.body('哈希单双'.tr, size: 28.sp, color: AppTheme.color000, weight: FontWeight.bold),
                  TextWidget.body('1分钟'.tr, size: 28.sp, color: AppTheme.colorGreen, weight: FontWeight.bold),
                ].toRow(),
                SizedBox(
                  height: 10.w,
                ),
                TextWidget.body('热血刺激，分秒必争'.tr, size: 20.sp, color: AppTheme.color999),
              ]
                  .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                  .paddingOnly(left: 30.w, right: 30.w, top: 110.w, bottom: 30.w)
                  .tight(height: 227.w, width: 335.w)
                  .decorated(
                    border: Border.all(color: AppTheme.borderLine),
                    borderRadius: BorderRadius.circular(16.w),
                  )
                  .positioned(top: 30.w)
            ].toStack().tight(width: 335.w, height: 300.w).onTap(() {
              Get.toNamed(AppRoutes.hashGame, arguments: {'type': 2});
            }),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w)
        ].toColumn(),

      // 资产币种列表
      if (controller.currentTab == 0) _buildAssetsList().paddingHorizontal(30.w),
      if (controller.currentTab == 3) _buildlicaiList().paddingHorizontal(30.w),
      SizedBox(
        height: 150.w,
      ),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssetsController>(
      init: AssetsController(),
      id: "assets",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            padding: EdgeInsets.only(left: 0, right: 30.w), // 重写左右内边距
            centerTitle: false, // 不显示标题
            height: 45, // 高度
            titleWidget: <Widget>[
              TextWidget.body(
                '我的资产'.tr,
                size: 32.sp,
                color: !controller.isShowGame ? const Color(0xff303236) : AppTheme.color999,
              ).onTap(() {
                controller.changeShowGame(false);
              }),
              SizedBox(
                width: 60.w,
              ),
              TextWidget.body(
                '游戏'.tr,
                size: 32.sp,
                color: controller.isShowGame ? const Color(0xff303236) : AppTheme.color999,
              ).onTap(() {
                controller.changeShowGame(true);
              }),
            ].toRow(),
            backgroundColor: AppTheme.navBgColor,
            screenAdaptation: true,
            useDefaultBack: false,
          ),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
