import 'package:BBIExchange/common/index.dart';

class ContractMyAuthorizeModel {
  int? id;
  String? orderNo;
  int? orderType;
  int? userId;
  int? side;
  int? contractId;
  int? contractCoinId;
  String? symbol;
  int? marginCoinId;
  String? unitAmount;
  int? type;
  dynamic entrustPrice;
  dynamic triggerPrice;
  int? amount;
  int? tradedAmount;
  dynamic avgPrice;
  dynamic profit;
  dynamic settleProfit;
  int? isWear;
  int? leverRate;
  String? margin;
  String? fee;
  int? status;
  int? hangStatus;
  dynamic cancelTime;
  int? ts;
  int? system;
  String? createdAt;
  String? updatedAt;
  dynamic surplusAmount;
  String? statusText;

  ContractMyAuthorizeModel({
    this.id,
    this.orderNo,
    this.orderType,
    this.userId,
    this.side,
    this.contractId,
    this.contractCoinId,
    this.symbol,
    this.marginCoinId,
    this.unitAmount,
    this.type,
    this.entrustPrice,
    this.triggerPrice,
    this.amount,
    this.tradedAmount,
    this.avgPrice,
    this.profit,
    this.settleProfit,
    this.isWear,
    this.leverRate,
    this.margin,
    this.fee,
    this.status,
    this.hangStatus,
    this.cancelTime,
    this.ts,
    this.system,
    this.createdAt,
    this.updatedAt,
    this.surplusAmount,
    this.statusText,
  });

  factory ContractMyAuthorizeModel.fromJson(Map<String, dynamic> json) {
    return ContractMyAuthorizeModel(
      id: DataUtils.toInt(json['id']),
      orderNo: DataUtils.toStr(json['order_no']),
      orderType: DataUtils.toInt(json['order_type']),
      userId: DataUtils.toInt(json['user_id']),
      side: DataUtils.toInt(json['side']),
      contractId: DataUtils.toInt(json['contract_id']),
      contractCoinId: DataUtils.toInt(json['contract_coin_id']),
      symbol: DataUtils.toStr(json['symbol']),
      marginCoinId: DataUtils.toInt(json['margin_coin_id']),
      unitAmount: DataUtils.toStr(json['unit_amount']),
      type: DataUtils.toInt(json['type']),
      entrustPrice: DataUtils.toStr(json['entrust_price']),
      triggerPrice: DataUtils.toStr(json['trigger_price']),
      amount: DataUtils.toInt(json['amount']),
      tradedAmount: DataUtils.toInt(json['traded_amount']),
      avgPrice: DataUtils.toStr(json['avg_price']),
      profit: DataUtils.toStr(json['profit']),
      settleProfit: DataUtils.toStr(json['settle_profit']),
      isWear: DataUtils.toInt(json['is_wear']),
      leverRate: DataUtils.toInt(json['lever_rate']),
      margin: DataUtils.toStr(json['margin']),
      fee: DataUtils.toStr(json['fee']),
      status: DataUtils.toInt(json['status']),
      hangStatus: DataUtils.toInt(json['hang_status']),
      cancelTime: DataUtils.toStr(json['cancel_time']),
      ts: DataUtils.toInt(json['ts']),
      system: DataUtils.toInt(json['system']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      surplusAmount: DataUtils.toStr(json['surplus_amount']),
      statusText: DataUtils.toStr(json['status_text']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_no': orderNo,
        'order_type': orderType,
        'user_id': userId,
        'side': side,
        'contract_id': contractId,
        'contract_coin_id': contractCoinId,
        'symbol': symbol,
        'margin_coin_id': marginCoinId,
        'unit_amount': unitAmount,
        'type': type,
        'entrust_price': entrustPrice,
        'trigger_price': triggerPrice,
        'amount': amount,
        'traded_amount': tradedAmount,
        'avg_price': avgPrice,
        'profit': profit,
        'settle_profit': settleProfit,
        'is_wear': isWear,
        'lever_rate': leverRate,
        'margin': margin,
        'fee': fee,
        'status': status,
        'hang_status': hangStatus,
        'cancel_time': cancelTime,
        'ts': ts,
        'system': system,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'surplus_amount': surplusAmount,
        'status_text': statusText,
      };
}
