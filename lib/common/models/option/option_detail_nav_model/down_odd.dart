import 'package:happy/common/index.dart';

class OptionDetailNavModelDownOdd {
  String? uuid;
  String? range;
  String? odds;
  int? upDown;

  OptionDetailNavModelDownOdd({this.uuid, this.range, this.odds, this.upDown});

  factory OptionDetailNavModelDownOdd.fromJson(Map<String, dynamic> json) => OptionDetailNavModelDownOdd(
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
