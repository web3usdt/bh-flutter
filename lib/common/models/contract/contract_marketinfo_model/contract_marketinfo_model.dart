import 'package:BBIExchange/common/index.dart';

class ContractMarketinfoModel {
  List<SwapBuyList>? swapBuyList;
  List<SwapSellList>? swapSellList;
  List<SwapTradeList>? swapTradeList;

  ContractMarketinfoModel({
    this.swapBuyList,
    this.swapSellList,
    this.swapTradeList,
  });

  factory ContractMarketinfoModel.fromJson(Map<String, dynamic> json) {
    return ContractMarketinfoModel(
      swapBuyList: (json['swapBuyList'] as List<dynamic>?)?.map((e) => SwapBuyList.fromJson(e as Map<String, dynamic>)).toList(),
      swapSellList: (json['swapSellList'] as List<dynamic>?)?.map((e) => SwapSellList.fromJson(e as Map<String, dynamic>)).toList(),
      swapTradeList: (json['swapTradeList'] as List<dynamic>?)?.map((e) => SwapTradeList.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'swapBuyList': swapBuyList?.map((e) => e.toJson()).toList(),
        'swapSellList': swapSellList?.map((e) => e.toJson()).toList(),
        'swapTradeList': swapTradeList?.map((e) => e.toJson()).toList(),
      };
}
