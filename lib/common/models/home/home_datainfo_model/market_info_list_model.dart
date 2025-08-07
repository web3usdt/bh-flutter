import 'package:happy/common/index.dart';

class MarketInfoListModel {
  int? id;
  String? count;
  String? open;
  String? low;
  String? high;
  String? vol;
  int? version;
  int? ts;
  String? amount;
  String? close;
  String? price;
  double? increase;
  String? increaseStr;
  List<double>? prices;
  String? coinName;
  String? coinIcon;
  String? pairName;
  int? pairId;
  int? isCollect;
  String? marketInfoList;
  String? symbol;

  MarketInfoListModel({
    this.id,
    this.count,
    this.open,
    this.low,
    this.high,
    this.vol,
    this.version,
    this.ts,
    this.amount,
    this.close,
    this.price,
    this.increase,
    this.increaseStr,
    this.prices,
    this.coinName,
    this.coinIcon,
    this.pairName,
    this.pairId,
    this.isCollect,
    this.marketInfoList,
    this.symbol,
  });

  factory MarketInfoListModel.fromJson(Map<String, dynamic> json) {
    return MarketInfoListModel(
      id: DataUtils.toInt(json['id']),
      count: DataUtils.toStr(json['count']),
      open: DataUtils.toStr(json['open']),
      low: DataUtils.toStr(json['low']),
      high: DataUtils.toStr(json['high']),
      vol: DataUtils.toStr(json['vol']),
      version: DataUtils.toInt(json['version']),
      ts: DataUtils.toInt(json['ts']),
      amount: DataUtils.toStr(json['amount']),
      close: DataUtils.toStr(json['close']),
      price: DataUtils.toStr(json['price']),
      increase: DataUtils.toDouble(json['increase']),
      increaseStr: DataUtils.toStr(json['increaseStr']),
      prices: (json['prices'] is List) ? (json['prices'] as List).map((e) => DataUtils.toDouble(e) ?? 0.0).toList() : [],
      coinName: DataUtils.toStr(json['coin_name']),
      coinIcon: DataUtils.toStr(json['coin_icon']),
      pairName: DataUtils.toStr(json['pair_name']),
      pairId: DataUtils.toInt(json['pair_id']),
      isCollect: DataUtils.toInt(json['is_collect']),
      marketInfoList: DataUtils.toStr(json['marketInfoList']),
      symbol: DataUtils.toStr(json['symbol']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'count': count,
        'open': open,
        'low': low,
        'high': high,
        'vol': vol,
        'version': version,
        'ts': ts,
        'amount': amount,
        'close': close,
        'price': price,
        'increase': increase,
        'increaseStr': increaseStr,
        'prices': prices,
        'coin_name': coinName,
        'coin_icon': coinIcon,
        'pair_name': pairName,
        'pair_id': pairId,
        'is_collect': isCollect,
        'marketInfoList': marketInfoList,
        'symbol': symbol,
      };
}
