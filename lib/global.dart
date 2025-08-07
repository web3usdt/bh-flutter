import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/index.dart';

class Global {
  static Future<void> init() async {
    // 插件初始化
    WidgetsFlutterBinding.ensureInitialized();
    // 工具类
    // await Storage().init();
    // 加载组件
    Loading();
    // 初始化配置服务
    Get.put<ConfigService>(ConfigService());
    // 初始化配置
    await ConfigService.to.init();
    // 初始化HTTP服务
    Get.put<WPHttpService>(WPHttpService());
    // 初始化Socket服务
    await SocketService().init();
    await SocketService2().init();
    await SocketService3().init();
    // 判断是否已登录，如果已登录则连接WebSocket
    final token = Storage().getString('token');
    if (token.isNotEmpty) {
      SocketService().connect();
      SocketService2().connect();
      SocketService3().connect();
    }
  }
}
