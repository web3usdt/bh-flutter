import 'package:happy/common/index.dart';

class AssetsWithdrawRecordModel {
  int? id;
  int? userId;
  String? username;
  String? address;
  int? addressType;
  int? totalAmount;
  int? amount;
  int? withdrawalFee;
  int? status;
  dynamic remark;
  dynamic checkTime;
  int? coinId;
  String? coinName;
  dynamic addressNote;
  int? datetime;
  dynamic hash;
  String? createdAt;
  String? updatedAt;
  String? statusText;

  AssetsWithdrawRecordModel({
    this.id,
    this.userId,
    this.username,
    this.address,
    this.addressType,
    this.totalAmount,
    this.amount,
    this.withdrawalFee,
    this.status,
    this.remark,
    this.checkTime,
    this.coinId,
    this.coinName,
    this.addressNote,
    this.datetime,
    this.hash,
    this.createdAt,
    this.updatedAt,
    this.statusText,
  });

  factory AssetsWithdrawRecordModel.fromJson(Map<String, dynamic> json) {
    return AssetsWithdrawRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      username: DataUtils.toStr(json['username']),
      address: DataUtils.toStr(json['address']),
      addressType: DataUtils.toInt(json['address_type']),
      totalAmount: DataUtils.toInt(json['total_amount']),
      amount: DataUtils.toInt(json['amount']),
      withdrawalFee: DataUtils.toInt(json['withdrawal_fee']),
      status: DataUtils.toInt(json['status']),
      remark: DataUtils.toStr(json['remark']),
      checkTime: DataUtils.toStr(json['check_time']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      addressNote: DataUtils.toStr(json['address_note']),
      datetime: DataUtils.toInt(json['datetime']),
      hash: DataUtils.toStr(json['hash']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      statusText: DataUtils.toStr(json['status_text']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'username': username,
        'address': address,
        'address_type': addressType,
        'total_amount': totalAmount,
        'amount': amount,
        'withdrawal_fee': withdrawalFee,
        'status': status,
        'remark': remark,
        'check_time': checkTime,
        'coin_id': coinId,
        'coin_name': coinName,
        'address_note': addressNote,
        'datetime': datetime,
        'hash': hash,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status_text': statusText,
      };
}
