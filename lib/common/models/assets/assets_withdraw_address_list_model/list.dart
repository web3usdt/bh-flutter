import 'package:happy/common/index.dart';

class AssetsWithdrawAddressListModelList {
  int? id;
  int? userId;
  String? coinName;
  String? addressNote;
  String? address;
  int? datetime;
  dynamic createdAt;
  dynamic updatedAt;

  AssetsWithdrawAddressListModelList({
    this.id,
    this.userId,
    this.coinName,
    this.addressNote,
    this.address,
    this.datetime,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetsWithdrawAddressListModelList.fromJson(Map<String, dynamic> json) => AssetsWithdrawAddressListModelList(
        id: DataUtils.toInt(json['id']),
        userId: DataUtils.toInt(json['user_id']),
        coinName: DataUtils.toStr(json['coin_name']),
        addressNote: DataUtils.toStr(json['address_note']),
        address: DataUtils.toStr(json['address']),
        datetime: DataUtils.toInt(json['datetime']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'coin_name': coinName,
        'address_note': addressNote,
        'address': address,
        'datetime': datetime,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
