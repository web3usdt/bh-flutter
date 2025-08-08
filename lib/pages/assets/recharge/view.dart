import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class RechargePage extends GetView<RechargeController> {
  const RechargePage({super.key});

  // 顶部
  Widget _buildTop(BuildContext context) {
    return <Widget>[
      // 选择币种
      <Widget>[
        TextWidget.body('选择币种'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          TextWidget.body(controller.selectedCoin, size: 30.sp, color: AppTheme.color000),
          Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color000)
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .height(96.w)
            .paddingHorizontal(30.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .onTap(() {
          controller.showCoinPicker(context);
        })
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 选择网络
      if (controller.selectedCoin == 'USDT')
        <Widget>[
          TextWidget.body('选择网络'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
          <Widget>[
            TextWidget.body(controller.selectedChain, size: 30.sp, color: AppTheme.color000),
            Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color000),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .height(96.w)
              .paddingHorizontal(30.w)
              .backgroundColor(AppTheme.blockTwoBgColor)
              .clipRRect(all: 10.w)
              .onTap(() {
            controller.showChainPicker(context);
          }),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 30.w),

      // 注意事项
      <Widget>[
        <Widget>[
          ImgWidget(
            path: 'assets/images/assets5.png',
            width: 28.w,
            height: 28.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          TextWidget.body('注意事项'.tr, size: 26.sp, color: AppTheme.colorRed),
        ].toRow().marginOnly(bottom: 20.w),
        TextWidget.body(
                '该地址只能接收@chain_@coin的资产，如果充值其他币种，将无法找回!'.trParams(
                  {
                    'chain': controller.selectedChain.toUpperCase(),
                    'coin': controller.selectedCoin.toUpperCase(),
                  },
                ),
                size: 24.sp,
                color: AppTheme.colorRed)
            .marginOnly(bottom: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

      // 二维码
      if (controller.qrCodeContent.isNotEmpty)
        <Widget>[
          QrImageView(
            data: controller.qrCodeContent,
            version: QrVersions.auto,
            size: 380.w,
            gapless: false,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .tight(width: 420.w, height: 420.w)
            .backgroundColor(Colors.white)
            .clipRRect(all: 20.w)
            .marginOnly(bottom: 30.w),

      if (controller.qrCodeContent.isNotEmpty)
        TextWidget.body(controller.qrCodeContent, size: 24.sp, color: AppTheme.color000).marginOnly(bottom: 30.w),
      ButtonWidget(
        text: '复制地址'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: () {
          ClipboardUtils.copy(controller.qrCodeContent);
          Loading.success('复制成功'.tr);
        },
      ),
    ].toColumn().paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 提示
  Widget _buildTips() {
    return <Widget>[
      if (controller.selectedCoin == 'BTC')
        TextWidget.body(
                '1、' +
                    '最小充值金额：@amount @coin，小于最小金额的充值将不会上账且无法返回'.trParams({
                      'amount': '0.0005',
                      'coin': 'BTC'.toUpperCase(),
                    }),
                size: 22.sp,
                color: AppTheme.color999)
            .marginOnly(bottom: 10.w),
      if (controller.selectedCoin == 'ETH')
        TextWidget.body(
                '1、' +
                    '最小充值金额：@amount @coin，小于最小金额的充值将不会上账且无法返回'.trParams({
                      'amount': '0.01',
                      'coin': 'ETH'.toUpperCase(),
                    }),
                size: 22.sp,
                color: AppTheme.color999)
            .marginOnly(bottom: 10.w),
      if (controller.selectedCoin == 'USDT')
        TextWidget.body(
                '1、' +
                    '最小充值金额：@amount @coin，小于最小金额的充值将不会上账且无法返回'.trParams({
                      'amount': '1',
                      'coin': 'USDT',
                    }),
                size: 22.sp,
                color: AppTheme.color999)
            .marginOnly(bottom: 10.w),
      TextWidget.body(
              '2、' +
                  '此地址是您最新的充值地址，当系统收到充值时，将进行自动入账。转账需要由整个区块链网络进行确认，到达@count个网络确认时，您的@coin将被自动存入账户中。'.trParams({
                    'count': '10',
                    'coin': controller.selectedCoin,
                  }),
              size: 22.sp,
              color: AppTheme.color999)
          .marginOnly(bottom: 10.w),
      TextWidget.body(
              '3、' +
                  '请只发送@coin到此地址，发送其他数字货币到此地址会造成永久性的损失。'.trParams({
                    'coin': controller.selectedCoin,
                  }),
              size: 22.sp,
              color: AppTheme.color999)
          .marginOnly(bottom: 10.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).decorated(
          border: Border.all(color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(10.w),
        );
  }

  // 充值记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          return <Widget>[
            <Widget>[
              TextWidget.body('订单状态'.tr, size: 26.sp, color: AppTheme.color666),
              if (item.status == '0') TextWidget.body('审核中'.tr, size: 26.sp, color: AppTheme.color000),
              if (item.status == '1') TextWidget.body('成功'.tr, size: 26.sp, color: AppTheme.colorGreen),
              if (item.status == '2') TextWidget.body('失败'.tr, size: 26.sp, color: AppTheme.colorRed),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('充币金额'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body('${item.amount} ${item.coinName}', size: 26.sp, color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('充币时间'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body(item.createdAt ?? '', size: 26.sp, color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ]
              .toColumn()
              .paddingAll(30.w)
              .decorated(
                border: Border.all(color: AppTheme.borderLine),
                borderRadius: BorderRadius.circular(16.w),
              )
              .marginOnly(top: 20.w);
        },
        childCount: controller.items.length,
      ),
    );
  }

  // 暂无数据
  Widget _buildEmpty() {
    return EmptyState(message: '暂无数据'.tr);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return CustomScrollView(slivers: [
      SizedBox(
        height: 30.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      _buildTop(context).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      _buildTips().sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      TextWidget.body('充值记录'.tr, size: 28.sp, color: AppTheme.color000).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.items.isEmpty) _buildEmpty().sliverToBoxAdapter(),
      _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(
      init: RechargeController(),
      id: "recharge",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '充值'.tr,
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
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
