import 'package:BBIExchange/common/index.dart';

class OptionCoinListModel {
  int? id;
  int? coinId;
  String? coinName;
  String? minAmount;
  String? maxAmount;
  int? isBet;
  int? sort;
  String? createdAt;
  dynamic updatedAt;

  OptionCoinListModel({
    this.id,
    this.coinId,
    this.coinName,
    this.minAmount,
    this.maxAmount,
    this.isBet,
    this.sort,
    this.createdAt,
    this.updatedAt,
  });

  factory OptionCoinListModel.fromJson(Map<String, dynamic> json) {
    return OptionCoinListModel(
      id: DataUtils.toInt(json['id']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      minAmount: DataUtils.toStr(json['min_amount']),
      maxAmount: DataUtils.toStr(json['max_amount']),
      isBet: DataUtils.toInt(json['is_bet']),
      sort: DataUtils.toInt(json['sort']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin_id': coinId,
        'coin_name': coinName,
        'min_amount': minAmount,
        'max_amount': maxAmount,
        'is_bet': isBet,
        'sort': sort,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
