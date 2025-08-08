import 'package:BBIExchange/common/index.dart';

class MiningGetpowerModelWallet {
  int? walletId;
  int? userId;
  int? coinId;
  String? coinName;
  String? omniWalletAddress;
  dynamic trxWalletAddress;
  String? walletAddress;
  dynamic rawData;
  String? usableBalance;
  int? freezeBalance;
  String? createdAt;
  String? updatedAt;

  MiningGetpowerModelWallet({
    this.walletId,
    this.userId,
    this.coinId,
    this.coinName,
    this.omniWalletAddress,
    this.trxWalletAddress,
    this.walletAddress,
    this.rawData,
    this.usableBalance,
    this.freezeBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory MiningGetpowerModelWallet.fromJson(Map<String, dynamic> json) => MiningGetpowerModelWallet(
        walletId: DataUtils.toInt(json['wallet_id']),
        userId: DataUtils.toInt(json['user_id']),
        coinId: DataUtils.toInt(json['coin_id']),
        coinName: DataUtils.toStr(json['coin_name']),
        omniWalletAddress: DataUtils.toStr(json['omni_wallet_address']),
        trxWalletAddress: DataUtils.toStr(json['trx_wallet_address']),
        walletAddress: DataUtils.toStr(json['wallet_address']),
        rawData: DataUtils.toStr(json['raw_data']),
        usableBalance: DataUtils.toStr(json['usable_balance']),
        freezeBalance: DataUtils.toInt(json['freeze_balance']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'wallet_id': walletId,
        'user_id': userId,
        'coin_id': coinId,
        'coin_name': coinName,
        'omni_wallet_address': omniWalletAddress,
        'trx_wallet_address': trxWalletAddress,
        'wallet_address': walletAddress,
        'raw_data': rawData,
        'usable_balance': usableBalance,
        'freeze_balance': freezeBalance,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
