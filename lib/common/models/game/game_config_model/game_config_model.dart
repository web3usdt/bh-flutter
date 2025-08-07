import 'package:happy/common/index.dart';

import 'coin.dart';
import 'game1min.dart';
import 'game3s.dart';

class GameConfigModel {
  Game3s? game3s;
  Game1min? game1min;
  List<Coin>? coins;
  String? intro;
  String? gameRate;

  GameConfigModel({this.game3s, this.game1min, this.coins, this.intro, this.gameRate});

  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      game3s: json['game_3s'] == null ? null : Game3s.fromJson(json['game_3s'] as Map<String, dynamic>),
      game1min: json['game_1min'] == null ? null : Game1min.fromJson(json['game_1min'] as Map<String, dynamic>),
      coins: (json['coins'] as List<dynamic>?)?.map((e) => Coin.fromJson(e as Map<String, dynamic>)).toList(),
      intro: DataUtils.toStr(json['intro']),
      gameRate: DataUtils.toStr(json['game_rate']),
    );
  }

  Map<String, dynamic> toJson() => {
        'game_3s': game3s?.toJson(),
        'game_1min': game1min?.toJson(),
        'coins': coins?.map((e) => e.toJson()).toList(),
        'intro': intro,
        'game_rate': gameRate,
      };
}
