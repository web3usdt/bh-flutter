import 'package:happy/common/index.dart';

class AssetsMinerAccountModel {
  int? id;
  int? userId;
  int? coinId;
  String? coinName;
  String? usableBalance;
  String? freezeBalance;
  dynamic createdAt;
  dynamic updatedAt;
  String? image;

  AssetsMinerAccountModel({
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

  factory AssetsMinerAccountModel.fromJson(Map<String, dynamic> json) {
    return AssetsMinerAccountModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      usableBalance: DataUtils.toStr(json['usable_balance']),
      freezeBalance: DataUtils.toStr(json['freeze_balance']),
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
