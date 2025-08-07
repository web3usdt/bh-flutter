import 'package:happy/common/index.dart';

class AssetsRechargeRecordModel {
  int? id;
  int? userId;
  String? username;
  int? coinId;
  String? coinName;
  int? datetime;
  int? amount;
  String? status;
  dynamic remark;
  dynamic checkTime;
  dynamic address;
  dynamic txid;
  int? type;
  int? accountType;
  String? note;
  dynamic rechargeImg;
  String? createdAt;
  String? updatedAt;

  AssetsRechargeRecordModel({
    this.id,
    this.userId,
    this.username,
    this.coinId,
    this.coinName,
    this.datetime,
    this.amount,
    this.status,
    this.remark,
    this.checkTime,
    this.address,
    this.txid,
    this.type,
    this.accountType,
    this.note,
    this.rechargeImg,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetsRechargeRecordModel.fromJson(Map<String, dynamic> json) {
    return AssetsRechargeRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      username: DataUtils.toStr(json['username']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      datetime: DataUtils.toInt(json['datetime']),
      amount: DataUtils.toInt(json['amount']),
      status: DataUtils.toStr(json['status']),
      remark: DataUtils.toStr(json['remark']),
      checkTime: DataUtils.toStr(json['check_time']),
      address: DataUtils.toStr(json['address']),
      txid: DataUtils.toStr(json['txid']),
      type: DataUtils.toInt(json['type']),
      accountType: DataUtils.toInt(json['account_type']),
      note: DataUtils.toStr(json['note']),
      rechargeImg: DataUtils.toStr(json['recharge_img']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'username': username,
        'coin_id': coinId,
        'coin_name': coinName,
        'datetime': datetime,
        'amount': amount,
        'status': status,
        'remark': remark,
        'check_time': checkTime,
        'address': address,
        'txid': txid,
        'type': type,
        'account_type': accountType,
        'note': note,
        'recharge_img': rechargeImg,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
