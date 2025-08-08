import 'package:BBIExchange/common/index.dart';

class AssetsWidthdrawReq {
  String? coinId;
  String? amount;
  String? address;
  String? addressType;
  String? codeType;
  String? googleCode;
  String? pwd;
  String? code;

  AssetsWidthdrawReq({
    this.coinId,
    this.amount,
    this.address,
    this.addressType,
    this.codeType,
    this.googleCode,
    this.pwd,
    this.code,
  });

  factory AssetsWidthdrawReq.fromJson(Map<String, dynamic> json) {
    return AssetsWidthdrawReq(
      coinId: DataUtils.toStr(json['coin_id']),
      amount: DataUtils.toStr(json['amount']),
      address: DataUtils.toStr(json['address']),
      addressType: DataUtils.toStr(json['address_type']),
      codeType: DataUtils.toStr(json['code_type']),
      googleCode: DataUtils.toStr(json['google_code']),
      pwd: DataUtils.toStr(json['pwd']),
      code: DataUtils.toStr(json['code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_id': coinId,
        'amount': amount,
        'address': address,
        'address_type': addressType,
        'code_type': codeType,
        'google_code': googleCode,
        'pwd': pwd,
        'code': code,
      };
}
