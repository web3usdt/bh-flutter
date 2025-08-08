import 'package:BBIExchange/common/index.dart';

class OptionDetailNavModelUpOdd {
  String? uuid;
  String? range;
  String? odds;
  int? upDown;

  OptionDetailNavModelUpOdd({this.uuid, this.range, this.odds, this.upDown});

  factory OptionDetailNavModelUpOdd.fromJson(Map<String, dynamic> json) => OptionDetailNavModelUpOdd(
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
