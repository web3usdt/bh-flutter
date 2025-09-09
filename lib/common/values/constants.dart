/// 常量
class Constants {
  // 本地存储key
  static const storageLanguageCode = 'language_code';
  // add
  static const storageEnv = 'env';

  // 是否显示测试节点
  static const isShowTestNode = false;

  // 服务 api
  static const nodeApi = [
    {
      'name': '节点1',
      'imgUrl': 'https://bhcf.kjhvb.cn/speedtest.png', // 访问图片进行测速
      'api': 'https://bhcf.kjhvb.cn', // 接口地址
      'socketUrl1': 'wss://bhcf.kjhvb.cn/ws1', // 接口地址
      'socketUrl2': 'wss://bhcf.kjhvb.cn/ws2', // 接口地址
      'socketUrl3': 'wss://bhcf.kjhvb.cn/ws3', // 接口地址
      'speed': '999', // 测速结果
      'isTesting': false, // 是否正在测速
      'testResult': null, // 测速结果
      'isSelected': false, // 是否选中
    },
     {
      'name': '节点2',
      'imgUrl': 'https://bhali.kjhvb.cn/speedtest.png', // 访问图片进行测速
      'api': 'https://bhali.kjhvb.cn', // 接口地址
      'socketUrl1': 'wss://bhali.kjhvb.cn/ws1', // 接口地址
      'socketUrl2': 'wss://bhali.kjhvb.cn/ws2', // 接口地址
      'socketUrl3': 'wss://bhali.kjhvb.cn/ws3', // 接口地址
      'speed': '999', // 测速结果
      'isTesting': false, // 是否正在测速
      'testResult': null, // 测速结果
      'isSelected': false, // 是否选中
    },
    
  ];
}
