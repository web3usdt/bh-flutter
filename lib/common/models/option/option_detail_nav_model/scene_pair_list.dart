import 'package:BBIExchange/common/index.dart';

class ScenePairList {
  int? sceneId;
  String? sceneSn;
  int? timeId;
  int? seconds;
  int? pairId;
  String? pairTimeName;
  List<OptionDetailNavModelUpOdd>? upOdds;
  List<OptionDetailNavModelDownOdd>? downOdds;
  List<OptionDetailNavModelDrawOdd>? drawOdds;
  int? beginTime;
  int? endTime;
  int? beginPrice;
  dynamic endPrice;
  dynamic deliveryUpDown;
  dynamic deliveryRange;
  dynamic deliveryTime;
  int? status;
  String? createdAt;
  String? updatedAt;
  double? increase;
  String? increaseStr;
  String? beginTimeText;
  String? endTimeText;
  String? statusText;
  int? lotteryTime;
  String? pairName;
  String? coinIcon;

  ScenePairList({
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
    this.increase,
    this.increaseStr,
    this.beginTimeText,
    this.endTimeText,
    this.statusText,
    this.lotteryTime,
    this.pairName,
    this.coinIcon,
  });

  factory ScenePairList.fromJson(Map<String, dynamic> json) => ScenePairList(
        sceneId: DataUtils.toInt(json['scene_id']),
        sceneSn: DataUtils.toStr(json['scene_sn']),
        timeId: DataUtils.toInt(json['time_id']),
        seconds: DataUtils.toInt(json['seconds']),
        pairId: DataUtils.toInt(json['pair_id']),
        pairTimeName: DataUtils.toStr(json['pair_time_name']),
        upOdds: (json['up_odds'] is List)
            ? (json['up_odds'] as List<dynamic>?)?.map((e) => OptionDetailNavModelUpOdd.fromJson(e as Map<String, dynamic>)).toList()
            : [],
        downOdds: (json['down_odds'] is List)
            ? (json['down_odds'] as List<dynamic>?)?.map((e) => OptionDetailNavModelDownOdd.fromJson(e as Map<String, dynamic>)).toList()
            : [],
        drawOdds: (json['draw_odds'] is List)
            ? (json['draw_odds'] as List<dynamic>?)?.map((e) => OptionDetailNavModelDrawOdd.fromJson(e as Map<String, dynamic>)).toList()
            : [],
        beginTime: DataUtils.toInt(json['begin_time']),
        endTime: DataUtils.toInt(json['end_time']),
        beginPrice: DataUtils.toInt(json['begin_price']),
        endPrice: json['end_price'] as dynamic,
        deliveryUpDown: json['delivery_up_down'] as dynamic,
        deliveryRange: json['delivery_range'] as dynamic,
        deliveryTime: json['delivery_time'] as dynamic,
        status: DataUtils.toInt(json['status']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
        increase: DataUtils.toDouble(json['increase']),
        increaseStr: DataUtils.toStr(json['increaseStr']),
        beginTimeText: DataUtils.toStr(json['begin_time_text']),
        endTimeText: DataUtils.toStr(json['end_time_text']),
        statusText: DataUtils.toStr(json['status_text']),
        lotteryTime: DataUtils.toInt(json['lottery_time']),
        pairName: DataUtils.toStr(json['pair_name']),
        coinIcon: DataUtils.toStr(json['coin_icon']),
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
        'increase': increase,
        'increaseStr': increaseStr,
        'begin_time_text': beginTimeText,
        'end_time_text': endTimeText,
        'status_text': statusText,
        'lottery_time': lotteryTime,
        'pair_name': pairName,
        'coin_icon': coinIcon,
      };
}
