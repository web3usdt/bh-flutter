import 'package:happy/common/index.dart';

class OptionBuyReq {
  String? betAmount;
  String? betCoinId;
  String? oddsUuid;
  String? sceneId;

  OptionBuyReq({
    this.betAmount,
    this.betCoinId,
    this.oddsUuid,
    this.sceneId,
  });

  factory OptionBuyReq.fromJson(Map<String, dynamic> json) => OptionBuyReq(
        betAmount: DataUtils.toStr(json['bet_amount']),
        betCoinId: DataUtils.toStr(json['bet_coin_id']),
        oddsUuid: DataUtils.toStr(json['odds_uuid']),
        sceneId: DataUtils.toStr(json['scene_id']),
      );

  Map<String, dynamic> toJson() => {
        'bet_amount': betAmount,
        'bet_coin_id': betCoinId,
        'odds_uuid': oddsUuid,
        'scene_id': sceneId,
      };
}
