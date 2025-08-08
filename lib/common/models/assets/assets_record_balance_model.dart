import 'package:BBIExchange/common/index.dart';

class AssetsRecordBalanceModel {
  String? usableBalance;
  String? freezeBalance;
  String? totalAssets;

  AssetsRecordBalanceModel({
    this.usableBalance,
    this.freezeBalance,
    this.totalAssets,
  });

  factory AssetsRecordBalanceModel.fromJson(Map<String, dynamic> json) {
    return AssetsRecordBalanceModel(
      usableBalance: DataUtils.toStr(json['usable_balance']),
      freezeBalance: DataUtils.toStr(json['freeze_balance']),
      totalAssets: DataUtils.toStr(json['total_assets']),
    );
  }

  Map<String, dynamic> toJson() => {
        'usable_balance': usableBalance,
        'freeze_balance': freezeBalance,
        'total_assets': totalAssets,
      };
}
