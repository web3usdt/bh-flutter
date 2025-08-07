import 'package:happy/common/index.dart';

/// 环境配置
class Env {
  final String tag;
  final String name;
  final String apiBaseUrl;
  final String socketUrl1;
  final String socketUrl2;
  final String socketUrl3;
  // 可以添加更多环境特定的变量...

  Env({
    required this.tag,
    required this.name,
    required this.apiBaseUrl,
    required this.socketUrl1,
    required this.socketUrl2,
    required this.socketUrl3,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is Env && runtimeType == other.runtimeType && tag == other.tag;

  @override
  int get hashCode => tag.hashCode;
}

/// 环境列表
class EnvConfig {
  static final Env curEnv = dev;

  static final Env dev = Env(
    //开发环境
    tag: 'dev',
    name: '开发--vip',
    apiBaseUrl: 'https://happyxfb.vip', // dev环境域名
    socketUrl1: 'wss://happyxfb.vip/ws1', // dev环境Socket地址1
    socketUrl2: 'wss://happyxfb.vip/ws2', // dev环境Socket地址2
    socketUrl3: 'wss://happyxfb.vip/ws3', // dev环境Socket地址3
  );

  static final Env test = Env(
    //测试环境
    tag: 'test',
    name: '开发--Vip',
    apiBaseUrl: 'https://happyxfb.vip', // dev环境域名
    socketUrl1: 'wss://happyxfb.vip/ws1', // dev环境Socket地址1
    socketUrl2: 'wss://happyxfb.vip/ws2', // dev环境Socket地址2
    socketUrl3: 'wss://happyxfb.vip/ws3', // dev环境Socket地址3
  );

  static final Env ceshi = Env(
    //生产环境
    tag: 'ceshi',
    name: '测试节点',
    apiBaseUrl: 'https://h5.happyxfb.vip', // prod环境域名
    socketUrl1: 'wss://h5.happyxfb.vip/ws1', // prod环境Socket地址1
    socketUrl2: 'wss://h5.happyxfb.vip/ws2', // prod环境Socket地址2
    socketUrl3: 'wss://h5.happyxfb.vip/ws3', // dev环境Socket地址3
  );

  static final Env prod = Env(
    //生产环境
    tag: 'prod',
    name: '节点1',
    apiBaseUrl: 'https://acdn.kjhvb.cn', // prod环境域名
    socketUrl1: 'wss://acdn.kjhvb.cn/ws1', // prod环境Socket地址1
    socketUrl2: 'wss://acdn.kjhvb.cn/ws2', // prod环境Socket地址2
    socketUrl3: 'wss://acdn.kjhvb.cn/ws3', // dev环境Socket地址3
  );

  static final Env prod1 = Env(
    //alpha环境
    tag: 'prod1',
    name: '节点2',
    apiBaseUrl: 'https://admincdn.gpuee.cn', // alpha环境域名
    socketUrl1: 'wss://admincdn.gpuee.cn/ws1', // alpha环境Socket地址1
    socketUrl2: 'wss://admincdn.gpuee.cn/ws2', // alpha环境Socket地址2
    socketUrl3: 'wss://admincdn.gpuee.cn/ws3', // dev环境Socket地址3
  );

  static final Env prod2 = Env(
    tag: 'prod2',
    name: '节点3',
    apiBaseUrl: 'https://happyxfb.net', // alpha环境域名
    socketUrl1: 'wss://happyxfb.net/ws1', // alpha环境Socket地址1
    socketUrl2: 'wss://happyxfb.net/ws2', // alpha环境Socket地址2
    socketUrl3: 'wss://happyxfb.net/ws3', // dev环境Socket地址3
  );

  static final Env prodh5 = Env(
    tag: 'prodh5',
    name: 'H5空节点',
    apiBaseUrl: '', // alpha环境域名
    socketUrl1: '/ws1', // alpha环境Socket地址1
    socketUrl2: '/ws2', // alpha环境Socket地址2
    socketUrl3: '/ws3', // dev环境Socket地址3
  );

  // 获取编译时环境

  // 环境列表Map
  static final List<Env> envList = _getEnvList();

  static List<Env> _getEnvList() {
    return [prod, prod1, prod2];
  }

  // 根据名称获取环境
  static Env getEnvByTag(String name) {
    List<Env> envList = _getEnvList();
    return envList.firstWhere((element) => element.tag == name, orElse: () => prod);
  }

  // 如果是测试模式
  static List<Env> getTestEnvList() {
    return [prod, prod1, prod2, ceshi, prodh5];
  }

  // 根据名称获取环境
  static Env getEnvByTagTest(String name) {
    List<Env> envList = getTestEnvList();
    return envList.firstWhere((element) => element.tag == name, orElse: () => prod);
  }
}
