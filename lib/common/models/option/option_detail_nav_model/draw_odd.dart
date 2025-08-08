import 'package:BBIExchange/common/index.dart';

class OptionDetailNavModelDrawOdd {
  String? uuid;
  String? range;
  String? odds;
  int? upDown;

  OptionDetailNavModelDrawOdd({this.uuid, this.range, this.odds, this.upDown});

  factory OptionDetailNavModelDrawOdd.fromJson(Map<String, dynamic> json) => OptionDetailNavModelDrawOdd(
        uuid: DataUtils.toStr(json['uuid']),
        range: DataUtils.toStr(json['range']),
        odds: DataUtils.toStr(json['odds']),
        upDown: DataUtils.toInt(json['up_down']),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'range': range,
        'odds': odds,
        'up_down': upDown,
      };
}
