import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import 'index.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class OptionBuyPage extends GetView<OptionBuyController> {
  const OptionBuyPage({super.key});

  // 时间 tab 切换
  Widget _buildTimeTab() {
    return <Widget>[
      TDTabBar(
        controller: controller.tabTimeController,
        tabs: controller.tabTimeNames.map((e) => TDTab(text: e)).toList(),
        onTap: (index) {
          controller.onTapTimeTabIndex(index);
        },
        backgroundColor: Colors.transparent,
        indicatorColor: AppTheme.colorfff,
        labelColor: AppTheme.colorfff,
        unselectedLabelColor: AppTheme.color999,
        dividerHeight: 0,
      ),
    ].toStack().height(84.w).backgroundColor(AppTheme.pageBgColor);
  }

  // 折线图
  Widget _buildLineChart() {
    // 显示所有数据，按时间排序
    List<OptionChartModel> chartData = [];
    if (controller.optionChartList.isNotEmpty) {
      chartData = List<OptionChartModel>.from(controller.optionChartList);
      // 按时间戳正序排列，用于绘制折线
      chartData.sort((a, b) => (a.ts ?? 0).compareTo(b.ts ?? 0));
    }

    return Container(
      width: 750.w,
      height: 700.w,
      decoration: BoxDecoration(
        color: AppTheme.pageBgColor,
      ),
      child: chartData.isEmpty
          ? Center(
              child: TextWidget.body(
                '暂无数据'.tr,
                size: 28.sp,
                color: Colors.white54,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: 30.w, top: 30.w),
              child: _buildFlChart(chartData),
            ),
    );
  }

  // 使用fl_chart构建折线图
  Widget _buildFlChart(List<OptionChartModel> chartData) {
    // 转换数据为FlSpot
    List<FlSpot> spots = [];
    for (int i = 0; i < chartData.length; i++) {
      spots.add(FlSpot(i.toDouble(), chartData[i].price ?? 0.0));
    }

    // 计算价格范围
    double maxY = spots.isNotEmpty ? spots.map((e) => e.y).reduce(math.max) : 100;
    double minY = spots.isNotEmpty ? spots.map((e) => e.y).reduce(math.min) : 0;

    // 扩大显示范围，让波动更明显
    double priceRange = maxY - minY;
    double padding = priceRange > 0 ? priceRange * 0.1 : maxY * 0.1;
    maxY = maxY + padding;
    minY = math.max(0, minY - padding);

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        // 线条配置
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true, // 平滑曲线
            color: const Color(0xff0067FF), // 金黄色线条
            barWidth: 1.5, // 更细的线条
            // 填充区域
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff0067FF).withOpacity(0.3),
                  const Color(0xff0067FF).withOpacity(0.05),
                ],
              ),
            ),
            // 数据点配置
            dotData: FlDotData(
              show: chartData.length <= 50,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 1.5, // 更小的圆点
                  color: const Color(0xff0067FF),
                  strokeWidth: 0.5, // 更细的描边
                  strokeColor: AppTheme.color000,
                );
              },
            ),
          ),
        ],
        // 触摸交互配置
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            getTooltipItems: (touchedSpots) {
              return touchedSpots
                  .map((spot) {
                    int idx = spot.spotIndex;
                    if (idx >= 0 && idx < chartData.length) {
                      final data = chartData[idx];
                      final time = DateTime.fromMillisecondsSinceEpoch(data.ts ?? 0);
                      final timeString =
                          '${time.month}-${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
                      final priceString = '${data.price?.toStringAsFixed(3)} USDT';

                      return LineTooltipItem(
                        '$timeString\n$priceString',
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return null;
                  })
                  .where((item) => item != null)
                  .cast<LineTooltipItem>()
                  .toList();
            },
          ),
          // 触摸指示器配置
          getTouchLineStart: (data, index) => 0,
          getTouchLineEnd: (data, index) => double.infinity,
          touchSpotThreshold: 10,
          // 自定义触摸指示器
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                // 垂直线配置
                FlLine(
                  color: const Color(0xff0067FF).withOpacity(0.8),
                  strokeWidth: 1.0, // 更细的触摸线
                ),
                // 圆点配置
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 2.0, // 更小的触摸圆点
                      color: const Color(0xff0067FF),
                      strokeWidth: 1.0,
                      strokeColor: AppTheme.color000,
                    );
                  },
                ),
              );
            }).toList();
          },
          handleBuiltInTouches: true,
        ),
        // 坐标轴配置
        titlesData: FlTitlesData(
          // 左侧Y轴 - 不显示
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          // 右侧Y轴
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 80, // 增加预留空间
              interval: (maxY - minY) / 6, // 设置Y轴标签间隔
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    value.toStringAsFixed(3), // 显示3位小数
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              },
            ),
          ),
          // 底部X轴 - 1分钟间隔
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                int idx = value.round();
                if (idx >= 0 && idx < chartData.length) {
                  final currentTime = DateTime.fromMillisecondsSinceEpoch(chartData[idx].ts ?? 0);

                  // 基于实际时间的1分钟间隔显示，但不显示最后一个时间标签
                  bool shouldShow = false;

                  // 排除最后一个数据点
                  if (idx < chartData.length - 1) {
                    if (chartData.length <= 1) {
                      shouldShow = true;
                    } else {
                      // 获取起始时间
                      final startTime = DateTime.fromMillisecondsSinceEpoch(chartData.first.ts ?? 0);

                      // 计算当前时间距离起始时间的分钟数
                      final diffMinutes = currentTime.difference(startTime).inMinutes;

                      // 每隔1分钟显示一个标签，或者是第一个数据点
                      if (diffMinutes % 1 == 0 || idx == 0) {
                        shouldShow = true;
                      }
                    }
                  }

                  if (shouldShow) {
                    return Text(
                      '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        // 网格配置
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: (maxY - minY) / 6, // 增加网格线密度
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.white12,
              strokeWidth: 0.5,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.white12,
              strokeWidth: 0.3,
            );
          },
        ),
        // 边框配置
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white12,
            width: 1,
          ),
        ),
      ),
    );
  }

  // 功能 tab 切换
  Widget _buildFunctionTab() {
    return <Widget>[
      TDTabBar(
        controller: controller.tabFunctionController,
        tabs: controller.tabFunctionNames.map((e) => TDTab(text: e)).toList(),
        backgroundColor: Colors.transparent,
        labelColor: AppTheme.color000,
        onTap: (index) {
          controller.onTapFunctionTabIndex(index);
        },
      ),
    ].toColumn();
  }

  // 功能 tab 内容1：购买期权
  Widget _buildFunctionTab1() {
    return <Widget>[
      <Widget>[
        <Widget>[
          TextWidget.body(
            '当前'.tr,
            size: 20.sp,
            color: AppTheme.color8B8B8B,
          ),
          TextWidget.body(
            '${controller.currentItem?.beginTimeText}',
            size: 20.sp,
            color: AppTheme.color000,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body(
            '即将交割'.tr,
            size: 20.sp,
            color: AppTheme.color8B8B8B,
          ),
          // 当前期倒计时
          TextWidget.body(
            controller.formatCountdown(controller.currentItem?.lotteryTime ?? 0),
            size: 20.sp,
            color: AppTheme.color000,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      ].toColumn()
      .paddingAll(30.w)
      .backgroundColor(AppTheme.blockBgColor)
      .clipRRect(all: 20.w)
      .marginOnly(bottom: 30.w),
      // 进度对比
      <Widget>[
        // 左边
        <Widget>[]
            .toRow()
            .width(690.w * (controller.item?.trendUp ?? 0) * 100 / 100)
            .backgroundColor(AppTheme.colorGreen)
            .clipRRect(
                topLeft: 20.w,
                bottomLeft: 20.w,
                topRight: (controller.item?.trendUp ?? 0) * 100 == 100 ? 20.w : 0,
                bottomRight: (controller.item?.trendUp ?? 0) * 100 == 100 ? 20.w : 0)
            .positioned(left: 0, top: 0, bottom: 0),
        // 右边
        <Widget>[]
            .toRow()
            .width(690.w * (controller.item?.trendDown ?? 0) * 100 / 100)
            .backgroundColor(AppTheme.colorRed)
            .clipRRect(
                topRight: 20.w,
                bottomRight: 20.w,
                topLeft: (controller.item?.trendDown ?? 0) * 100 == 100 ? 20.w : 0,
                bottomLeft: (controller.item?.trendDown ?? 0) * 100 == 100 ? 20.w : 0)
            .positioned(right: 0, top: 0, bottom: 0),
        TextWidget.body(
          '${((controller.item?.trendUp ?? 0) * 100).toStringAsFixed(1)}%',
          size: 20.sp,
          color: AppTheme.colorfff,
        ).positioned(left: 20.w, top: 8.w, bottom: 0),
        TextWidget.body(
          '${((controller.item?.trendDown ?? 0) * 100).toStringAsFixed(1)}%',
          size: 20.sp,
          color: AppTheme.colorfff,
        ).positioned(right: 20.w, top: 8.w, bottom: 0),
      ].toStack().tight(width: 690.w, height: 40.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 20.w).marginOnly(bottom: 20.w),

      <Widget>[
        TextWidget.body(
          '下期'.tr,
          size: 20.sp,
          color: AppTheme.color8B8B8B,
        ),
        TextWidget.body(
          '${controller.nextItem?.beginTimeText}',
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body(
          '购买中'.tr,
          size: 20.sp,
          color: AppTheme.color8B8B8B,
        ),
        // 下期倒计时
        TextWidget.body(
          controller.formatCountdown(controller.nextItem?.lotteryTime ?? 0),
          size: 20.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),


      // 按钮组
      <Widget>[
        ButtonWidget(
          text: '看多'.tr,
          width: 200,
          height: 64,
          borderRadius: 32,
          backgroundColor: AppTheme.colorGreen,
          textColor: AppTheme.colorfff,
          onTap: () => _showBottomSheet('看多'.tr),
        ),
        ButtonWidget(
          text: '看平'.tr,
          width: 200,
          height: 64,
          borderRadius: 32,
          backgroundColor: AppTheme.color000,
          textColor: AppTheme.colorfff,
          onTap: () => _showBottomSheet('看平'.tr),
        ),
        ButtonWidget(
          text: '看空'.tr,
          width: 200,
          height: 64,
          borderRadius: 32,
          backgroundColor: AppTheme.colorRed,
          textColor: AppTheme.colorfff,
          onTap: () => _showBottomSheet('看空'.tr),
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ].toColumn().paddingAll(30.w).width(690.w)
    .decorated(
      border: Border.all(color: AppTheme.borderLine),
      borderRadius: BorderRadius.circular(16.w),
    )
    .paddingAll(30.w);
  }

  // 底部弹窗
  void _showBottomSheet(String type) {
    // 设置交易类型
    int tradeType = 1; // 默认看多
    if (type == '看多'.tr)
      tradeType = 1;
    else if (type == '看平'.tr)
      tradeType = 2;
    else if (type == '看空'.tr) tradeType = 3;

    controller.setTradeType(tradeType);

    Get.bottomSheet(
      Container(
        height: 900.w,
        decoration: BoxDecoration(
          color: AppTheme.colorfff,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
          ),
        ),
        child: GetBuilder<OptionBuyController>(
          id: "option_buy_bottom",
          builder: (_) {
            return <Widget>[
              // 标题
              <Widget>[
                <Widget>[
                  ButtonWidget(
                    text: controller.getTradeTypeConfig()['typeText'],
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 40,
                    borderRadius: 10,
                    backgroundColor: controller.getTradeTypeConfig()['backgroundColor'],
                    textColor: AppTheme.colorfff,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  TextWidget.body('${'购买'.tr}（${controller.item?.pairTimeName}）${'期权'.tr}', size: 32.sp, weight: FontWeight.bold),
                ].toRow(),
                Icon(Icons.close, size: 40.w).onTap(() {
                  Get.back();
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w),

              // 时间
              <Widget>[
                <Widget>[
                  TextWidget.body(
                    '${controller.currentItem?.beginTimeText}',
                    size: 24.sp,
                    color: AppTheme.color000,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  TextWidget.body(
                    '${controller.currentItem?.statusText}',
                    size: 20.sp,
                    color: AppTheme.colorRed,
                  ),
                ].toRow(),
                TextWidget.body(
                  controller.formatCountdown(controller.currentItem?.lotteryTime ?? 0),
                  size: 24.sp,
                  color: AppTheme.colorRed,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .paddingHorizontal(30.w)
                  .height(70.w)
                  .backgroundColor(const Color(0xffFFF6F6)),

              // 涨幅选择
              TextWidget.body(
                '涨幅选择'.tr,
                size: 24.sp,
                color: AppTheme.color000,
              ).marginOnly(top: 20.w, left: 30.w, bottom: 10.w),
              <Widget>[
                for (var item in controller.getCurrentOddsRangeList())
                  <Widget>[
                    <Widget>[
                      TextWidget.body(
                        controller.getTradeTypeConfig()['direction'],
                        size: 24.sp,
                        color: AppTheme.color000,
                      ),
                      TextWidget.body(
                        controller.tradeType == 2 ? '±${item.range}%' : '≥${item.range}%',
                        size: 24.sp,
                        color: controller.getTradeTypeConfig()['color'],
                      ),
                    ].toRow(mainAxisAlignment: MainAxisAlignment.center),
                    SizedBox(
                      height: 10.w,
                    ),
                    TextWidget.body(
                      '${'收益率'.tr}${((double.tryParse(item.odds?.toString() ?? '0') ?? 0) * 100).toStringAsFixed(0)}%',
                      size: 24.sp,
                      color: AppTheme.color999,
                    ),
                  ]
                      .toColumn()
                      .paddingVertical(10.w)
                      .width(220.w)
                      .decorated(
                        color: AppTheme.blockBgColor,
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(
                          color: controller.selectedOddsUuid == item.uuid ? controller.getTradeTypeConfig()['color'] : AppTheme.borderLine,
                          width: 1,
                        ),
                      )
                      .onTap(() {
                    print('点击选择赔率: UUID=${item.uuid}, 涨幅=${item.range}%, 收益率=${item.odds}');
                    controller.selectOdds(item.uuid);
                  }),
              ].toWrap(spacing: 10.w, runSpacing: 10.w, alignment: WrapAlignment.spaceBetween).paddingHorizontal(30.w),

              // 购买数量
              <Widget>[
                <Widget>[
                  TextWidget.body(
                    '购买数量'.tr,
                    size: 26.sp,
                    color: AppTheme.color000,
                  ),
                  TextWidget.body(
                    '${'余额：'.tr}${controller.optionCoinBalance?.usableBalance}',
                    size: 24.sp,
                    color: AppTheme.color999,
                  ),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),

                <Widget>[
                  InputWidget(
                    placeholder: "请输入购买数量".tr,
                    controller: controller.buyNumberController,
                  ).expanded(),
                  <Widget>[
                    TextWidget.body(
                      controller.selectedCoin,
                      size: 26.sp,
                      color: AppTheme.color000,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 24.sp,
                      color: AppTheme.color8B8B8B,
                    ),
                  ].toRow().onTap(() {
                    controller.showCoinPicker(Get.context!);
                  }),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(88.w).paddingHorizontal(30.w).decorated(
                      color: AppTheme.blockBgColor,
                      borderRadius: BorderRadius.circular(10.w),
                      border: Border.all(
                        color: AppTheme.borderLine,
                        width: 1,
                      ),
                    ),

                // 选择数量区间
                <Widget>[
                  for (var amount in controller.quickAmounts)
                    ButtonWidget(
                      text: amount.toString(),
                      width: 160,
                      height: 68,
                      borderRadius: 10,
                      backgroundColor: AppTheme.blockBgColor,
                      textColor: AppTheme.color000,
                      onTap: () {
                        controller.setQuickAmount(amount);
                      },
                    ),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 20.w, bottom: 40.w),

                SizedBox(
                  height: 80.w,
                ),
                // 预计收益
                TextWidget.body(
                  '${'预计收益：'.tr}${controller.calculateExpectedProfit().toStringAsFixed(2)} ${controller.selectedCoin}',
                  size: 24.sp,
                  color: AppTheme.color000,
                ).marginOnly(bottom: 20.w),
                ButtonWidget(
                  text: '确认购买'.tr,
                  height: 88,
                  borderRadius: 44,
                  backgroundColor: AppTheme.primary,
                  textColor: AppTheme.colorfff,
                  onTap: () {
                    controller.buyOption();
                  },
                ),
              ].toColumn().paddingHorizontal(30.w).marginOnly(bottom: 20.w, top: 20.w),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
          },
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  // 功能 tab 内容2：等待交割
  Widget _buildFunctionTab2() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.deliveryRecordList[index];
          return <Widget>[
            <Widget>[
              TextWidget.body(
                '${item.pairName}-${item.timeName}',
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body(
                item.createdAt ?? '',
                size: 22.sp,
                color: AppTheme.color8B8B8B,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
            <Widget>[
              TextWidget.body(
                '${item.upDown == 1 ? '涨'.tr : item.upDown == 2 ? '跌'.tr : '平'.tr}${item.upDown == 3 ? '±' : '≥'}${item.range}%',
                size: 24.sp,
                color: item.upDown == 1
                    ? AppTheme.colorGreen
                    : item.upDown == 2
                        ? AppTheme.colorRed
                        : AppTheme.colorYellow,
              ),
            ].toColumn().width(220.w),
            <Widget>[
              TextWidget.body(
                '${item.betAmount}(${item.betCoinName})',
                size: 24.sp,
                color: AppTheme.color000,
                textAlign: TextAlign.right,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(220.w),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingVertical(15.w).border(bottom: 1, color: AppTheme.dividerColor);
        },
        childCount: controller.deliveryRecordList.length,
      ),
    );
  }

  // 功能 tab 内容3：我的交割
  Widget _buildFunctionTab3() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.deliveryRecordList[index];
          return <Widget>[
            <Widget>[
              TextWidget.body(
                '${item.pairName}-${item.timeName}',
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body(
                item.createdAt ?? '',
                size: 22.sp,
                color: AppTheme.color8B8B8B,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
            <Widget>[
              TextWidget.body(
                '${item.upDown == 1 ? '涨'.tr : item.upDown == 2 ? '跌'.tr : '平'.tr}${item.upDown == 3 ? '±' : '≥'}${item.range}%',
                size: 24.sp,
                color: item.upDown == 1
                    ? AppTheme.colorGreen
                    : item.upDown == 2
                        ? AppTheme.colorRed
                        : AppTheme.colorYellow,
              ),
            ].toColumn().width(220.w),
            <Widget>[
              TextWidget.body(
                '${item.deliveryAmount}(${item.betCoinName})',
                size: 24.sp,
                color: AppTheme.color000,
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 10.w,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 24.sp,
                color: AppTheme.color8B8B8B,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(220.w),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingVertical(15.w).border(bottom: 1, color: AppTheme.dividerColor).onTap(() {
            Get.toNamed(AppRoutes.optionBuyRecord, arguments: {
              'id': item.orderId,
            });
          });
        },
        childCount: controller.deliveryRecordList.length,
      ),
    );
  }

  // 功能 tab 内容4：交割记录
  Widget _buildFunctionTab4() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.deliveryRecordList[index];
          return <Widget>[
            <Widget>[
              TextWidget.body(
                item.pairTimeName ?? '',
                size: 24.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body(
                item.createdAt ?? '',
                size: 22.sp,
                color: AppTheme.color8B8B8B,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
            <Widget>[
              TextWidget.body(
                '${item.deliveryRange}%',
                size: 24.sp,
                color: AppTheme.colorGreen,
              ),
              SizedBox(
                height: 10.w,
              ),
              TextWidget.body(
                item.deliveryUpDown == 1
                    ? '涨'.tr
                    : item.deliveryUpDown == 2
                        ? '跌'.tr
                        : '平'.tr,
                size: 24.sp,
                color: item.deliveryUpDown == 1
                    ? AppTheme.colorGreen
                    : item.deliveryUpDown == 2
                        ? AppTheme.colorRed
                        : AppTheme.colorYellow,
              ),
            ].toColumn().width(220.w),
            <Widget>[
              TextWidget.body(
                item.endTimeText ?? '',
                size: 24.sp,
                color: AppTheme.color8B8B8B,
                textAlign: TextAlign.right,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(220.w),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingVertical(15.w).border(bottom: 1, color: AppTheme.dividerColor);
        },
        childCount: controller.deliveryRecordList.length,
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(slivers: [
      // _buildTimeTab().sliverToBoxAdapter(),
      _buildLineChart().sliverToBoxAdapter(),
      TDDivider(height: 1, color: AppTheme.dividerColor).sliverToBoxAdapter(),
      _buildFunctionTab().sliverToBoxAdapter(),
      SizedBox(
        height: 20.w,
      ).sliverToBoxAdapter(),
      if (controller.tabFunctionIndex == 0) _buildFunctionTab1().sliverToBoxAdapter(),
      if (controller.tabFunctionIndex == 1)
        <Widget>[
          TextWidget.body(
            '期权'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.left,
          ).width(220.w),
          TextWidget.body(
            '方向'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.center,
          ).width(220.w),
          TextWidget.body(
            '交割数量'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.right,
          ).width(220.w),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.tabFunctionIndex == 2)
        <Widget>[
          TextWidget.body(
            '期权'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.left,
          ).width(220.w),
          TextWidget.body(
            '方向'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.center,
          ).width(220.w),
          TextWidget.body(
            '结算数量'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.right,
          ).width(220.w),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.tabFunctionIndex == 3)
        <Widget>[
          TextWidget.body(
            '期权'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.left,
          ).width(220.w),
          TextWidget.body(
            '交割结果'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.center,
          ).width(220.w),
          TextWidget.body(
            '交割时间'.tr,
            size: 24.sp,
            color: AppTheme.color8B8B8B,
            textAlign: TextAlign.right,
          ).width(220.w),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.tabFunctionIndex == 1) _buildFunctionTab2().sliverPaddingHorizontal(30.w),
      if (controller.tabFunctionIndex == 2) _buildFunctionTab3().sliverPaddingHorizontal(30.w),
      if (controller.tabFunctionIndex == 3) _buildFunctionTab4().sliverPaddingHorizontal(30.w),
      if (controller.deliveryRecordList.isEmpty) const EmptyState().marginOnly(top: 100.w).sliverToBoxAdapter(),
    ]);
  }

  // 币种导航栏
  Widget _buildCoinNav() {
    return <Widget>[
      // 标题
      <Widget>[
        TextWidget.body(
          '期权'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ).width(150.w),
        TextWidget.body(
          '涨跌幅'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ).width(200.w),
        TextWidget.body(
          '距离交割'.tr,
          size: 24.sp,
          color: AppTheme.color999,
          textAlign: TextAlign.right,
        ).width(120.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).height(88.w),

      // 列表
      ListView.builder(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        itemBuilder: (context, index) {
          var item = controller.optionDetailNavList[index];
          return <Widget>[
            <Widget>[
              TextWidget.body(
                item.guessPairsName ?? 'BTC/USDT',
                size: 26.sp,
                color: AppTheme.color000,
              ).marginOnly(top: 15.w, bottom: 30.w),
              for (var value in item.scenePairList ?? [])
                <Widget>[
                  TextWidget.body(
                    (value.pairTimeName ?? '').replaceAll(RegExp(r'/USDT'), ''),
                    size: 26.sp,
                    color: AppTheme.color000,
                  ).width(150.w),
                  TextWidget.body(
                    value.increaseStr,
                    size: 24.sp,
                    color: value.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
                  ).width(200.w),
                  TextWidget.body(
                    controller.formatCountdown(value.lotteryTime ?? 0),
                    size: 24.sp,
                    color: AppTheme.color000,
                    textAlign: TextAlign.right,
                  ).width(120.w),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 15.w).onTap(() {
                  controller.onTapOptionNav(value);
                }),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).border(bottom: 1, color: AppTheme.borderLine).onTap(() {});
        },
        itemCount: controller.optionDetailNavList.length,
      ).expanded()
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OptionBuyController>(
      init: OptionBuyController(),
      id: "option_buy",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          key: _scaffoldKey, // 见下方
          drawer: Drawer(
            child: SafeArea(
              child: _buildCoinNav(),
            ),
          ),
          appBar: TDNavBar(
              centerTitle: false, // 不显示标题
              height: 44, // 高度
              titleWidget: <Widget>[
                // 点击导航弹出自定义内容
                <Widget>[
                  TextWidget.body(
                    controller.item?.pairTimeName ?? '',
                    size: 32.sp,
                    weight: FontWeight.bold,
                    color: AppTheme.color000,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 32,
                    color: AppTheme.color000,
                  ),
                ].toRow().onTap(() {
                  _scaffoldKey.currentState?.openDrawer();
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              backgroundColor: AppTheme.pageBgColor,
              screenAdaptation: true,
              useDefaultBack: false,
              leftBarItems: [
                TDNavBarItem(
                    icon: TDIcons.chevron_left,
                    iconSize: 24,
                    iconColor: AppTheme.color000,
                    action: () {
                      Get.back();
                    }),
              ],
              rightBarItems: [
                TDNavBarItem(
                  iconWidget: ImgWidget(
                    path: Get.isDarkMode ? 'assets/images/coin4.png' : 'assets/images/coin4.png',
                    width: 40.w,
                    height: 40.w,
                  ),
                  action: () {
                    controller.goKLine();
                  },
                ),
              ]),

          body: SmartRefresher(
            controller: controller.refreshController,
            enablePullUp: true, // 启用上拉加载
            onRefresh: controller.onRefresh, // 下拉刷新回调
            onLoading: controller.onLoading, // 上拉加载回调
            footer: const SmartRefresherFooterWidget(), // 底部加载更多组件
            header: const SmartRefresherHeaderWidget(), // 头部刷新组件
            child: _buildView(),
          ),
        );
      },
    );
  }
}
