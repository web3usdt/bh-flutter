import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class WithdrawPage extends GetView<WithdrawController> {
  const WithdrawPage({super.key});

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

      // 提币地址
      <Widget>[
        TextWidget.body('提币地址'.tr, size: 26.sp, color: AppTheme.color000).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入提币地址".tr,
            controller: controller.withdrawAddressController,
          ).expanded(),
          Icon(Icons.add_chart_rounded, size: 32.sp, color: AppTheme.color000).onTap(() {
            controller.jumpWithdrawAddress();
          })
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      TextWidget.body('转账前请务必确认地址及信息无误!一旦转出，不可撤回'.tr, size: 20.sp, color: AppTheme.colorRed).marginOnly(bottom: 30.w),

      // 提币数量
      <Widget>[
        <Widget>[
          TextWidget.body('提币数量'.tr, size: 26.sp, color: AppTheme.color000),
          TextWidget.body(
              '余额:@amount @coin'.trParams({
                'amount': controller.withdrawBalance.usableBalance?.toString() ?? '0',
                'coin': controller.selectedCoin,
              }),
              size: 24.sp,
              color: AppTheme.color999),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入提币数量".tr,
            controller: controller.withdrawAmountController,
          ).expanded(),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 30.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

      // 交易密码
      <Widget>[
        <Widget>[
          TextWidget.body('交易密码'.tr, size: 26.sp, color: AppTheme.color000),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入交易密码".tr,
            controller: controller.payController,
            obscureText: true,
          ).expanded(),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 30.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

      // 如果是邮箱验证
      if (controller.withdrawVerifyIsEmail)
        <Widget>[
          <Widget>[
            TextWidget.body('邮箱验证码'.tr, size: 26.sp, color: AppTheme.color000),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
          <Widget>[
            InputWidget(
              placeholder: "请输入邮箱验证码".tr,
              controller: controller.emailCodeController,
            ).expanded(),
            VerificationCodeWidget(
              mobile: controller.emailCodeController.text,
              type: 'withdraw',
              onRequestCode: (mobile, type) async {
                return await controller.sendPhoneCode();
              },
            )
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingHorizontal(30.w)
              .height(90.w)
              .backgroundColor(AppTheme.blockTwoBgColor)
              .clipRRect(all: 10.w)
              .marginOnly(bottom: 30.w),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),

      <Widget>[
        TextWidget.body(
            '最小提币额：@amount @coin'.trParams({
              'amount': controller.withdrawBalance.withdrawalMin.toString(),
              'coin': controller.selectedCoin,
            }),
            size: 24.sp,
            color: AppTheme.color000),
        if (controller.selectedCoin == 'USDT')
          TextWidget.body(
              '手续费：@amount USDT'.trParams({
                'amount': controller.withdrawBalance.withdrawalFee.toString(),
              }),
              size: 24.sp,
              color: AppTheme.color000)
        else
          TextWidget.body(
              '手续费：@feeRate%'.trParams({
                'feeRate': controller.withdrawBalance.withdrawalFeeRate.toString(),
              }),
              size: 24.sp,
              color: AppTheme.color000)
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),

      ButtonWidget(
        text: '提币'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: controller.submit,
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 提示
  Widget _buildTips() {
    return <Widget>[
      TextWidget.body('1、请仔细检查并输入正确的提币钱包地址；'.tr, size: 22.sp, color: AppTheme.color999).marginOnly(bottom: 10.w),
      TextWidget.body('2、发送不对应的数字货币到钱包地址会造成永久性的损失；'.tr, size: 22.sp, color: AppTheme.color999).marginOnly(bottom: 10.w),
      TextWidget.body('3、提币手续费将从提币数量中扣除。'.tr, size: 22.sp, color: AppTheme.color999).marginOnly(bottom: 10.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).decorated(
          border: Border.all(color: AppTheme.borderLine),
          borderRadius: BorderRadius.circular(10.w),
        );
  }

  // 提币记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          return <Widget>[
            <Widget>[
              TextWidget.body('订单状态'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body(item.statusText ?? '',
                  size: 26.sp,
                  color: item.status == 9
                      ? AppTheme.color999
                      : item.status == 0
                          ? AppTheme.color000
                          : item.status == 2
                              ? AppTheme.colorRed
                              : AppTheme.colorGreen),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('提币金额'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body('${item.amount} ${item.coinName}', size: 26.sp, color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('提币时间'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body(item.createdAt ?? '', size: 26.sp, color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            if (item.status == 2)
              TextWidget.body(
                      '驳回原因：@reason'.trParams({
                        'reason': item.remark ?? '',
                      }),
                      size: 24.sp,
                      color: AppTheme.colorRed)
                  .marginOnly(top: 20.w),
            if (item.status == 0)
              <Widget>[
                ButtonWidget(
                  text: '撤销'.tr,
                  backgroundColor: AppTheme.colorRed,
                  textColor: Colors.white,
                  borderRadius: 10,
                  height: 52,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  onTap: () {
                    controller.cancelWithdraw(item.id ?? 0);
                  },
                )
              ].toRow(mainAxisAlignment: MainAxisAlignment.end).marginOnly(top: 20.w),
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
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
      TextWidget.body('提币记录'.tr, size: 28.sp, color: AppTheme.color000).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      controller.items.isEmpty ? _buildEmpty().sliverToBoxAdapter() : _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawController>(
      init: WithdrawController(),
      id: "withdraw",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '提币'.tr,
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
