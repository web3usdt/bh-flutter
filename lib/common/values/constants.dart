/// 常量
class Constants {
  // 本地存储key
  static const storageLanguageCode = 'language_code';
  // add
  static const storageEnv = 'env';

  // 服务 api
  static const nodeApi = [
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
}
