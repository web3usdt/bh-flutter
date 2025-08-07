import 'package:happy/common/index.dart';

class SwapBuyList {
  String? id;
  String? amount;
  String? price;

  SwapBuyList({this.id, this.amount, this.price});

  factory SwapBuyList.fromJson(Map<String, dynamic> json) => SwapBuyList(
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
