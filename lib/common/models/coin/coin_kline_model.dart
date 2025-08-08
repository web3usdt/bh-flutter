import 'package:BBIExchange/common/index.dart';

class CoinKlineModel {
  int? id;
  double? open;
  double? close;
  double? low;
  double? high;
  double? amount;
  double? vol;
  int? count;

  CoinKlineModel({
    this.id,
    this.open,
    this.close,
    this.low,
    this.high,
    this.amount,
    this.vol,
    this.count,
  });

  factory CoinKlineModel.fromJson(Map<String, dynamic> json) {
    return CoinKlineModel(
      id: DataUtils.toInt(json['id']),
      open: DataUtils.toDouble(json['open']),
      close: DataUtils.toDouble(json['close']),
      low: DataUtils.toDouble(json['low']),
      high: DataUtils.toDouble(json['high']),
      amount: DataUtils.toDouble(json['amount']),
      vol: DataUtils.toDouble(json['vol']),
      count: DataUtils.toInt(json['count']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'open': open,
        'close': close,
        'low': low,
        'high': high,
        'amount': amount,
        'vol': vol,
        'count': count,
      };
}
