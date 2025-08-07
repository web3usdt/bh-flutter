import 'package:happy/common/index.dart';

class GameTransferReq {
  String? from;
  String? to;
  String? amount;
  String? coinId;

  GameTransferReq({
    this.from,
    this.to,
    this.amount,
    this.coinId,
  });

  factory GameTransferReq.fromJson(Map<String, dynamic> json) {
    return GameTransferReq(
      from: DataUtils.toStr(json['from']),
      to: DataUtils.toStr(json['to']),
      amount: DataUtils.toStr(json['amount']),
      coinId: DataUtils.toStr(json['coin_id']),
    );
  }

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': amount,
        'coin_id': coinId,
      };
}
