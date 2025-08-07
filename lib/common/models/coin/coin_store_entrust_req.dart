import 'package:happy/common/index.dart';

class CoinStoreEntrustReq {
  String? direction;
  String? type;
  String? symbol;
  String? entrustPrice;
  String? amount;
  String? triggerPrice;
  String? total;

  CoinStoreEntrustReq({
    this.direction,
    this.type,
    this.symbol,
    this.entrustPrice,
    this.amount,
    this.triggerPrice,
    this.total,
  });

  factory CoinStoreEntrustReq.fromJson(Map<String, dynamic> json) {
    return CoinStoreEntrustReq(
      direction: DataUtils.toStr(json['direction']),
      type: DataUtils.toStr(json['type']),
      symbol: DataUtils.toStr(json['symbol']),
      entrustPrice: DataUtils.toStr(json['entrust_price']),
      amount: DataUtils.toStr(json['amount']),
      triggerPrice: DataUtils.toStr(json['trigger_price']),
      total: DataUtils.toStr(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'type': type,
        'symbol': symbol,
        'entrust_price': entrustPrice,
        'amount': amount,
        'trigger_price': triggerPrice,
        'total': total,
      };
}
