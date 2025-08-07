import 'package:happy/common/index.dart';

class SwapSellList {
  String? id;
  String? amount;
  String? price;

  SwapSellList({this.id, this.amount, this.price});

  factory SwapSellList.fromJson(Map<String, dynamic> json) => SwapSellList(
        id: DataUtils.toStr(json['id']),
        amount: DataUtils.toStr(json['amount']),
        price: DataUtils.toStr(json['price']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'price': price,
      };
}
