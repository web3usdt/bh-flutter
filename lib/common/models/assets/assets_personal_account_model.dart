import 'package:BBIExchange/common/index.dart';

class AssetsPersonalAccountModel {
  String? fundsAccountUsd;
  String? fundsAccountBtc;
  String? contractAccountUsd;
  String? contractAccountBtc;
  String? otcAccountUsd;
  String? otcAccountBtc;
  String? totalAssetsUsd;
  String? totalAssetsBtc;
  int? priceDecimals;
  int? qtyDecimals;
  String? minerAccountBb;
  String? gameAccountUsd;

  AssetsPersonalAccountModel({
    this.fundsAccountUsd,
    this.fundsAccountBtc,
    this.contractAccountUsd,
    this.contractAccountBtc,
    this.otcAccountUsd,
    this.otcAccountBtc,
    this.totalAssetsUsd,
    this.totalAssetsBtc,
    this.priceDecimals,
    this.qtyDecimals,
    this.minerAccountBb,
    this.gameAccountUsd,
  });

  factory AssetsPersonalAccountModel.fromJson(Map<String, dynamic> json) {
    return AssetsPersonalAccountModel(
      fundsAccountUsd: json['funds_account_usd']?.toString(),
      fundsAccountBtc: json['funds_account_btc']?.toString(),
      contractAccountUsd: json['contract_account_usd']?.toString(),
      contractAccountBtc: json['contract_account_btc']?.toString(),
      otcAccountUsd: json['otc_account_usd']?.toString(),
      otcAccountBtc: json['otc_account_btc']?.toString(),
      totalAssetsUsd: json['total_assets_usd']?.toString(),
      totalAssetsBtc: json['total_assets_btc']?.toString(),
      priceDecimals: DataUtils.toInt(json['priceDecimals']),
      qtyDecimals: DataUtils.toInt(json['qtyDecimals']),
      minerAccountBb: json['miner_account_bb']?.toString(),
      gameAccountUsd: json['game_account_usd']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'funds_account_usd': fundsAccountUsd,
        'funds_account_btc': fundsAccountBtc,
        'contract_account_usd': contractAccountUsd,
        'contract_account_btc': contractAccountBtc,
        'otc_account_usd': otcAccountUsd,
        'otc_account_btc': otcAccountBtc,
        'total_assets_usd': totalAssetsUsd,
        'total_assets_btc': totalAssetsBtc,
        'priceDecimals': priceDecimals,
        'qtyDecimals': qtyDecimals,
        'miner_account_bb': minerAccountBb,
        'game_account_usd': gameAccountUsd,
      };
}
