import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class TransferPage extends GetView<TransferController> {
  const TransferPage({super.key});

  // 选择账户
  Widget _buildAccount(BuildContext context) {
    return <Widget>[
      <Widget>[
        // 从账户
        <Widget>[
          TextWidget.body('从'.tr, size: 24.sp, color: AppTheme.color999),
          SizedBox(
            height: 15.w,
          ),
          <Widget>[
            TextWidget.body(controller.fromAccount, size: 26.sp, color: AppTheme.color000),
            Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color000)
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center)
            .paddingOnly(left: 30.w, right: 50.w)
            .tight(width: 330.w, height: 120.w)
            .decorated(
              color: AppTheme.blockBgColor,
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine),
            )
            .onTap(() {
          controller.showFromAccountPicker(context);
        }),

        // 到账户
        <Widget>[
          TextWidget.body('至'.tr, size: 24.sp, color: AppTheme.color999),
          SizedBox(
            height: 15.w,
          ),
          <Widget>[
            TextWidget.body(controller.toAccount, size: 26.sp, color: AppTheme.color000),
            Icon(Icons.arrow_forward_ios, size: 24.sp, color: AppTheme.color000)
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center)
            .paddingOnly(left: 50.w, right: 30.w)
            .tight(width: 330.w, height: 120.w)
            .decorated(
              color: AppTheme.blockBgColor,
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine),
            )
            .onTap(() {
          controller.showToAccountPicker(context);
        }).positioned(right: 0),
        ImgWidget(path: 'assets/images/assets6.png', width: 82.w, height: 82.w).onTap(() {
          controller.switchAccount();
        }).positioned(left: 304.w, top: 20.w),
      ].toStack().tight(width: 690.w, height: 120.w),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

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

      // 划转数量
      <Widget>[
        <Widget>[
          TextWidget.body('划转数量'.tr, size: 26.sp, color: AppTheme.color000),
          TextWidget.body(
              '余额:@amount @coin'.trParams({
                'amount': controller.transferBalance.usableBalance ?? '0',
                'coin': controller.selectedCoin,
              }),
              size: 24.sp,
              color: AppTheme.color999),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入划转数量".tr,
            controller: controller.withdrawAmountController,
          ).expanded(),
          TextWidget.body('全部'.tr, size: 26.sp, color: AppTheme.color000),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .paddingHorizontal(30.w)
            .height(90.w)
            .backgroundColor(AppTheme.blockTwoBgColor)
            .clipRRect(all: 10.w)
            .marginOnly(bottom: 30.w)
            .onTap(() {
          controller.withdrawAmountController.text = controller.transferBalance.usableBalance ?? '0';
          controller.update(["transfer"]);
        }),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 20.w),

      ButtonWidget(
        text: '划转'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: controller.submit,
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 划转记录
  Widget _buildRecord() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = controller.items[index];
          return <Widget>[
            <Widget>[
              TextWidget.body('订单状态'.tr, size: 26.sp, color: AppTheme.color666),
              if (item.orderStatus == 0) TextWidget.body('审核中'.tr, size: 26.sp, color: AppTheme.color000),
              if (item.orderStatus == 1) TextWidget.body('成功'.tr, size: 26.sp, color: AppTheme.colorGreen),
              if (item.orderStatus == 2) TextWidget.body('失败'.tr, size: 26.sp, color: AppTheme.colorRed),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('划转金额'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body('${item.amount} ${item.coinName}', size: 26.sp, color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('划转方向'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body(
                  '${item.drawOutDirection == 'UserWallet'  ? '资金账户'.tr 
                  : item.drawOutDirection == 'ContractAccount' ? '合约账户'.tr 
                  : item.drawOutDirection == 'gameAccount' ? '游戏账户'.tr 
                  : item.drawOutDirection == 'EarnAccount' ? '理财账户'.tr : '挖矿账户'.tr}  - ${item.intoDirection == 'UserWallet' ? '资金账户'.tr 
                  : item.intoDirection == 'ContractAccount' ? '合约账户'.tr 
                  : item.intoDirection == 'gameAccount' ? '游戏账户'.tr 
                  : item.intoDirection == 'EarnAccount' ? '理财账户'.tr  
                  : '挖矿账户'.tr}',
                  size: 26.sp,
                  color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
            <Widget>[
              TextWidget.body('划转时间'.tr, size: 26.sp, color: AppTheme.color666),
              TextWidget.body(DataUtils.toDateTimeStr(item.datetime), size: 26.sp, color: AppTheme.color000),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            // <Widget>[
            //   TextWidget.body('从-${item.drawOutDirection }'.tr, size: 26.sp, color: AppTheme.color666),
            //   TextWidget.body('-${item.intoDirection }'.tr, size: 26.sp, color: AppTheme.color666),
            // ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
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
      _buildAccount(context).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 30.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      _buildTop(context).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      SizedBox(
        height: 40.w,
      ).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      TextWidget.body('划转记录'.tr, size: 28.sp, color: AppTheme.color000).sliverToBoxAdapter().sliverPaddingHorizontal(30.w),
      if (controller.items.isEmpty) _buildEmpty().sliverToBoxAdapter(),
      _buildRecord().sliverPaddingHorizontal(30.w),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferController>(
      init: TransferController(),
      id: "transfer",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '划转'.tr,
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
