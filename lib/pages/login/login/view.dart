import 'package:BBIExchange/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/pages/mine/develop_mode/controller.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  Widget _buildBottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget.body(
          '${ConfigService.to.appName} V${ConfigService.to.version}(${ConfigService.to.buildNumber})',
          size: 24.sp,
          color: AppTheme.color999,
        ).padding(top: 20.w, bottom: 20.w, left: 20.w, right: 20.w).onContinuousClick(
              onTrigger: () => Get.toNamed(AppRoutes.networkDiagnosis),
            ),
      ],
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      SizedBox(height: 40.w),
      TextWidget.body(
        '登录'.tr,
        size: 44.sp,
        color: AppTheme.color000,
        weight: FontWeight.w600,
      ).onTap(() => Get.find<DevelopModeController>().switchTestEnv()),
      SizedBox(height: 20.w),
      TextWidget.body(
        'Hello!欢迎来到BBI Exchange'.tr,
        size: 28.sp,
        color: AppTheme.color000,
      ),
      SizedBox(height: 80.w),

      // 账号
      <Widget>[
        // TextWidget.body(
        //   '账号'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 20.w),
        <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return controller.accountHistory.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  controller.accountController.text = selection;
                  controller.passwordController.clear();
                  FocusScope.of(context).unfocus();
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "请输入账号".tr,
                    ),
                    onChanged: (text) {
                      controller.accountController.text = text;
                    },
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                  );
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200, maxWidth: constraints.maxWidth),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return InkWell(
                              onTap: () {
                                onSelected(option);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 40.w),

      // 登陆密码
      <Widget>[
        // TextWidget.body(
        //   '登陆密码'.tr,
        //   size: 28.sp,
        //   color: AppTheme.color000,
        // ).marginOnly(bottom: 20.w),
        <Widget>[
          InputWidget(
            placeholder: "请输入登陆密码".tr,
            controller: controller.passwordController,
            obscureText: true,
          ).expanded(),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingHorizontal(30.w).height(90.w).decorated(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: AppTheme.borderLine, width: 1),
              color: AppTheme.blockBgColor,
            ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).marginOnly(bottom: 40.w),

      <Widget>[
        TextWidget.body(
          '忘记密码？'.tr,
          size: 26.sp,
          color: AppTheme.color8B8B8B,
        ).padding(top: 10.w, bottom: 10.w, left: 30.w).onTap(() => Get.toNamed(AppRoutes.forgotPassword)),
      ].toRow(mainAxisAlignment: MainAxisAlignment.end),

      ButtonWidget(
        text: '立即登录'.tr,
        height: 74,
        borderRadius: 37,
        backgroundColor: AppTheme.color000,
        margin: const EdgeInsets.all(0),
        onTap: controller.submit,
      ).marginOnly(bottom: 30.w, top: 40.w),
      <Widget>[
        ImgWidget(
          path: 'assets/images/home24.png',
          width: 24.w,
          height: 24.w,
        ),
        TextWidget.body(
          '解绑谷歌验证'.tr,
          size: 26.sp,
          color: AppTheme.color000,
        ),
        ImgWidget(
          path: 'assets/images/home22.png',
          width: 20.w,
          height: 20.w,
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .paddingHorizontal(30.w)
          .tight(height: 68.w)
          .decorated(
            border: Border.all(color: AppTheme.borderLine, width: 1),
            borderRadius: BorderRadius.circular(34.w),
          )
          .onTap(() => Get.toNamed('/removeGooglePage')),

      SizedBox(height: 20.w),
      <Widget>[
        <Widget>[
          TextWidget.body(
            '还没有账号？'.tr,
            size: 24.sp,
            color: AppTheme.color999,
          ),
          TextWidget.body(
            '立即注册'.tr,
            size: 24.sp,
            color: AppTheme.color000,
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.center)
            .padding(top: 10.w, bottom: 10.w, left: 30.w, right: 30.w)
            .onTap(() => Get.toNamed(AppRoutes.register)),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: TDNavBar(
              padding: EdgeInsets.only(left: 0, right: 30.w), // 重写左右内边距
              centerTitle: false, // 不显示标题
              height: 44, // 高度
              backgroundColor: AppTheme.navBgColor,
              screenAdaptation: true,
              useDefaultBack: controller.isSwitch,
              rightBarItems: [
                TDNavBarItem(
                  padding: EdgeInsets.only(right: 20.w),
                  iconWidget: <Widget>[
                    <Widget>[
                      TextWidget(
                        text: '${'当前节点'.tr}: ',
                        size: 24.sp,
                        color: AppTheme.color8B8B8B,
                      ),
                      TextWidget(
                        text: Storage().getString('nodeName'),
                        size: 24.sp,
                        color: AppTheme.primary,
                      )
                    ].toRow().onTap(() => Get.toNamed(AppRoutes.node)),
                    // SizedBox(width: 10.w),
                    // TextWidget.body(
                    //   ConfigService.to.locale.toLanguageTag() == 'zh-CN'
                    //       ? '简体中文'
                    //       : ConfigService.to.locale.toLanguageTag() == 'zh-TW'
                    //           ? '繁体中文'
                    //           : ConfigService.to.locale.toLanguageTag() == 'en-US'
                    //               ? 'English'
                    //               : '',
                    //   size: 24.sp,
                    //   color: AppTheme.color000,
                    // )
                    // .onTap(() => controller.setLanguageSetting()),
                    // Icon(
                    //   Icons.arrow_drop_down,
                    //   size: 32.sp,
                    //   color: AppTheme.color8B8B8B,
                    // ),
                  ]
                      .toRow()
                      .height(60.w)
                      .padding(left: 30.w, right: 20.w)
                      .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(80.w)),
                ),
                TDNavBarItem(
                  padding: EdgeInsets.only(right: 20.w),
                  iconWidget: <Widget>[
                    TextWidget.body(
                      ConfigService.to.locale.toLanguageTag() == 'zh-CN'
                          ? '简体中文'
                          : ConfigService.to.locale.toLanguageTag() == 'zh-TW'
                              ? '繁体中文'
                              : ConfigService.to.locale.toLanguageTag() == 'en-US'
                                  ? 'English'
                                  : '',
                      size: 24.sp,
                      color: AppTheme.color000,
                    ).onTap(() => controller.setLanguageSetting()),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 32.sp,
                      color: AppTheme.color8B8B8B,
                    ),
                  ]
                      .toRow()
                      .height(60.w)
                      .padding(left: 30.w, right: 20.w)
                      .decorated(border: Border.all(width: 1, color: AppTheme.borderLine), borderRadius: BorderRadius.circular(80.w)),
                ),
              ]),
          body: SingleChildScrollView(
            child: _buildView(),
          ),
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }
}
