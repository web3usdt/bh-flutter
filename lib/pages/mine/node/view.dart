import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class NodePage extends GetView<NodeController> {
  const NodePage({super.key});
  // 标题
  Widget _buildTitle() {
    return <Widget>[
      TextWidget.body(
        '节点速度',
        size: 28.sp,
        color: AppTheme.color000,
      ),
      <Widget>[
        <Widget>[
          <Widget>[].toRow().tight(width: 12.w, height: 12.w).backgroundColor(const Color(0xff32BE67)).clipRRect(all: 6.w),
          SizedBox(width: 12.w),
          TextWidget.body(
            '快',
            size: 28.sp,
            color: AppTheme.color000,
          ),
        ].toRow(),
        SizedBox(width: 40.w),
        <Widget>[
          <Widget>[].toRow().tight(width: 12.w, height: 12.w).backgroundColor(const Color(0xffFFBA00)).clipRRect(all: 6.w),
          SizedBox(width: 12.w),
          TextWidget.body(
            '中',
            size: 28.sp,
            color: AppTheme.color000,
          ),
        ].toRow(),
        SizedBox(width: 40.w),
        <Widget>[
          <Widget>[].toRow().tight(width: 12.w, height: 12.w).backgroundColor(const Color(0xffED3C3E)).clipRRect(all: 6.w),
          SizedBox(width: 12.w),
          TextWidget.body(
            '慢',
            size: 28.sp,
            color: AppTheme.color000,
          ),
        ].toRow(),
      ].toRow(),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(width: 690.w, height: 88.w).paddingHorizontal(30.w).decorated(
          borderRadius: BorderRadius.circular(10.w),
          color: AppTheme.blockBgColor,
        );
  }

  // 节点列表
  Widget _buildNodeList() {
    return <Widget>[
      ...controller.nodeList.asMap().entries.where((entry) => controller.isShowTestNode || entry.value['name'] != '测试节点').map((entry) {
        final item = entry.value;
        return <Widget>[
          <Widget>[
            if (item['isSelected']) Icon(Icons.check, size: 32.sp, color: AppTheme.primary).marginOnly(right: 10.w),
            TextWidget.body(
              item['name'],
              size: 28.sp,
              color: AppTheme.color000,
            ),
          ].toRow(),
          <Widget>[
            TextWidget.body(
              controller.getSpeedStatusText(item),
              size: 28.sp,
              color: AppTheme.color000,
            ),
            SizedBox(width: 20.w),
            <Widget>[].toRow().tight(width: 12.w, height: 12.w).backgroundColor(Color(controller.getSpeedStatusColor(item))).clipRRect(all: 6.w),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).tight(height: 100.w).paddingHorizontal(30.w).onTap(() {
          controller.selectNode(entry.key);
        });
      }).toList(),
    ].toColumn().backgroundColor(AppTheme.blockBgColor).clipRRect(all: 10.w);
  }

  // 测速按钮
  Widget _buildTestButton() {
    return ButtonWidget(
        text: '重新测试',
        height: 88,
        backgroundColor: AppTheme.blockBgColor,
        borderRadius: 10,
        textColor: AppTheme.color000,
        onTap: () {
          controller.testAllNodesSpeed();
        });
  }

  // 显示测试节点
  Widget _buildTestNode() {
    return ButtonWidget(
        text: '测试节点显示',
        height: 88,
        backgroundColor: AppTheme.blockBgColor,
        borderRadius: 10,
        textColor: AppTheme.color000,
        onTap: () {
          controller.showTestNode();
        });
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 40.w),
      // 标题
      _buildTitle(),
      SizedBox(height: 40.w),
      // 节点列表
      _buildNodeList(),
      SizedBox(height: 120.w),
      // 测速按钮
      _buildTestButton(),
      _buildTestNode().opacity(0),
    ].toColumn().paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NodeController>(
      init: NodeController(),
      id: "node",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '节点'.tr,
            titleColor: AppTheme.color000,
            titleFontWeight: FontWeight.w600,
            backgroundColor: AppTheme.pageBgColor,
            screenAdaptation: true,
            useDefaultBack: false,
            leftBarItems: [
              if (controller.token?.isNotEmpty ?? false)
                TDNavBarItem(
                    icon: TDIcons.chevron_left,
                    iconSize: 24,
                    iconColor: AppTheme.color000,
                    action: () {
                      Get.back();
                    }),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: _buildView(),
            ),
          ),
        );
      },
    );
  }
}
