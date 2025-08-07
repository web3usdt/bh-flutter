import 'package:happy/common/index.dart';

class AssetsWidthdrawBalanceReq {
  String? coinName;
  int? addressType;

  AssetsWidthdrawBalanceReq({this.coinName, this.addressType});

  factory AssetsWidthdrawBalanceReq.fromJson(Map<String, dynamic> json) {
    return AssetsWidthdrawBalanceReq(
      coinName: DataUtils.toStr(json['coin_name']),
      addressType: DataUtils.toInt(json['address_type']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_name': coinName,
        'address_type': addressType,
      };
}
