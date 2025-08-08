import 'package:BBIExchange/common/index.dart';

class CoinMarketinfoModel {
  List<BuyList>? buyList;
  List<SellList>? sellList;
  String? max;
  String? min;
  List<TradeList>? tradeList;

  CoinMarketinfoModel({
    this.buyList,
    this.sellList,
    this.max,
    this.min,
    this.tradeList,
  });

  factory CoinMarketinfoModel.fromJson(Map<String, dynamic> json) {
    return CoinMarketinfoModel(
      buyList: (json['buyList'] as List<dynamic>?)?.map((e) => BuyList.fromJson(e as Map<String, dynamic>)).toList(),
      sellList: (json['sellList'] as List<dynamic>?)?.map((e) => SellList.fromJson(e as Map<String, dynamic>)).toList(),
      max: DataUtils.toStr(json['max']),
      min: DataUtils.toStr(json['min']),
      tradeList: (json['tradeList'] as List<dynamic>?)?.map((e) => TradeList.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'buyList': buyList?.map((e) => e.toJson()).toList(),
        'sellList': sellList?.map((e) => e.toJson()).toList(),
        'max': max,
        'min': min,
        'tradeList': tradeList?.map((e) => e.toJson()).toList(),
      };
}
