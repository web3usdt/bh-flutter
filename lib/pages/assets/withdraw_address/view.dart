import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class WithdrawAddressPage extends GetView<WithdrawAddressController> {
  const WithdrawAddressPage({super.key});

  // 地址列表
  Widget _buildAddressList(BuildContext context) {
    return SingleChildScrollView(
      child: <Widget>[
        for (var item in controller.withdrawAddressList)
          <Widget>[
            <Widget>[
              ImgWidget(path: item.coinIcon ?? '', width: 40.w, height: 40.w, radius: 20.w),
              SizedBox(
                width: 14.w,
              ),
              TextWidget.body(item.coinName ?? '', size: 28.sp, color: AppTheme.color000),
            ].toRow(),
            for (var v in item.list)
              <Widget>[
                <Widget>[
                  <Widget>[
                    if (controller.isManage)
                      Icon(Icons.check_circle, size: 32.sp, color: controller.isSelected(v) ? AppTheme.colorRed : AppTheme.color999)
                          .marginOnly(right: 10.w),
                    TextWidget.body(v.addressNote ?? '', size: 26.sp, color: AppTheme.color000),
                  ].toRow(),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                SizedBox(
                  height: 20.w,
                ),
                TextWidget.body(v.address ?? '', size: 26.sp, color: AppTheme.color000),
                if (controller.type != 'withdraw') TDDivider(height: 1, color: AppTheme.borderLine).marginOnly(top: 20.w, bottom: 20.w),
                if (controller.type != 'withdraw')
                  <Widget>[
                    <Widget>[
                      TextWidget.body('删除'.tr, size: 26.sp, color: AppTheme.color999),
                      SizedBox(
                        width: 10.w,
                      ),
                      Icon(Icons.delete_forever, size: 32.sp, color: AppTheme.color999),
                    ].toRow().onTap(() {
                      controller.delete(v.id ?? 0);
                    }),
                    SizedBox(
                      width: 30.w,
                    ),
                    <Widget>[
                      TextWidget.body('编辑'.tr, size: 26.sp, color: AppTheme.color999),
                      SizedBox(
                        width: 10.w,
                      ),
                      Icon(Icons.edit_note, size: 32.sp, color: AppTheme.color999),
                    ].toRow()
                  ].toRow(mainAxisAlignment: MainAxisAlignment.end),
              ]
                  .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                  .paddingAll(30.w)
                  .backgroundColor(AppTheme.blockTwoBgColor)
                  .clipRRect(all: 10.w)
                  .marginOnly(top: 20.w)
                  .onTap(() {
                controller.onSelect(v);
              })
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .paddingAll(30.w)
              .tight(width: 690.w)
              .backgroundColor(AppTheme.blockBgColor)
              .clipRRect(all: 10.w)
              .marginOnly(top: 20.w),
        TextWidget.body('1、地址簿可以用来管理您的常用地址，往地址簿中存在的地址发起提币时，无需进行多重校验。'.tr, size: 24.sp, color: AppTheme.color999).marginOnly(top: 20.w),
        TextWidget.body('2、API已支持自动提币，使用API提币时，只允许网地址中存在的地址发起提币。'.tr, size: 24.sp, color: AppTheme.color999).marginOnly(top: 10.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    );
  }

  // 底部添加地址按钮
  Widget _buildAddAddressButton() {
    return <Widget>[
      if (!controller.isManage)
        ButtonWidget(
          text: '添加地址'.tr,
          width: 690,
          height: 74,
          borderRadius: 37,
          backgroundColor: AppTheme.color000,
          textColor: Colors.white,
          onTap: () {
            controller.goAddAddress();
          },
        )
      // else
      // ButtonWidget(
      //   text: '删除',
      //   width: 690,
      //   height: 88,
      //   borderRadius: 44,
      //   backgroundColor: AppTheme.colorRed,
      //   textColor: Colors.white,
      //   onTap: (){
      //     controller.delete();
      //   },
      // )
    ].toColumn();
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      Expanded(child: _buildAddressList(context)),
      _buildAddAddressButton(),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawAddressController>(
      init: WithdrawAddressController(),
      id: "withdraw_address",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: TDNavBar(
            height: 44,
            title: '提币地址'.tr,
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
            // rightBarItems: [
            //   TDNavBarItem(
            //     iconWidget: TextWidget.body(controller.isManage ? '完成' : '管理',size: 26.sp,color: AppTheme.color000),
            //     action: (){
            //       controller.switchManage();
            //     }
            //   ),
            // ],
          ),
          body: SafeArea(
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
