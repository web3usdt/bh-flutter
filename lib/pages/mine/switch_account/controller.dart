import 'dart:convert';

import 'package:get/get.dart';
import 'package:happy/common/index.dart';

// import 'package:xinghuodarong/pages/tab/main/index.dart';
class SwitchAccountController extends GetxController {
  SwitchAccountController();
  // 登录历史
  List<LoginHistoryModel> loginHistoryList = [];
  // 用户信息
  User userInfo = User();
  // token
  String token = '';
  // 管理开启
  bool isManage = false;

  // 切换管理
  void onManage() {
    isManage = !isManage;
    update(["switch_account"]);
  }

  _initData() async {
    // 获取登录历史
    var stringLoginHistoryList = Storage().getString('loginHistoryList');
    loginHistoryList = stringLoginHistoryList != ""
        ? jsonDecode(stringLoginHistoryList).map<LoginHistoryModel>((item) {
            return LoginHistoryModel.fromJson(item);
          }).toList()
        : [];

    // 获取用户信息
    var stringUserInfo = Storage().getString('userInfo');
    userInfo = stringUserInfo != "" ? User.fromJson(jsonDecode(stringUserInfo)) : User();
    update(["switch_account"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // 删除
  void onDel(LoginHistoryModel item) {
    loginHistoryList.remove(item);
    Storage().setJson('loginHistoryList', loginHistoryList);
    Loading.success('删除成功'.tr);
    isManage = false;
    update(["switch_account"]);
  }

  // 切换
  void onSwitch(LoginHistoryModel item) async {
    Loading.show();
    try {
      int type = item.account!.contains('@') ? 2 : 1;
      Loading.show();
      var res = await LoginApi.login(
          LoginReq(
            account: item.account!,
            password: item.password!,
            type: type,
          ),
          showErrorToast: false);

      if (res.token!.isNotEmpty) {
        token = res.token!;
        userInfo = res.user!;
        // 登录成功后再断开WebSocket连接
        await SocketService().disconnect();
        // 同时断开WebSocket2连接
        await SocketService2().disconnect();
        // 同时断开WebSocket3连接
        await SocketService3().disconnect();

        // 清除旧token
        await Storage().remove('token');
        await Storage().setString('token', token);
        await Storage().setJson('userInfo', userInfo);

        // 重新初始化WebSocket
        await SocketService().init();
        await SocketService().connect();

        // 重新初始化WebSocket2
        await SocketService2().init();
        await SocketService2().connect();
        // 同时初始化并连接WebSocket3
        await SocketService3().init();
        await SocketService3().connect();
        Loading.success('切换成功'.tr);
        Get.until((route) => route.settings.name == AppRoutes.home);
      } else {
        Loading.error('切换账号失败'.tr);
      }
    } catch (e) {
      Loading.error(e.toString());
    }
  }
}
