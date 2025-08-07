import 'package:happy/common/index.dart';

class AssetsRecordListModel {
  int? id;
  int? userId;
  int? sUserId;
  int? accountType;
  dynamic subAccount;
  int? coinId;
  String? coinName;
  String? richType;
  String? amount;
  String? logType;
  String? logNote;
  String? beforeBalance;
  String? afterBalance;
  int? logableId;
  String? logableType;
  int? ts;
  String? createdAt;
  String? updatedAt;
  String? logTypeText;

  AssetsRecordListModel({
    this.id,
    this.userId,
    this.sUserId,
    this.accountType,
    this.subAccount,
    this.coinId,
    this.coinName,
    this.richType,
    this.amount,
    this.logType,
    this.logNote,
    this.beforeBalance,
    this.afterBalance,
    this.logableId,
    this.logableType,
    this.ts,
    this.createdAt,
    this.updatedAt,
    this.logTypeText,
  });

  factory AssetsRecordListModel.fromJson(Map<String, dynamic> json) {
    return AssetsRecordListModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      sUserId: DataUtils.toInt(json['s_user_id']),
      accountType: DataUtils.toInt(json['account_type']),
      subAccount: DataUtils.toStr(json['sub_account']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      richType: DataUtils.toStr(json['rich_type']),
      amount: json['amount']?.toString(),
      logType: DataUtils.toStr(json['log_type']),
      logNote: DataUtils.toStr(json['log_note']),
      beforeBalance: json['before_balance']?.toString(),
      afterBalance: json['after_balance']?.toString(),
      logableId: DataUtils.toInt(json['logable_id']),
      logableType: DataUtils.toStr(json['logable_type']),
      ts: DataUtils.toInt(json['ts']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      logTypeText: DataUtils.toStr(json['log_type_text']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        's_user_id': sUserId,
        'account_type': accountType,
        'sub_account': subAccount,
        'coin_id': coinId,
        'coin_name': coinName,
        'rich_type': richType,
        'amount': amount,
        'log_type': logType,
        'log_note': logNote,
        'before_balance': beforeBalance,
        'after_balance': afterBalance,
        'logable_id': logableId,
        'logable_type': logableType,
        'ts': ts,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'log_type_text': logTypeText,
      };
}
