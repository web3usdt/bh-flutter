import 'package:happy/common/index.dart';

class Coin {
  int? id;
  int? coinId;
  String? coinName;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? min;
  int? max;
  String? usableBalance;
  String? freezeBalance;

  Coin({
    this.id,
    this.coinId,
    this.coinName,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.min,
    this.max,
    this.usableBalance,
    this.freezeBalance,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        id: DataUtils.toInt(json['id']),
        coinId: DataUtils.toInt(json['coin_id']),
        coinName: DataUtils.toStr(json['coin_name']),
        status: DataUtils.toInt(json['status']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
        min: DataUtils.toInt(json['min']),
        max: DataUtils.toInt(json['max']),
        usableBalance: DataUtils.toStr(json['usable_balance']),
        freezeBalance: DataUtils.toStr(json['freeze_balance']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin_id': coinId,
        'coin_name': coinName,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'min': min,
        'max': max,
        'usable_balance': usableBalance,
        'freeze_balance': freezeBalance,
      };
}
