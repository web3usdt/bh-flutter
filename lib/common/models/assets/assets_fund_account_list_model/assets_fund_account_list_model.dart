import 'package:happy/common/index.dart';

import 'symbol.dart';

class AssetsFundAccountListModel {
  String? usableBalance;
  String? freezeBalance;
  String? valuation;
  String? coinName;
  int? coinId;
  String? image;
  String? fullName;
  String? usdEstimate;
  List<AssetsFundAccountListModelSymbol>? symbol;
  int? qtyDecimals;
  int? priceDecimals;
  int? isWithdraw;
  int? isRecharge;
  String? withdrawalMin;
  String? withdrawalMax;
  int? order;
  dynamic legalBalance;

  AssetsFundAccountListModel({
    this.usableBalance,
    this.freezeBalance,
    this.valuation,
    this.coinName,
    this.coinId,
    this.image,
    this.fullName,
    this.usdEstimate,
    this.symbol,
    this.qtyDecimals,
    this.priceDecimals,
    this.isWithdraw,
    this.isRecharge,
    this.withdrawalMin,
    this.withdrawalMax,
    this.order,
    this.legalBalance,
  });

  factory AssetsFundAccountListModel.fromJson(Map<String, dynamic> json) {
    return AssetsFundAccountListModel(
      usableBalance: json['usable_balance']?.toString(),
      freezeBalance: json['freeze_balance']?.toString(),
      valuation: json['valuation']?.toString(),
      coinName: DataUtils.toStr(json['coin_name']),
      coinId: DataUtils.toInt(json['coin_id']),
      image: DataUtils.toStr(json['image']),
      fullName: DataUtils.toStr(json['full_name']),
      usdEstimate: DataUtils.toStr(json['usd_estimate']),
      symbol: (json['symbol'] as List<dynamic>?)?.map((e) => AssetsFundAccountListModelSymbol.fromJson(e as Map<String, dynamic>)).toList(),
      qtyDecimals: DataUtils.toInt(json['qtyDecimals']),
      priceDecimals: DataUtils.toInt(json['priceDecimals']),
      isWithdraw: DataUtils.toInt(json['is_withdraw']),
      isRecharge: DataUtils.toInt(json['is_recharge']),
      withdrawalMin: json['withdrawal_min']?.toString(),
      withdrawalMax: json['withdrawal_max']?.toString(),
      order: DataUtils.toInt(json['order']),
      legalBalance: DataUtils.toStr(json['legal_balance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'usable_balance': usableBalance,
        'freeze_balance': freezeBalance,
        'valuation': valuation,
        'coin_name': coinName,
        'coin_id': coinId,
        'image': image,
        'full_name': fullName,
        'usd_estimate': usdEstimate,
        'symbol': symbol?.map((e) => e.toJson()).toList(),
        'qtyDecimals': qtyDecimals,
        'priceDecimals': priceDecimals,
        'is_withdraw': isWithdraw,
        'is_recharge': isRecharge,
        'withdrawal_min': withdrawalMin,
        'withdrawal_max': withdrawalMax,
        'order': order,
        'legal_balance': legalBalance,
      };
}
