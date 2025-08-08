import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'index.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ContinuousPage extends GetView<ContinuousController> {
  const ContinuousPage({super.key});

  // 顶部：资产统计
  Widget _buildTopAssets() {
    return <Widget>[
      <Widget>[
        TextWidget.body(
          '用户权益(USDT)'.tr,
          size: 22.sp,
          color: AppTheme.color000,
        ),
        ImgWidget(
          path: 'assets/images/continuous2.png',
          width: 30.w,
          height: 30.w,
        ).onTap(() {
          Get.toNamed(AppRoutes.transfer);
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      TextWidget.body(
        controller.userMoney.accountEquity ?? '0',
        size: 40.sp,
        color: AppTheme.color000,
        weight: FontWeight.bold,
      ),
      SizedBox(
        height: 10.w,
      ),
      <Widget>[
        <Widget>[
          <Widget>[].toRow().tight(width: 10.w, height: 10.w).backgroundColor(AppTheme.colorGreen).clipRRect(all: 5.w),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            '未实现盈亏(USDT)'.tr,
            size: 22.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            controller.userMoney.totalUnrealProfit ?? '0',
            size: 26.sp,
            color: AppTheme.colorGreen,
          ),
        ].toRow(),
        <Widget>[
          <Widget>[].toRow().tight(width: 10.w, height: 10.w).backgroundColor(AppTheme.colorRed).clipRRect(all: 5.w),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            '风险率:'.tr,
            size: 22.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body(
            '${controller.userMoney.riskRate ?? '0'}%',
            size: 26.sp,
            color: AppTheme.colorRed,
          ),
          Icon(
            Icons.privacy_tip_outlined,
            size: 24.sp,
            color: AppTheme.color999,
          ),
        ].toRow().onTap(() {
          controller.onViewRiskInfo();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w);
  }

  // 左上：委托
  Widget _buildLeftOrderType() {
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
          height: 72.w, // 高度和你的红框一致
          width: 180.w, // 宽度自适应父容器
          padding: EdgeInsets.only(
            left: 20.w,
            right: 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            color: AppTheme.colorGreen,
          ),
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

  // 左上：杠杆
  Widget _buildLeftLeverage() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: controller.selectedLeverage,
        items: controller.leverages
            .map((item) => DropdownMenuItem<String>(
                  value: item.toString(),
                  child: TextWidget.body(
                    '${item}X',
                    size: 24.sp,
                    color: AppTheme.color000,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          controller.changeLeverage(value!);
        },
        buttonStyleData: ButtonStyleData(
          height: 72.w, // 高度和你的红框一致
          width: 140.w, // 宽度自适应父容器
          padding: EdgeInsets.only(
            left: 20.w,
            right: 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(width: 1, color: AppTheme.borderLine),
          ),
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

  // 左上：以当前最新价交易 提示
  Widget _buildLeftBestMarketPriceTip() {
    return <Widget>[
      TextWidget.body(
        '以当前最新价交易'.tr,
        size: 22.sp,
        color: AppTheme.color999,
      ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.center)
        .tight(width: 340.w, height: 80.w)
        .paddingHorizontal(20.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w));
  }

  // 左上：进步器
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
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w);
  }

  // 左上：数量输入框
  Widget _buildLeftQuantityInput() {
    return <Widget>[
      <Widget>[
        InputWidget(
          placeholder: "数量".tr,
          controller: controller.amountController,
          cleanable: false,
        ).expanded(),
        TextWidget.body(
          '张'.tr,
          size: 22.sp,
          color: AppTheme.color000,
        ),
      ]
          .toRow()
          .tight(width: 340.w, height: 80.w)
          .paddingHorizontal(20.w)
          .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
          .marginOnly(bottom: 20.w),

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
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w);
  }

  // 左上：直营、止损 设置
  Widget _buildLeftStopLoss() {
    return <Widget>[
      TextWidget.body(
        '止盈止损设置'.tr,
        size: 22.sp,
        color: AppTheme.color000,
      ),
      SizedBox(
        height: 20.w,
      ),
      <Widget>[
        <Widget>[
          InputWidget(
            placeholder: "止盈触发价".tr,
            controller: controller.stopProfitController,
            cleanable: false,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.color000,
            ),
          ).expanded(),
        ]
            .toRow()
            .paddingHorizontal(10.w)
            .tight(width: 160.w, height: 72.w)
            .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w)),
        <Widget>[
          InputWidget(
            placeholder: "止损触发价".tr,
            controller: controller.stopLossController,
            cleanable: false,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.color000,
            ),
          ).expanded(),
        ]
            .toRow()
            .paddingHorizontal(10.w)
            .tight(width: 160.w, height: 72.w)
            .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w)),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w);
  }

  // 左上：确定按钮
  Widget _buildLeftConfirm() {
    return <Widget>[
      ButtonWidget(
        text: '开多（看涨）'.tr,
        height: 80,
        borderRadius: 10,
        backgroundColor: AppTheme.colorGreen,
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        onTap: () {
          // 确定
          controller.onConfirm('开多'.tr, 1);
        },
      ),
      SizedBox(
        height: 20.w,
      ),
      ButtonWidget(
        text: '开空（看跌）'.tr,
        height: 80,
        borderRadius: 10,
        backgroundColor: AppTheme.colorRed,
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        onTap: () {
          // 确定
          controller.onConfirm('开空'.tr, 2);
        },
      ),
      SizedBox(
        height: 20.w,
      ),
      <Widget>[
        TextWidget.body(
          '可开'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.canOpen}张',
          size: 22.sp,
          color: AppTheme.color999,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body(
          '预估保证金'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.estimateMargin}USDT',
          size: 22.sp,
          color: AppTheme.color999,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
    ].toColumn();
  }

  // 左边
  Widget _buildLeft() {
    return <Widget>[
      // 限价、市价
      <Widget>[
        _buildLeftOrderType(),
        SizedBox(
          width: 20.w,
        ),
        _buildLeftLeverage(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      // 限价进步器
      if (controller.selectedOrderType == '普通委托'.tr) _buildLeftQuantity(),

      // 在最佳市场价格成交 提示
      if (controller.selectedOrderType == '市价委托'.tr) _buildLeftBestMarketPriceTip().marginOnly(top: 20.w, bottom: 20.w),

      // 数量输入框
      _buildLeftQuantityInput(),

      // 直营、止损 设置
      _buildLeftStopLoss(),

      // 确定按钮
      _buildLeftConfirm(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(340.w);
  }

  // 右上
  Widget _buildRight() {
    final displaySellList = controller.sellList?.take(8).toList() ?? [];
    final displayBuyList = controller.buyList?.take(8).toList() ?? [];
    final maxAmount = controller.getDepthMaxAmountForDisplay(max: 8);
    return GetBuilder<ContinuousController>(
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
            ].toStack().tight(width: 350.w, height: 40.w).marginOnly(bottom: 10.w),

          // 当前价
          <Widget>[
            if (controller.latestPrice.isNotEmpty)
              TextWidget.body(
                controller.latestPrice,
                size: 30.sp,
                color: AppTheme.color000,
              )
            else
              TextWidget.body(
                controller.limitPrice,
                size: 28.sp,
                color: AppTheme.color000,
              )
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
              // 如果item.price>100 保留2位小数，不四舍五入
              // 如果item.price>1&&item.price<100  保留4位小数，不四舍五入
              // 如果item.price<1 保留10位小数，不四舍五入
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 100)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 2), size: 20.sp, color: AppTheme.colorGreen).positioned(left: 0, top: 5.w),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 1 && double.parse(item.price ?? '0') < 100)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 4), size: 20.sp, color: AppTheme.colorGreen).positioned(left: 0, top: 5.w),
              if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') < 1)
                TextWidget.body(MathUtils.omitTo(item.price ?? '0', 10), size: 20.sp, color: AppTheme.colorGreen).positioned(left: 0, top: 5.w),
              TextWidget.body(MathUtils.omitTo(item.amount ?? '0', 2), size: 20.sp, color: AppTheme.color000).positioned(right: 0, top: 5.w),
            ].toStack().tight(width: 350.w, height: 40.w).marginOnly(bottom: 10.w),
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
        <Widget>[
          TextWidget.body(
            '${'持有仓位'.tr}(${controller.currentPosition.length})',
            size: 28.sp,
            color: controller.currentTab == 'currentPosition' ? AppTheme.color000 : AppTheme.color999,
          ).onTap(() {
            controller.changeCurrentTab('currentPosition');
          }),
          SizedBox(
            width: 40.w,
          ),
          TextWidget.body(
            '${'当前委托'.tr}(${controller.currentEntrust.length})',
            size: 28.sp,
            color: controller.currentTab == 'currentEntrust' ? AppTheme.color000 : AppTheme.color999,
          ).onTap(() {
            controller.changeCurrentTab('currentEntrust');
          }),
        ].toRow(),
        <Widget>[
          TextWidget.body(
            '查看全部'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 22.sp,
            color: AppTheme.color999,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).onTap(() {
          controller.goAllEntrust();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w),
      SizedBox(
        height: 30.w,
      ),
      if (controller.currentTab == 'currentPosition')
        <Widget>[
          <Widget>[
            Icon(
              Icons.check_circle,
              size: 30.sp,
              color: controller.isOnlyCurrentPosition ? AppTheme.color000 : AppTheme.color999,
            ),
            SizedBox(
              width: 5.w,
            ),
            TextWidget.body(
              '仅显示当前合约'.tr,
              size: 22.sp,
              color: AppTheme.color999,
            ),
          ].toRow().onTap(() {
            controller.changeIsOnlyCurrentPosition();
          }),
          ButtonWidget(
            text: '一健全平'.tr,
            height: 50,
            borderRadius: 25,
            backgroundColor: AppTheme.color000,
            textColor: Colors.white,
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            onTap: () {
              // 确定
              controller.onCloseAll();
            },
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).marginOnly(bottom: 30.w),
      // 当前持有仓位item
      if (controller.currentTab == 'currentPosition')
        for (var item in controller.currentPosition) _buildCurrentPositionItem(item),

      // 当前委托item
      if (controller.currentTab == 'currentEntrust')
        for (var item in controller.currentEntrust) _buildCurrentEntrustItem(item),

      if (controller.currentTab == 'currentPosition' && controller.currentPosition.isEmpty) const EmptyState().marginOnly(top: 100.w, bottom: 100.w),

      if (controller.currentTab == 'currentEntrust' && controller.currentEntrust.isEmpty) const EmptyState().marginOnly(top: 100.w, bottom: 100.w),
    ].toColumn();
  }

  // 当前持有仓位item
  Widget _buildCurrentPositionItem(ContractCurrentPositionModel item) {
    return <Widget>[
      <Widget>[
        <Widget>[
          ButtonWidget(
            text: item.side == 1 ? '开多'.tr : '开空'.tr,
            height: 38,
            borderRadius: 10,
            backgroundColor: item.side == 1 ? const Color(0xffFDEBEB) : const Color(0xffE5F7FF),
            textColor: item.side == 1 ? AppTheme.colorRed : AppTheme.colorGreen,
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
          ),
          SizedBox(
            width: 16.w,
          ),
          TextWidget.body(
            '${item.symbol}/USDT',
            size: 22.sp,
            color: AppTheme.color000,
          ),
          SizedBox(
            width: 16.w,
          ),
          TextWidget.body(
            '${item.leverRate}X',
            size: 22.sp,
            color: AppTheme.color000,
          ),
        ].toRow(),
        ImgWidget(
          path: 'assets/images/continuous1.png',
          width: 24.w,
          height: 24.w,
        ).onTap(() {
          controller.showInviteFriendDialog();
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      SizedBox(
        height: 40.w,
      ),
      // 数据统计
      <Widget>[
        <Widget>[
          TextWidget.body(
            '开仓平均价'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.avgPrice}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '标记价'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.realtimePrice}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(200.w),
        <Widget>[
          TextWidget.body(
            '保证金'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.positionMargin}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '止盈触发价'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.tpPrice ?? '--'}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '止损触发价'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.slPrice ?? '--'}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(200.w),
        <Widget>[
          TextWidget.body(
            '持仓(张)'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.availPosition}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '预计收益'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.unRealProfit}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '预估强平价'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.flatPrice}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).width(200.w),
        <Widget>[
          TextWidget.body(
            '收益率'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.profitRate}',
            size: 24.sp,
            color: item.profitRate?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),

      // 按钮组
      <Widget>[
        ButtonWidget(
          text: '止盈止损'.tr,
          width: 200,
          height: 60,
          borderRadius: 10,
          backgroundColor: AppTheme.dividerColor,
          textColor: Colors.black,
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          onTap: () {
            // 确定
            controller.onStopProfit(item);
          },
        ),
        ButtonWidget(
          text: '一键反向'.tr,
          width: 200,
          height: 60,
          borderRadius: 10,
          backgroundColor: AppTheme.dividerColor,
          textColor: Colors.black,
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          onTap: () {
            // 确定
            controller.onReverse(item.side ?? 0);
          },
        ),
        ButtonWidget(
          text: '平仓'.tr,
          width: 200,
          height: 60,
          borderRadius: 10,
          backgroundColor: AppTheme.color000,
          textColor: Colors.white,
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          onTap: () {
            // 确定
            controller.onClosePosition(item);
          },
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .paddingHorizontal(30.w)
        .marginOnly(bottom: 16.w);
  }

  // 当前委托item
  Widget _buildCurrentEntrustItem(ContractMyAuthorizeModel item) {
    return <Widget>[
      <Widget>[
        <Widget>[
          <Widget>[
            ButtonWidget(
              text: controller.cals(item.side ?? 0, item.orderType ?? 0),
              height: 38,
              borderRadius: 10,
              backgroundColor: item.side == 1 ? const Color(0xffE5F7FF) : const Color(0xffFDEBEB),
              textColor: item.side == 1 ? AppTheme.colorGreen : AppTheme.colorRed,
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
            ),
            SizedBox(
              width: 16.w,
            ),
            TextWidget.body(
              '${item.symbol}/USDT ${item.leverRate}X',
              size: 22.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
          SizedBox(
            height: 16.w,
          ),
          TextWidget.body(
            '${item.createdAt}',
            size: 22.sp,
            color: AppTheme.color999,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

      SizedBox(
        height: 40.w,
      ),
      // 数据统计
      <Widget>[
        <Widget>[
          TextWidget.body(
            '委托总量(张)'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.amount}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '委托价(USDT)'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.entrustPrice}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '保证金'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.margin}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '成交量(张)'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.tradedAmount}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[
          TextWidget.body(
            '成交均价(USDT)'.tr,
            size: 22.sp,
            color: AppTheme.color999,
          ),
          SizedBox(
            height: 14.w,
          ),
          TextWidget.body(
            '${item.avgPrice}',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(200.w),
        <Widget>[].toColumn(crossAxisAlignment: CrossAxisAlignment.end).width(200.w),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(30.w)
        .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(10.w))
        .paddingHorizontal(30.w)
        .marginOnly(bottom: 16.w);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildTopAssets(),
      <Widget>[].toRow().tight(width: 750.w, height: 20.w).backgroundColor(AppTheme.dividerColor),
      SizedBox(
        height: 30.w,
      ),
      _buildTop(),
      SizedBox(
        height: 30.w,
      ),
      _buildRecord(),
      SizedBox(
        height: 150.w,
      ),
    ].toColumn();
  }

  // 币种导航栏
  Widget _buildCoinNav() {
    return GetBuilder<ContinuousController>(
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
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(120.w).marginOnly(top: 30.w),

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
          controller.getMarketList(controller.tabIndex).isEmpty
              ? const EmptyState()
              : ListView.builder(
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
                        '${item.price}',
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
    return GetBuilder<ContinuousController>(
      init: ContinuousController(),
      id: "continuous",
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
                // SizedBox(width: 20.w,),
                // TextWidget.body(controller.pairRatio,size: 26.sp,color: controller.pairRatio.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,),
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

          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
