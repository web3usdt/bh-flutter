import 'dart:io';
import 'package:BBIExchange/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RealnameController extends GetxController {
  RealnameController();
  // 类型
  String type = '';
  // 真实姓名
  TextEditingController realNameController = TextEditingController();
  // 身份证号
  TextEditingController idCardController = TextEditingController();
  // 身份证正面
  String? idCardFrontFile;
  // 身份证反面
  String? idCardBackFile;
  // 手持身份证
  String? idCardHandFile;

  // 国家名称
  String country = '';
  // 国家id
  int countryId = 0;
  // 国家代码
  String countryCode = '';

  // 国家列表
  List<UserCountrylistModel> countryList = [];
  // 切换国家
  void goCountrySetting() async {
    PickerUtils.showPicker(
      context: Get.context!,
      title: '选择国籍'.tr,
      items: countryList.map((e) => {'id': e.id, 'name': e.name, 'country_code': e.countryCode}).toList(),
      alignment: MainAxisAlignment.center,
      onConfirm: (selected) {
        country = selected['name'];
        countryId = selected['id'];
        countryCode = selected['country_code'];
        update(['realname']);
      },
      onCancel: () {},
    );
  }

  // 更换头像
  void changeIdCardFront(int type) {
    WechatImagePicker.showImagePicker(
      context: Get.context!,
      maxAssets: 1, // 单张选择
      onSingleResult: (File? selectedFile) async {
        try {
          if (selectedFile == null) return Loading.toast('图片选择失败'.tr);
          Loading.show();
          String imageUrl = await UploadApi.uploadImage(selectedFile, '/api/app/uploadImage');
          if (imageUrl.isEmpty) return Loading.toast('上传图片失败'.tr);
          // 根据类型设置对应的图片
          if (type == 1) {
            idCardFrontFile = imageUrl;
          } else if (type == 2) {
            idCardBackFile = imageUrl;
          } else {
            idCardHandFile = imageUrl;
          }
          Loading.success('图片上传成功'.tr);
          update(["realname"]);
        } catch (e) {
          Loading.toast('图片处理失败'.tr);
        } finally {
          Loading.dismiss();
        }
      },
    );
  }

  void submit() async {
    if (type == 'realname') {
      if (countryId == 0) return Loading.toast('请选择国籍'.tr);
      if (realNameController.text.isEmpty) return Loading.toast('请输入真实姓名'.tr);
      if (idCardController.text.isEmpty) return Loading.toast('请输入身份证号'.tr);
      Loading.show();
      var res = await UserApi.submitRealname(UserRealnameReq(
        realname: realNameController.text,
        idCard: idCardController.text,
        countryId: countryId.toString(),
        countryCode: countryCode,
      ));
      if (res) {
        Loading.success('认证成功'.tr);
        Get.back();
      }
    } else {
      // Get.toNamed(AppRoutes.realNameAws);
      if (idCardFrontFile == null) return Loading.toast('请上传身份证正面'.tr);
      if (idCardBackFile == null) return Loading.toast('请上传身份证反面'.tr);
      if (idCardHandFile == null) return Loading.toast('请上传您的面部照片'.tr);
      Loading.show();
      await UserApi.submitAdvanced(UserAdvancedReq(
        frontImg: idCardFrontFile,
        backImg: idCardBackFile,
        handImg: idCardHandFile,
      ));
      Loading.toast('提交成功，实名认证审核中，请耐心等待'.tr);
      Get.until((route) => route.settings.name == AppRoutes.userinfo);
    }

    update(["realname"]);
  }

  Future<void> _initData() async {
    type = Get.arguments['type'];
    update(["realname"]);
    countryList = await UserApi.getCountryList();
    update(["realname"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    realNameController.dispose();
    idCardController.dispose();
  }
}
