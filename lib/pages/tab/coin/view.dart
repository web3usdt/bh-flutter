import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'index.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CoinPage extends GetView<CoinController> {
  const CoinPage({super.key});

  // 左上：买入卖出 切换
  Widget _buildLeftBuySellDropdown() {
    return <Widget>[
      ButtonWidget(
        text: '买入'.tr,
        width: 165,
        height: 72,
        borderRadius: 10,
        backgroundColor: controller.buySellStatus == 1 ? AppTheme.colorGreen : Colors.transparent,
        showBorder: true,
        borderColor: controller.buySellStatus == 1 ? AppTheme.colorGreen : AppTheme.color000,
        textColor: controller.buySellStatus == 1 ? Colors.white : AppTheme.color000,
        onTap: () {
          controller.changeBuySellStatus(1);
        },
      ),
      ButtonWidget(
        text: '卖出'.tr,
        width: 165,
        height: 72,
        borderRadius: 10,
        backgroundColor: controller.buySellStatus == 2 ? AppTheme.colorRed : Colors.transparent,
        showBorder: true,
        borderColor: controller.buySellStatus == 2 ? AppTheme.colorRed : AppTheme.color000,
        textColor: controller.buySellStatus == 2 ? Colors.white : AppTheme.color000,
        onTap: () {
          controller.changeBuySellStatus(2);
        },
      ),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w);
  }

  // 左上：限价、市价切换
  Widget _buildLeftOrderTypeDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: controller.selectedOrderType,
        items: controller.orderTypes
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: TextWidget.body(
                    item,
                    size: 24.sp,
                    color: AppTheme.color000,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          controller.changeOrderType(value!);
        },
        buttonStyleData: ButtonStyleData(
          height: 40.w, // 高度和你的红框一致
          width: double.infinity, // 宽度自适应父容器
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          iconSize: 30.sp,
        ),
        dropdownStyleData: DropdownStyleData(
          width: null, // 跟随按钮宽度
          decoration: BoxDecoration(
            color: AppTheme.dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
          offset: const Offset(0, 0), // 默认正下方弹出
        ),
      ),
    );
  }

  // 左上：金额、单位切换，只有买入时才显示
  Widget _buildLeftAmountUnit() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: controller.selectedAmountUnit,
        items: controller.amountUnits
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: TextWidget.body(
                    item,
                    size: 24.sp,
                    color: AppTheme.color000,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          controller.changeAmountUnit(value!);
        },
        buttonStyleData: ButtonStyleData(
          height: 40.w, // 高度和你的红框一致
          width: double.infinity, // 宽度自适应父容器
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          iconSize: 30.sp,
        ),
        dropdownStyleData: DropdownStyleData(
          width: null, // 跟随按钮宽度
          decoration: BoxDecoration(
            color: AppTheme.dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
          offset: const Offset(0, 0), // 默认正下方弹出
        ),
      ),
    );
  }

  // 左上：在最佳市场价格成交 提示
  Widget _buildLeftBestMarketPriceTip() {
    return <Widget>[
      TextWidget.body(
        '在最佳市场价格成交'.tr,
        size: 22.sp,
        color: AppTheme.color999,
      ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.center)
        .tight(width: 340.w, height: 80.w)
        .paddingHorizontal(20.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w));
  }

  // 左上：限价进步器
  Widget _buildLeftQuantity() {
    return <Widget>[
      <Widget>[
        // 减号
        Icon(
          Icons.remove,
          size: 30.sp,
          color: AppTheme.color000,
        ).onTap(() {
          controller.onLimitPriceStep('-');
        }),
        // 数量
        InputWidget(
          placeholder: "",
          controller: controller.limitPriceController,
          cleanable: false,
          textAlign: TextAlign.center,
          padding: const EdgeInsets.only(left: 0, right: 0),
          onChanged: (val) {
            controller.onLimitPriceChange(val);
          },
        ).expanded(),
        // 加号
        Icon(
          Icons.add,
          size: 30.sp,
          color: AppTheme.color000,
        ).onTap(() {
          controller.onLimitPriceStep('+');
        }),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .tight(width: 340.w, height: 80.w)
          .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
          .marginOnly(top: 20.w, bottom: 20.w),
      TextWidget.body(
        '≈${controller.customTotal}',
        size: 22.sp,
        color: AppTheme.color999,
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w);
  }

  // 左上：数量输入框
  Widget _buildLeftQuantityInput() {
    return <Widget>[
      <Widget>[
        InputWidget(
          placeholder: "请输入数量".tr,
          controller: controller.amountController,
          cleanable: false,
          onChanged: (val) {
            controller.onAmountChange(val);
          },
        ).expanded(),
        // 单位
        if (controller.buySellStatus == 1)
          <Widget>[
            if (controller.selectedAmountUnit == '金额'.tr)
              TextWidget.body(
                controller.pairName.split('/').last,
                size: 22.sp,
                color: AppTheme.color000,
              ),
            if (controller.selectedAmountUnit != '金额'.tr)
              TextWidget.body(
                controller.pairName.split('/').first,
                size: 22.sp,
                color: AppTheme.color999,
              ),
          ].toRow(),
        if (controller.buySellStatus == 2)
          <Widget>[
            TextWidget.body(
              controller.pairName.split('/').first,
              size: 22.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
      ]
          .toRow()
          .tight(width: 340.w, height: 80.w)
          .paddingHorizontal(20.w)
          .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
          .marginOnly(bottom: 20.w),

      <Widget>[
        TextWidget.body(
          '可用'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        // 买入单位：目标币种余额
        if (controller.buySellStatus == 1)
          TextWidget.body(
            '${controller.targetCoinBalance?.usableBalance ?? '--'}${controller.targetCoinBalance?.coinName}',
            size: 18.sp,
            color: AppTheme.color999,
          ),
        // 卖出单位：当前币种余额
        if (controller.buySellStatus == 2)
          TextWidget.body(
            '${controller.currentCoinBalance?.usableBalance ?? '--'}${controller.coinName}',
            size: 18.sp,
            color: AppTheme.color999,
          ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),

      // 百分比
      <Widget>[
        ButtonWidget(
          text: '25%',
          height: 44,
          borderRadius: 6,
          backgroundColor: controller.percent == 25 ? AppTheme.color000 : Colors.transparent,
          textColor: controller.percent == 25 ? Colors.white : AppTheme.color999,
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          showBorder: true,
          borderColor: controller.percent == 25 ? AppTheme.color000 : AppTheme.color999,
          onTap: () {
            controller.onPercentChange(25);
          },
        ),
        ButtonWidget(
          text: '50%',
          height: 44,
          borderRadius: 6,
          backgroundColor: controller.percent == 50 ? AppTheme.color000 : Colors.transparent,
          textColor: controller.percent == 50 ? Colors.white : AppTheme.color999,
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          showBorder: true,
          borderColor: controller.percent == 50 ? AppTheme.color000 : AppTheme.color999,
          onTap: () {
            controller.onPercentChange(50);
          },
        ),
        ButtonWidget(
          text: '75%',
          height: 44,
          borderRadius: 6,
          backgroundColor: controller.percent == 75 ? AppTheme.color000 : Colors.transparent,
          textColor: controller.percent == 75 ? Colors.white : AppTheme.color999,
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          showBorder: true,
          borderColor: controller.percent == 75 ? AppTheme.color000 : AppTheme.color999,
          onTap: () {
            controller.onPercentChange(75);
          },
        ),
        ButtonWidget(
          text: '100%',
          height: 44,
          borderRadius: 6,
          backgroundColor: controller.percent == 100 ? AppTheme.color000 : Colors.transparent,
          textColor: controller.percent == 100 ? Colors.white : AppTheme.color999,
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          showBorder: true,
          borderColor: controller.percent == 100 ? AppTheme.color000 : AppTheme.color999,
          onTap: () {
            controller.onPercentChange(100);
          },
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      // 总值
      <Widget>[
        TextWidget.body(
          '总值'.tr,
          size: 24.sp,
          color: AppTheme.color000,
        ),
        if (controller.buySellStatus == 1 && controller.selectedAmountUnit != '金额'.tr)
          TextWidget.body(
            '${controller.total}${controller.pairName.split('/').last}',
            size: 22.sp,
            color: AppTheme.color999,
          ),
        if (controller.buySellStatus == 2)
          TextWidget.body(
            '${controller.total}${controller.pairName.split('/').last}',
            size: 22.sp,
            color: AppTheme.color999,
          ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(top: 20.w, bottom: 20.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  // 左上：确定按钮
  Widget _buildLeftConfirm() {
    return ButtonWidget(
      text: controller.buySellStatus == 1 ? '买入'.tr : '卖出'.tr,
      height: 80,
      borderRadius: 10,
      backgroundColor: controller.buySellStatus == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
      textColor: Colors.white,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      onTap: () {
        controller.onStoreEntrust();
      },
    );
  }

  // 左上：曲线图
  Widget _buildLeftCurve() {
    return <Widget>[
      TextWidget.body(
        '${controller.pairName}分时图'.tr,
        size: 20.sp,
        color: AppTheme.color000,
      ),
      buildLineChart(Get.context!, controller.tradeList ?? []),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).clipRRect(all: 20.w).marginOnly(top: 20.w)
    .onTap(() {
      controller.goKLine();
    });
  }

  Widget buildLineChart(BuildContext context, List<TradeList> tradeList) {
    // 确定1分钟的时间范围：当前时间往前推1分钟
    int now = DateTime.now().millisecondsSinceEpoch;
    int oneMinuteAgo = now - 60 * 1000;

    // 获取1分钟内的数据
    List<TradeList> lastMinuteList = tradeList.where((item) => (item.ts ?? 0) >= oneMinuteAgo).toList();
    lastMinuteList.sort((a, b) => (a.ts ?? 0).compareTo(b.ts ?? 0));

    // 使用真实的时间戳作为X轴坐标
    List<FlSpot> spots = [];
    for (var item in lastMinuteList) {
      final price = item.price;
      final ts = item.ts;
      if (price != null && ts != null) {
        // 将时间戳转换为相对于开始时间的秒数，用于X轴显示
        double xValue = (ts - oneMinuteAgo) / 1000.0; // 转换为秒数
        spots.add(FlSpot(xValue, price.toDouble()));
      }
    }

    if (spots.isEmpty) {
      return Container(
        width: 690.w,
        height: 250.w,
        alignment: Alignment.center,
        child: Text('暂无数据'.tr, style: TextStyle(color: Colors.grey)),
      );
    }

    // 计算Y轴范围，针对小数值优化
    double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    double range = maxY - minY;
    if (range.abs() < 1e-10) {
      // 如果所有数据几乎相同，创建一个小范围来显示
      double center = (minY + maxY) / 2;
      double artificialRange = center * 0.001; // 0.1%的范围
      if (artificialRange.abs() < 1e-10) artificialRange = 1e-6; // 最小范围
      minY = center - artificialRange;
      maxY = center + artificialRange;
    } else {
      // 对于有波动的数据，根据数值大小调整padding
      double padding;
      if (maxY < 1e-6) {
        // 极小数值，使用较大的padding比例
        padding = range * 0.5;
      } else if (maxY < 1e-3) {
        // 小数值，使用中等padding比例
        padding = range * 0.3;
      } else {
        // 正常数值，使用小padding比例
        padding = range * 0.1;
      }
      minY = minY - padding;
      maxY = maxY + padding;
    }

    // 格式化开始和结束时间
    String startTimeStr = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(oneMinuteAgo));
    String endTimeStr = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(now));

    // 动态计算Y轴标签所需宽度
    double calculateReservedSize(double maxValue) {
      double absMaxValue = maxValue.abs();

      if (absMaxValue < 0.0001) {
        return 15; // 只显示"0"，最小宽度
      } else if (absMaxValue >= 1000000000) {
        return 40; // "1.2B" 格式
      } else if (absMaxValue >= 1000000) {
        return 35; // "1.2M" 格式
      } else if (absMaxValue >= 1000) {
        return 35; // "1.2K" 格式
      } else if (absMaxValue >= 100) {
        return 40; // "123.5" 格式
      } else if (absMaxValue >= 1) {
        return 45; // "12.34" 格式
      } else if (absMaxValue >= 0.001) {
        return 50; // "0.1234" 格式
      } else {
        return 55; // "0.123456" 格式
      }
    }

    double reservedSize = calculateReservedSize(maxY);

    return Container(
      padding: EdgeInsets.only(left: 30.w, right: 20.w, top: 0, bottom: 0),
      width: 690.w,
      height: 250.w,
      child: LineChart(
        LineChartData(
          minX: 0, // X轴从0秒开始
          maxX: 60, // X轴到60秒结束（1分钟）
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.2),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: false,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  // 计算实际时间戳
                  int actualTs = oneMinuteAgo + (barSpot.x * 1000).round();
                  String timeStr = DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(actualTs));
                  return LineTooltipItem(
                    '$timeStr\n${barSpot.y.toStringAsFixed(4)}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: reservedSize, // 动态调整预留空间
                interval: (maxY - minY) / 4,
                getTitlesWidget: (value, meta) {
                  // 格式化价格显示
                  String formatPrice(double price) {
                    // 处理负数
                    bool isNegative = price < 0;
                    double absPrice = price.abs();

                    // 极小数值显示为0
                    if (absPrice < 0.0001) {
                      return '0';
                    }

                    String result;
                    // 大数值简化显示
                    if (absPrice >= 1000000000) {
                      result = '${(absPrice / 1000000000).toStringAsFixed(1)}B';
                    } else if (absPrice >= 1000000) {
                      result = '${(absPrice / 1000000).toStringAsFixed(1)}M';
                    } else if (absPrice >= 1000) {
                      result = '${(absPrice / 1000).toStringAsFixed(1)}K';
                    } else if (absPrice >= 100) {
                      result = absPrice.toStringAsFixed(1); // 减少小数位
                    } else if (absPrice >= 1) {
                      result = absPrice.toStringAsFixed(2); // 减少小数位
                    } else if (absPrice >= 0.001) {
                      result = absPrice.toStringAsFixed(4); // 减少小数位
                    } else {
                      result = absPrice.toStringAsFixed(6); // 减少小数位
                    }

                    return isNegative ? '-$result' : result;
                  }

                  return Container(
                    width: reservedSize - 5, // 动态宽度，留5px边距
                    child: Text(
                      formatPrice(value),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp, // 稍微减小字体
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis, // 防止溢出
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 60, // 每60秒显示一个标签
                getTitlesWidget: (value, meta) {
                  // 在开始位置显示开始时间，在结束位置显示结束时间
                  if (value == 0) {
                    return Text(
                      startTimeStr,
                      style: const TextStyle(color: Colors.black, fontSize: 11),
                    );
                  } else if (value == 60) {
                    return Text(
                      endTimeStr,
                      style: const TextStyle(color: Colors.black, fontSize: 11),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 0.5,
              );
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // 左边
  Widget _buildLeft() {
    return GetBuilder<CoinController>(
        id: "buildLeft",
        builder: (_) {
          return <Widget>[
            // 买入、卖出
            _buildLeftBuySellDropdown(),

            // 限价、市价
            _buildLeftOrderTypeDropdown(),

            // 限价进步器,只有限价时才显示
            if (controller.selectedOrderType == '限价'.tr) _buildLeftQuantity(),

            // 金额、单位切换，只有买入，并且是市价时才显示
            if (controller.buySellStatus == 1 && controller.selectedOrderType == '市价'.tr) _buildLeftAmountUnit().marginOnly(top: 20.w),

            // 在最佳市场价格成交 提示
            if (controller.selectedOrderType == '市价'.tr) _buildLeftBestMarketPriceTip().marginOnly(top: 20.w, bottom: 20.w),

            // 数量输入框
            _buildLeftQuantityInput(),

            // 确定按钮
            _buildLeftConfirm(),

            // 曲线图
            _buildLeftCurve(),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(340.w);
        });
  }

  // 右上
  Widget _buildRight() {
    final displaySellList = controller.sellList?.take(8).toList() ?? [];
    final displayBuyList = controller.buyList?.take(8).toList() ?? [];
    final maxAmount = controller.getDepthMaxAmountForDisplay(max: 8);

    return GetBuilder<CoinController>(
      id: "buildRight",
      builder: (_) {
        return <Widget>[
          // 标题
          <Widget>[
            TextWidget.body(
              '价格'.tr,
              size: 22.sp,
              color: AppTheme.color999,
            ),
            TextWidget.body(
              '数量'.tr,
              size: 22.sp,
              color: AppTheme.color999,
            ),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          SizedBox(
            height: 20.w,
          ),
          // 红色背景
          for (var item in displaySellList)
            <Widget>[
              Builder(
                builder: (context) {
                  double amount = double.tryParse(item.amount ?? '0') ?? 0;
                  double percent = maxAmount > 0 ? (amount / maxAmount) : 0;
                  return Container(
                    width: 350.w * percent, // 100.w为最大宽度
                    height: 40.w,
                    color: const Color(0xffFDEBEB),
                  ).positioned(right: 0);
                },
              ),
              // 如果item.price>100 保留2位小数，不四舍五入
              // 如果item.price>1&&item.price<100  保留4位小数，不四舍五入
              // 如果item.price<1 保留10位小数，不四舍五入
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 100)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 2), size: 20.sp, color: AppTheme.colorRed).positioned(left: 0, top: 5.w),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 1 && double.parse(item.price ?? '0') < 100)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 4), size: 20.sp, color: AppTheme.colorRed).positioned(left: 0, top: 5.w),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') < 1)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 10), size: 20.sp, color: AppTheme.colorRed).positioned(left: 0, top: 5.w),
              TextWidget.body(MathUtils.omitTo(item.amount ?? '0', 2), size: 20.sp, color: AppTheme.color000).positioned(right: 0, top: 5.w),
            ].toStack().tight(height: 40.w).marginOnly(bottom: 10.w).onTap(() {
              controller.onTapDepth(item);
            }),

          // 当前价
          <Widget>[
            if (controller.latestPrice.isNotEmpty)
              TextWidget.body(
                controller.latestPrice,
                size: 28.sp,
                color: controller.buySellStatus == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
              )
            else
              TextWidget.body(
                controller.buySellStatus == 1 ? controller.buyPrice : controller.sellPrice,
                size: 24.sp,
                color: controller.buySellStatus == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
              ),
            SizedBox(
              height: 5.w,
            ),
            TextWidget.body(
              '≈${controller.depthTotal}',
              size: 18.sp,
              color: AppTheme.color000,
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(330.w).marginOnly(top: 10.w, bottom: 20.w),

          // 绿色背景
          for (var item in displayBuyList)
            <Widget>[
              Builder(
                builder: (context) {
                  double amount = double.tryParse(item.amount ?? '0') ?? 0;
                  double percent = maxAmount > 0 ? (amount / maxAmount) : 0;
                  return Container(
                    width: 350.w * percent, // 100.w为最大宽度
                    height: 40.w,
                    color: const Color(0xffEAF8F0),
                  ).positioned(right: 0);
                },
              ),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 100)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 2), size: 20.sp, color: AppTheme.colorGreen).positioned(left: 0, top: 5.w),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 1 && double.parse(item.price ?? '0') < 100)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 4), size: 20.sp, color: AppTheme.colorGreen).positioned(left: 0, top: 5.w),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') < 1)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 10), size: 20.sp, color: AppTheme.colorGreen).positioned(left: 0, top: 5.w),
              TextWidget.body(MathUtils.omitTo(item.amount ?? '0', 2), size: 20.sp, color: AppTheme.color000).positioned(right: 0, top: 5.w),
            ].toStack().tight(height: 40.w).marginOnly(bottom: 10.w).onTap(() {
              controller.onTapDepth(item);
            }),
        ].toColumn().width(330.w);
      },
    );
  }

  // 顶部
  Widget _buildTop() {
    return <Widget>[
      _buildLeft(),
      SizedBox(
        width: 20.w,
      ),
      _buildRight(),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  // 委托记录
  Widget _buildRecord() {
    return <Widget>[
      <Widget>[].toRow().tight(width: 750.w, height: 20.w).backgroundColor(AppTheme.dividerColor),
      SizedBox(
        height: 30.w,
      ),
      <Widget>[
        TextWidget.body(
          '当前委托'.tr,
          size: 28.sp,
          color: AppTheme.color000,
          weight: FontWeight.bold,
        ),
        <Widget>[
          TextWidget.body(
            '查看全部'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 22.sp,
            color: AppTheme.color999,
          ),
        ].toRow().onTap(() {
          controller.goMyAuthorizePage();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w),
      SizedBox(
        height: 30.w,
      ),
      if (controller.currentAuthorizeItems.isEmpty) EmptyState().marginOnly(top: 100.w, bottom: 100.w),
      for (var item in controller.currentAuthorizeItems)
        <Widget>[
          <Widget>[
            <Widget>[
              ImgWidget(
                path: item.entrustType == 1 ? 'assets/images/coin5.png' : 'assets/images/coin6.png',
                width: 38.w,
                height: 38.w,
              ),
              SizedBox(
                width: 16.w,
              ),
              TextWidget.body(
                item.symbol ?? '',
                size: 22.sp,
                color: AppTheme.color000,
              ),
              SizedBox(
                width: 16.w,
              ),
              ButtonWidget(
                text: item.entrustType == 1 ? '买入'.tr : '卖出'.tr,
                height: 38,
                borderRadius: 10,
                backgroundColor: item.entrustType == 1 ? const Color(0xffE5F7FF) : const Color(0xffFDEBEB),
                textColor: item.entrustType == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
              ),
            ].toRow(),
            SizedBox(
              width: 16.w,
            ),
            TextWidget.body(
              item.statusText ?? '---',
              size: 24.sp,
              color: item.status == 1 ? AppTheme.colorRed : AppTheme.colorGreen,
            ),
            ButtonWidget(
              text: '撤销'.tr,
              height: 48,
              borderRadius: 10,
              backgroundColor: AppTheme.colorRed,
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              onTap: () {
                controller.onCancel(item);
              },
            ),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          SizedBox(
            height: 20.w,
          ),
          TextWidget.body(
            item.createdAt ?? '',
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 20.w,
          ),
          <Widget>[
            <Widget>[
              TextWidget.body(
                '委托价'.tr,
                size: 22.sp,
                color: AppTheme.color999,
              ),
              SizedBox(
                height: 14.w,
              ),
              TextWidget.body(
                item.entrustPrice ?? '-',
                size: 22.sp,
                color: AppTheme.color000,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
            <Widget>[
              TextWidget.body(
                '数量'.tr,
                size: 22.sp,
                color: AppTheme.color999,
              ),
              SizedBox(
                height: 14.w,
              ),
              TextWidget.body(
                item.amount.toString(),
                size: 24.sp,
                color: AppTheme.color000,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(220.w),
            <Widget>[
              TextWidget.body(
                '类型'.tr,
                size: 22.sp,
                color: AppTheme.color999,
              ),
              SizedBox(
                height: 14.w,
              ),
              TextWidget.body(
                item.type == 1 ? '限价交易' : (item.type == 2 ? '市价交易' : '-'),
                size: 24.sp,
                color: AppTheme.colorGreen,
              ),
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .paddingAll(30.w)
            .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
            .paddingHorizontal(30.w)
            .marginOnly(bottom: 16.w),
    ].toColumn();
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [
        SizedBox(
          height: 30.w,
        ).sliverToBoxAdapter(),
        _buildTop().sliverToBoxAdapter(),
        _buildRecord().sliverToBoxAdapter(),
        SizedBox(
          height: 150.w,
        ).sliverToBoxAdapter(),
      ],
    );
  }

  // 币种导航栏
  Widget _buildCoinNav() {
    return GetBuilder<CoinController>(
      id: "buildCoinNav",
      builder: (_) {
        return <Widget>[
          // 搜索框
          <Widget>[
            <Widget>[
              InputWidget(
                prefix: Icon(
                  Icons.search,
                  size: 30.sp,
                  color: AppTheme.color999,
                ),
                placeholder: "请输入搜索关键词".tr,
                controller: controller.searchController,
                onChanged: (val) {
                  // 实时搜索
                  controller.onSearch(val);
                },
              ).expanded(),
            ]
                .toRow(crossAxisAlignment: CrossAxisAlignment.center)
                .paddingHorizontal(30.w)
                .tight(width: 450.w)
                .backgroundColor(AppTheme.blockBgColor)
                .clipRRect(all: 60.w),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w),

          // TAB切换
          if (controller.tabNames.length > 1)
            <Widget>[
              for (var item in controller.tabNames)
                <Widget>[
                  TextWidget.body(
                    item,
                    size: 26.sp,
                    color: controller.tabIndex == item ? AppTheme.color000 : AppTheme.color999,
                  ),
                ].toRow().onTap(() {
                  controller.onTapTabIndex(item);
                }),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).marginOnly(top: 30.w),

          // 标题
          <Widget>[
            TextWidget.body(
              '交易对'.tr,
              size: 22.sp,
              color: AppTheme.color999,
            ).width(150.w),
            TextWidget.body(
              '最新价'.tr,
              size: 22.sp,
              color: AppTheme.color999,
            ).width(200.w),
            TextWidget.body(
              '涨跌幅'.tr,
              size: 22.sp,
              color: AppTheme.color999,
              textAlign: TextAlign.right,
            ).width(120.w),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).height(88.w),

          // 列表
          ListView.builder(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            itemBuilder: (context, index) {
              var item = controller.getMarketList(controller.tabIndex)[index];
              return <Widget>[
                TextWidget.body(
                  item.pairName ?? '',
                  size: 24.sp,
                  color: AppTheme.color000,
                ).width(150.w),
                TextWidget.body(
                  '${item.close}',
                  size: 22.sp,
                  color: AppTheme.color000,
                ).width(200.w),
                TextWidget.body(
                  '${item.increaseStr}',
                  size: 22.sp,
                  color: item.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
                  textAlign: TextAlign.right,
                ).width(120.w),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(108.w).border(bottom: 1, color: AppTheme.borderLine).onTap(() {
                Get.back();
                controller.changeSymbol(item);
              });
            },
            itemCount: controller.getMarketList(controller.tabIndex).length,
          ).expanded()
        ].toColumn();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinController>(
      init: CoinController(),
      id: "coin",
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
              padding: EdgeInsets.only(left: 0, right: 30.w), // 重写左右内边距
              centerTitle: false, // 不显示标题
              height: 45, // 高度
              titleWidget: <Widget>[
                // 点击导航弹出自定义内容
                <Widget>[
                  ImgWidget(
                    path: 'assets/images/coin1.png',
                    width: 36.w,
                    height: 36.w,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  TextWidget.body(
                    controller.pairName,
                    size: 30.sp,
                    weight: FontWeight.bold,
                    color: AppTheme.color000,
                  ),
                ].toRow().onTap(() {
                  _scaffoldKey.currentState?.openDrawer();
                }),
                SizedBox(
                  width: 20.w,
                ),
                TextWidget.body(
                  controller.pairRatio,
                  size: 22.sp,
                  color: controller.pairRatio.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
                ),
              ].toRow(),
              backgroundColor: AppTheme.navBgColor,
              screenAdaptation: true,
              useDefaultBack: false,
              rightBarItems: [
                TDNavBarItem(
                  padding: EdgeInsets.only(right: 20.w),
                  iconWidget: ImgWidget(
                    path: controller.isCollectCoin(controller.pairName) ? 'assets/images/coin2.png' : 'assets/images/coin7.png',
                    width: 40.w,
                    height: 40.w,
                  ),
                  action: () {
                    controller.onCollectCoin(controller.pairName);
                  },
                ),
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

          body: _buildView(),
        );
      },
    );
  }
}
