import 'package:happy/common/index.dart';

import 'related.dart';

class MiningRecordModel {
  int? id;
  int? userId;
  int? purchaseSource;
  int? inviterId;
  String? purchaseTime;
  String? price;
  int? num;
  int? divideStatus;
  int? orderType;
  MinineRecordModelRelated? related;

  MiningRecordModel({
    this.id,
    this.userId,
    this.purchaseSource,
    this.inviterId,
    this.purchaseTime,
    this.price,
    this.num,
    this.divideStatus,
    this.orderType,
    this.related,
  });

  factory MiningRecordModel.fromJson(Map<String, dynamic> json) {
    return MiningRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      purchaseSource: DataUtils.toInt(json['purchase_source']),
      inviterId: DataUtils.toInt(json['inviter_id']),
      purchaseTime: DataUtils.toStr(json['purchase_time']),
      price: DataUtils.toStr(json['price']),
      num: DataUtils.toInt(json['num']),
      divideStatus: DataUtils.toInt(json['divide_status']),
      orderType: DataUtils.toInt(json['order_type']),
      related: json['related'] == null ? null : MinineRecordModelRelated.fromJson(json['related'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'purchase_source': purchaseSource,
        'inviter_id': inviterId,
        'purchase_time': purchaseTime,
        'price': price,
        'num': num,
        'divide_status': divideStatus,
        'order_type': orderType,
        'related': related?.toJson(),
      };
}
