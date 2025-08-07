import 'package:happy/common/index.dart';

import 'miner_num.dart';

class MiningUserinfoModelMiner {
  String? allPower;
  String? powerAdd;
  String? produceNum;
  String? allDel;
  String? yesterdayProduce;
  double? yesterdayDel;
  MiningUserinfoModelMinerMinerNum? minerNum;

  MiningUserinfoModelMiner({
    this.allPower,
    this.powerAdd,
    this.produceNum,
    this.allDel,
    this.yesterdayProduce,
    this.yesterdayDel,
    this.minerNum,
  });

  factory MiningUserinfoModelMiner.fromJson(Map<String, dynamic> json) => MiningUserinfoModelMiner(
        allPower: DataUtils.toStr(json['all_power']),
        powerAdd: DataUtils.toStr(json['power_add']),
        produceNum: DataUtils.toStr(json['produce_num']),
        allDel: DataUtils.toStr(json['all_del']),
        yesterdayProduce: DataUtils.toStr(json['yesterday_produce']),
        yesterdayDel: DataUtils.toDouble(json['yesterday_del']),
        minerNum: json['miner_num'] == null ? null : MiningUserinfoModelMinerMinerNum.fromJson(json['miner_num'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'all_power': allPower,
        'power_add': powerAdd,
        'produce_num': produceNum,
        'all_del': allDel,
        'yesterday_produce': yesterdayProduce,
        'yesterday_del': yesterdayDel,
        'miner_num': minerNum?.toJson(),
      };
}
