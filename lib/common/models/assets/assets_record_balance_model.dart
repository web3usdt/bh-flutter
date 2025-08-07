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
      usableBalance: json['usable_balance']?.toString(),
      freezeBalance: json['freeze_balance']?.toString(),
      totalAssets: json['total_assets']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'usable_balance': usableBalance,
        'freeze_balance': freezeBalance,
        'total_assets': totalAssets,
      };
}
