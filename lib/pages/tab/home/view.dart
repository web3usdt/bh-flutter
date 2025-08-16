import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  // 轮播图
  Widget _buildBanner() {
    return <Widget>[
      SizedBox(
        width:350.w,
        height: 480.w,
        child: CarouselSlider(
          items: controller.bannerList.map((banner) {
            return <Widget>[
              ImgWidget(
                path: banner.imgurl ?? '',
                width: 335.w,
                height: 480.w,
              ).tight(width: 335.w, height: 480.w),
            ].toStack();
          }).toList(),
          options: CarouselOptions(
            scrollDirection: Axis.horizontal, // 垂直方向滚动
            height: 480.w, // 设置高度为文字高度
            viewportFraction: 1.0, // 每个item占满整个viewport
            autoPlay: true, // 自动播放
            autoPlayInterval: const Duration(seconds: 3), // 播放间隔
            autoPlayAnimationDuration: const Duration(milliseconds: 800), // 动画时长
            autoPlayCurve: Curves.easeInOut, // 动画曲线
            pauseAutoPlayOnTouch: true, // 触摸时暂停自动播放
            enableInfiniteScroll: true, // 无限滚动
            onPageChanged: (index, reason) => controller.onPageChanged(index, reason),
          ),
        ),
      ),
      SliderIndicatorWidget(
        length: controller.bannerList.length,
        currentIndex: controller.currentIndex,
        color: Colors.white,
      ).positioned(
        bottom: 30.w,
        left: 0,
        right: 0,
      ),
    ].toStack().height(480.w).clipRRect(all: 20.w);
  }

  // 公告栏
  Widget _buildNotice() {
    return <Widget>[
      <Widget>[
        ImgWidget(
          path: 'assets/images/home21.png',
          width: 36.w,
          height: 36.w,
        ),
        SizedBox(
          width: 20.w,
        ),
        // 可垂直滚动的公告内容
        SizedBox(
          width: 530.w,
          height: 68.w,
          child: CarouselSlider(
            items: controller.noticeList.map((notice) {
              return TextWidget.body(
                notice.title ?? '',
                size: 24.sp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppTheme.colorfff,
              ).onTap(() => controller.goNoticeDetail(notice.id ?? 0));
            }).toList(),
            options: CarouselOptions(
              scrollDirection: Axis.vertical, // 垂直方向滚动
              height: 68.w, // 设置高度为文字高度
              viewportFraction: 1.0, // 每个item占满整个viewport
              autoPlay: true, // 自动播放
              autoPlayInterval: const Duration(seconds: 3), // 播放间隔
              autoPlayAnimationDuration: const Duration(milliseconds: 800), // 动画时长
              autoPlayCurve: Curves.easeInOut, // 动画曲线
              pauseAutoPlayOnTouch: true, // 触摸时暂停自动播放
              enableInfiniteScroll: true, // 无限滚动
            ),
          ),
        ),
        SizedBox(
          width: 40.w,
        ),
        ImgWidget(
          path: 'assets/images/home22.png',
          width: 20.w,
          height: 20.w,
        ).onTap(() => controller.goNoticeList()),
      ].toRow(mainAxisAlignment: MainAxisAlignment.start).paddingHorizontal(20.w).backgroundColor(const Color(0xff303236)).clipRRect(all: 32.w)
    ].toRow().height(64.w);
  }

  // 资产折合
  Widget _buildAssets() {
    return <Widget>[
      <Widget>[
        // 资产折合
        <Widget>[
          <Widget>[
            TextWidget.body(
              '总资产折合(BTC)'.tr,
              size: 24.sp,
              color: AppTheme.color000,
            ),
            SizedBox(
              width: 15.w,
            ),
            ImgWidget(
              path: controller.isShowTotalAssetsBtc ? 'assets/images/home8.png' : 'assets/images/home9.png',
              width: 20.w,
              height: 20.w,
            ).padding(bottom: 10.w),
          ].toRow().onTap(() {
            controller.changeShowTotalAssetsBtc();
          }),
          SizedBox(
            height: 30.w,
          ),
          if (controller.isShowTotalAssetsBtc)
            <Widget>[
              TextWidget.body(
                '${controller.personalAccount.totalAssetsBtc ?? 0}',
                size: 48.sp,
                color: AppTheme.color000,
                weight: FontWeight.bold,
              ),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body(
                '≈ \$${controller.personalAccount.totalAssetsUsd ?? 0} USD',
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
                '≈\$****** USD',
                size: 24.sp,
                color: AppTheme.color8B8B8B,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      SizedBox(
        height: 30.w,
      ),
      // 充值/币币交易
      <Widget>[
        ButtonWidget(
          text: '充值'.tr,
          width: 335,
          height: 64,
          textColor: AppTheme.colorfff,
          backgroundColor: AppTheme.primary,
          borderRadius: 32,
          onTap: () {
            Get.toNamed(AppRoutes.recharge);
          },
        ),
        SizedBox(
          width: 20.w,
        ),
        ButtonWidget(
          text: '提币'.tr,
          width: 335,
          height: 64,
          textColor: AppTheme.color000,
          backgroundColor: AppTheme.blockBgColor,
          borderRadius: 32,
          showBorder: true,
          onTap: () {
            Get.toNamed(AppRoutes.withdraw);
          },
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      // 申购、提币、推广
      // <Widget>[
      //   <Widget>[
      //     ImgWidget(
      //       path: 'assets/images/home5.png',
      //       width: 46.w,
      //       height: 46.w,
      //     ),
      //     SizedBox(
      //       height: 18.w,
      //     ),
      //     TextWidget.body(
      //       'IDO',
      //       size: 26.sp,
      //       color: AppTheme.color000,
      //     ),
      //   ].toColumn().onTap(() => Get.toNamed(AppRoutes.subscribe)),
      //   <Widget>[
      //     ImgWidget(
      //       path: 'assets/images/home6.png',
      //       width: 46.w,
      //       height: 46.w,
      //     ),
      //     SizedBox(
      //       height: 18.w,
      //     ),
      //     TextWidget.body(
      //       '提币'.tr,
      //       size: 26.sp,
      //       color: AppTheme.color000,
      //     ),
      //   ].toColumn().onTap(() => Get.toNamed(AppRoutes.withdraw)),
      //   <Widget>[
      //     ImgWidget(
      //       path: 'assets/images/home7.png',
      //       width: 46.w,
      //       height: 46.w,
      //     ),
      //     SizedBox(
      //       height: 18.w,
      //     ),
      //     TextWidget.body(
      //       '推广'.tr,
      //       size: 26.sp,
      //       color: AppTheme.color000,
      //     ),
      //   ].toColumn().onTap(() {
      //     Get.toNamed(AppRoutes.share);
      //   }),
      // ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(horizontal: 60.w),
    ].toColumn();
  }

  // 推广助力
  Widget _buildPromote() {
    return <Widget>[
      <Widget>[
        _buildBanner(),
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .tight(width: 335.w, height: 480.w)
          .decorated(
            border: Border.all(width: 1, color: AppTheme.borderLine),
            borderRadius: BorderRadius.circular(15.w),
          )
          .onTap(() => Get.toNamed(AppRoutes.share)),
      <Widget>[
        <Widget>[
          <Widget>[
            TextWidget.body('IDO', size: 24.sp, color: AppTheme.color8D9094),
            SizedBox(
              height: 12.w,
            ),
            <Widget>[
              ImgWidget(
                path: 'assets/images/home19.png',
                width: 40.w,
                height: 40.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              TextWidget.body('发行价'.tr, size: 24.sp, color: AppTheme.color000),
            ].toRow(),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          <Widget>[
            TextWidget.body('1${controller.selectedSubscribe?.coinName ?? ''}', size: 28.sp, color: AppTheme.color000, weight: FontWeight.bold),
            SizedBox(
              height: 10.w,
            ),
            TextWidget.body('≈${controller.selectedSubscribe?.issuePrice ?? '0'}USDT', size: 24.sp, color: AppTheme.color8D9094),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingAll(20.w)
            .tight(width: 335.w, height: 264.w)
            .decorated(
              border: Border.all(width: 1, color: AppTheme.borderLine),
              borderRadius: BorderRadius.circular(15.w),
            )
            .onTap(() => Get.toNamed(AppRoutes.subscribe)),
        SizedBox(
          height: 20.w,
        ),
        <Widget>[
          ImgWidget(
            path: 'assets/images/home20.png',
            width: 48.w,
            height: 48.w,
          ),
          TextWidget.body('推广助力'.tr, size: 26.sp, color: AppTheme.color000),
          TextWidget.body('邀请好友一起赚收益'.tr, size: 24.sp, color: AppTheme.color8D9094),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingAll(20.w)
            .tight(width: 335.w, height: 196.w)
            .decorated(
              border: Border.all(width: 1, color: AppTheme.borderLine),
              borderRadius: BorderRadius.circular(15.w),
            )
            .onTap(() => Get.toNamed(AppRoutes.share)),
      ].toColumn(),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  // 资产曲线图
  Widget _buildAssetsCurve() {
    return <Widget>[
      // 循环判断
      for (var item in controller.filteredMarketInfoList)
        <Widget>[
          <Widget>[
            TextWidget.body(
              '${item.pairName}',
              size: 18.sp,
              color: AppTheme.color8B8B8B,
              textAlign: TextAlign.center,
            ),
            if (item.pairName == 'BB/USDT')
              <Widget>[
                SizedBox(
                  width: 5.w,
                ),
                <Widget>[
                  TextWidget.body(
                    '平台币'.tr,
                    size: 12.sp,
                    weight: FontWeight.w900,
                    color: AppTheme.color000,
                    textAlign: TextAlign.center,
                  )
                      .padding(horizontal: 8.w, vertical: 4.w)
                      .backgroundColor(Color(0xffA7F757))
                      .clipRRect(topLeft: 10.w, topRight: 10.w, bottomLeft: 0, bottomRight: 10.w),
                  SizedBox(
                    height: 10.w,
                  )
                ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              ].toRow()
          ].toRow(mainAxisAlignment: MainAxisAlignment.start),
          SizedBox(
            height: 18.w,
          ),
          TextWidget.body(
            '${item.close}',
            size: 26.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            height: 10.w,
          ),
          // 曲线图
          buildLineChart(Get.context!, item.prices ?? [], item.increaseStr ?? ''),
          SizedBox(
            height: 10.w,
          ),
          TextWidget.body(
            '${item.increaseStr}',
            size: 24.sp,
            color: item.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
          ),
        ]
            .toColumn(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start)
            .width(200.w)
            .onTap(() => controller.goKLine(item.pairName ?? '')),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center)
        .paddingHorizontal(30.w)
        .tight(width: 690.w, height: 255.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(16.w));
  }

  // 资产曲线图方法，参考CoinPage
  Widget buildLineChart(BuildContext context, List<dynamic> prices, String increaseStr) {
    List<FlSpot> spots = [];
    for (int i = 0; i < prices.length; i++) {
      final price = prices[i];
      if (price is num) {
        spots.add(FlSpot(i.toDouble(), price.toDouble()));
      }
    }
    double minY = spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) : 0;
    double maxY = spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 100;
    if ((maxY - minY).abs() < 1e-8) {
      minY = minY * 0.9;
      maxY = maxY * 1.1;
    } else {
      double padding = (maxY - minY) * 0.2;
      minY = minY - padding;
      maxY = maxY + padding;
    }
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 0, bottom: 0),
      width: 200.w,
      height: 80.w,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: increaseStr.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                color: increaseStr.startsWith('-') == true ? AppTheme.colorRed.withOpacity(0.2) : AppTheme.colorGreen.withOpacity(0.2),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
          lineTouchData: const LineTouchData(
            enabled: false,
          ),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // 币币行情
  Widget _buildCoinMarket() {
    return <Widget>[
      // 标题
      TextWidget.body(
        '24h涨幅榜'.tr,
        size: 28.sp,
        color: AppTheme.color000,
      ),

      // tab
      <Widget>[
        TextWidget.body(
          '交易对'.tr,
          size: 18.sp,
          color: AppTheme.color8B8B8B,
        ),
        <Widget>[
          TextWidget.body(
            '最新价'.tr,
            size: 18.sp,
            color: AppTheme.color8B8B8B,
          ),
          SizedBox(
            width: 30.w,
          ),
          TextWidget.body(
            '今日涨跌幅'.tr,
            size: 18.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.right,
          ).width(150.w),
        ].toRow(),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .height(80.w)
          // .paddingHorizontal(30.w)
          // .backgroundColor(AppTheme.blockTwoBgColor)
          .clipRRect(all: 16.w),

      // 列表
      for (var item in controller.allUsdtMarketList())
        <Widget>[
          <Widget>[
            ImgWidget(
              path: item.coinIcon ?? '',
              width: 44.w,
              height: 44.w,
              radius: 22.w,
            ),
            SizedBox(
              width: 20.w,
            ),
            <Widget>[
              <Widget>[
                TextWidget.body(
                  '${item.pairName}',
                  size: 20.sp,
                  color: AppTheme.color8B8B8B,
                ),
                if (item.pairName == 'BB/USDT')
                  <Widget>[
                    SizedBox(
                      width: 5.w,
                    ),
                    <Widget>[
                      TextWidget.body(
                        '平台币'.tr,
                        size: 12.sp,
                        weight: FontWeight.w900,
                        color: AppTheme.color000,
                        textAlign: TextAlign.center,
                      )
                          .padding(horizontal: 8.w, vertical: 4.w)
                          .backgroundColor(Color(0xffA7F757))
                          .clipRRect(topLeft: 10.w, topRight: 10.w, bottomLeft: 0, bottomRight: 10.w),
                      SizedBox(
                        height: 10.w,
                      )
                    ].toColumn()
                  ].toRow()
              ].toRow(mainAxisAlignment: MainAxisAlignment.start),
              TextWidget.body(
                '24H量'.tr,
                size: 16.sp,
                color: AppTheme.color8B8B8B,
              ),
              TextWidget.body(
                '${item.vol}',
                size: 16.sp,
                color: AppTheme.color8B8B8B,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center)
          ].toRow(),
          <Widget>[
            TextWidget.body(
              '${item.close}',
              size: 20.sp,
              color: AppTheme.color000,
            ),
            SizedBox(
              width: 40.w,
            ),
            <Widget>[
              <Widget>[
                TextWidget.body(
                  '${item.increaseStr}',
                  size: 20.sp,
                  color: AppTheme.colorfff,
                  textAlign: TextAlign.right,
                ),
              ]
                  .toRow()
                  .paddingHorizontal(15.w)
                  .tight(height: 44.w)
                  .backgroundColor(item.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen)
                  .clipRRect(all: 10.w)
            ].toRow(mainAxisAlignment: MainAxisAlignment.end).width(150.w)
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .height(128.w)
            // .border(bottom: 1, color: AppTheme.dividerColor)
            .onTap(() => controller.goKLine(item.pairName ?? '')),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingOnly(left: 30.w, right: 30.w, top: 40.w, bottom: 30.w)
        .clipRRect(topLeft: 30.w, topRight: 30.w);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(
        height: 40.w,
      ),
      _buildAssets().paddingHorizontal(30.w),
      SizedBox(
        height: 60.w,
      ),
      _buildPromote().paddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ),
      _buildNotice().paddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ),
      _buildAssetsCurve().paddingHorizontal(30.w),
      _buildCoinMarket(),
      const SizedBox(
        height: 150,
      ),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            padding: EdgeInsets.only(left: 0, right: 0.w), // 重写左右内边距
            centerTitle: false, // 不显示标题
            height: 44, // 高度
            titleWidget: <Widget>[
              ImgWidget(
                // 左图
                path: 'assets/icons/ic_logo.png',
                width: 48.w,
                height: 48.w,
                radius: 24.w,
              ),
              // TextWidget.body(
              //   controller.userInfo.getAccountDisplay(),
              //   size: 28.sp,
              // ),
              <Widget>[
                <Widget>[
                  <Widget>[].toRow().tight(width: 12.w, height: 12.w).backgroundColor(AppTheme.colorGreen).clipRRect(all: 12.w),
                  SizedBox(
                    width: 10.w,
                  ),
                  TextWidget.body(
                    ConfigService.to.curEnv.value.name,
                    size: 24.sp,
                  ),
                ].toRow().paddingHorizontal(20.w).tight(height: 48.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 30.w),
                SizedBox(
                  width: 20.w,
                ),
                ImgWidget(
                  path: 'assets/images/home23.png',
                  width: 36.w,
                  height: 36.w,
                ),
              ].toRow()
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).onTap(() => Get.toNamed(AppRoutes.userinfo)),
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
