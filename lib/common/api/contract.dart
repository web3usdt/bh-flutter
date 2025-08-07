import '../index.dart';

class ContractApi {
  // 获取风险说明
  static Future<String> riskInfo() async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/instruction',
    );
    return res.data['data'];
  }

  // 获取币种列表
  static Future<List<MarketList>> coinList() async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/getMarketList',
    );
    var data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MarketList.fromJson(e)).toList();
    }
    return [];
  }

  // 获取币种市场信息
  static Future<ContractMarketinfoModel> coinMarketinfo(String symbol) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/getMarketInfo',
      params: {'symbol': symbol},
    );
    return ContractMarketinfoModel.fromJson(res.data['data']);
  }

  // 获取合约详情
  static Future<ContractDetailModel> coinDetail(String symbol) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/getSymbolDetail',
      params: {'symbol': symbol},
    );
    return ContractDetailModel.fromJson(res.data['data']);
  }

  // 获取可开张数
  static Future<int> openNum(Map<String, dynamic> data) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/openNum',
      params: data,
    );
    return res.data['data'];
  }

  // 开仓
  static Future<bool> open(ContractOpenReq data) async {
    await WPHttpService.to.post(
      '/api/app/contract/openPosition',
      data: data.toJson(),
    );
    return true;
  }

  // 获取我的授权列表
  static Future<List<ContractMyAuthorizeModel>> myAuthorizeList(PageListReq? req, {bool shouldToast = true}) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/getCurrentEntrust',
      params: req?.toJson(),
      shouldToast: shouldToast,
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => ContractMyAuthorizeModel.fromJson(e)).toList();
    }
    return [];
  }

  // 撤销授权
  static Future<bool> cancelAuthorize(CoinCancelAuthorizeReq req) async {
    await WPHttpService.to.post(
      '/api/app/contract/cancelEntrust',
      data: req.toJson(),
    );
    return true;
  }

  // 获取历史委托列表
  static Future<List<ContractMyAuthorizeModel>> historyAuthorizeList(PageListReq? req) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/getHistoryEntrust',
      params: req?.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => ContractMyAuthorizeModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取用户合约收益
  static Future<ContractUserMoneyModel> userMoney(String symbol, {bool shouldToast = true}) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/contractAccount',
      params: {'symbol': symbol},
      shouldToast: shouldToast,
    );
    return ContractUserMoneyModel.fromJson(res.data['data']);
  }

  // 当前持有仓位
  static Future<List<ContractCurrentPositionModel>> currentPosition(String symbol, {bool shouldToast = true}) async {
    var res = await WPHttpService.to.get(
      '/api/app/contract/holdPosition',
      params: {'symbol': symbol},
      shouldToast: shouldToast,
    );
    var data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => ContractCurrentPositionModel.fromJson(e)).toList();
    }
    return [];
  }

  // 一键反向
  static Future<bool> reverse(String symbol, int side) async {
    await WPHttpService.to.post(
      '/api/app/contract/onekeyReverse',
      data: {'symbol': symbol, 'position_side': side},
    );
    return true;
  }

  // 一键全平
  static Future<bool> reverseAll() async {
    await WPHttpService.to.post(
      '/api/app/contract/onekeyAllFlat',
    );
    return true;
  }

  // 止盈止损
  static Future<bool> setStrategy(ContracrSetstragetyReq req) async {
    print(req.toJson());
    await WPHttpService.to.post(
      '/api/app/contract/setStrategy',
      data: req.toJson(),
    );
    return true;
  }

  // 平仓
  static Future<bool> closePosition(Map<String, dynamic> data) async {
    await WPHttpService.to.post(
      '/api/app/contract/closePosition',
      data: data,
    );
    return true;
  }
}
