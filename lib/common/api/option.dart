import '../index.dart';

/// 后台返回的成功默认是空数组
/// res.statusCode = 200
/// res.data = []
/// 用户 api
/// 直接使用 res.data['code'] 获取数据
class OptionApi {
  // 期权信息
  static Future<String> getOptionInfo() async {
    final res = await WPHttpService.to.get(
      '/api/app/option/instruction',
    );
    return res.data['data'];
  }

  // 期权列表
  static Future<List<OptionIndexListModel>> getOptionList() async {
    final res = await WPHttpService.to.get(
      '/api/app/option/sceneListByTimes',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => OptionIndexListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 期权详情-导航数据
  static Future<List<OptionDetailNavModel>> getOptionDetailNav() async {
    final res = await WPHttpService.to.get(
      '/api/app/option/sceneListByPairs',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => OptionDetailNavModel.fromJson(e)).toList();
    }
    return [];
  }

  // 期权详情-折线数据
  static Future<List<OptionChartModel>> getOptionChart(String symbol) async {
    final res = await WPHttpService.to.get(
      '/api/app/option/getNewPriceBook',
      params: {
        'symbol': symbol,
        'name': symbol,
      },
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => OptionChartModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取当前交易期权和下一个交易期权，接口data返回current_scene和next_scene
  static Future<Map<String, dynamic>> getCurrentItem(int pairId, int timeId) async {
    var res = await WPHttpService.to.get(
      '/api/app/option/sceneDetail',
      params: {
        'pair_id': pairId,
        'time_id': timeId,
      },
    );
    var data = res.data['data'];
    return data;
  }

  // 获取期权币种列表
  static Future<List<OptionCoinListModel>> getOptionCoinList() async {
    final res = await WPHttpService.to.get(
      '/api/app/option/getBetCoinList',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => OptionCoinListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取期权币种余额
  static Future<OptionCoinBalanceModel> getOptionCoinBalance(String coinId) async {
    final res = await WPHttpService.to.get(
      '/api/app/option/getUserCoinBalance',
      params: {
        'coin_id': coinId,
      },
    );
    final data = res.data['data'];
    return OptionCoinBalanceModel.fromJson(data);
  }

  // 获取涨跌幅赔率
  static Future<OptionIndexListModelScenePairList> getOptionOdds(int pairId, int timeId) async {
    final res = await WPHttpService.to.get(
      '/api/app/option/getOddsList',
      params: {
        'pair_id': pairId,
        'time_id': timeId,
      },
    );
    final data = res.data['data'];
    return OptionIndexListModelScenePairList.fromJson(data);
  }

  // 购买期权
  static Future<bool> buyScene(OptionBuyReq optionBuyReq) async {
    await WPHttpService.to.post(
      '/api/app/option/betScene',
      data: optionBuyReq.toJson(),
    );
    return true;
  }

  // 获取交割记录
  static Future<List<OptionIndexListModelScenePairList>> getDeliveryRecordList(PageListReq pageListReq, int pairId, int timeId, int status) async {
    var url = '';
    if (status == 0 || status == 1 || status == 2) {
      url = '/api/app/option/getOptionHistoryOrders';
    } else {
      url = '/api/app/option/getSceneResultList';
    }
    final res = await WPHttpService.to.get(
      url,
      params: {
        'page': pageListReq.page,
        'pair_id': pairId,
        'time_id': timeId,
        'status': status == 3
            ? 2
            : status == 0
                ? 1
                : status,
      },
    );
    log.d('原参数:$pairId ，$timeId ，${status == 3 ? 2 : status}');
    final data = res.data['data']['data'];
    log.d('元数据: $data');
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => OptionIndexListModelScenePairList.fromJson(e)).toList();
    }
    return [];
  }

  // 获取期权订单详情
  static Future<OptionIndexListModelScenePairList> getOptionBuyRecord(int orderId) async {
    final res = await WPHttpService.to.get(
      '/api/app/option/getOptionOrderDetail',
      params: {
        'order_id': orderId,
      },
    );
    final data = res.data['data'];
    return OptionIndexListModelScenePairList.fromJson(data);
  }
}
