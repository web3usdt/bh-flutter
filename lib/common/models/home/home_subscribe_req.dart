import 'package:BBIExchange/common/index.dart';

class HomeSubscribeReq {
  String? amount;
  String? coinName;

  HomeSubscribeReq({this.amount, this.coinName});

  factory HomeSubscribeReq.fromJson(Map<String, dynamic> json) {
    return HomeSubscribeReq(
      amount: DataUtils.toStr(json['amount']),
      coinName: DataUtils.toStr(json['coin_name']),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'coin_name': coinName,
      };
}
