import '../index.dart';
import 'dart:convert';

class GameApi {
  // 获取币种列表
  static Future<List<GameCoinlistModel>> coinList() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/gameAccount',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => GameCoinlistModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取战绩总览统计
  static Future<GameDetailModel> gameDetail(int type, int coinId, String date) async {
    final res = await WPHttpService.to.get(
      '/api/app/games/stats',
      params: {
        'type': type,
        'coin_id': coinId,
        'date': date,
      },
    );
    final data = res.data['data'];
    print('data: $data');
    return GameDetailModel.fromJson(data);
  }

  // 获取投注金额
  static Future<List<GameMoneyListModel>> gameMoneyList(int type, int coinId) async {
    final res = await WPHttpService.to.get(
      '/api/app/games/moneys',
      params: {
        'type': type,
        'coin_id': coinId,
      },
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => GameMoneyListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 编辑投注金额
  static Future<bool> gameEditMoneyList(int type, int coinId, List<MoneyGameEditMoneyListReq> req) async {
    // 转换为Map列表
    List<Map<String, dynamic>> moneysMap = req.map((e) => e.toJson()).toList();
    // 转换为JSON字符串
    String moneysJson = jsonEncode(moneysMap);
    // 验证JSON格式 - 只有moneys需要是JSON格式
    final jsonData = {
      'type': type.toString(), // 转换为字符串
      'coin_id': coinId.toString(), // 转换为字符串
      'moneys': moneysJson, // JSON字符串格式
    };
    await WPHttpService.to.post(
      '/api/app/games/setMoneys',
      data: jsonData,
    );
    return true;
  }

  // 提交投注
  static Future<bool> gameSubmit(GameSubmitReq req) async {
    await WPHttpService.to.post(
      '/api/app/games/bet',
      data: req.toJson(),
    );
    return true;
  }

  // 流水记录
  static Future<List<GameAssetsRecordModel>> gameRecord(int coinId, PageListReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/games/walletRecords',
      params: {
        'coin_id': coinId,
        'page': req.page,
      },
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => GameAssetsRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 下单投注记录
  static Future<List<GameRecordModel>> gameBetRecord(int type, int coinId, PageListReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/games/records',
      params: {
        'type': type,
        'coin_id': coinId,
        'page': req.page,
      },
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => GameRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取游戏配置
  static Future<GameConfigModel> gameConfig() async {
    final res = await WPHttpService.to.get(
      '/api/app/games/config',
    );
    final data = res.data['data'];
    return GameConfigModel.fromJson(data);
  }

  // 最近开奖走势
  static Future<dynamic> gameRecentTrend(int type, int isMy) async {
    final res = await WPHttpService.to.get(
      '/api/app/games/trend',
      params: {
        'type': type,
        'is_my': isMy,
      },
    );
    print(res.data);
    final data = res.data['data'];
    return data;
  }

  // 游戏账户转账
  static Future<bool> gameTransfer(GameTransferReq req) async {
    await WPHttpService.to.post(
      '/api/app/games/swap',
      data: req.toJson(),
    );
    return true;
  }
}
