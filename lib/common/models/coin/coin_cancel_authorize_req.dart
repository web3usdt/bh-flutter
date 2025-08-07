import 'package:happy/common/index.dart';

class CoinCancelAuthorizeReq {
  int? entrustId;
  int? entrustType;
  String? symbol;

  CoinCancelAuthorizeReq({this.entrustId, this.entrustType, this.symbol});

  factory CoinCancelAuthorizeReq.fromJson(Map<String, dynamic> json) {
    return CoinCancelAuthorizeReq(
      entrustId: DataUtils.toInt(json['entrust_id']),
      entrustType: DataUtils.toInt(json['entrust_type']),
      symbol: DataUtils.toStr(json['symbol']),
    );
  }

  Map<String, dynamic> toJson() => {
        'entrust_id': entrustId,
        'entrust_type': entrustType,
        'symbol': symbol,
      };
}
