import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class SubscribePage extends GetView<SubscribeController> {
  const SubscribePage({super.key});

  // 发行价格
  Widget _buildPrice() {
    return <Widget>[
      ImgWidget(
        path: 'assets/images/home14.png',
        width: 690.w,
        height: 143.w,
      ),
      <Widget>[
        <Widget>[
          <Widget>[
            ImgWidget(
              path: 'assets/images/home15.png',
              width: 36.w,
              height: 36.w,
            ),
            SizedBox(
              width: 12.w,
            ),
            TextWidget.body(
              '发行价'.tr,
              size: 28.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
          TextWidget.body(
            '1${controller.selectedSubscribe?.coinName ?? ''}',
            size: 28.sp,
            color: AppTheme.color000,
            weight: FontWeight.w600,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        SizedBox(
          height: 20.w,
        ),
        <Widget>[
          TextWidget.body(
            '≈${controller.selectedSubscribe?.issuePrice ?? '0'}USDT',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.end),
      ].toColumn().padding(top: 30.w, left: 30.w, right: 30.w, bottom: 0)
    ].toStack().tight(width: 690.w, height: 143.w);
  }

  // 申购币种
  Widget _buildCoin() {
    return <Widget>[
      <Widget>[
        TextWidget.body(
          '申购币种'.tr,
          size: 28.sp,
          color: AppTheme.color000,
        ),
        <Widget>[
          TextWidget.body(
            controller.selectedSubscribe?.coinName ?? '',
            size: 28.sp,
            color: AppTheme.color000,
          ),
          // SizedBox(width: 12.w,),
          // ImgWidget(path: 'assets/images/usdt.png',width: 36.w,height: 36.w,),
        ].toRow(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '预计上线时间'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          controller.selectedSubscribe?.expectedTimeOnline ?? '',
          size: 24.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      <Widget>[
        TextWidget.body(
          '申购时间'.tr,
          size: 24.sp,
          color: AppTheme.color999,
        ),
        TextWidget.body(
          '${controller.selectedSubscribe?.startSubscriptionTime ?? ''} - ${controller.selectedSubscribe?.endSubscriptionTime ?? ''}',
          size: 24.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 30.w),
      TDDivider(
        height: 1,
        color: AppTheme.dividerColor,
      ),
    ].toColumn();
  }

  // 选择币种
  Widget _buildCoinType() {
    return <Widget>[
      <Widget>[
        TextWidget.body(
          '申购'.tr,
          size: 28.sp,
          color: AppTheme.color000,
        ),
        <Widget>[
          TextWidget.body(
            '每人限购：'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          TextWidget.body(
            '${controller.selectedSubscribe?.totalPurchaseCurrency ?? '0'}USDT',
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ].toRow(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      <Widget>[
        <Widget>[
          // ImgWidget(path: 'assets/images/usdt.png',width: 40.w,height: 40.w,),
          // SizedBox(width: 12.w,),
          TextWidget.body(
            controller.selectedSubscribe?.coinName ?? '',
            size: 28.sp,
            color: AppTheme.color000,
          ),
        ].toRow(),
        Icon(
          Icons.arrow_forward_ios,
          size: 24.w,
          color: AppTheme.color999,
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(88.w)
          .decorated(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: AppTheme.borderLine, width: 1),
          )
          .marginOnly(bottom: 20.w)
          .onTap(() {
        controller.showCoinPicker();
      }),
      // if (controller.selectedSubscribe?.coinName != 'BB')
      //   TextWidget.body(
      //     '${'支付比例：'.tr}${controller.selectedSubscribe?.hashRate ?? 0}% ${'算力'.tr} + ${100 - (controller.selectedSubscribe?.hashRate ?? 0)}% USDT',
      //     size: 24.sp,
      //     color: AppTheme.color999,
      //   ).marginOnly(bottom: 20.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  // 申购数量
  Widget _buildNumber() {
    return <Widget>[
      <Widget>[
        TextWidget.body(
          '申购金额'.tr,
          size: 28.sp,
          color: AppTheme.color000,
        ),
        TextWidget.body(
          '（${controller.selectedSubscribe?.minimumPurchase ?? 0}-${controller.selectedSubscribe?.maximumPurchase ?? 0}USDT）',
          size: 28.sp,
          color: AppTheme.color000,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).marginOnly(bottom: 20.w),
      // 滑块选择：范围100-3000
      Slider(
        value: controller.progress.toDouble(),
        min: 100,
        max: 3000,
        divisions: 290, // 3000-100=2900，每10一个刻度
        label: '${controller.progress}USDT',
        activeColor: AppTheme.colorGreen,
        inactiveColor: AppTheme.color999,
        onChanged: (double value) {
          controller.onSliderChange(value);
        },
      ),

      // if (controller.selectedSubscribe?.package != null && controller.selectedSubscribe?.coinName != 'BB')
      //   <Widget>[
      //     for (var item in controller.selectedSubscribe?.package ?? [])
      //       ButtonWidget(
      //         text: '$item',
      //         height: 66,
      //         borderRadius: 6,
      //         backgroundColor: controller.currentNum == item ? AppTheme.primary : Colors.transparent,
      //         textColor: controller.currentNum == item ? Colors.white : AppTheme.color999,
      //         padding: EdgeInsets.only(left: 30.w, right: 30.w),
      //         showBorder: true,
      //         borderColor: controller.currentNum == item ? AppTheme.primary : AppTheme.color999,
      //         onTap: () {
      //           controller.onNumChange(item);
      //         },
      //       ).marginOnly(right: 30.w),
      //   ].toRow()
      // else
      <Widget>[
        InputWidget(
          placeholder: "请输入申购数量".tr,
          controller: controller.numberController,
          onBlur: controller.onInputBlur,
          onChanged: controller.onNumberChanged,
          readOnly: false,
          keyboardType: TextInputType.number,
        ).expanded(),
        TextWidget.body(
          '全部'.tr,
          size: 26.sp,
          color: AppTheme.color000,
        ).onTap(controller.onAll),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .height(88.w)
          .decorated(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: AppTheme.borderLine, width: 1),
          )
          .marginOnly(bottom: 20.w),
      <Widget>[
        TextWidget.body(
          '=',
          size: 24.sp,
          color: AppTheme.color999,
        ),
        SizedBox(
          width: 5.w,
        ),
        TextWidget.body(
          // 输入框中的值 需要* 1000
          '${((double.tryParse(controller.numberController.text) ?? 0) * 1000)}${controller.selectedSubscribe?.coinName ?? ''}',
          size: 24.sp,
          color: AppTheme.color000,
        ),
      ].toRow()
    ].toColumn();
  }

  // 申购周期
  Widget _buildCycle() {
    return <Widget>[
      TextWidget.body(
        '申购周期'.tr,
        size: 28.sp,
        color: AppTheme.color000,
      ).marginOnly(bottom: 20.w),
      SubscribeStepWidget(
        steps: controller.timeList,
        current: controller.current,
        axis: Axis.vertical, // 或 Axis.vertical
        themeColor: AppTheme.color000,
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).width(690.w);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SingleChildScrollView(
        child: <Widget>[
          _buildPrice().paddingHorizontal(30.w),
          SizedBox(
            height: 30.w,
          ),
          _buildCoin().paddingHorizontal(30.w),
          SizedBox(
            height: 30.w,
          ),
          _buildCoinType().paddingHorizontal(30.w),
          SizedBox(
            height: 30.w,
          ),
          _buildNumber().paddingHorizontal(30.w),
          SizedBox(
            height: 30.w,
          ),
          TDDivider(
            height: 16.w,
            color: AppTheme.dividerColor,
          ),
          SizedBox(
            height: 30.w,
          ),
          _buildCycle().paddingHorizontal(30.w),
          SizedBox(
            height: 30.w,
          ),
        ].toColumn(),
      ).expanded(),
      SizedBox(
        height: 20.w,
      ),
      ButtonWidget(
        text: '立即申购'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        onTap: controller.submit,
      ).paddingHorizontal(30.w),
      SizedBox(
        height: 30.w,
      ),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscribeController>(
      init: SubscribeController(),
      id: "subscribe",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '申购'.tr,
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
            rightBarItems: [
              TDNavBarItem(
                  iconWidget: ImgWidget(
                    path: 'assets/images/home13.png',
                    width: 36.w,
                    height: 36.w,
                  ),
                  padding: EdgeInsets.only(right: 20.w),
                  action: () {
                    controller.onViewProjectDetails();
                  }),
              TDNavBarItem(
                  iconWidget: ImgWidget(
                    path: 'assets/images/mining15.png',
                    width: 36.w,
                    height: 36.w,
                  ),
                  action: () {
                    Get.toNamed('/subscribeRecordPage');
                  }),
            ],
          ),
          body: _buildView(),
        );
      },
    );
  }
}
