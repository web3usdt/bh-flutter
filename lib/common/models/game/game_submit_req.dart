import 'package:BBIExchange/common/index.dart';

class GameSubmitReq {
  String? type;
  String? coinId;
  String? amount;
  String? expect;

  GameSubmitReq({this.type, this.coinId, this.amount, this.expect});

  factory GameSubmitReq.fromJson(Map<String, dynamic> json) => GameSubmitReq(
        type: DataUtils.toStr(json['type']),
        coinId: DataUtils.toStr(json['coin_id']),
        amount: DataUtils.toStr(json['amount']),
        expect: DataUtils.toStr(json['expect']),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'coin_id': coinId,
        'amount': amount,
        'expect': expect,
      };
}
