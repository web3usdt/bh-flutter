import 'package:happy/common/index.dart';

class ContractShareReq {
  String? symbol;
  String? positionSide;
  String? orderNo;
  String? lang;

  ContractShareReq({
    this.symbol,
    this.positionSide,
    this.orderNo,
    this.lang,
  });

  factory ContractShareReq.fromJson(Map<String, dynamic> json) {
    return ContractShareReq(
      symbol: DataUtils.toStr(json['symbol']),
      positionSide: DataUtils.toStr(json['position_side']),
      orderNo: DataUtils.toStr(json['order_no']),
      lang: DataUtils.toStr(json['lang']),
    );
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'position_side': positionSide,
        'order_no': orderNo,
        'lang': lang,
      };
}
