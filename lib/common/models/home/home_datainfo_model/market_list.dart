import 'package:BBIExchange/common/index.dart';

import 'market_info_list_model.dart';

class MarketList {
  String? coinName;
  List<MarketInfoListModel>? marketInfoList;

  MarketList({this.coinName, this.marketInfoList});

  factory MarketList.fromJson(Map<String, dynamic> json) => MarketList(
        coinName: DataUtils.toStr(json['coin_name']),
        marketInfoList: (json['marketInfoList'] as List<dynamic>?)?.map((e) => MarketInfoListModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'coin_name': coinName,
        'marketInfoList': marketInfoList?.map((e) => e.toJson()).toList(),
      };
}
