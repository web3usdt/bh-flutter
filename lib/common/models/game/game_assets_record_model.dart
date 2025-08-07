import 'package:happy/common/index.dart';

class GameAssetsRecordModel {
  int? id;
  int? beforeBalance;
  int? afterBalance;
  String? createdAt;
  String? logTypeText;
  int? amount;

  GameAssetsRecordModel({
    this.id,
    this.beforeBalance,
    this.afterBalance,
    this.createdAt,
    this.logTypeText,
    this.amount,
  });

  factory GameAssetsRecordModel.fromJson(Map<String, dynamic> json) {
    return GameAssetsRecordModel(
      id: DataUtils.toInt(json['id']),
      beforeBalance: DataUtils.toInt(json['before_balance']),
      afterBalance: DataUtils.toInt(json['after_balance']),
      createdAt: DataUtils.toStr(json['created_at']),
      logTypeText: DataUtils.toStr(json['log_type_text']),
      amount: DataUtils.toInt(json['amount']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'before_balance': beforeBalance,
        'after_balance': afterBalance,
        'created_at': createdAt,
        'log_type_text': logTypeText,
      };
}
