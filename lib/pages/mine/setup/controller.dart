import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';
import 'package:image_picker/image_picker.dart';

class SetupController extends GetxController {
  SetupController();
  // 用户信息
  late User userInfo;
  // 头像文件
  File? avatarFile;
  // 语言
  String language = '';

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  void _initData() {
    update(["setup"]);
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringUserInfo = Storage().getString('userInfo');
    userInfo = stringUserInfo != "" ? User.fromJson(jsonDecode(stringUserInfo)) : User();
    print('用户信息: ${userInfo.toJson()}');
    update(["userInfo"]);
  }

  // 更换头像
  void changeAvatar() {
    final List<Map<String, dynamic>> actions = [
      {"id": 1, "title": "相机".tr, "type": "camera"},
      {"id": 2, "title": "相册".tr, "type": "gallery"},
    ];
    ActionSheetUtil.showActionSheet(
      context: Get.context!,
      title: '请选择'.tr,
      items: actions,
      onConfirm: (item) async {
        // print('操作类型：${item['type']}');
        try {
          final file = await ImagePicker().pickImage(source: item['type'] == 'camera' ? ImageSource.camera : ImageSource.gallery);
          avatarFile = File(file!.path);
          // print('选择的图片路径：${avatarFile!.path}');
          // String imageUrl = await UploadApi.uploadImage(avatarFile!);
          // print('上传图片接口返回：$imageUrl');
          update(["userinfo"]);
        } catch (e) {
          // print(e.toString());
        }
      },
    );
  }

  // 切换语言
  void setLanguageSetting() async {
    final List<Map<String, dynamic>> languageList = [
      {'id': 0, 'name': '简体中文'},
      {'id': 1, 'name': '繁体中文'},
      {'id': 2, 'name': 'English'},
    ];
    PickerUtils.showPicker(
      context: Get.context!,
      title: '选择语言'.tr,
      items: languageList,
      alignment: MainAxisAlignment.center,
      onConfirm: (selected) {
        language = selected['name'] ?? '';
        var zh = Translation.supportedLocales[0];
        var tw = Translation.supportedLocales[1];
        var en = Translation.supportedLocales[2];
        if (language == "简体中文") {
          ConfigService.to.setLanguage(zh);
        } else if (language == "繁体中文") {
          ConfigService.to.setLanguage(tw);
        } else if (language == "English") {
          ConfigService.to.setLanguage(en);
        }
        update(['mine']);
      },
      onCancel: () {},
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
