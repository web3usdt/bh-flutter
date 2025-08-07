import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:happy/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class NoticeDetailPage extends GetView<NoticeDetailController> {
  const NoticeDetailPage({super.key});

  // 头部
  Widget _buildHeader() {
    return <Widget>[
      TextWidget.body(
        controller.title,
        size: 28.sp,
        weight: FontWeight.w600,
        color: AppTheme.color000,
      ),
      SizedBox(
        height: 20.w,
      ),
      <Widget>[
        Icon(
          Icons.access_time_outlined,
          size: 28.sp,
          color: AppTheme.color000,
        ),
        SizedBox(
          width: 10.w,
        ),
        TextWidget.body(
          controller.time,
          color: AppTheme.color666,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center)
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.center)
        .paddingHorizontal(30.w)
        .paddingOnly(top: 20.w, bottom: 20.w)
        .card(color: AppTheme.blockBgColor);
  }

  // 内容详情
  Widget _buildContent() {
    return <Widget>[
      HtmlWidget(
        controller.content,
        // 设置渲染模式
        renderMode: RenderMode.column,
        // 设置文本样式
        textStyle: TextStyle(
          fontSize: 28.sp,
          color: AppTheme.color000,
          height: 1.5,
        ),
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(30.w).width(690.w).card(color: AppTheme.blockBgColor);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(
        height: 30.w,
      ),
      _buildHeader(),
      SizedBox(
        height: 20.w,
      ),
      _buildContent(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoticeDetailController>(
      init: NoticeDetailController(),
      id: "notice_detail",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
            height: 44,
            title: '消息详情'.tr,
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
          ),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
