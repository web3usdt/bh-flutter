import '../index.dart';

class CoinApi {
  // 获取K线数据
  static Future<List<CoinKlineModel>> coinKline(CoinKlineReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/option/getKline',
      params: req.toJson(),
    );

    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => CoinKlineModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取我的授权列表
  static Future<List<CoinMyAuthorizeModel>> myAuthorizeList(PageListReq? req) async {
    final res = await WPHttpService.to.get(
      '/api/app/exchange/getCurrentEntrust',
      params: req?.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => CoinMyAuthorizeModel.fromJson(e)).toList();
    }
    return [];
  }

  // 撤销授权
  static Future<bool> cancelAuthorize(CoinCancelAuthorizeReq req) async {
    await WPHttpService.to.post(
      '/api/app/exchange/cancelEntrust',
      data: req.toJson(),
    );
    return true;
  }

  // 获取历史委托列表
  static Future<List<CoinMyAuthorizeModel>> historyAuthorizeList(PageListReq? req) async {
    final res = await WPHttpService.to.get(
      '/api/app/exchange/getHistoryEntrust',
      params: req?.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => CoinMyAuthorizeModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取币种列表
  static Future<List<MarketList>> coinList() async {
    final res = await WPHttpService.to.get(
      '/api/app/exchange/getMarketList',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MarketList.fromJson(e)).toList();
    }
    return [];
  }

  // 获取收藏币种列表
  static Future<List<MarketInfoListModel>> collectCoinList() async {
    final res = await WPHttpService.to.get(
      '/api/app/getCollect',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MarketInfoListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取币种市场信息
  static Future<CoinMarketinfoModel> coinMarketinfo(String symbol) async {
    final res = await WPHttpService.to.get(
      '/api/app/exchange/getMarketInfo',
      params: {'symbol': symbol},
    );
    return CoinMarketinfoModel.fromJson(res.data['data']);
  }

  // 下单买入/卖出
  static Future<bool> storeEntrust(CoinStoreEntrustReq req) async {
    await WPHttpService.to.post(
      '/api/app/exchange/storeEntrust',
      data: req.toJson(),
    );
    return true;
  }

  // 获取币种余额
  static Future<Map<String, CoinBalanceModel>> coinBalance(String symbol) async {
    final res = await WPHttpService.to.get(
      '/api/app/exchange/getUserCoinBalance',
      params: {'symbol': symbol},
    );
    final data = res.data['data'];
    if (data != null && data is Map) {
      return data.map<String, CoinBalanceModel>((key, value) => MapEntry(key, CoinBalanceModel.fromJson(value)));
    }
    return {};
  }

  // 目标币种的币价
  static Future<double> targetCoinPrice(String symbol) async {
    final res = await WPHttpService.to.get(
      '/api/app/market/getCurrencyExCny',
      params: {'coin_name': symbol},
    );
    return res.data['data']['price_cny'];
  }

  // 收藏币种
  static Future<bool> collectCoin(String symbol) async {
    final res = await WPHttpService.to.post(
      '/api/app/option',
      data: {'pair_name': symbol},
    );
    return res.data['data'];
  }

  // 获取币种信息
  static Future<CoinCoinInfomsgModel> coinCoinInfomsg(String symbol) async {
    final res = await WPHttpService.to.get(
      '/api/app/exchange/getCoinInfo',
      params: {'coin_name': symbol},
    );
    return CoinCoinInfomsgModel.fromJson(res.data['data']);
  }
}
