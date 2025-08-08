import 'package:BBIExchange/common/index.dart';

class HomeSubscribeCoinlistModel {
  String? coinName;
  int? qtyDecimals;
  int? priceDecimals;
  double? proportionAmount;
  String? subscribeCoinName;
  int? usableBalance;

  HomeSubscribeCoinlistModel({
    this.coinName,
    this.qtyDecimals,
    this.priceDecimals,
    this.proportionAmount,
    this.subscribeCoinName,
    this.usableBalance,
  });

  factory HomeSubscribeCoinlistModel.fromJson(Map<String, dynamic> json) {
    return HomeSubscribeCoinlistModel(
      coinName: DataUtils.toStr(json['coin_name']),
      qtyDecimals: DataUtils.toInt(json['qtyDecimals']),
      priceDecimals: DataUtils.toInt(json['priceDecimals']),
      proportionAmount: DataUtils.toDouble(json['proportion_amount']),
      subscribeCoinName: DataUtils.toStr(json['subscribe_coin_name']),
      usableBalance: DataUtils.toInt(json['usable_balance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_name': coinName,
        'qtyDecimals': qtyDecimals,
        'priceDecimals': priceDecimals,
        'proportion_amount': proportionAmount,
        'subscribe_coin_name': subscribeCoinName,
        'usable_balance': usableBalance,
      };
}
