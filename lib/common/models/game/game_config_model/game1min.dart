import 'package:BBIExchange/common/index.dart';

class Game1min {
  String? odds;
  String? gameRate;
  String? brokerage;

  Game1min({this.odds, this.gameRate, this.brokerage});

  factory Game1min.fromJson(Map<String, dynamic> json) => Game1min(
        odds: DataUtils.toStr(json['odds']),
        gameRate: DataUtils.toStr(json['game_rate']),
        brokerage: DataUtils.toStr(json['brokerage']),
      );

  Map<String, dynamic> toJson() => {
        'odds': odds,
        'game_rate': gameRate,
        'brokerage': brokerage,
      };
}
