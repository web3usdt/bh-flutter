import 'package:BBIExchange/common/utils/data_utils.dart';

class MiningCoinRecordModel {
  int? id;
  int? userId;
  String? date;
  String? produceNum;
  int? type;
  int? fromUid;
  String? shouldProduced;

  MiningCoinRecordModel({
    this.id,
    this.userId,
    this.date,
    this.produceNum,
    this.type,
    this.fromUid,
    this.shouldProduced,
  });

  factory MiningCoinRecordModel.fromJson(Map<String, dynamic> json) {
    return MiningCoinRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      date: DataUtils.toStr(json['date']),
      produceNum: DataUtils.toStr(json['produce_num']),
      type: DataUtils.toInt(json['type']),
      fromUid: DataUtils.toInt(json['from_uid']),
      shouldProduced: DataUtils.toStr(json['should_produced']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': date,
        'produce_num': produceNum,
        'type': type,
        'from_uid': fromUid,
        'should_produced': shouldProduced,
      };
}
