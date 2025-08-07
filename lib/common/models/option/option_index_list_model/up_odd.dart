import 'package:happy/common/index.dart';

class OptionIndexListModelUpOdd {
  String? uuid;
  String? range;
  String? odds;
  int? upDown;

  OptionIndexListModelUpOdd({this.uuid, this.range, this.odds, this.upDown});

  factory OptionIndexListModelUpOdd.fromJson(Map<String, dynamic> json) => OptionIndexListModelUpOdd(
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
