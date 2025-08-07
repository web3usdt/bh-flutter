import 'package:happy/common/index.dart';

class BuyList {
  String? id;
  String? amount;
  String? price;

  BuyList({this.id, this.amount, this.price});

  factory BuyList.fromJson(Map<String, dynamic> json) => BuyList(
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
