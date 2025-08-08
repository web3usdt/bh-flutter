import 'package:BBIExchange/common/index.dart';

class SellList {
  String? id;
  String? amount;
  String? price;

  SellList({this.id, this.amount, this.price});

  factory SellList.fromJson(Map<String, dynamic> json) => SellList(
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
