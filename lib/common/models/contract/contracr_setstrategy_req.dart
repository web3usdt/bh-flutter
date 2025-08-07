import 'package:happy/common/utils/index.dart';

class ContracrSetstragetyReq {
  String? symbol;
  int? positionSide;
  int? tpTriggerPrice;
  int? slTriggerPrice;
  String? iscanel;

  ContracrSetstragetyReq({
    this.symbol,
    this.positionSide,
    this.tpTriggerPrice,
    this.slTriggerPrice,
    this.iscanel,
  });

  factory ContracrSetstragetyReq.fromJson(Map<String, dynamic> json) {
    return ContracrSetstragetyReq(
      symbol: DataUtils.toStr(json['symbol']),
      positionSide: DataUtils.toInt(json['position_side']),
      tpTriggerPrice: DataUtils.toInt(json['tp_trigger_price']),
      slTriggerPrice: DataUtils.toInt(json['sl_trigger_price']),
      iscanel: DataUtils.toStr(json['iscanel']),
    );
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'position_side': positionSide,
        'tp_trigger_price': tpTriggerPrice,
        'sl_trigger_price': slTriggerPrice,
        'iscanel': iscanel,
      };
}
