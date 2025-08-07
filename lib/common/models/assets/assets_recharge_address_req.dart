import 'package:happy/common/index.dart';

class AssetsRechargeAddressReq {
  String? coinId;
  int? addressType;

  AssetsRechargeAddressReq({this.coinId, this.addressType});

  factory AssetsRechargeAddressReq.fromJson(Map<String, dynamic> json) {
    return AssetsRechargeAddressReq(
      coinId: DataUtils.toStr(json['coin_id']),
      addressType: DataUtils.toInt(json['address_type']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_id': coinId,
        'address_type': addressType,
      };
}
