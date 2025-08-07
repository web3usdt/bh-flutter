import 'package:happy/common/index.dart';

class MiningPowerRecordModel {
  int? id;
  int? userId;
  int? changeType;
  String? changeAmount;
  String? changeReason;
  dynamic relatedId;
  String? changeTime;
  String? currentPower;
  int? withUser;
  dynamic lastPower;

  MiningPowerRecordModel({
    this.id,
    this.userId,
    this.changeType,
    this.changeAmount,
    this.changeReason,
    this.relatedId,
    this.changeTime,
    this.currentPower,
    this.withUser,
    this.lastPower,
  });

  factory MiningPowerRecordModel.fromJson(Map<String, dynamic> json) {
    return MiningPowerRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      changeType: DataUtils.toInt(json['change_type']),
      changeAmount: DataUtils.toStr(json['change_amount']),
      changeReason: DataUtils.toStr(json['change_reason']),
      relatedId: DataUtils.toStr(json['related_id']),
      changeTime: DataUtils.toStr(json['change_time']),
      currentPower: DataUtils.toStr(json['current_power']),
      withUser: DataUtils.toInt(json['with_user']),
      lastPower: DataUtils.toStr(json['last_power']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'change_type': changeType,
        'change_amount': changeAmount,
        'change_reason': changeReason,
        'related_id': relatedId,
        'change_time': changeTime,
        'current_power': currentPower,
        'with_user': withUser,
        'last_power': lastPower,
      };
}
