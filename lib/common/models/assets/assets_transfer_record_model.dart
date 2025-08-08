import 'package:BBIExchange/common/index.dart';

class AssetsTransferRecordModel {
  int? id;
  int? userId;
  int? coinId;
  String? coinName;
  String? drawOutDirection;
  String? intoDirection;
  String? amount;
  int? status;
  int? datetime;
  int? orderStatus;

  AssetsTransferRecordModel({
    this.id,
    this.userId,
    this.coinId,
    this.coinName,
    this.drawOutDirection,
    this.intoDirection,
    this.amount,
    this.status,
    this.datetime,
    this.orderStatus,
  });

  factory AssetsTransferRecordModel.fromJson(Map<String, dynamic> json) {
    return AssetsTransferRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      drawOutDirection: DataUtils.toStr(json['draw_out_direction']),
      intoDirection: DataUtils.toStr(json['into_direction']),
      amount: DataUtils.toStr(json['amount']),
      status: DataUtils.toInt(json['status']),
      datetime: DataUtils.toInt(json['datetime']),
      orderStatus: DataUtils.toInt(json['order_status']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'coin_id': coinId,
        'coin_name': coinName,
        'draw_out_direction': drawOutDirection,
        'into_direction': intoDirection,
        'amount': amount,
        'status': status,
        'datetime': datetime,
        'order_status': orderStatus,
      };
}
