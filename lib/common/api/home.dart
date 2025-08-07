import '../index.dart';

/// 后台返回的成功默认是空数组
/// res.statusCode = 200
/// res.data = []
/// 用户 api
/// 直接使用 res.data['code'] 获取数据
class HomeApi {
  // 首页数据
  static Future<HomeDatainfoModel> homeDatainfo() async {
    var res = await WPHttpService.to.get(
      '/api/app/indexList',
    );
    return HomeDatainfoModel.fromJson(res.data['data']);
  }

  /// 公告列表
  static Future<List<HomeNoticeListModel>> noticesList(PageListReq? req) async {
    var res = await WPHttpService.to.get(
      '/api/app/article/list',
      params: req?.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => HomeNoticeListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 系统消息列表
  static Future<List<HomeSystemMessageListModel>> systemMessageList(PageListReq? req) async {
    var res = await WPHttpService.to.get(
      '/api/app/user/myNotifiables',
      params: req?.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => HomeSystemMessageListModel.fromJson(e)).toList();
    }
    return [];
  }

  /// 公告详情
  static Future<HomeNoticeDetailModel> noticeDetail(int id) async {
    var res = await WPHttpService.to.get(
      '/api/app/article/detail',
      params: {'id': id},
    );
    return HomeNoticeDetailModel.fromJson(res.data['data']);
  }

  // 系统消息详情
  static Future<HomeSystemMessageListModel> systemMessageDetail(String id) async {
    var res = await WPHttpService.to.get(
      '/api/app/user/readNotifiable',
      params: {'id': id},
    );
    return HomeSystemMessageListModel.fromJson(res.data['data']);
  }

  // 申购信息
  static Future<HomeSubscribeInfoModel> subscribeInfo() async {
    var res = await WPHttpService.to.post(
      '/api/app/user/subscribe',
    );
    return HomeSubscribeInfoModel.fromJson(res.data['data']);
  }

  // 申购币种列表
  static Future<List<HomeSubscribeCoinlistModel>> subscribeCoinList() async {
    var res = await WPHttpService.to.post(
      '/api/app/user/subscribeTokenList',
    );
    var data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => HomeSubscribeCoinlistModel.fromJson(e)).toList();
    }
    return [];
  }

  // 申购
  static Future<bool> subscribe(HomeSubscribeReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/subscribeNow',
      data: req.toJson(),
    );
    return true;
  }

  // 申购记录
  static Future<List<HomeSubscribeRecordModel>> subscribeRecord(PageListReq? req) async {
    var res = await WPHttpService.to.post(
      '/api/app/user/subscribeRecords',
      data: req?.toJson(),
    );
    var data = res.data['data']['data'];
    print(data);
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => HomeSubscribeRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 申购列表
  static Future<List<HomeSubscribeListModel>> subscribeList() async {
    var res = await WPHttpService.to.get(
      '/api/app/user/subscribeV2',
    );
    var data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => HomeSubscribeListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 确认申购
  static Future<bool> confirmSubscribe(String amount, String coinName) async {
    await WPHttpService.to.post(
      '/api/app/user/subscribeV2',
      data: {'amount': amount, 'coin_name': coinName},
    );
    return true;
  }

  // 市场
  static Future<List<HomeMarkets>> marketsList() async {
    var res = await WPHttpService.to.get(
      '/api/markets',
    );
    var markets = res.data['markets'];
    if (markets != null && markets is List && markets.isNotEmpty) {
      return markets.map((e) => HomeMarkets.fromJson(e)).toList();
    }
    return [];
  }

  // 市场价格详情
  static Future<List<HomeMarketsDetail>> marketsDetail(HomeMarketsDetailReq data) async {
    var res = await WPHttpService.to.get(
      '/api/markets/api/v3/ticker/24hr',
      params: data.toJson(),
    );
    var marketsDetail = res.data;
    if (marketsDetail != null && marketsDetail is List && marketsDetail.isNotEmpty) {
      return marketsDetail.map((e) => HomeMarketsDetail.fromJson(e)).toList();
    }
    return [];
  }

  // 获取K线头部24小时数据
  static Future<HomeKlineHeadPriceModel> klineHeadPrice(String symbol) async {
    var res = await WPHttpService.to.get(
      '/api/markets/api/v3/ticker/24hr',
      params: {'symbol': symbol},
    );
    return HomeKlineHeadPriceModel.fromJson(res.data);
  }

  // 获取K线数据
  static Future<List<KlineData>> klineData(HomeKlineReq data) async {
    var res = await WPHttpService.to.get(
      '/api/markets/api/v3/klines',
      params: data.toJson(),
    );
    var klineData = res.data;
    if (klineData != null && klineData is List && klineData.isNotEmpty) {
      return klineData.map((e) => KlineData.fromJson(e)).toList();
    }
    return [];
  }
}
