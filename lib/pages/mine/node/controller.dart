import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';

class NodeController extends GetxController {
  NodeController();
  // token
  String? token;
  // 是否显示测试节点
  bool isShowTestNode = true;
  int isShowTestNodeCount = 0;

  // 节点列表
  List<Map<String, dynamic>> nodeList = [
    {
      'name': '节点1',
      'imgUrl': 'https://acdn.kjhvb.cn/speedtest.png',
      'api': 'https://acdn.kjhvb.cn',
      'socketUrl1': 'wss://acdn.kjhvb.cn/ws1',
      'socketUrl2': 'wss://acdn.kjhvb.cn/ws2',
      'socketUrl3': 'wss://acdn.kjhvb.cn/ws3',
      'speed': '999',
      'isTesting': false, // 是否正在测速
      'testResult': null, // 测速结果（毫秒）
      'isSelected': false, // 是否选中
    },
    {
      'name': '节点2',
      'imgUrl': 'https://admincdn.gpuee.cn/speedtest.png',
      'api': 'https://admincdn.gpuee.cn',
      'socketUrl1': 'wss://admincdn.gpuee.cn/ws1',
      'socketUrl2': 'wss://admincdn.gpuee.cn/ws2',
      'socketUrl3': 'wss://admincdn.gpuee.cn/ws3',
      'speed': '9999',
      'isTesting': false,
      'testResult': null,
      'isSelected': false,
    },
    {
      'name': '测试节点',
      'imgUrl': 'https://happyxfb.vip/speedtest.png',
      'api': 'https://happyxfb.vip',
      'socketUrl1': 'wss://h5.happyxfb.vip/ws1',
      'socketUrl2': 'wss://h5.happyxfb.vip/ws2',
      'socketUrl3': 'wss://h5.happyxfb.vip/ws3',
      'speed': '9999',
      'isTesting': false,
      'testResult': null,
      'isSelected': false,
    },
  ];

  // 是否正在测速
  bool isTestingAll = false;
  // Dio 实例
  final Dio _dio = Dio();

  _initData() {
    token = Storage().getString('token');
    print('token: $token');
    // 延迟1秒设置系统样式
    Future.delayed(const Duration(seconds: 1), () {
      AppTheme.setSystemStyle();
    });
    // 主动测速一次
    testAllNodesSpeed();
    // 是否存在nodeApi
    var nodeApi = Storage().getString('nodeApi');
    if (nodeApi.isNotEmpty) {
      nodeList.firstWhere((element) => element['api'] == nodeApi)['isSelected'] = true;
      update(["node"]);
    }
    update(["node"]);
  }

  // 选择节点
  void selectNode(int index) async {
    Loading.show();
    // 选中状态设置为false
    for (var node in nodeList) {
      node['isSelected'] = false;
    }
    // 当前选中的api
    final currentName = nodeList[index]['name'];
    final currentApi = nodeList[index]['api'];
    final currentSocketUrl1 = nodeList[index]['socketUrl1'];
    final currentSocketUrl2 = nodeList[index]['socketUrl2'];
    final currentSocketUrl3 = nodeList[index]['socketUrl3'];
    print('currentName: $currentName');
    print('currentApi: $currentApi');
    print('currentSocketUrl1: $currentSocketUrl1');
    print('currentSocketUrl2: $currentSocketUrl2');
    print('currentSocketUrl3: $currentSocketUrl3');
    Storage().setString('nodeName', currentName);
    Storage().setString('nodeApi', currentApi);
    Storage().setString('nodeSocketUrl1', currentSocketUrl1);
    Storage().setString('nodeSocketUrl2', currentSocketUrl2);
    Storage().setString('nodeSocketUrl3', currentSocketUrl3);
    // 更新 HTTP 服务的 baseUrl 到当前节点（若未注册则先注册）
    if (Get.isRegistered<WPHttpService>()) {
      WPHttpService.to.updateBaseUrl(currentApi);
    } else {
      Get.put<WPHttpService>(WPHttpService());
      WPHttpService.to.updateBaseUrl(currentApi);
    }
    nodeList[index]['isSelected'] = true;
    // 获取token
    // 如果没有token，直接去登录页
    if (token?.isEmpty ?? true) {
      Loading.success('切换成功'.tr);
      Get.offAllNamed(AppRoutes.login);
    } else {
      // 如果有token，直接去首页
      try {
        // 直接连接并等待就绪（connect 内部会先关闭旧连接）
        await Future.wait([
          _connectAndWait(SocketService(), timeout: const Duration(seconds: 20)),
          _connectAndWait(SocketService2(), timeout: const Duration(seconds: 20)),
          _connectAndWait(SocketService3(), timeout: const Duration(seconds: 20)),
        ]);

        // HTTP 服务已在上方更新 baseUrl，这里无需重新初始化

        Loading.success('切换成功'.tr);
        Get.until((route) => route.settings.name == AppRoutes.home);
      } catch (e) {
        nodeList[index]['isSelected'] = false;
        Loading.error('链接错误，请重新测速');
      }
    }
    update(["node"]);
  }

  // 连接并等待状态进入 connected，超时则抛出异常
  Future<void> _connectAndWait(dynamic service, {Duration timeout = const Duration(seconds: 20)}) async {
    try {
      await service.connect();
      // 等待状态流进入 connected
      await service.stateStream.firstWhere((s) => s == SocketConnectionState.connected).timeout(timeout, onTimeout: () {
        throw TimeoutException('连接超时');
      });
    } catch (_) {
      rethrow;
    }
  }

  // 测速单个节点
  Future<void> testNodeSpeed(int index) async {
    if (index < 0 || index >= nodeList.length) return;

    // 设置测速状态
    nodeList[index]['isTesting'] = true;
    update(["node"]);

    try {
      final stopwatch = Stopwatch()..start();

      // 发起图片请求
      await _dio.get(
        nodeList[index]['imgUrl'],
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      stopwatch.stop();
      final responseTime = stopwatch.elapsedMilliseconds;

      // 更新测速结果
      nodeList[index]['testResult'] = responseTime;
      nodeList[index]['speed'] = responseTime.toString();
    } catch (e) {
      // 测速失败，设置一个较大的值
      nodeList[index]['testResult'] = 99999;
      nodeList[index]['speed'] = '99999';
      print('节点测速失败: ${nodeList[index]['name']}, 错误: $e');
    } finally {
      // 清除测速状态
      nodeList[index]['isTesting'] = false;
      update(["node"]);
    }
  }

  // 测速所有节点
  Future<void> testAllNodesSpeed() async {
    print('测速所有节点');
    if (isTestingAll) return;

    isTestingAll = true;
    update(["node"]);

    try {
      // 并发测速所有节点
      final futures = <Future>[];
      for (int i = 0; i < nodeList.length; i++) {
        futures.add(testNodeSpeed(i));
      }

      await Future.wait(futures);

      // 测速完成后按速度排序，如果需要按速度排序，就打开下面注释
      // _sortNodesBySpeed();
    } finally {
      isTestingAll = false;
      update(["node"]);
    }
  }

  // 按速度排序节点
  void _sortNodesBySpeed() {
    nodeList.sort((a, b) {
      final speedA = a['testResult'] ?? int.tryParse(a['speed']) ?? 99999;
      final speedB = b['testResult'] ?? int.tryParse(b['speed']) ?? 99999;
      return speedA.compareTo(speedB); // 按速度从快到慢排序
    });
  }

  // 重置测速结果
  void resetSpeedTest() {
    for (var node in nodeList) {
      node['testResult'] = null;
      node['isTesting'] = false;
    }
    isTestingAll = false;
    update(["node"]);
  }

  // 获取测速状态文本
  String getSpeedStatusText(Map<String, dynamic> node) {
    if (node['isTesting'] == true) {
      return '测速中...';
    }

    final testResult = node['testResult'];
    if (testResult != null) {
      if (testResult >= 99999) {
        return '9999';
      } else {
        return '${testResult}ms';
      }
    }

    return '未测速';
  }

  // 获取测速状态颜色
  int getSpeedStatusColor(Map<String, dynamic> node) {
    if (node['isTesting'] == true) {
      return 0xFF666666; // 灰色
    }

    final testResult = node['testResult'];
    if (testResult != null) {
      if (testResult >= 99999) {
        return 0xFFFF0000; // 红色（失败）
      } else if (testResult <= 1000) {
        return 0xFF00FF00; // 绿色（优秀）
      } else if (testResult <= 3000) {
        return 0xFFFFFF00; // 黄色（良好）
      } else {
        return 0xFFFF6600; // 橙色（较慢）
      }
    }

    return 0xFF999999; // 灰色（未测速）
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    _dio.close();
  }

  // 连点五次显示测试节点
  void showTestNode() {
    isShowTestNodeCount++;
    if (isShowTestNodeCount >= 5) {
      isShowTestNode = true;
    }
    update(["node"]);
  }
}
