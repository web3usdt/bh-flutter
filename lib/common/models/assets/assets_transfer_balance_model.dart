import 'package:happy/common/index.dart';

class AssetsTransferBalanceModel {
  int? id;
  int? userId;
  int? coinId;
  String? coinName;
  String? marginName;
  String? usableBalance;
  String? usedBalance;
  String? freezeBalance;

  AssetsTransferBalanceModel({
    this.id,
    this.userId,
    this.coinId,
    this.coinName,
    this.marginName,
    this.usableBalance,
    this.usedBalance,
    this.freezeBalance,
  });

  factory AssetsTransferBalanceModel.fromJson(Map<String, dynamic> json) {
    return AssetsTransferBalanceModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      marginName: DataUtils.toStr(json['margin_name']),
      usableBalance: DataUtils.toStr(json['usable_balance']),
      usedBalance: DataUtils.toStr(json['used_balance']),
      freezeBalance: DataUtils.toStr(json['freeze_balance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'coin_id': coinId,
        'coin_name': coinName,
        'margin_name': marginName,
        'usable_balance': usableBalance,
        'used_balance': usedBalance,
        'freeze_balance': freezeBalance,
      };
}
