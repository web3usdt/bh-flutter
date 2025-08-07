import 'package:happy/common/index.dart';

class CoinKlineReq {
  String? symbol;
  String? period;
  int? form;
  int? to;
  int? size;

  CoinKlineReq({this.symbol, this.period, this.form, this.to, this.size});

  factory CoinKlineReq.fromJson(Map<String, dynamic> json) => CoinKlineReq(
        symbol: DataUtils.toStr(json['symbol']),
        period: DataUtils.toStr(json['period']),
        form: DataUtils.toInt(json['form']),
        to: DataUtils.toInt(json['to']),
        size: DataUtils.toInt(json['size']),
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'period': period,
        'form': form,
        'to': to,
        'size': size,
      };
}
