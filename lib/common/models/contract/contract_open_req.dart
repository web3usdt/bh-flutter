import 'package:BBIExchange/common/index.dart';

class ContractOpenReq {
  String? side;
  String? symbol;
  String? type;
  String? entrustPrice;
  String? amount;
  String? leverRate;
  String? tpTriggerPrice;
  String? slTriggerPrice;

  ContractOpenReq({
    this.side,
    this.symbol,
    this.type,
    this.entrustPrice,
    this.amount,
    this.leverRate,
    this.tpTriggerPrice,
    this.slTriggerPrice,
  });

  factory ContractOpenReq.fromJson(Map<String, dynamic> json) {
    return ContractOpenReq(
      side: DataUtils.toStr(json['side']),
      symbol: DataUtils.toStr(json['symbol']),
      type: DataUtils.toStr(json['type']),
      entrustPrice: DataUtils.toStr(json['entrust_price']),
      amount: DataUtils.toStr(json['amount']),
      leverRate: DataUtils.toStr(json['lever_rate']),
      tpTriggerPrice: DataUtils.toStr(json['tp_trigger_price']),
      slTriggerPrice: DataUtils.toStr(json['sl_trigger_price']),
    );
  }

  Map<String, dynamic> toJson() => {
        'side': side,
        'symbol': symbol,
        'type': type,
        'entrust_price': entrustPrice,
        'amount': amount,
        'lever_rate': leverRate,
        'tp_trigger_price': tpTriggerPrice,
        'sl_trigger_price': slTriggerPrice,
      };
}
