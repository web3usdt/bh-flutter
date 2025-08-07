import '../index.dart';
import '../models/mining/mining_coin_record_model.dart';

class MiningApi {
  // 获取挖矿信息
  static Future<MiningUserinfoModel> getMiningUserinfo() async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/user_info',
    );
    print('getMiningUserinfo: ${res.data['data']}');
    return MiningUserinfoModel.fromJson(res.data['data']);
  }

  // 新人首次领取矿机
  static Future<bool> getMiningNewUserPower() async {
    await WPHttpService.to.post(
      '/api/app/miner/newUserPower',
    );
    return true;
  }

  // 获取我的矿机记录
  static Future<List<MiningRecordModel>> getMiningRecordList(PageListReq req) async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/transactionRecord',
      data: req.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MiningRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 购买矿机
  static Future<bool> buyMining(int num) async {
    await WPHttpService.to.post(
      '/api/app/miner/buy',
      data: {'num': num},
    );
    return true;
  }

  // 获取算力明细
  static Future<List<MiningPowerRecordModel>> getMiningPowerRecordList(PageListReq req) async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/powerRecord',
      data: req.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MiningPowerRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取矿机产出记录
  static Future<List<MiningCoinRecordModel>> getMiningCoinRecordList(PageListReq req) async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/coinRecord',
      data: req.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MiningCoinRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 团队统计
  static Future<MiningTeamInfoModel> getMiningTeamStat() async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/team',
    );
    return MiningTeamInfoModel.fromJson(res.data['data']);
  }

  // 获取矿机团队信息
  static Future<MiningTeamInfoModel> getMiningTeamInfo() async {
    var res = await WPHttpService.to.get(
      '/api/app/generalize/info',
    );
    print('getMiningTeamInfo: ${res.data}');
    return MiningTeamInfoModel.fromJson(res.data['data']);
  }

  // 获取矿机团队列表
  static Future<List<MiningTeamListModel>> getMiningTeamList(PageListReq req) async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/team_user',
      data: req.toJson(),
    );
    var data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MiningTeamListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取算力信息
  static Future<MiningGetpowerModel> getMiningGetpower() async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/destroyConfig',
    );
    return MiningGetpowerModel.fromJson(res.data['data']);
  }

  // 销毁算力
  static Future<bool> destroyMiningPower(MiningDestoryPowerReq req) async {
    await WPHttpService.to.post(
      '/api/app/miner/destroyCoin',
      data: req.toJson(),
    );
    return true;
  }

  // 锁仓算力明细
  static Future<List<MiningPowerRecordModel>> getMiningLockPowerRecordList(PageListReq req) async {
    var res = await WPHttpService.to.post(
      '/api/app/miner/lockPowerRecord',
      data: req.toJson(),
    );
    var data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => MiningPowerRecordModel.fromJson(e)).toList();
    }
    return [];
  }
}
