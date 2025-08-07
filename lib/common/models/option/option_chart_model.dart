import 'package:happy/common/index.dart';

class OptionChartModel {
  int? id;
  int? ts;
  int? tradeId;
  double? amount;
  double? price;
  String? direction;
  double? increase;
  String? increaseStr;

  OptionChartModel({
    this.id,
    this.ts,
    this.tradeId,
    this.amount,
    this.price,
    this.direction,
    this.increase,
    this.increaseStr,
  });

  factory OptionChartModel.fromJson(Map<String, dynamic> json) {
    return OptionChartModel(
      id: DataUtils.toInt(json['id']),
      ts: DataUtils.toInt(json['ts']),
      tradeId: DataUtils.toInt(json['tradeId']),
      amount: DataUtils.toDouble(json['amount']),
      price: DataUtils.toDouble(json['price']),
      direction: DataUtils.toStr(json['direction']),
      increase: DataUtils.toDouble(json['increase']),
      increaseStr: DataUtils.toStr(json['increaseStr']),
    );
  }

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
