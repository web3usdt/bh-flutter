import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class HashGamePage extends GetView<HashGameController> {
  const HashGamePage({super.key});
  // 玩法介绍
  Widget _buildPlayIntro() {
    return <Widget>[
      <Widget>[
        <Widget>[
          TextWidget.body(controller.type == 1 ? '哈希单双3秒钟'.tr : '哈希单双1分钟'.tr, color: AppTheme.color000, size: 28.sp, weight: FontWeight.w600),
          SizedBox(width: 10.w),
          <Widget>[
            TextWidget.body(
              '${controller.type == 1 ? controller.gameConfig.game3s?.odds ?? '' : controller.gameConfig.game1min?.odds ?? ''} X',
              color: AppTheme.colorGreen,
              size: 20.sp,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center)
              .paddingHorizontal(20.w)
              .height(32.w)
              .backgroundColor(Color(0xffE9FAF2))
              .clipRRect(topLeft: 20.w, topRight: 20.w, bottomLeft: 0.w, bottomRight: 20.w)
        ].toRow(),
        <Widget>[
          ImgWidget(
            path: 'assets/images/game13.png',
            width: 24.w,
            height: 24.w,
          ),
          SizedBox(width: 10.w),
          TextWidget.body(
            '玩法介绍'.tr,
            color: AppTheme.color000,
            size: 20.sp,
          ),
        ]
            .toRow()
            .paddingHorizontal(20.w)
            .tight(height: 46.w)
            .decorated(
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(28.w),
            )
            .onTap(() {
          controller.onViewProjectDetails();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(height: 80.w),
      <Widget>[
        <Widget>[
          TextWidget.body('${controller.currentCoin?.min ?? 0}-${controller.currentCoin?.max ?? 0}',
              color: AppTheme.color000, size: 26.sp, weight: FontWeight.w600),
          SizedBox(height: 10.w),
          TextWidget.body(
            '${'投注限额'.tr}(${controller.currentCoin?.coinName ?? ''})',
            color: AppTheme.color999,
            size: 20.sp,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        <Widget>[
          TextWidget.body('${controller.type == 1 ? controller.gameConfig.gameRate ?? '' : controller.gameConfig.gameRate ?? ''}%',
              color: AppTheme.color000, size: 26.sp, weight: FontWeight.w600),
          SizedBox(height: 10.w),
          TextWidget.body(
            '我的分佣'.tr,
            color: AppTheme.color999,
            size: 20.sp,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        <Widget>[
          TextWidget.body(
              '${controller.type == 1 ? controller.gameConfig.game3s?.brokerage ?? '' : controller.gameConfig.game1min?.brokerage ?? ''}%',
              color: AppTheme.color000,
              size: 26.sp,
              weight: FontWeight.w600),
          SizedBox(height: 10.w),
          TextWidget.body(
            '级别分佣'.tr,
            color: AppTheme.color999,
            size: 20.sp,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        <Widget>[
          TextWidget.body(controller.currentCoin?.usableBalance ?? '0', color: AppTheme.color000, size: 26.sp, weight: FontWeight.w600),
          SizedBox(height: 10.w),
          <Widget>[
            TextWidget.body(
              '${'余额'.tr}(${controller.currentCoin?.coinName ?? ''})',
              color: AppTheme.colorGreen,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Icon(Icons.arrow_forward_ios, size: 20.w, color: AppTheme.colorGreen),
          ].toRow(),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).onTap(() {
          controller.showCoinPicker();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ].toColumn().paddingAll(30.w);
  }

  // 开奖区块
  Widget _buildResultBlock() {
    return <Widget>[
      TextWidget.body(
        '已开奖区块'.tr,
        color: AppTheme.color999,
        size: 24.sp,
      ),
      SizedBox(height: 30.w),
      <Widget>[
        <Widget>[
          <Widget>[
            TextWidget.body(
              controller.result == 1 ? '单'.tr : '双'.tr,
              color: AppTheme.colorfff,
              size: 24.sp,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.center)
              .tight(width: 52.w, height: 52.w)
              .backgroundColor(controller.result == 1 ? AppTheme.colorRed : AppTheme.colorGreen)
              .clipRRect(all: 26.w),
          SizedBox(width: 20.w),
          TextWidget.body(
            '${controller.lastBlock}',
            color: AppTheme.color000,
            size: 28.sp,
          ),
        ].toRow(),
        <Widget>[
          TextWidget.body(
            '验证'.tr,
            color: AppTheme.colorfff,
            size: 24.sp,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .tight(width: 80.w, height: 40.w)
            .backgroundColor(AppTheme.color000)
            .clipRRect(all: 20.w)
            .onTap(() {
          controller.verifyBlock();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(height: 40.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '下一开奖区块'.tr,
            color: AppTheme.color999,
            size: 24.sp,
          ),
          SizedBox(height: 10.w),
          TextWidget.body(
            '${controller.nextBlock}',
            color: AppTheme.color000,
            size: 28.sp,
            weight: FontWeight.w600,
          ),
        ].toColumn(),
        <Widget>[
          GetBuilder<HashGameController>(
            id: "hash_game_timer",
            builder: (_) {
              return TextWidget.body(
                '${controller.timer}',
                color: AppTheme.colorGreen,
                size: 28.sp,
                weight: FontWeight.w600,
              );
            },
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.center).tight(width: 68.w, height: 68.w).decorated(
              border: Border.all(color: AppTheme.colorGreen, width: 1),
              borderRadius: BorderRadius.circular(34.w),
              color: AppTheme.colorGreen.withOpacity(0.1),
            ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w).tight(width: 690.w).decorated(
            border: Border.all(color: AppTheme.borderLine, width: 1),
            borderRadius: BorderRadius.circular(10.w),
            color: AppTheme.blockBgColor,
          ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w);
  }

  // 投注区块
  Widget _buildBetBlock() {
    return <Widget>[
      <Widget>[
        <Widget>[
          TextWidget.body(
            '单'.tr,
            color: AppTheme.colorRed,
            size: 40.sp,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .tight(width: 345.w, height: 96.w)
            .decorated(
              border: Border.all(color: controller.betType == 1 ? AppTheme.colorRed : Color(0xffFBE6E0), width: 1),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(52.w), bottomLeft: Radius.circular(52.w)),
              color: Color(0xffFBE6E0),
            )
            .onTap(() {
          controller.onTapBetType(1);
        }),
        <Widget>[
          TextWidget.body(
            '双'.tr,
            color: AppTheme.colorGreen,
            size: 40.sp,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .tight(width: 345.w, height: 96.w)
            .decorated(
              border: Border.all(color: controller.betType == 2 ? AppTheme.colorGreen : Color(0xffE4F2E9), width: 1),
              borderRadius: BorderRadius.only(topRight: Radius.circular(52.w), bottomRight: Radius.circular(52.w)),
              color: Color(0xffE4F2E9),
            )
            .onTap(() {
          controller.onTapBetType(2);
        }),
      ].toRow(),
      SizedBox(height: 30.w),
      <Widget>[
        TextWidget.body(
          '投注金额'.tr,
          color: AppTheme.color000,
          size: 24.sp,
        ),
        ImgWidget(
          path: 'assets/images/game14.png',
          width: 32.w,
          height: 32.w,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).onTap(() {
        // 底部弹出金额设置选项
        showModalBottomSheet(
          context: Get.context!,
          backgroundColor: AppTheme.pageBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.w),
              topRight: Radius.circular(30.w),
            ),
          ),
          builder: (context) => _buildAmountPicker(),
        );
      }),
      SizedBox(height: 30.w),
      // 选择投注金额
      <Widget>[
        for (var i = 0; i < controller.betAmountList.length; i++)
          <Widget>[
            TextWidget.body(
              '${controller.betAmountList[i].value}',
              color: controller.selectedAmountIndex == i ? AppTheme.colorfff : AppTheme.color000,
              size: 24.sp,
              weight: FontWeight.w600,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.center)
              .tight(width: 128.w, height: 52.w)
              .backgroundColor(controller.selectedAmountIndex == i ? AppTheme.color000 : AppTheme.blockBgColor)
              .clipRRect(all: 10.w)
              .onTap(() {
            controller.onTapBetAmount(i);
          }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      SizedBox(height: 40.w),
      // 输入框
      <Widget>[
        <Widget>[
          // 减号
          Icon(
            Icons.remove,
            size: 32.w,
            color: AppTheme.color000,
            weight: 1,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .tight(width: 80.w, height: 80.w)
            .decorated(
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(40.w),
              color: AppTheme.blockBgColor,
            )
            .onTap(() {
          controller.decreaseBetAmount();
        }),
        // 输入框
        <Widget>[
          InputWidget(
            placeholder: "",
            controller: controller.betAmountController,
            textAlign: TextAlign.center,
            cleanable: false,
            keyboardType: TextInputType.number,
            onChanged: controller.onBetAmountChanged,
          ).expanded(),
        ].toRow().tight(width: 490.w, height: 80.w).decorated(
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(10.w),
              color: AppTheme.blockBgColor,
            ),
        <Widget>[
          // 加号
          Icon(
            Icons.add,
            size: 32.w,
            color: AppTheme.color000,
            weight: 1,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .tight(width: 80.w, height: 80.w)
            .decorated(
              border: Border.all(color: AppTheme.borderLine, width: 1),
              borderRadius: BorderRadius.circular(40.w),
              color: AppTheme.blockBgColor,
            )
            .onTap(() {
          controller.increaseBetAmount();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      SizedBox(height: 40.w),

      // 投注按钮
      ButtonWidget(
        text: '投注'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: controller.submitBet,
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingOnly(left: 30.w, right: 30.w, bottom: 30.w);
  }

  // 可编辑的投注金额列表
  Widget _buildAmountPicker() {
    return <Widget>[
      // 标题
      <Widget>[
        TextWidget.body(
          '金额设置'.tr,
          color: AppTheme.color000,
          size: 30.sp,
        ),
        // 取消按钮
        ImgWidget(
          path: 'assets/images/game11.png',
          width: 32.w,
          height: 32.w,
        ).onTap(() {
          controller.cancelAmountSettings();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(height: 100.w),

      TDDivider(height: 1, color: AppTheme.dividerColor),

      // 金额列表
      for (var i = 0; i < controller.editableBetAmountList.length; i++)
        <Widget>[
          <Widget>[
            TextWidget.body(
              '${controller.editableBetAmountList[i].value}',
              color: AppTheme.color000,
              size: 24.sp,
              weight: FontWeight.w600,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.center)
              .tight(width: 128.w, height: 60.w)
              .backgroundColor(AppTheme.blockBgColor)
              .clipRRect(all: 10.w),
          <Widget>[
            <Widget>[
              // 减号
              Icon(
                Icons.remove,
                size: 32.w,
                color: AppTheme.color000,
                weight: 1,
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                .tight(width: 60.w, height: 60.w)
                .decorated(
                  border: Border.all(color: AppTheme.borderLine, width: 1),
                  borderRadius: BorderRadius.circular(40.w),
                  color: AppTheme.blockBgColor,
                )
                .onTap(() {
              controller.decreaseEditableAmount(i);
            }),
            SizedBox(width: 10.w),
            // 输入框
            <Widget>[
              InputWidget(
                placeholder: "",
                controller: controller.editableControllers[i],
                textAlign: TextAlign.center,
                cleanable: false,
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.onEditableAmountChanged(i, value),
              ).expanded(),
            ].toRow().tight(width: 390.w, height: 60.w).decorated(
                  border: Border.all(color: AppTheme.borderLine, width: 1),
                  borderRadius: BorderRadius.circular(10.w),
                  color: AppTheme.blockBgColor,
                ),
            SizedBox(width: 10.w),
            <Widget>[
              // 加号
              Icon(
                Icons.add,
                size: 32.w,
                color: AppTheme.color000,
                weight: 1,
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                .tight(width: 60.w, height: 60.w)
                .decorated(
                  border: Border.all(color: AppTheme.borderLine, width: 1),
                  borderRadius: BorderRadius.circular(40.w),
                  color: AppTheme.blockBgColor,
                )
                .onTap(() {
              controller.increaseEditableAmount(i);
            }),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),

      // 确认按钮
      ButtonWidget(
        text: '确认'.tr,
        height: 88,
        borderRadius: 44,
        onTap: controller.confirmAmountSettings,
      ),
    ].toColumn().paddingHorizontal(30.w).tight(height: 700.w);
  }

  // 区块走势
  Widget _buildBlockTrend() {
    return <Widget>[
      // 标题
      <Widget>[
        TDTabBar(
          isScrollable: true,
          controller: controller.tabController,
          tabs: controller.tabNames.map((e) => TDTab(text: e)).toList(),
          onTap: (index) => controller.onTapTabItem(index),
          backgroundColor: Colors.white,
          showIndicator: true,
          indicatorColor: AppTheme.color000,
          labelColor: AppTheme.color000,
          unselectedLabelColor: AppTheme.color999,
          labelPadding: EdgeInsets.symmetric(horizontal: 30.w),
          dividerColor: Colors.transparent,
        ).expanded(),
        // 总计单双总数
        <Widget>[
          // 双
          <Widget>[
            <Widget>[
              TextWidget.body(
                '双'.tr,
                color: AppTheme.colorfff,
                size: 24.sp,
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                .tight(width: 36.w, height: 36.w)
                .backgroundColor(AppTheme.colorGreen)
                .clipRRect(all: 18.w),
            SizedBox(width: 10.w),
            TextWidget.body(
              '${controller.doubleCount}',
              color: AppTheme.color000,
              size: 24.sp,
              weight: FontWeight.w600,
            ),
          ].toRow().paddingOnly(left: 2.w, right: 15.w).tight(height: 40.w).decorated(
                border: Border.all(color: AppTheme.borderLine, width: 1),
                borderRadius: BorderRadius.circular(20.w),
                color: AppTheme.blockBgColor,
              ),
          SizedBox(width: 10.w),
          // 单
          <Widget>[
            <Widget>[
              TextWidget.body(
                '单'.tr,
                color: AppTheme.colorfff,
                size: 24.sp,
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                .tight(width: 36.w, height: 36.w)
                .backgroundColor(AppTheme.colorRed)
                .clipRRect(all: 18.w),
            SizedBox(width: 10.w),
            TextWidget.body(
              '${controller.singularCount}',
              color: AppTheme.color000,
              size: 24.sp,
              weight: FontWeight.w600,
            ),
          ].toRow().paddingOnly(left: 2.w, right: 15.w).tight(height: 40.w).decorated(
                border: Border.all(color: AppTheme.borderLine, width: 1),
                borderRadius: BorderRadius.circular(20.w),
                color: AppTheme.blockBgColor,
              ),
        ].toRow().paddingOnly(right: 30.w),
      ].toRow(),
      SizedBox(height: 30.w),
      // 走势图
      _buildTrendChart(),
    ].toColumn();
  }

  // 走势图
  Widget _buildTrendChart() {
    if (controller.trendData.isEmpty) {
      return <Widget>[
        TextWidget.body(
          '暂无走势数据'.tr,
          color: AppTheme.color999,
          size: 24.sp,
        ),
      ]
          .toColumn(mainAxisAlignment: MainAxisAlignment.center)
          .tight(width: 690.w, height: 300.w)
          .backgroundColor(AppTheme.blockBgColor)
          .clipRRect(all: 10.w);
    }

    return Container(
      width: 690.w,
      height: 500.w,
      decoration: BoxDecoration(
        color: AppTheme.blockBgColor,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        children: [
          // 走势网格
          Expanded(
            child: _buildTrendGridWithMode(),
          ),
        ],
      ),
    );
  }

  // 根据模式选择走势网格实现
  Widget _buildTrendGridWithMode() {
    // 调试模式控制 - 设置为 true 使用复杂版本，false 使用简化版本
    const bool useComplexMode = false;

    // 打印原始数据用于调试
    // print('=== 走势数据调试信息 ===');
    // print('原始数据长度: ${controller.trendData.length}');
    // for (int i = 0; i < controller.trendData.length; i++) {
    //   print('第$i组数据: ${controller.trendData[i]}');
    // }
    // print('========================');

    try {
      if (useComplexMode) {
        return _buildTrendGridComplex();
      } else {
        return _buildTrendGridSafe();
      }
    } catch (e) {
      print('构建走势网格时发生错误: $e');
      return _buildEmptyTrendGrid();
    }
  }

  // 简化的走势网格 - 备用方案
  Widget _buildTrendGridSafe() {
    try {
      if (controller.trendData.isEmpty) {
        return _buildEmptyTrendGrid();
      }

      // 简化的数据显示 - 显示所有数据
      List<Widget> trendItems = [];

      for (int i = 0; i < controller.trendData.length; i++) {
        try {
          var row = controller.trendData[i];
          if (row is List<int> && row.isNotEmpty) {
            int value = row[0];
            int count = row.length;

            // 显示所有数据，不限制数量
            // print('渲染第$i列，数据: $row，数量: $count');

            trendItems.add(
              Container(
                margin: EdgeInsets.only(right: 15.w, bottom: 15.w),
                child: Column(
                  children: [
                    for (int j = 0; j < count; j++)
                      Container(
                        width: 40.w,
                        height: 40.w,
                        margin: EdgeInsets.only(bottom: 4.w),
                        decoration: BoxDecoration(
                          color: value == 1 ? AppTheme.colorRed : AppTheme.colorGreen,
                          borderRadius: BorderRadius.circular(6.w),
                          border: Border.all(
                            color: value == 1 ? AppTheme.colorRed.withOpacity(0.3) : AppTheme.colorGreen.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: TextWidget.body(
                            value == 1 ? '单' : '双',
                            color: AppTheme.colorfff,
                            size: 16.sp,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        } catch (e) {
          // print('处理走势数据第$i项时发生错误: $e');
          continue;
        }
      }

      if (trendItems.isEmpty) {
        return _buildEmptyTrendGrid();
      }

      return SingleChildScrollView(
        controller: controller.horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: trendItems,
        ),
      );
    } catch (e) {
      print('构建简化走势网格时发生错误: $e');
      return _buildEmptyTrendGrid();
    }
  }

  // 复杂的走势网格实现
  Widget _buildTrendGridComplex() {
    try {
      // 单元格样式
      const double cellWidth = 40.0;
      const double cellHeight = 40.0;
      const double columnSpacing = 12.0;
      const double rowSpacing = 6.0;

      // 深度安全检查数据
      if (controller.trendData.isEmpty) {
        return _buildEmptyTrendGrid();
      }

      // 验证数据结构的完整性
      List<List<int>> validData = [];
      for (var row in controller.trendData) {
        if (row is List<int> && row.isNotEmpty) {
          // 验证每个元素是否为有效的整数
          List<int> validRow = [];
          for (var item in row) {
            if (item is int && (item == 1 || item == 2)) {
              validRow.add(item);
            }
          }
          if (validRow.isNotEmpty) {
            validData.add(validRow);
          }
        }
      }

      if (validData.isEmpty) {
        return _buildEmptyTrendGrid();
      }

      // 计算最大列高
      int maxColumnHeight = 0;
      for (var row in validData) {
        if (row.length > maxColumnHeight) {
          maxColumnHeight = row.length;
        }
      }

      // 安全检查最大列高
      if (maxColumnHeight <= 0) {
        maxColumnHeight = 1;
      }

      // 不限制最大高度，显示所有数据
      print('最大列高: $maxColumnHeight');

      // 构建所有列
      List<Widget> columns = [];
      for (int i = 0; i < validData.length; i++) {
        try {
          List<int> row = validData[i];
          if (row.isEmpty) continue;

          int value = row[0];
          int count = row.length;

          // 显示所有格子，不限制数量
          // print('第$i列，值: $value，格子数: $count');

          // 构建每列的格子
          List<Widget> cells = [];
          for (int j = 0; j < count; j++) {
            try {
              cells.add(_buildTrendCell(value, cellWidth, cellHeight, rowSpacing));
            } catch (e) {
              print('构建格子时发生错误: $e');
              continue;
            }
          }

          // 补齐空格（保持所有列等高）
          while (cells.length < maxColumnHeight) {
            cells.add(SizedBox(height: cellHeight + rowSpacing));
          }

          columns.add(
            Container(
              width: cellWidth,
              margin: EdgeInsets.only(right: i < validData.length - 1 ? columnSpacing : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: cells,
              ),
            ),
          );
        } catch (e) {
          // print('构建第$i列时发生错误: $e');
          continue;
        }
      }

      // 安全检查列数
      if (columns.isEmpty) {
        return _buildEmptyTrendGrid();
      }

      // 显示所有列，不限制数量
      print('总列数: ${columns.length}');

      // 计算总宽度和高度
      double totalWidth = columns.length * cellWidth + (columns.length - 1) * columnSpacing;
      totalWidth = totalWidth < 690.w ? 690.w : totalWidth;
      totalWidth += 30.w;

      double totalHeight = maxColumnHeight * (cellHeight + rowSpacing);
      totalHeight += 50.w;

      // 不限制最大高度，显示所有数据
      print('总高度: $totalHeight');

      return Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 6.0,
        radius: Radius.circular(3.w),
        child: SingleChildScrollView(
          controller: controller.horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: controller.verticalScrollController,
            scrollDirection: Axis.vertical,
            child: Container(
              width: totalWidth,
              height: totalHeight,
              padding: EdgeInsets.only(left: 15.w, top: 15.w, right: 15.w, bottom: 25.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print('构建复杂走势网格时发生错误: $e');
      return _buildEmptyTrendGrid();
    }
  }

  // 构建单个走势格子
  Widget _buildTrendCell(int value, double width, double height, double margin) {
    try {
      return Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(bottom: margin),
        decoration: BoxDecoration(
          color: value == 1 ? AppTheme.colorRed : AppTheme.colorGreen,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: value == 1 ? AppTheme.colorRed.withOpacity(0.3) : AppTheme.colorGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: TextWidget.body(
            value == 1 ? '单' : '双',
            color: AppTheme.colorfff,
            size: 16.sp,
            weight: FontWeight.w600,
          ),
        ),
      );
    } catch (e) {
      print('构建走势格子时发生错误: $e');
      return Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(bottom: margin),
        color: AppTheme.color999,
        child: Center(
          child: TextWidget.body(
            '?',
            color: AppTheme.colorfff,
            size: 16.sp,
          ),
        ),
      );
    }
  }

  // 空走势网格
  Widget _buildEmptyTrendGrid() {
    return Container(
      width: 690.w,
      height: 200.w,
      child: Center(
        child: TextWidget.body(
          '暂无走势数据'.tr,
          color: AppTheme.color999,
          size: 24.sp,
        ),
      ),
    );
  }

  // 暂无数据
  Widget _buildEmpty() {
    return EmptyState(message: '暂无数据'.tr);
  }

  // 数据列表,可以是SliverGrid，也可以是SliverList
  Widget _buildDataList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.betRecordList[index];
          return <Widget>[
            <Widget>[
              TextWidget.body('${item.number}', color: AppTheme.color000, size: 26.sp, weight: FontWeight.w600),
              TextWidget.body(
                '${item.createdAt}',
                color: AppTheme.color999,
                size: 20.sp,
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(height: 20.w),
            <Widget>[
              TextWidget.body(
                '我的投注'.tr,
                color: AppTheme.color999,
                size: 26.sp,
              ).width(300.w),
              TextWidget.body(
                item.status == 1 ? '待结算'.tr : '开奖结果'.tr,
                color: AppTheme.color999,
                size: 20.sp,
              ).width(300.w),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(height: 20.w),
            <Widget>[
              <Widget>[
                <Widget>[
                  TextWidget.body(
                    item.expect == 1 ? '单'.tr : '双'.tr,
                    color: AppTheme.colorfff,
                    size: 20.sp,
                  ),
                ]
                    .toRow(mainAxisAlignment: MainAxisAlignment.center)
                    .tight(width: 40.w, height: 40.w)
                    .backgroundColor(item.expect == 1 ? AppTheme.colorRed : AppTheme.colorGreen)
                    .clipRRect(all: 20.w),
                TextWidget.body(
                  '${item.amount}',
                  color: AppTheme.color000,
                  size: 24.sp,
                )
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .paddingHorizontal(20.w)
                  .tight(width: 300.w, height: 80.w)
                  .backgroundColor(AppTheme.blockBgColor)
                  .clipRRect(all: 10.w),
              <Widget>[
                if (item.result != null && item.result! > 0)
                  <Widget>[
                    TextWidget.body(
                      item.result == 1 ? '单'.tr : '双'.tr,
                      color: AppTheme.colorfff,
                      size: 20.sp,
                    ),
                  ]
                      .toRow(mainAxisAlignment: MainAxisAlignment.center)
                      .tight(width: 40.w, height: 40.w)
                      .backgroundColor(item.result == 1 ? AppTheme.colorRed : AppTheme.colorGreen)
                      .clipRRect(all: 20.w),
                if (item.status != 1)
                  TextWidget.body(
                    '${item.win}',
                    color: item.win != null && item.win! < 0 ? AppTheme.colorRed : AppTheme.colorGreen,
                    size: 24.sp,
                  )
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .paddingHorizontal(20.w)
                  .tight(width: 300.w, height: 80.w)
                  .backgroundColor(AppTheme.blockBgColor)
                  .clipRRect(all: 10.w),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ]
              .toColumn()
              .paddingOnly(top: 30.w, left: 30.w, right: 30.w)
              .tight(width: 690.w, height: 242.w)
              .decorated(
                border: Border.all(color: AppTheme.borderLine, width: 1),
                borderRadius: BorderRadius.circular(10.w),
              )
              .paddingHorizontal(30.w)
              .marginOnly(bottom: 20.w)
              .onTap(() {
            if (item.status != 1) {
              Get.toNamed(AppRoutes.hashGameDetail, arguments: {
                'item': item,
              });
            }
          });
        },
        childCount: controller.betRecordList.length,
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(slivers: [
      _buildPlayIntro().sliverToBoxAdapter(),
      SizedBox(height: 40.w).sliverToBoxAdapter(),
      TDDivider(height: 16.w, color: AppTheme.dividerColor).sliverToBoxAdapter(),
      _buildResultBlock().sliverToBoxAdapter(),
      SizedBox(height: 30.w).sliverToBoxAdapter(),
      _buildBetBlock().sliverToBoxAdapter(),
      SizedBox(height: 10.w).sliverToBoxAdapter(),
      _buildBlockTrend().sliverToBoxAdapter(),
      SizedBox(height: 30.w).sliverToBoxAdapter(),
      TDDivider(height: 16.w, color: AppTheme.dividerColor).sliverToBoxAdapter(),
      SizedBox(height: 30.w).sliverToBoxAdapter(),
      TextWidget.body(
        '投注记录'.tr,
        color: AppTheme.color000,
        size: 28.sp,
        weight: FontWeight.w600,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(height: 30.w).sliverToBoxAdapter(),
      controller.betRecordList.isEmpty ? _buildEmpty().sliverToBoxAdapter() : _buildDataList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HashGameController>(
      init: HashGameController(),
      id: "hash_game",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '哈希游戏'.tr,
            titleColor: AppTheme.color000,
            titleFontWeight: FontWeight.w600,
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
          ),
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
