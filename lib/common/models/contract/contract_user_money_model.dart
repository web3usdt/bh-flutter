import 'package:BBIExchange/common/index.dart';

class ContractUserMoneyModel {
  double? usableBalance;
  int? usedBalance;
  int? freezeBalance;
  String? totalUnrealProfit;
  String? accountEquity;
  String? riskRate;
  String? leverRate;

  ContractUserMoneyModel({
    this.usableBalance,
    this.usedBalance,
    this.freezeBalance,
    this.totalUnrealProfit,
    this.accountEquity,
    this.riskRate,
    this.leverRate,
  });

  factory ContractUserMoneyModel.fromJson(Map<String, dynamic> json) {
    return ContractUserMoneyModel(
      usableBalance: DataUtils.toDouble(json['usable_balance']),
      usedBalance: DataUtils.toInt(json['used_balance']),
      freezeBalance: DataUtils.toInt(json['freeze_balance']),
      totalUnrealProfit: DataUtils.toStr(json['totalUnrealProfit']),
      accountEquity: DataUtils.toStr(json['account_equity']),
      riskRate: DataUtils.toStr(json['riskRate']),
      leverRate: DataUtils.toStr(json['lever_rate']),
    );
  }

  Map<String, dynamic> toJson() => {
        'usable_balance': usableBalance,
        'used_balance': usedBalance,
        'freeze_balance': freezeBalance,
        'totalUnrealProfit': totalUnrealProfit,
        'account_equity': accountEquity,
        'riskRate': riskRate,
        'lever_rate': leverRate,
      };
}
