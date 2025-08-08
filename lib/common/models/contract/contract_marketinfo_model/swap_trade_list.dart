import 'package:BBIExchange/common/index.dart';

class SwapTradeList {
  String? id;
  int? ts;
  String? tradeId;
  String? amount;
  double? price;
  String? direction;
  double? increase;
  String? increaseStr;

  SwapTradeList({
    this.id,
    this.ts,
    this.tradeId,
    this.amount,
    this.price,
    this.direction,
    this.increase,
    this.increaseStr,
  });

  factory SwapTradeList.fromJson(Map<String, dynamic> json) => SwapTradeList(
        id: DataUtils.toStr(json['id']),
        ts: DataUtils.toInt(json['ts']),
        tradeId: DataUtils.toStr(json['tradeId']),
        amount: DataUtils.toStr(json['amount']),
        price: DataUtils.toDouble(json['price']),
        direction: DataUtils.toStr(json['direction']),
        increase: DataUtils.toDouble(json['increase']),
        increaseStr: DataUtils.toStr(json['increaseStr']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'tradeId': tradeId,
        'amount': amount,
        'price': price,
        'direction': direction,
        'increase': increase,
        'increaseStr': increaseStr,
      };
}
