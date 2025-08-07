import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'index.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ContractKChartPage extends GetView<ContractKChartController> {
  const ContractKChartPage({super.key});

  // 头部数据
  Widget _buildHeader() {
    return <Widget>[
      <Widget>[
        // TextWidget.body('${controller.currentCoin.price}',size:30.sp,color: AppTheme.color000,weight: FontWeight.w600,),
        // SizedBox(height: 15.w),
        // <Widget>[
        //   TextWidget.body('${controller.currentCoin.increaseStr}',size:26.sp,color: AppTheme.color000,weight: FontWeight.w600,),
        // ].toRow().paddingHorizontal(30.w).card(
        //   color: controller.currentCoin.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
        // ).height(40.w)
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      <Widget>[
        // TextWidget.body('24h量 ${controller.currentCoin.vol}',size:24.sp,color: AppTheme.color000,),
        // SizedBox(height: 10.w),
        TextWidget.body(
          '24h${'最高'.tr} ${controller.currentCoin.high}',
          size: 22.sp,
          color: AppTheme.color000,
        ),
        SizedBox(height: 10.w),
        TextWidget.body(
          '24h${'最低'.tr} ${controller.currentCoin.low}',
          size: 22.sp,
          color: AppTheme.color000,
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingAll(30.w).card(color: AppTheme.blockBgColor).tight(
          width: 690.w,
        );
  }

  // 时间选择
  Widget _buildPeriodButtons() {
    return <Widget>[
      _buildPeriodButton('1min', '1M'),
      _buildPeriodButton('5min', '5M'),
      _buildPeriodButton('15min', '15M'),
      _buildPeriodButton('30min', '30M'),
      _buildPeriodButton('60min', '1H'),
      _buildPeriodButton('1day', '1${'天'.tr}'),
      _buildPeriodButton('1week', '1${'周'.tr}'),
      _buildPeriodButton('1mon', '1${'月'.tr}'),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).height(90.w);
  }

  // 时间选择按钮
  Widget _buildPeriodButton(String period, String label) {
    bool isSelected = controller.period == period;
    return TextWidget.body(label, color: isSelected ? AppTheme.primary : AppTheme.color666).onTap(() {
      controller.changePeriod(period);
    });
  }

  // 指标切换按钮
  Widget _buildIndicatorButtons() {
    return <Widget>[
      TextWidget.body('MA', color: controller.mainState == MainState.MA ? AppTheme.primary : AppTheme.color666).onTap(() {
        controller.changeMainState(MainState.MA);
      }),
      SizedBox(width: 20.w),
      TextWidget.body('BOLL', color: controller.mainState == MainState.BOLL ? AppTheme.primary : AppTheme.color666).onTap(() {
        controller.changeMainState(MainState.BOLL);
      }),
      SizedBox(width: 100.w),
      TextWidget.body('MACD', color: controller.secondaryState == SecondaryState.MACD ? AppTheme.primary : AppTheme.color666).onTap(() {
        controller.changeSecondaryState(SecondaryState.MACD);
      }),
      SizedBox(width: 20.w),
      TextWidget.body('KDJ', color: controller.secondaryState == SecondaryState.KDJ ? AppTheme.primary : AppTheme.color666).onTap(() {
        controller.changeSecondaryState(SecondaryState.KDJ);
      }),
      SizedBox(width: 20.w),
      TextWidget.body('RSI', color: controller.secondaryState == SecondaryState.RSI ? AppTheme.primary : AppTheme.color666).onTap(() {
        controller.changeSecondaryState(SecondaryState.RSI);
      }),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(60.w).card(color: AppTheme.blockBgColor).height(80.w);
  }

  // K线图样式配置
  ChartStyle _getChartStyle() {
    return ChartStyle()
      ..topPadding = 30.w
      ..bottomPadding = 20.w
      ..childPadding = 12.w
      ..pointWidth = 11.w
      ..candleWidth = 8.5.w
      ..candleLineWidth = 1.5.w
      ..volWidth = 8.5.w
      ..macdWidth = 3.w
      ..vCrossWidth = 8.5.w
      ..hCrossWidth = 0.5.w
      ..nowPriceLineLength = 1.w
      ..nowPriceLineSpan = 1.w
      ..nowPriceLineWidth = 1.w
      ..gridRows = 5
      ..gridColumns = 5;
  }

  // K线图颜色配置
  ChartColors _getChartColors() {
    return ChartColors()
      ..bgColor = [AppTheme.pageBgColor, AppTheme.pageBgColor] // 背景色
      ..kLineColor = const Color(0xff4C86CD) // K线图颜色
      ..lineFillColor = const Color(0x554C86CD) // 线填充颜色
      ..lineFillInsideColor = const Color(0x00000000) // 线内部填充颜色
      ..ma5Color = const Color(0xffC9B885) // MA5线颜色
      ..ma10Color = const Color(0xff6CB0A6) // MA10线颜色
      ..ma30Color = const Color(0xff9979C6) // MA30线颜色
      ..upColor = const Color(0xff4DAA90) // 涨的颜色
      ..dnColor = const Color(0xffC15466) // 跌的颜色
      ..volColor = const Color(0xff4729AE) // 成交量颜色
      ..macdColor = const Color(0xff4729AE) // MACD颜色
      ..difColor = const Color(0xffC9B885) // DIF颜色
      ..deaColor = const Color(0xff6CB0A6) // DEA颜色
      ..kColor = const Color(0xffC9B885) // KDJ K线颜色
      ..dColor = const Color(0xff6CB0A6) // KDJ D线颜色
      ..jColor = const Color(0xff9979C6) // KDJ J线颜色
      ..rsiColor = const Color(0xffC9B885) // RSI颜色
      ..defaultTextColor = const Color(0xff60738E) // 默认文字颜色
      ..nowPriceUpColor = const Color(0xff4DAA90) // 当前价格上涨颜色
      ..nowPriceDnColor = const Color(0xffC15466) // 当前价格下跌颜色
      ..nowPriceTextColor = const Color(0xffffffff) // 当前价格文字颜色
      ..selectBorderColor = const Color(0xff6C7A86) // 选中边框颜色
      ..selectFillColor = AppTheme.blockBgColor // 选中背景色
      ..gridColor = const Color(0xff4c5c74) // 网格线颜色
      ..infoWindowNormalColor = AppTheme.color000 // 信息窗口普通文字颜色
      ..infoWindowTitleColor = AppTheme.color000 // 信息窗口标题文字颜色
      ..infoWindowUpColor = AppTheme.colorGreen // 信息窗口涨的颜色
      ..infoWindowDnColor = AppTheme.colorRed // 信息窗口跌的颜色
      ..hCrossColor = const Color(0x1E999999) // 水平十字线颜色
      ..vCrossColor = const Color(0x1E999999) // 垂直十字线颜色
      ..crossTextColor = AppTheme.color000 // 十字线文字颜色
      ..maxColor = AppTheme.color000 // 最大值颜色
      ..minColor = AppTheme.color000; // 最小值颜色
  }

  // tab 切换
  Widget _buildTab() {
    return <Widget>[
      for (var i = 0; i < controller.bottomTabNames.length; i++)
        <Widget>[
          TextWidget.body(
            controller.bottomTabNames[i],
            size: 26.sp,
            color: controller.bottomTabIndex == i ? AppTheme.color000 : AppTheme.color999,
          ),
        ].toRow().onTap(() {
          controller.onTapBottomTabIndex(i);
        }),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).marginOnly(top: 30.w).marginOnly(bottom: 20.w);
  }

  // 买卖盘
  Widget _buildBuySell() {
    final maxAmount = controller.getDepthMaxAmountForDisplay();
    return controller.buyList?.isEmpty == true && controller.sellList?.isEmpty == true
        ? const EmptyState().marginOnly(top: 100.w, bottom: 100.w)
        : <Widget>[
            // 买
            <Widget>[
              // 标题
              <Widget>[
                TextWidget.body(
                  '数量'.tr,
                  size: 22.sp,
                  color: AppTheme.color999,
                ),
                TextWidget.body(
                  '买价'.tr,
                  size: 22.sp,
                  color: AppTheme.color999,
                ),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 335.w, height: 44.w),
              // 红色背景
              for (var item in controller.buyList ?? [])
                <Widget>[
                  Builder(
                    builder: (context) {
                      double amount = double.tryParse(item.amount ?? '0') ?? 0;
                      double percent = maxAmount > 0 ? (amount / maxAmount) : 0;
                      return Container(
                        width: 335.w * percent, // 100.w为最大宽度
                        height: 40.w,
                        color: const Color(0xffEAF8F0),
                      ).positioned(left: 0);
                    },
                  ),
                  // 如果item.price>100 保留2位小数，不四舍五入
                  // 如果item.price>1&&item.price<100  保留4位小数，不四舍五入
                  // 如果item.price<1 保留10位小数，不四舍五入
                  TextWidget.body('${item.amount}', size: 20.sp, color: AppTheme.color000).positioned(left: 0, top: 5.w),
                  if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 100)
                    TextWidget.body(MathUtils.omitTo(item.price ?? '0', 2), size: 20.sp, color: AppTheme.colorGreen).positioned(right: 0, top: 5.w),
                  if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 1 && double.parse(item.price ?? '0') < 100)
                    TextWidget.body(MathUtils.omitTo(item.price ?? '0', 4), size: 20.sp, color: AppTheme.colorGreen).positioned(right: 0, top: 5.w),
                  if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') < 1)
                    TextWidget.body(MathUtils.omitTo(item.price ?? '0', 10), size: 20.sp, color: AppTheme.colorGreen).positioned(right: 0, top: 5.w),
                ].toStack().tight(width: 335.w, height: 40.w).marginOnly(bottom: 10.w),
            ].toColumn(),

            // 卖
            <Widget>[
              // 标题
              <Widget>[
                TextWidget.body(
                  '数量'.tr,
                  size: 22.sp,
                  color: AppTheme.color999,
                ),
                TextWidget.body(
                  '卖价'.tr,
                  size: 22.sp,
                  color: AppTheme.color999,
                ),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 335.w, height: 44.w),
              for (var item in controller.sellList ?? [])
                <Widget>[
                  Builder(
                    builder: (context) {
                      double amount = double.tryParse(item.amount ?? '0') ?? 0;
                      double percent = maxAmount > 0 ? (amount / maxAmount) : 0;
                      return Container(
                        width: 335.w * percent, // 100.w为最大宽度
                        height: 40.w,
                        color: const Color(0xffFDEBEB),
                      ).positioned(right: 0);
                    },
                  ),
                  TextWidget.body('${item.amount}', size: 20.sp, color: AppTheme.color000).positioned(left: 0, top: 5.w),
                  if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 100)
                    TextWidget.body(MathUtils.omitTo(item.price ?? '0', 2), size: 20.sp, color: AppTheme.colorRed).positioned(right: 0, top: 5.w),
                  if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') > 1 && double.parse(item.price ?? '0') < 100)
                    TextWidget.body(MathUtils.omitTo(item.price ?? '0', 4), size: 20.sp, color: AppTheme.colorRed).positioned(right: 0, top: 5.w),
                  if (item.price?.isNotEmpty == true && double.parse(item.price ?? '0') < 1)
                    TextWidget.body(MathUtils.omitTo(item.price ?? '0', 10), size: 20.sp, color: AppTheme.colorRed).positioned(right: 0, top: 5.w),
                ].toStack().tight(width: 335.w, height: 40.w).marginOnly(bottom: 10.w),
            ].toColumn(),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).paddingHorizontal(30.w).tight(width: 750.w);
  }

  // 最新成交
  Widget _buildLatest() {
    return <Widget>[
      if (controller.tradeList?.isEmpty == true)
        const EmptyState().marginOnly(top: 100.w, bottom: 100.w)
      else
        <Widget>[
          TextWidget.body(
            '时间'.tr,
            size: 22.sp,
            color: AppTheme.color999,
            textAlign: TextAlign.left,
          ).width(200.w),
          TextWidget.body(
            '方向'.tr,
            size: 22.sp,
            color: AppTheme.color999,
            textAlign: TextAlign.left,
          ).width(100.w),
          TextWidget.body(
            '价格'.tr,
            size: 22.sp,
            color: AppTheme.color999,
            textAlign: TextAlign.right,
          ).width(190.w),
          TextWidget.body(
            '数量'.tr,
            size: 22.sp,
            color: AppTheme.color999,
            textAlign: TextAlign.right,
          ).width(190.w),
        ].toRow().height(44.w),
      for (var item in controller.tradeList ?? [])
        <Widget>[
          // 使用时间戳转换为时间
          TextWidget.body(
            DateCommonUtils.formatHMS(item.ts),
            size: 22.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.left,
          ).width(200.w),
          TextWidget.body(
            item.direction == 'buy' ? '买'.tr : '卖'.tr,
            size: 22.sp,
            color: item.direction == 'buy' ? AppTheme.colorGreen : AppTheme.colorRed,
            textAlign: TextAlign.left,
          ).width(100.w),
          TextWidget.body(
            '${item.price}',
            size: 22.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.right,
          ).width(190.w),
          TextWidget.body(
            '${item.amount}',
            size: 22.sp,
            color: AppTheme.color000,
            textAlign: TextAlign.right,
          ).width(190.w),
        ].toRow().height(44.w).marginOnly(top: 10.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w).tight(width: 750.w);
  }

  // 币种信息
  Widget _buildCoinInfo() {
    return <Widget>[
      <Widget>[
        ImgWidget(
          path: controller.coinInfo.coinIcon ?? '',
          width: 48.w,
          height: 48.w,
          radius: 24.w,
        ),
        SizedBox(width: 20.w),
        TextWidget.body(
          controller.coinInfo.coinName ?? '',
          size: 30.sp,
          color: AppTheme.color000,
        ),
      ].toRow(),
      <Widget>[
        TextWidget.body(
          '发行总量'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.coinInfo.totalIssuance}',
          size: 26.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(44.w).marginOnly(top: 10.w),
      <Widget>[
        TextWidget.body(
          '流通总量'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.coinInfo.totalCirculation}',
          size: 26.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(44.w).marginOnly(top: 10.w),
      <Widget>[
        TextWidget.body(
          '发行价格'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.coinInfo.crowdfundingPrice}',
          size: 26.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(44.w).marginOnly(top: 10.w),
      <Widget>[
        TextWidget.body(
          '发行时间'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.coinInfo.publishTime}',
          size: 26.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(44.w).marginOnly(top: 10.w),
      <Widget>[
        TextWidget.body(
          '白皮书地址'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        <Widget>[
          TextWidget.body(
            controller.coinInfo.whitePaperLink ?? '',
            size: 26.sp,
            color: AppTheme.color000,
          ),
          SizedBox(width: 10.w),
          ButtonWidget(
            text: '复制'.tr,
            height: 44,
            borderRadius: 10,
            backgroundColor: AppTheme.primary,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            onTap: () {
              // 复制
              ClipboardUtils.copy(controller.coinInfo.whitePaperLink ?? '');
            },
          )
        ].toRow()
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(44.w).marginOnly(top: 10.w),
      <Widget>[
        TextWidget.body(
          '官网地址'.tr,
          size: 22.sp,
          color: AppTheme.color999,
        ),
        <Widget>[
          TextWidget.body(
            controller.coinInfo.officialWebsiteLink ?? '',
            size: 26.sp,
            color: AppTheme.color000,
          ),
          SizedBox(width: 10.w),
          ButtonWidget(
            text: '复制'.tr,
            height: 44,
            borderRadius: 10,
            backgroundColor: AppTheme.primary,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            onTap: () {
              // 复制
              ClipboardUtils.copy(controller.coinInfo.officialWebsiteLink ?? '');
            },
          )
        ].toRow(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(44.w).marginOnly(top: 10.w),
      SizedBox(height: 20.w),
      TextWidget.body(
        '简介'.tr,
        size: 30.sp,
        color: AppTheme.color000,
      ),
      SizedBox(height: 20.w),
      HtmlWidget(
        controller.coinInfo.coinContent ?? '',
        // 设置渲染模式
        renderMode: RenderMode.column,
        // 设置文本样式
        textStyle: TextStyle(
          fontSize: 28.sp,
          color: AppTheme.color000,
          height: 1.5,
        ),
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w).tight(width: 750.w);
  }

  // 顶部的可滚动内容：SingleChildScrollView
  Widget _buildTop() {
    return SingleChildScrollView(
      child: <Widget>[
        SizedBox(height: 30.w),
        _buildHeader(),
        _buildPeriodButtons(),
        SizedBox(
          width: 750.w,
          height: 750.w,
          child: KChartWidget(
            controller.datas,
            // ChartStyle(),
            // ChartColors()
            _getChartStyle(),
            _getChartColors(),
            isLine: false,
            isTapShowInfoDialog: true,
            mainState: controller.mainState,
            secondaryState: controller.secondaryState,
            volHidden: true, // 隐藏量
            isTrendLine: false, // 显示趋势线
            verticalTextAlignment: VerticalTextAlignment.right, // 将价格Y轴显示在右侧
          ),
        ),
        _buildIndicatorButtons(),
        _buildTab(),
        if (controller.bottomTabIndex == 0)
          _buildBuySell()
        else if (controller.bottomTabIndex == 1)
          _buildLatest()
        else if (controller.bottomTabIndex == 2)
          _buildCoinInfo()
      ].toColumn(),
    );
  }

  // 底部固定按钮
  Widget _buildBottom() {
    return <Widget>[
      ButtonWidget(
        text: '买入'.tr,
        width: 335,
        height: 80,
        borderRadius: 10,
        backgroundColor: AppTheme.colorGreen,
        textColor: Colors.white,
        onTap: () {
          // 买入
          controller.onBuySell(1);
        },
      ),
      ButtonWidget(
        text: '卖出'.tr,
        width: 335,
        height: 80,
        borderRadius: 10,
        backgroundColor: AppTheme.colorRed,
        textColor: Colors.white,
        onTap: () {
          // 卖出
          controller.onBuySell(2);
        },
      ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingHorizontal(30.w)
        .tight(width: 750.w, height: 110.w)
        .backgroundColor(AppTheme.blockBgColor);
  }

  // 主视图
  Widget _buildView() {
    return Column(
      children: [
        // 顶部可滚动内容
        _buildTop().expanded(),
        // 底部固定按钮
        if (controller.router != 'option') _buildBottom()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContractKChartController>(
      init: ContractKChartController(),
      id: "contract_k_chart",
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
              height: 44,
              titleWidget: <Widget>[
                // 点击导航弹出自定义内容
                <Widget>[
                  TextWidget.body(
                    controller.pairName,
                    size: 32.sp,
                    weight: FontWeight.bold,
                    color: AppTheme.color000,
                  ),
                  if (controller.router != 'option')
                    Icon(
                      Icons.arrow_drop_down,
                      size: 32,
                      color: AppTheme.color000,
                    ),
                ].toRow().onTap(() {
                  if (controller.router != 'option') _scaffoldKey.currentState?.openDrawer();
                }),
                // SizedBox(width: 20.w,),
                // TextWidget.body(controller.pairRatio,size: 26.sp,color: controller.pairRatio.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,),
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              titleColor: AppTheme.color000,
              titleFontWeight: FontWeight.w600,
              backgroundColor: AppTheme.navBgColor,
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
              ]),
          body: _buildView(),
        );
      },
    );
  }

  // 币种导航栏
  Widget _buildCoinNav() {
    return GetBuilder<ContractKChartController>(
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
                    size: 24.sp,
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
              size: 20.sp,
              color: AppTheme.color999,
            ).width(150.w),
            TextWidget.body(
              '最新价'.tr,
              size: 20.sp,
              color: AppTheme.color999,
            ).width(200.w),
            TextWidget.body(
              '涨跌幅'.tr,
              size: 20.sp,
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
                        size: 20.sp,
                        color: AppTheme.color000,
                      ).width(150.w),
                      TextWidget.body(
                        '${item.price}',
                        size: 20.sp,
                        color: AppTheme.color000,
                      ).width(200.w),
                      TextWidget.body(
                        '${item.increaseStr}',
                        size: 20.sp,
                        color: item.increaseStr?.startsWith('-') == true ? AppTheme.colorRed : AppTheme.colorGreen,
                        textAlign: TextAlign.right,
                      ).width(120.w),
                    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).height(108.w).border(bottom: 1, color: AppTheme.borderLine).onTap(() {
                      Get.back();
                      controller.changeSymbol(item.pairName ?? '');
                    });
                  },
                  itemCount: controller.getMarketList(controller.tabIndex).length,
                ).expanded()
        ].toColumn();
      },
    );
  }
}
