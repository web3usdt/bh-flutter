import 'package:happy/common/index.dart';

class OptionIndexListModelScenePairList {
  int? sceneId;
  String? sceneSn;
  int? timeId;
  int? seconds;
  int? pairId;
  String? pairTimeName;
  List<OptionIndexListModelUpOdd>? upOdds;
  List<OptionIndexListModelDownOdd>? downOdds;
  List<OptionIndexListModelDrawOdd>? drawOdds;
  int? beginTime;
  int? endTime;
  double? beginPrice;
  dynamic endPrice;
  dynamic deliveryUpDown;
  dynamic deliveryRange;
  dynamic deliveryTime;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? upodds;
  String? downodds;
  double? increase;
  String? increaseStr;
  double? trendUp;
  double? trendDown;
  List<double>? prices;
  String? beginTimeText;
  String? endTimeText;
  String? statusText;
  int? lotteryTime;
  String? pairName;
  String? coinIcon;
  String? timeName;
  String? deliveryAmount;
  String? betCoinName;
  String? range;
  int? upDown;
  String? betAmount;
  int? orderId;
  String? orderNo;
  String? odds;
  String? fee;
  dynamic scene;
  OptionIndexListModelScenePairList({
    this.sceneId,
    this.sceneSn,
    this.timeId,
    this.seconds,
    this.pairId,
    this.pairTimeName,
    this.upOdds,
    this.downOdds,
    this.drawOdds,
    this.beginTime,
    this.endTime,
    this.beginPrice,
    this.endPrice,
    this.deliveryUpDown,
    this.deliveryRange,
    this.deliveryTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.upodds,
    this.downodds,
    this.increase,
    this.increaseStr,
    this.trendUp,
    this.trendDown,
    this.prices,
    this.beginTimeText,
    this.endTimeText,
    this.statusText,
    this.lotteryTime,
    this.pairName,
    this.coinIcon,
    this.timeName,
    this.deliveryAmount,
    this.betCoinName,
    this.range,
    this.upDown,
    this.betAmount,
    this.orderId,
    this.orderNo,
    this.odds,
    this.fee,
    this.scene,
  });

  factory OptionIndexListModelScenePairList.fromJson(Map<String, dynamic> json) => OptionIndexListModelScenePairList(
        sceneId: DataUtils.toInt(json['scene_id']),
        sceneSn: DataUtils.toStr(json['scene_sn']),
        timeId: DataUtils.toInt(json['time_id']),
        seconds: DataUtils.toInt(json['seconds']),
        pairId: DataUtils.toInt(json['pair_id']),
        pairTimeName: DataUtils.toStr(json['pair_time_name']),
        upOdds: (json['up_odds'] is List)
            ? (json['up_odds'] as List<dynamic>?)?.map((e) => OptionIndexListModelUpOdd.fromJson(e as Map<String, dynamic>)).toList()
            : [],
        downOdds: (json['down_odds'] is List)
            ? (json['down_odds'] as List<dynamic>?)?.map((e) => OptionIndexListModelDownOdd.fromJson(e as Map<String, dynamic>)).toList()
            : [],
        drawOdds: (json['draw_odds'] is List)
            ? (json['draw_odds'] as List<dynamic>?)?.map((e) => OptionIndexListModelDrawOdd.fromJson(e as Map<String, dynamic>)).toList()
            : [],
        beginTime: DataUtils.toInt(json['begin_time']),
        endTime: DataUtils.toInt(json['end_time']),
        beginPrice: DataUtils.toDouble(json['begin_price']),
        endPrice: DataUtils.toDouble(json['end_price']),
        deliveryUpDown: DataUtils.toInt(json['delivery_up_down']),
        deliveryRange: DataUtils.toStr(json['delivery_range']),
        deliveryTime: DataUtils.toStr(json['delivery_time']),
        status: DataUtils.toInt(json['status']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
        upodds: DataUtils.toStr(json['upodds']),
        downodds: DataUtils.toStr(json['downodds']),
        increase: DataUtils.toDouble(json['increase']),
        increaseStr: DataUtils.toStr(json['increaseStr']),
        trendUp: DataUtils.toDouble(json['trend_up']),
        trendDown: DataUtils.toDouble(json['trend_down']),
        prices: (json['prices'] is List) ? (json['prices'] as List).map((e) => DataUtils.toDouble(e) ?? 0.0).toList() : [],
        beginTimeText: DataUtils.toStr(json['begin_time_text']),
        endTimeText: DataUtils.toStr(json['end_time_text']),
        statusText: DataUtils.toStr(json['status_text']),
        lotteryTime: DataUtils.toInt(json['lottery_time']),
        pairName: DataUtils.toStr(json['pair_name']),
        coinIcon: DataUtils.toStr(json['coin_icon']),
        timeName: DataUtils.toStr(json['time_name']),
        deliveryAmount: DataUtils.toStr(json['delivery_amount']),
        betCoinName: DataUtils.toStr(json['bet_coin_name']),
        range: DataUtils.toStr(json['range']),
        upDown: DataUtils.toInt(json['up_down']),
        betAmount: DataUtils.toStr(json['bet_amount']),
        orderId: DataUtils.toInt(json['order_id']),
        orderNo: DataUtils.toStr(json['order_no']),
        odds: DataUtils.toStr(json['odds']),
        fee: DataUtils.toStr(json['fee']),
        scene: (json['scene'] is Map) ? json['scene'] as Map<String, dynamic> : null,
      );

  Map<String, dynamic> toJson() => {
        'scene_id': sceneId,
        'scene_sn': sceneSn,
        'time_id': timeId,
        'seconds': seconds,
        'pair_id': pairId,
        'pair_time_name': pairTimeName,
        'up_odds': upOdds?.map((e) => e.toJson()).toList(),
        'down_odds': downOdds?.map((e) => e.toJson()).toList(),
        'draw_odds': drawOdds?.map((e) => e.toJson()).toList(),
        'begin_time': beginTime,
        'end_time': endTime,
        'begin_price': beginPrice,
        'end_price': endPrice,
        'delivery_up_down': deliveryUpDown,
        'delivery_range': deliveryRange,
        'delivery_time': deliveryTime,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'upodds': upodds,
        'downodds': downodds,
        'increase': increase,
        'increaseStr': increaseStr,
        'trend_up': trendUp,
        'trend_down': trendDown,
        'prices': prices,
        'begin_time_text': beginTimeText,
        'end_time_text': endTimeText,
        'status_text': statusText,
        'lottery_time': lotteryTime,
        'pair_name': pairName,
        'coin_icon': coinIcon,
        'time_name': timeName,
        'delivery_amount': deliveryAmount,
        'bet_coin_name': betCoinName,
        'range': range,
        'up_down': upDown,
        'bet_amount': betAmount,
        'order_id': orderId,
        'order_no': orderNo,
        'odds': odds,
        'fee': fee,
        'scene': scene,
      };
}
