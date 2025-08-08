import 'package:BBIExchange/common/index.dart';

class Game3s {
  String? odds;
  String? brokerage;
  String? gameRate;

  Game3s({this.odds, this.brokerage, this.gameRate});

  factory Game3s.fromJson(Map<String, dynamic> json) => Game3s(
        odds: DataUtils.toStr(json['odds']),
        brokerage: DataUtils.toStr(json['brokerage']),
        gameRate: DataUtils.toStr(json['game_rate']),
      );

  Map<String, dynamic> toJson() => {
        'odds': odds,
        'brokerage': brokerage,
        'game_rate': gameRate,
      };
}
