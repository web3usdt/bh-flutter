import 'package:BBIExchange/common/index.dart';

class CoinMyAuthorizeModel {
  int? id;
  String? orderNo;
  int? userId;
  int? entrustType;
  String? symbol;
  int? type;
  String? entrustPrice;
  String? triggerPrice;
  int? quoteCoinId;
  int? baseCoinId;
  String? amount;
  String? tradedAmount;
  String? money;
  String? tradedMoney;
  int? status;
  dynamic hangStatus;
  int? cancelTime;
  String? createdAt;
  String? updatedAt;
  int? isTraded;
  int? surplusAmount;
  String? statusText;
  String? entrustTypeText;
  String? avgPrice;

  CoinMyAuthorizeModel({
    this.id,
    this.orderNo,
    this.userId,
    this.entrustType,
    this.symbol,
    this.type,
    this.entrustPrice,
    this.triggerPrice,
    this.quoteCoinId,
    this.baseCoinId,
    this.amount,
    this.tradedAmount,
    this.money,
    this.tradedMoney,
    this.status,
    this.hangStatus,
    this.cancelTime,
    this.createdAt,
    this.updatedAt,
    this.isTraded,
    this.surplusAmount,
    this.statusText,
    this.entrustTypeText,
    this.avgPrice,
  });

  factory CoinMyAuthorizeModel.fromJson(Map<String, dynamic> json) {
    return CoinMyAuthorizeModel(
      id: DataUtils.toInt(json['id']),
      orderNo: DataUtils.toStr(json['order_no']),
      userId: DataUtils.toInt(json['user_id']),
      entrustType: DataUtils.toInt(json['entrust_type']),
      symbol: DataUtils.toStr(json['symbol']),
      type: DataUtils.toInt(json['type']),
      entrustPrice: formatDecimal(DataUtils.toStr(json['entrust_price']), toFixed: 10),
      triggerPrice: formatDecimal(DataUtils.toStr(json['trigger_price']), toFixed: 10),
      quoteCoinId: DataUtils.toInt(json['quote_coin_id']),
      baseCoinId: DataUtils.toInt(json['base_coin_id']),
      amount: formatDecimal(DataUtils.toStr(json['amount']), toFixed: 10),
      tradedAmount: formatDecimal(DataUtils.toStr(json['traded_amount']), toFixed: 10),
      money: formatDecimal(DataUtils.toStr(json['money']), toFixed: 10),
      tradedMoney: formatDecimal(DataUtils.toStr(json['traded_money']), toFixed: 10),
      status: DataUtils.toInt(json['status']),
      hangStatus: DataUtils.toStr(json['hang_status']),
      cancelTime: DataUtils.toInt(json['cancel_time']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      isTraded: DataUtils.toInt(json['is_traded']),
      surplusAmount: DataUtils.toInt(json['surplus_amount']),
      statusText: DataUtils.toStr(json['status_text']),
      entrustTypeText: DataUtils.toStr(json['entrust_type_text']),
      avgPrice: formatDecimal(DataUtils.toStr(json['avg_price']), toFixed: 10),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_no': orderNo,
        'user_id': userId,
        'entrust_type': entrustType,
        'symbol': symbol,
        'type': type,
        'entrust_price': entrustPrice,
        'trigger_price': triggerPrice,
        'quote_coin_id': quoteCoinId,
        'base_coin_id': baseCoinId,
        'amount': amount,
        'traded_amount': tradedAmount,
        'money': money,
        'traded_money': tradedMoney,
        'status': status,
        'hang_status': hangStatus,
        'cancel_time': cancelTime,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_traded': isTraded,
        'surplus_amount': surplusAmount,
        'status_text': statusText,
        'entrust_type_text': entrustTypeText,
        'avg_price': avgPrice,
      };
}
