import 'package:BBIExchange/common/index.dart';

import 'miner.dart';

class MiningUserinfoModel {
  double? commisson;
  double? commissonYes;
  int? coinId;
  double? totalIncome;
  String? todayIncome;
  int? level;
  String? levelName;
  String? myPower;
  int? isNews;
  int? minerCount;
  int? minerNoactiveCount;
  MiningUserinfoModelMiner? miner;
  String? lockPower;

  MiningUserinfoModel({
    this.commisson,
    this.commissonYes,
    this.coinId,
    this.totalIncome,
    this.todayIncome,
    this.level,
    this.levelName,
    this.myPower,
    this.isNews,
    this.minerCount,
    this.minerNoactiveCount,
    this.miner,
    this.lockPower,
  });

  factory MiningUserinfoModel.fromJson(Map<String, dynamic> json) {
    return MiningUserinfoModel(
      commisson: DataUtils.toDouble(json['commisson']),
      commissonYes: DataUtils.toDouble(json['commisson_yes']),
      coinId: DataUtils.toInt(json['coin_id']),
      totalIncome: DataUtils.toDouble(json['total_income']),
      todayIncome: DataUtils.toStr(json['today_income']),
      level: DataUtils.toInt(json['level']),
      levelName: DataUtils.toStr(json['level_name']),
      myPower: DataUtils.toStr(json['my_power']),
      isNews: DataUtils.toInt(json['is_news']),
      minerCount: DataUtils.toInt(json['miner_count']),
      minerNoactiveCount: DataUtils.toInt(json['miner_noactive_count']),
      miner: json['miner'] == null ? null : MiningUserinfoModelMiner.fromJson(json['miner'] as Map<String, dynamic>),
      lockPower: DataUtils.toStr(json['lock_power']),
    );
  }

  Map<String, dynamic> toJson() => {
        'commisson': commisson,
        'commisson_yes': commissonYes,
        'coin_id': coinId,
        'total_income': totalIncome,
        'today_income': todayIncome,
        'level': level,
        'level_name': levelName,
        'my_power': myPower,
        'is_news': isNews,
        'miner_count': minerCount,
        'miner_noactive_count': minerNoactiveCount,
        'miner': miner?.toJson(),
        'lock_power': lockPower,
      };
}
