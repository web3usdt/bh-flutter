import 'package:BBIExchange/common/index.dart';

class MiningUserinfoModelMinerMinerNum {
  int? num2;
  int? num3;
  int? num4;
  int? num5;
  int? num6;
  int? num1;

  MiningUserinfoModelMinerMinerNum({
    this.num2,
    this.num3,
    this.num4,
    this.num5,
    this.num6,
    this.num1,
  });

  factory MiningUserinfoModelMinerMinerNum.fromJson(Map<String, dynamic> json) => MiningUserinfoModelMinerMinerNum(
        num2: DataUtils.toInt(json['num2']),
        num3: DataUtils.toInt(json['num3']),
        num4: DataUtils.toInt(json['num4']),
        num5: DataUtils.toInt(json['num5']),
        num6: DataUtils.toInt(json['num6']),
        num1: DataUtils.toInt(json['num1']),
      );

  Map<String, dynamic> toJson() => {
        'num2': num2,
        'num3': num3,
        'num4': num4,
        'num5': num5,
        'num6': num6,
        'num1': num1,
      };
}
