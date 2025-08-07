import 'package:happy/common/index.dart';

class GameDetailModel {
  int? amount;
  int? profitAndLoss;
  int? num;
  String? winRate;
  String? inviteUrl;

  GameDetailModel({
    this.amount,
    this.profitAndLoss,
    this.num,
    this.winRate,
    this.inviteUrl,
  });

  factory GameDetailModel.fromJson(Map<String, dynamic> json) {
    return GameDetailModel(
      amount: DataUtils.toInt(json['amount']),
      profitAndLoss: DataUtils.toInt(json['profitAndLoss']),
      num: DataUtils.toInt(json['num']),
      winRate: DataUtils.toStr(json['winRate']),
      inviteUrl: DataUtils.toStr(json['invite_url']),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'profitAndLoss': profitAndLoss,
        'num': num,
        'winRate': winRate,
        'invite_url': inviteUrl,
      };
}
