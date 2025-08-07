import 'package:happy/common/index.dart';

class GameCoinlistModel {
  int? id;
  int? userId;
  int? coinId;
  String? coinName;
  double? usableBalance;
  double? freezeBalance;
  String? createdAt;
  String? updatedAt;
  String? image;

  GameCoinlistModel({
    this.id,
    this.userId,
    this.coinId,
    this.coinName,
    this.usableBalance,
    this.freezeBalance,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  factory GameCoinlistModel.fromJson(Map<String, dynamic> json) {
    return GameCoinlistModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      usableBalance: DataUtils.toDouble(json['usable_balance']),
      freezeBalance: DataUtils.toDouble(json['freeze_balance']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      image: DataUtils.toStr(json['image']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'coin_id': coinId,
        'coin_name': coinName,
        'usable_balance': usableBalance,
        'freeze_balance': freezeBalance,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'image': image,
      };
}
