/// 常量
class Constants {
  // 本地存储key
  static const storageLanguageCode = 'language_code';
  // add
  static const storageEnv = 'env';

  // 是否显示测试节点
  static const isShowTestNode = true;

  // 服务 api
  static const nodeApi = [
    {
      'name': '节点1',
      'imgUrl': 'https://acdn.kjhvb.cn/speedtest.png', // 访问图片进行测速
      'api': 'https://acdn.kjhvb.cn', // 接口地址
      'socketUrl1': 'wss://acdn.kjhvb.cn/ws1', // 接口地址
      'socketUrl2': 'wss://acdn.kjhvb.cn/ws2', // 接口地址
      'socketUrl3': 'wss://acdn.kjhvb.cn/ws3', // 接口地址
      'speed': '999', // 测速结果
      'isTesting': false, // 是否正在测速
      'testResult': null, // 测速结果
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
