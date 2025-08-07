import 'package:happy/common/index.dart';

class MiningDestoryPowerReq {
  double? amount;
  String? coinId;
  String? coinType;
  String? accountType;

  MiningDestoryPowerReq({
    this.amount,
    this.coinId,
    this.coinType,
    this.accountType,
  });

  factory MiningDestoryPowerReq.fromJson(Map<String, dynamic> json) {
    return MiningDestoryPowerReq(
      amount: DataUtils.toDouble(json['amount']),
      coinId: DataUtils.toStr(json['coin_id']),
      coinType: DataUtils.toStr(json['coin_type']),
      accountType: DataUtils.toStr(json['account_type']),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'coin_id': coinId,
        'coin_type': coinType,
        'account_type': accountType,
      };
}
