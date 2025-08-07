import 'package:happy/common/index.dart';

class AssetsWithdrawAddReq {
  String? address;
  String? addressNote;
  String? coinName;
  int? id;
  String? pwd;

  AssetsWithdrawAddReq({this.address, this.addressNote, this.coinName, this.id, this.pwd});

  factory AssetsWithdrawAddReq.fromJson(Map<String, dynamic> json) {
    return AssetsWithdrawAddReq(
      address: DataUtils.toStr(json['address']),
      addressNote: DataUtils.toStr(json['address_note']),
      coinName: DataUtils.toStr(json['coin_name']),
      id: DataUtils.toInt(json['id']),
      pwd: DataUtils.toStr(json['pwd']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (address != null) data['address'] = address;
    if (addressNote != null) data['address_note'] = addressNote;
    if (coinName != null) data['coin_name'] = coinName;
    if (id != null) data['id'] = id;
    if (pwd != null) data['pwd'] = pwd;
    return data;
  }
}
